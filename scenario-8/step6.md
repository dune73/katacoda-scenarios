Here are the new exercise files. It's still the same traffic, but with fewer alerts again thanks to the rule exclusions.

* [tutorial-8-example-access-round-3.log](https://www.netnea.com/files/tutorial-8-example-access-round-3.log)
* [tutorial-8-example-error-round-3.log](https://www.netnea.com/files/tutorial-8-example-error-round-3.log)


This brings us to the following statistics (this time only printing numbers for the incoming requests):

```
cat tutorial-8-example-access-round-3.log | alscores | modsec-positive-stats.rb --incoming
```{{execute}}

```
INCOMING                     Num of req. | % of req. |  Sum of % | Missing %
Number of incoming req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. incoming score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with incoming score of   0 |   9192 |  91.9200% |  91.9200% |   8.0800%
Reqs with incoming score of   1 |      0 |   0.0000% |  91.9200% |   8.0800%
Reqs with incoming score of   2 |      0 |   0.0000% |  91.9200% |   8.0800%
Reqs with incoming score of   3 |      0 |   0.0000% |  91.9200% |   8.0800%
Reqs with incoming score of   4 |      0 |   0.0000% |  91.9200% |   8.0800%
Reqs with incoming score of   5 |    439 |   4.3900% |  96.3100% |   3.6900%
Reqs with incoming score of   6 |      0 |   0.0000% |  96.3100% |   3.6900%
Reqs with incoming score of   7 |      0 |   0.0000% |  96.3100% |   3.6900%
Reqs with incoming score of   8 |    368 |   3.6800% |  99.9900% |   0.0100%
Reqs with incoming score of   9 |      0 |   0.0000% |  99.9900% |   0.0100%
Reqs with incoming score of  10 |      1 |   0.0100% | 100.0000% |   0.0000%

Incoming average:   0.5149    Median   0.0000    Standard deviation   1.7882
```

So again, a great deal of the false positives disappeared because of a bunch of exclusions for a score of 60. For this tuning round, we'll tackle the lone request at 10 and the cluster at 8, allowing us to reduce the anomaly threshold to 10 afterwards, which is already quite low.


```
egrep " (10|8) [0-9-]+$" tutorial-8-example-access-round-3.log | alreqid > ids
```{{execute}}

```
grep -F -f ids tutorial-8-example-error-round-3.log | melidmsg | sucs
```{{execute}}

```
      2 932160 Remote Command Execution: Unix Shell Code Found
    368 921180 HTTP Parameter Pollution (ARGS_NAMES:editors[])
    368 942431 Restricted SQL Character Anomaly Detection (args): # of special characters …
```

The first alert is funny: "Remote command execution." What's this?


```
grep -F -f ids tutorial-8-example-error-round-3.log | grep 932160 | melmatch
```{{execute}}

```
ARGS:account[pass][pass1]
ARGS:account[pass][pass2]
```

```
grep -F -f ids tutorial-8-example-error-round-3.log | grep 932160 | meldata
```{{execute}}

```
Matched Data: /bin/bash found within ARGS:account[pass
Matched Data: /bin/bash found within ARGS:account[pass
```

OK, so there seems to be a password `/bin/bash`. That is probably not the smartest choice, but nothing that should harm us. We can easily suppress this rule for this parameter. Or looking forward a bit, we can expect other funny passwords to trigger all sorts of rules on the password field. And, in fact, the password field is not a typical target of an attack. So this might be a situation where it makes sense to disable a whole class of rules. We have multiple options. We can disable by tag, or we can disable by rule ID range. Let's look over the various rules files:

```
REQUEST-901-INITIALIZATION.conf
REQUEST-903.9001-DRUPAL-EXCLUSION-RULES.conf
REQUEST-903.9002-WORDPRESS-EXCLUSION-RULES.conf
REQUEST-905-COMMON-EXCEPTIONS.conf
REQUEST-910-IP-REPUTATION.conf
REQUEST-911-METHOD-ENFORCEMENT.conf
REQUEST-912-DOS-PROTECTION.conf
REQUEST-913-SCANNER-DETECTION.conf
REQUEST-920-PROTOCOL-ENFORCEMENT.conf
REQUEST-921-PROTOCOL-ATTACK.conf
REQUEST-930-APPLICATION-ATTACK-LFI.conf
REQUEST-931-APPLICATION-ATTACK-RFI.conf
REQUEST-932-APPLICATION-ATTACK-RCE.conf
REQUEST-933-APPLICATION-ATTACK-PHP.conf
REQUEST-941-APPLICATION-ATTACK-XSS.conf
REQUEST-942-APPLICATION-ATTACK-SQLI.conf
REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf
REQUEST-949-BLOCKING-EVALUATION.conf
RESPONSE-950-DATA-LEAKAGES.conf
RESPONSE-951-DATA-LEAKAGES-SQL.conf
RESPONSE-952-DATA-LEAKAGES-JAVA.conf
RESPONSE-953-DATA-LEAKAGES-PHP.conf
RESPONSE-954-DATA-LEAKAGES-IIS.conf
RESPONSE-959-BLOCKING-EVALUATION.conf
RESPONSE-980-CORRELATION.conf
```

We do not want to ignore the protocol attacks, but all the application stuff should be off limits. So let's kick the rules from `REQUEST-930-APPLICATION-ATTACK-LFI.conf` to `REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf`. This is effectively the rule range from 930,000 to 943,999. We can exclude the two parameters for all these rules with the following startup time directives:

```
# ModSec Rule Exclusion: 930000 - 943999 : All application rules for password parameters
SecRuleUpdateTargetById 930000-943999 "!ARGS:account[pass][pass1]"
SecRuleUpdateTargetById 930000-943999 "!ARGS:account[pass][pass2]"
```

We are left with another instance of 921180, plus the 942431 which we have seen before too. Here is what the script proposes:

```
grep -F -f ids tutorial-8-example-error-round-3.log | grep "921180\|942431" | \
modsec-rulereport.rb -m combined 
```{{execute}}

```
448 x 921180 HTTP Parameter Pollution (ARGS_NAMES:editors[])
------------------------------------------------------------
      # ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (ARGS_NAMES:editors[])
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/attachments" \
              "phase:2,nolog,pass,id:10000,\
              ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:editors[]"

448 x 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
----------------------------------------------------------------------------------------------------
      # ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): …
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/attachments" \
              "phase:2,nolog,pass,id:10001,ctl:ruleRemoveTargetById=942431;ARGS:ajax_page_state[libraries]"
```

You know the drill by now: The first one goes with the other 921180 exclusions (don't forget to pick a new rule ID) and the second is added as a new entry:


```
# ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/attachments" \
    "phase:2,nolog,pass,id:10005,ctl:ruleRemoveTargetById=942431;ARGS:ajax_page_state[libraries]"
```

Time to reduce the limit once more (down to 10 this time) and see what happens.
