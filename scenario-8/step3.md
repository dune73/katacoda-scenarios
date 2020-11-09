In order to find out what rules stand behind the anomaly scores 231 and 189, we need to link the access log to the error log. The unique request ID is this link:

```
egrep " (231|189) [0-9-]+$" tutorial-8-example-access.log | alreqid | tee ids
```{{execute}}

```
WBuxz38AAQEAAEdWQ5UAAACH
WBux0H8AAQEAAEdWQ7QAAACT
WBux0H8AAQEAAEdS9vYAAAAW
WBux0H8AAQEAAEdWQ7kAAACE
WBux0H8AAQEAAEdTojoAAABW
WBux0H8AAQEAAEdS9v4AAAAA
WBux0H8AAQEAAEdTokEAAABL
```

With this one-liner, we *grep* for the requests with score 231 or 189. We know it is the second item from the end of the log line. The final value is the outgoing anomaly score. In our case, all responses scored 0, but theoretically, this value could be any number or undefined (-> `-`) so it is generally a good practice to write the pattern this way. The alias *alreqid* extracts the unique ID and *tee* will show us the IDs and write them to the file *ids* at the same time.

We can then take the IDs in this file and use them to extract the alerts belonging to the requests we're focused on. We use `grep -f` to perform this step. The `-F` flag tells *grep* that our pattern file is actually a list of fixed strings separated by newlines. Thus equipped, *grep* is a lot more efficient than without the flag.  The *melidmsg* alias extracts the ID and the message explaining the alert. Combining both is very helpful. The already familiar *sucs* alias is then used to sum it all up:

```
grep -F -f ids tutorial-8-example-error.log  | melidmsg | sucs
```{{execute}}
```
      7 921180 HTTP Parameter Pollution (ARGS_NAMES:ids[])
     12 942450 SQL Hex Encoding Identified
     35 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
     75 942130 SQL Injection Attack: SQL Tautology Detected.
    110 920273 Invalid character in request (outside of very strict set)
    150 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)
```

So these are the culprits. Let's go through them one by one. 921180 is a rule that identifies when a parameter (*ids[]* here) is submitted more than once within the same request. It's an advanced rule which appeared in the CRS3 for the first time (based on a mechanic I developed). Drupal seems to do this and we can hardly instruct it to stop this behaviour. 942450 looks for strings of the pattern `0x` with two additional hexadecimal digits. This is a hexadecimal encoding which can point to an exploit being used. The problem with this encoding is that session cookies can sometimes contain this pattern. Session cookies are randomly generated strings and at times you get this pattern in such an identifier. When you do, there is a paranoia level 2 rule that looks for attack patterns in hexadecimal encoding that try to sneak past our ruleset. So, we are facing a false positive in a very classical way.

942431 and 942432 are closely related. We call these siblings. They form a group with 942430, the base rule looking for 12 special characters like square brackets, colons, semicolons, asterisks, etc. (paranoia level 2). 942431 is a strict sibling doing the same things, but with a limit of 6 characters at paranoia level 3 and finally the paranoid zealot in the family, 942432, is going crazy after the 2nd special character (paranoia level 4).

942130 is one from the big group of SQL injection rules (this is a field the CRS are very strong in) and finally, 920273, another paranoid rule from paranoia level 4 defining the set of allowed ASCII characters (i.e. `38,44-46,48-58,61,65-90,95,97-122`).

For every alert, we need to write a rule exclusion and as we have seen in the previous tutorial, there are multiple options. It takes a bit of experience to make the right choice and very often, multiple approaches can be suitable. Let's look at the cheat sheet we covered in the previous scenario again:

<a href="https://www.netnea.com/cms/rule-exclusion-cheatsheet-download/">Link to Netnea ModSecurity CRS Rule Exclusion Cheatsheet</a>

Let's start with a simple case: 920273. We could look at this in great detail and check out all the different parameters triggering this rule. Depending on the security level we want to provide for our application, this would be the right approach. But then this is an exercise, so we will keep it simple: Let's kick this rule out completely. We'll opt for a startup rule (to be placed after the CRS include).

```
# === ModSec Core Rule Set: Config Time Exclusion Rules (no ids)

# ModSec Rule Exclusion: 920273 : Invalid character in request (outside of very strict set)
SecRuleRemoveById 920273
```

Next are the alerts for 942432:

```
grep -F -f ids tutorial-8-example-error.log  | grep 942432 | melmatch | sucs
```{{execute}}

```
     75 ARGS:ids[]
     75 ARGS_NAMES:ids[]
``` 

Drupal obviously uses square brackets within the parameter name. This is not limited to IDs, but a general pattern. Two square brackets are enough to trigger the rule, so this sets off a lot of false alarms. Running after all occurrences would be very tedious, so we will kick this rule out as well (remember, it's a paranoia level 4 rule and a more relaxed version of this rule exists at PL3). 

```
# ModSec Rule Exclusion: 942432 : Restricted SQL Character Anomaly Detection (args): 
# number of special characters exceeded (2)
SecRuleRemoveById 942432
```

The next one is 942450. This is the rule looking for traces of hex encoding. This is a peculiar case as we can easily see:


```
grep -F -f ids tutorial-8-example-error.log  | grep 942450 | melmatch | sucs
```{{execute}}

```
      6 REQUEST_COOKIES:98febd3dhf84de73ab2e32889dc5f0x032a9
      6 REQUEST_COOKIES_NAMES:SESS29af1facda0a866a687d5055f0x034ca
```

As expected, it's a session cookie, but unexpectedly, the session cookie has a dynamic name on top! This means we can not simply ignore the session cookie by name, we need to ignore cookies whose name matches a certain pattern and this is very, very complicated. And it's probably not worth the hassle. The easier approach is to have this rule ignore all cookies. This way, the rule is still intact for post and query string parameter, but it does not trigger on cookies anymore.

```
# ModSec Rule Exclusion: 942450 : SQL Hex Encoding Identified (severity: 5 CRITICAL)
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES"
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES_NAMES"
```

Three more to go: 921180, 942431 and 942130. We start with the latter:

```
grep -F -f ids tutorial-8-example-error.log | grep 942130 | melmatch | sucs
```{{execute}}

```
     75 ARGS:ids[]
```

So this is always the same parameter *ids[]*, which is already familiar to us. Maybe it's worth looking at the URI to understand how this is happening:

```
grep -F -f ids tutorial-8-example-error.log  | grep 942130 | meluri | sucs
```{{execute}}

```
     75 /drupal/index.php/contextual/render
```

So this is always the same URI. Let's exclude the parameter `ids[]` from being examined when it occurs in requests to this location. This boils down to a run-time exclusion rule. In the previous tutorial, we have seen that writing these kind of rules is cumbersome. It would be nice to have a script do the work for us. So, I created such a script: introducing [modsec-rulereport.rb](https://www.netnea.com/files/modsec-rulereport.rb). It takes an alert message (or the error log in a more general sense) on STDIN and proposes one of many rules exclusions of different types (see modsec-rulereport.rb -h` for an overview). 


```
grep -F -f ids tutorial-8-example-error.log  | grep 942130 | modsec-rulereport.rb --mode combined
```{{execute}}

```
75 x 942130 SQL Injection Attack: SQL Tautology Detected.
--------------------------------------------------------------------------------
      # ModSec Rule Exclusion: 942130 : SQL Injection Attack: SQL Tautology Detected.
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
              "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942130;ARGS:ids[]"
```

The mode _combined_ instructs the script to write a rule that combines a path condition with a rule ID and a certain parameter. First, it reports the number of occurrences, then it proposes an exclusion rule which we can copy together with the comment into our Apache configuration file 1:1. The proposed rule has an ID of 10,000. If we continue to use the script, we will have to edit this ID ourselves to avoid ID collisions, but that's a simple task.

Here is how the configuration looks when we enter this construct (line break introduced for display reasons):

```
# === ModSec Core Rule Set: Runtime Exclusion Rules (ids: 10000-49999)

# ModSec Rule Exclusion: 942130 : SQL Injection Attack: SQL Tautology Detected.
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
    "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942130;ARGS:ids[]"
```

This is script is very handy. Let's throw in 942431 and see what happens:


```
grep -F -f ids tutorial-8-example-error.log  | grep 942431 | modsec-rulereport.rb --mode combined
```{{execute}}

```
35 x 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
---------------------------------------------------------------------------------------------------
      # ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): …
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
              "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942431;ARGS:ids[]"
```

So that's almost the same thing. We can thus take out the control action (the bit starting with `ctl`) and append it to the previous statement:


```
# === ModSec Core Rule Set: Runtime Exclusion Rules (ids: 10000-49999)

# ModSec Rule Exclusion: 942130 : SQL Injection Attack: SQL Tautology Detected.
# ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): # of ...
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
    "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942130;ARGS:ids[],\
                                 ctl:ruleRemoveTargetById=942431;ARGS:ids[]"
```

And now 921180:

```
grep -F -f ids tutorial-8-example-error.log  | grep 921180 | modsec-rulereport.rb --mode combined
```{{execute}}

```
7 x 921180 HTTP Parameter Pollution (ARGS_NAMES:ids[])
------------------------------------------------------
      # ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (ARGS_NAMES:ids[])
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
               "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:ids[]"
```

This is a special case. It's caused by submitting a single parameter multiple times. The rule works with a separate counter introduced for every parameter which will then check the counter in rule 921180. If we want to suppress the alarm, we'd best suppress the examination of this counter as the script proposes. We are facing the same URI again, but I have the feeling that this rule will be triggered by other parameters as well. We will see.

In fact, this brings us to an organizational problem. How do we best organize the rule exclusions? Especially the complicated run-time exclusions. We can order by rule ID, by URI or by parameter. There is no easy answer. For large sites with multiple services or many different application paths, I use the URI to group the exclusion rules by branches of the service. But with small services, sorting by rule ID seems like a reasonable approach.

We now take the proposed rule, prepare the comment for future variables, raise the rule ID by 1 to avoid ID collisions and add it to the configuration:

```
# ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (multiple variables)
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
    "phase:2,nolog,pass,id:10001,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:ids[]"
```

With this, we have covered these seven highly scoring requests (189 and 231). Writing these six rule exclusions was a bit cumbersome, but the script seems to be a real improvement to the process. The rest will be faster. Promise.
