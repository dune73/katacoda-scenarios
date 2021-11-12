In order to find out what rules stand behind the anomaly scores 231 and 189, we need to link the access log to the error log. The unique request ID is this link:

```
egrep " (144|171) [0-9-]+$" tutorial-8-example-access.log | alreqid | tee ids
```{{execute}}

```
YOLwPjVthd6oCpPp2VVvSwAAAAI
YOLwcTVthd6oCpPp2VVw1wAAABE
YOLwcTVthd6oCpPp2VVw1gAAABU
YOLwcTVthd6oCpPp2VVw1gAAABc
YOLwcTVthd6oCpPp2VVw1wAAABY
YOLwcTVthd6oCpPp2VVw1wAAAAc
YOLwcTVthd6oCpPp2VVw1wAAAAg
```

With this one-liner, we *grep* for the requests with score 231 or 189. We know it is the second item from the end of the log line. The final value is the outgoing anomaly score. In our case, all responses scored 0, but theoretically, this value could be any number or undefined (-> `-`) so it is generally a good practice to write the pattern this way. The alias *alreqid* extracts the unique ID and *tee* will show us the IDs and write them to the file *ids* at the same time.

We can then take the IDs in this file and use them to extract the alerts belonging to the requests we're focused on. We use `grep -f` to perform this step. The `-F` flag tells *grep* that our pattern file is actually a list of fixed strings separated by newlines. Thus equipped, *grep* is a lot more efficient than without the `-F` flag for files larger than the one in question.  The *melidmsg* alias extracts the ID and the message explaining the alert. Combining both is very helpful. The already familiar *sucs* alias is then used to sum it all up:


```
grep -F -f ids tutorial-8-example-error.log  | melidmsg | sucs
```{{execute}}
```
      6 942450 SQL Hex Encoding Identified
      7 921180 HTTP Parameter Pollution (ARGS_NAMES:ids[])
     35 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
    110 920273 Invalid character in request (outside of very strict set)
    150 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)
```

So these are the culprits: These are the rules driving the anomaly score of said seven requests to the heights we encountered. Let's go through them one by one.

942450 SQL Hex Encoding Identified looks for strings of the pattern `0x` with two additional hexadecimal digits. This is a hexadecimal encoding which can point to an exploit being used. The problem with this encoding is that session cookies can sometimes contain this pattern. Session cookies are randomly generated strings and at times you get this pattern in such an identifier. When you do, there is this paranoia level 2 rule that looks for hexadecimal encoding assuming it might be used to sneak past our ruleset. This is a false positive in a very classical way.

921180 HTTP Parameter Pollution is a rule that identifies when a parameter (*ids[]* here) is submitted more than once within the same request. It's an advanced rule which appeared in the CRS3 for the first time (based on a mechanic I developed). Drupal seems to exhibit this behavior and we can hardly instruct it to stop it.

942431 Restricted SQL Character Anomaly Detection and 942432 are closely related. We call these siblings. They form a group with 942430, the base rule looking for 12 special characters like square brackets, colons, semicolons, asterisks, etc. (paranoia level 2). 942431 is a strict sibling and executes the same check, but with a limit of 6 characters at paranoia level 3 and finally the paranoid zealot in the family, 942432, is going crazy after the 2nd special character (paranoia level 4).

Rule `920273 Invalid character in request` is pretty much self explanatory. It's a very strict rule at paranoia level 4 and it fights special characters fiercly.

So this is what we are facing for our first tuning round.

Let's look at the rule exclusion cheat sheet from the previous tutorial again. It illustrates the four basic ways to handle a false positive. This is going to be our guide as we work through them.

<a href="https://www.netnea.com/cms/rule-exclusion-cheatsheet-download/">Link to Netnea ModSecurity CRS Rule Exclusion Cheatsheet</a>

Let's start with a simple case: 920273 Invalid character in request. We could look at this in great detail and check out all the different parameters triggering this rule. Depending on the security level we want to provide for our application, this would be the right approach. But this is only an exercise and the numbers for this rule are staggering, so we will keep it simple: Let's kick this rule out completely. We'll opt for a startup rule (to be placed after the CRS include) that remove the rule 920273 from the memory of the WAF.

```
# === ModSec Core Rule Set: Config Time Exclusion Rules (no ids)

# ModSec Rule Exclusion: 920273 : Invalid character in request (outside of very strict set)
SecRuleRemoveById 920273
```

I suggest you always add at least a minimal comment where you describe what you are doing and also name the rule, since most people won't know the rule IDs by heart.

Next are the alerts for 942432 Restricted SQL Character Anomaly Detection. Let's take a closer look.

```
grep -F -f ids tutorial-8-example-error.log  | grep 942432 | melmatch | sucs
```{{execute}}
```
     75 ARGS:ids[]
     75 ARGS_NAMES:ids[]
``` 

Drupal obviously uses square brackets within the parameter name. This is not limited to IDs, but a general pattern. Two square brackets are enough to trigger the rule, so this sets off a lot of false alarms. Running after all occurrences would be very tedious, so we will kick this rule out as well (remember, it's a paranoia level 4 rule and a more relaxed version of this rule exists at PL3). 

```bash
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

As expected, it's a session cookie, but unexpectedly, the session cookie has a dynamic name on top! This means we can not simply ignore the session cookie by name, we would need to ignore cookies whose name matches a certain pattern and this is something ModSecurity does not allow us to do. The only viable approach from my perspective is to have this rule ignore all cookies. This way, the rule is still intact for post and query string parameters, but it does not trigger on cookies anymore. That's not ideal, but the best we can do in this situation. So unlike the previous rule exclusions, we limit our exclusion at two parameters (ModSecurity collections is the correct term) and leave the rest of the rule intact. On the cheat sheet, this is the bottom left option; another startup rule exclusion but one that leaves the rule itself intact.

```
# ModSec Rule Exclusion: 942450 : SQL Hex Encoding Identified (severity: 5 CRITICAL)
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES"
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES_NAMES"
```

Two more to go: 921180 HTTP Parameter Pollution and 942431 Restricted SQL Character Anomaly Detection. Let's try and work in a more diligent way here. We no longer throw out the entire rule and we do not want to exclude parameters from the application of the rule entirely. Instead, we limit the rule exclusion to a certain URI pattern. That means, we will construct a rule exclusion that depends on the request in question; a runtime rule exclusion. On the cheat sheet, this is the right column.

As you can also see on the cheat sheet, these are very hard to do by hand. That's why I have developed a script that comes to your help. Please download [modsec-rulereport.rb](https://www.netnea.com/files/modsec-rulereport.rb) and put it into your `bin` folder. Try out the `--help` option of the script to get an idea of what it can do for you.

Here is how I use it to generate a rule exclusion for 942431: First I take a look at the alert again:

```
grep -F -f ids tutorial-8-example-error.log | grep 942431 | melmatch 
```{{execute}}
```
ARGS:ids[]
ARGS:ids[]
ARGS:ids[]
...
ARGS:ids[]
```

So the parameter `ids[]` is affected. And it's always the same URI:

```
$> grep -F -f ids tutorial-8-example-error.log | grep 942431 | meluri 
```{{€xecute}}
```
/drupal/index.php/contextual/render
/drupal/index.php/contextual/render
/drupal/index.php/contextual/render
...
/drupal/index.php/contextual/render
```

So it's a perfect use case for a runtime rule exclusion that ignores parameter `ids[]` on `/drupal/index.php/contextual/render`. Here is how to use the script to do this:


```
grep -F -f ids tutorial-8-example-error.log | grep 942431 | \
modsec-rulereport.rb --runtime --target --byid
```{{execute}}
```
# ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render"
        "phase:1,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942431;ARGS:ids[]"
```

This output is config code. You can copy it over to your Apache / ModSecurity configuration as is, ideally together with the comment. Important: This has to be placed above the CRS include in the configuration file. If you place it afterwards, there is a chance the rule has already been executed the moment you issue the rule exclusion. So as a rule of thumb, runtime rule exclusions are always defined before the include, startup rule exclusions are defined after the include.

If we accept this rule exclusion proposal as our new config, then there is only 921180 HTTP Parameter Pollution left. The script gives us the following:

```
grep -F -f ids tutorial-8-example-error.log | grep 921180 | \
modsec-rulereport.rb --runtime --target --byid
```{{execute}}
```
# ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (ARGS_NAMES:ids[])
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render"
        "phase:1,nolog,pass,id:10000,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:ids[]"
```

We can copy this over to the config again, but there is a twist. If we take it as is, there is going to be a rule collision as the script issued the new rule with ID 10000 again. Let's change that to 10001 and enter it as follows:

```
# ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (ARGS_NAMES:ids[])
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render"
        "phase:1,nolog,pass,id:10001,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:ids[]"
```

If you do not want to tweak with the rule ID by hand, then you can also pass the desired base rule ID as a command line parameter `--baseruleid` or - even better still - make sure the script saves the rule ID and starts the next run with the rule ID it finds from the previous run. Look up the help page of the script to learn how this works.


