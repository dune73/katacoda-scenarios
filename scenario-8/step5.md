After the first batch of rule exclusions, we would observe the service. In our exercise, we can speed up the process and run the `10K-traffic-generator.sh` script again (Don't forget to restart your webserver after having added the rule exclusions in step 3 above).

Here for your discretion the log files I got with the rule exclusions defined above:

* [tutorial-8-example-access-round-2.log](https://www.netnea.com/files/tutorial-8-example-access-round-2.log)
* [tutorial-8-example-error-round-2.log](https://www.netnea.com/files/tutorial-8-example-error-round-2.log)

We start again with a look at the score distribution:

```
cat tutorial-8-example-access-round-2.log | alscores | modsec-positive-stats.rb
```{{execute}}

```
INCOMING                     Num of req. | % of req. |  Sum of % | Missing %
Number of incoming req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. incoming score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with incoming score of   0 |   8612 |  86.1199% |  86.1199% |  13.8801%
Reqs with incoming score of   1 |      0 |   0.0000% |  86.1199% |  13.8801%
Reqs with incoming score of   2 |      0 |   0.0000% |  86.1199% |  13.8801%
Reqs with incoming score of   3 |      0 |   0.0000% |  86.1199% |  13.8801%
Reqs with incoming score of   4 |      0 |   0.0000% |  86.1199% |  13.8801%
Reqs with incoming score of   5 |    736 |   7.3600% |  93.4799% |   6.5201%
Reqs with incoming score of   6 |      0 |   0.0000% |  93.4799% |   6.5201%
Reqs with incoming score of   7 |      0 |   0.0000% |  93.4799% |   6.5201%
Reqs with incoming score of   8 |    388 |   3.8800% |  97.3599% |   2.6401%
Reqs with incoming score of   9 |      0 |   0.0000% |  97.3599% |   2.6401%
Reqs with incoming score of  10 |     36 |   0.3600% |  97.7199% |   2.2801%
Reqs with incoming score of  11 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  12 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  13 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  14 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  15 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  16 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  17 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  18 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  19 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  20 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  21 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  22 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  23 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  24 |      0 |   0.0000% |  97.7199% |   2.2801%
Reqs with incoming score of  25 |     76 |   0.7600% |  98.4799% |   1.5201%
Reqs with incoming score of  26 |      0 |   0.0000% |  98.4799% |   1.5201%
Reqs with incoming score of  27 |      0 |   0.0000% |  98.4799% |   1.5201%
Reqs with incoming score of  28 |      0 |   0.0000% |  98.4799% |   1.5201%
Reqs with incoming score of  29 |      0 |   0.0000% |  98.4799% |   1.5201%
Reqs with incoming score of  30 |     76 |   0.7600% |  99.2400% |   0.7600%
Reqs with incoming score of  31 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  32 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  33 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  34 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  35 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  36 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  37 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  38 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  39 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  40 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  41 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  42 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  43 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  44 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  45 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  46 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  47 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  48 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  49 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  50 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  51 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  52 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  53 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  54 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  55 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  56 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  57 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  58 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  59 |      0 |   0.0000% |  99.2400% |   0.7600%
Reqs with incoming score of  60 |     76 |   0.7600% | 100.0000% |   0.0000%

Incoming average:   1.5884    Median   0.0000    Standard deviation   6.4117

OUTGOING                     Num of req. | % of req. |  Sum of % | Missing %
Number of outgoing req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. outgoing score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with outgoing score of   0 |  10000 | 100.0000% | 100.0000% |   0.0000%

Outgoing average:   0.0000    Median   0.0000    Standard deviation   0.0000
```

If we compare this to the first run of the statistic script, we reduced the mean incoming score from 12.6 to 1.6. This is very impressive in light of just seven requests that we tuned: By focusing on a handful of high scoring requests, we improved the whole service by a lot.

We could expect the high scoring requests of 144 and 171 to be gone, but funnily enough, the cluster at 74 and the one at 93 have also disappeared. We only covered seven requests in the initial tuning, but two clusters with alerts from over 350 requests are completly gone as well. And this is not an exceptional effect. It is the standard behaviour if we work with this tuning method: a few rule exclusions that we derieved from the highest scoring requests will kill with most of the false alarms.

Our next goal is the group of requests with a score of 60 so we can then lower the anomaly score threshold to 50 in the 2nd reduction round. Let's extract the rule IDs and then examine the alerts a bit.

```
egrep " 60 [0-9-]+$" tutorial-8-example-access-round-2.log | alreqid > ids
grep -F -f ids tutorial-8-example-error-round-2.log | melidmsg | sucs
```{{execute}}
```
     75 921180 HTTP Parameter Pollution (ARGS_NAMES:keys)
     75 942100 SQL Injection Attack Detected via libinjection
    150 942190 Detects MSSQL code execution and information gathering attempts
    150 942200 Detects MySQL comment-/space-obfuscated injections and backtick termination
    150 942260 Detects basic SQL authentication bypass attempts 2/3
    150 942270 Looking for basic sql injection. Common attack string for mysql, oracle and others
    150 942480 SQL Injection Attack

```

Interestingly, the alerts all happen on the same path:

```
grep -F -f ids tutorial-8-example-error-round-2.log | meluri | sucs
```{{execute}}
```
    912 /drupal/index.php/search/node
```

This path points to a search form and payloads resembling SQL injections. Just what the alerts listed above also indicate. But there is one exception: We have seen rule 921180 HTTP Parameter Pollution before. In the previous tuning round we did a diligent runtime rule exclusion to avoid this rule for parameter `ids[]`. Now it looks like the submission of a certain parameter name multiple time in the same request is one of Drupal's favorite past times. So the diligent approach is overly tedious and we better give up on that idea and kiss this rule goodbye in our Drupal context:

```
# ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution
SecRuleRemoveById 921180
```

Don't forget to remove the previous run time rule exclusion for 921180.

All the other alerts stem from SQL injection rules. But we know this was legitimate traffic: I filled in the forms personally when I searched for SQL statements in the Drupal articles I had posted as an exercise and we are now facing a dilemma: If we suppress the rules, we open a door for SQL injections. If we leave the rules intact and reduce the limit, we will block legitimate traffic. I think it is OK to say that nobody should be using the search form to look for sql statements in our articles. But I could also say that Drupal is smart enough to fight off SQL attacks via the search form. As this is an exercise, this is our position for the moment since a security issue this blatant would have been discovered a long time ago: Let's trust Drupal on this and exclude these rules in this context.

How could we do this really quick? We could do a rule exclusion based on a tag, since all SQL injection rule share a tag. Here is how we can identify it (make sure you skip 921180 as that's not an SQLi rule):

```
grep -F -f ids tutorial-8-example-error-round-2.log | grep -v 921180 | meltags | sucs
```{{execute}}
```
    380 paranoia-level/1
    456 paranoia-level/2
    836 application-multi
    836 attack-sqli
    836 capec/1000/152/248/66
    836 language-multi
    836 OWASP_CRS
    836 PCI/6.5.2
    836 platform-multi
```

That's all sorts of tags, but one we are interested in is `attack-sqli`. Let's call the helper script with `attack-sqli` as tag parameter:

```
grep -F -f ids tutorial-8-example-error-round-2.log | grep -v 921180 | \
modsec-rulereport.rb --runtime --target --bytag attack-sqli
```{{execute}}
```
# ModSec Rule Exclusion: 942100 via tag attack-sqli: (Msg: SQL Injection Attack Detected via libinjection)
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node"
        "phase:1,nolog,pass,id:10000,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"

# ModSec Rule Exclusion: 942190 via tag attack-sqli: (Msg: Detects MSSQL code execution and information …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node"
        "phase:1,nolog,pass,id:10001,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"

# ModSec Rule Exclusion: 942200 via tag attack-sqli: (Msg: Detects MySQL comment-/space-obfuscated …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node"
        "phase:1,nolog,pass,id:10002,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"

# ModSec Rule Exclusion: 942260 via tag attack-sqli: (Msg: Detects basic SQL authentication bypass …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node"
        "phase:1,nolog,pass,id:10003,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"

# ModSec Rule Exclusion: 942270 via tag attack-sqli: (Msg: Looking for basic sql injection. Common …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node"
        "phase:1,nolog,pass,id:10004,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"

# ModSec Rule Exclusion: 942480 via tag attack-sqli: (Msg: SQL Injection Attack)
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node"
        "phase:1,nolog,pass,id:10005,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"
```

This is always the same `ctl` statement. So by attempting a rule exclusion by tag name, we get the same rule exclusion for all the individual alerts. The script could be a bit smarter and condense this by itself, but for the time being, we need to do this ourselves to get the desired configuration:

```
# ModSec Rule Exclusion: All SQLi rules for parameter keys on search form via tag attack-sqli
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
        "phase:1,nolog,pass,id:10001,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"
```

Since we have removed the runtime rule exclusion for 921180 HTTP Parameter Pollution, the rule ID 921180 is free again. We re-use it for this SQLi rule exclusion.

That's it for the 2nd tuning round: We cleaned out all the scores above 50. Time to reduce the anomaly threshold to 50, let it rest a bit and then examine the logs for the third batch.

