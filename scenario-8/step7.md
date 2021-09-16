Here is the pair of logs I got after running the traffic generator once more:

* [tutorial-8-example-access-round-4.log](https://www.netnea.com/files/tutorial-8-example-access-round-4.log)
* [tutorial-8-example-error-round-4.log](https://www.netnea.com/files/tutorial-8-example-error-round-4.log)

These are the statistics:

```
cat tutorial-8-example-access-round-4.log | alscores | modsec-positive-stats.rb --incoming
```{{execute}}
```
INCOMING                     Num of req. | % of req. |  Sum of % | Missing %
Number of incoming req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. incoming score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with incoming score of   0 |   9571 |  95.7099% |  95.7099% |   4.2901%
Reqs with incoming score of   1 |      0 |   0.0000% |  95.7099% |   4.2901%
Reqs with incoming score of   2 |      0 |   0.0000% |  95.7099% |   4.2901%
Reqs with incoming score of   3 |    388 |   3.8800% |  99.5899% |   0.4101%
Reqs with incoming score of   4 |      0 |   0.0000% |  99.5899% |   0.4101%
Reqs with incoming score of   5 |     41 |   0.4100% |  99.9999% |   0.0001%

Incoming average:   0.1369    Median   0.0000    Standard deviation   0.6580
```

It seems that we are almost done. What rules are behind these remaining alerts at anomaly score 3 and 5?


```
cat tutorial-8-example-error-round-4.log  | melidmsg | sucs
```{{execute}}

```
     41 932160 Remote Command Execution: Unix Shell Code Found
    388 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
```

Look, the Remote Command Execution is back. What's the matter exactly?

```
$> cat ~/data/git/laboratory/tutorial-8/tutorial-8-example-error-round-4.log | grep 932160 | meluri | sucs
```{{execute}}

```
     41 /drupal/index.php/user/login
```

```
$> cat ~/data/git/laboratory/tutorial-8/tutorial-8-example-error-round-4.log | grep 932160 | melmatch | sucs
```{{execute}}

```
     41 ARGS:pass
```

Ah yes, that makes sense. The previous alerts were the instances where the password had been set, and here, the password is used for the login. We'll simply a
dd this to the previous password rule exclusion:

```
# ModSec Rule Exclusion: 930000 - 944999 : All application rules for password parameters
SecRuleUpdateTargetById 930000-944999 "!ARGS:account[pass][pass1]"
SecRuleUpdateTargetById 930000-944999 "!ARGS:account[pass][pass2]"
SecRuleUpdateTargetById 930000-944999 "!ARGS:pass"
```

And then we're facing 942431 Restricted SQL Character Anomaly Detection again. We have done a rule exclusion for this rule on parameter `ids[]` on path `/drup
al/index.php/contextual/render`. We could kick the rule completely, but given this is the remaining alert, we can also approach this with a bit more patience:

```
cat tutorial-8-example-error-round-4.log | grep 942431 | meluri  | sucs
```{{execute}}

```
    388 /drupal/index.php/quickedit/attachments
```

```
cat tutorial-8-example-error-round-4.log | grep 942431 | melmatch  | sucs
```{{execute}}

```
    388 ARGS:ajax_page_state[libraries]
```

So it's a single parameter again. Let's call the helper script one last time and tell it to use 10002 as the new rule ID.

```
cat tutorial-8-example-error-round-4.log | grep 942431 | \
        modsec-rulereport.rb --runtime --target --byid --baseruleid 10002
```{{execute}}

```
# ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): # of special …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/attachments" 
        "phase:1,nolog,pass,id:10002,ctl:ruleRemoveTargetById=942431;ARGS:ajax_page_state[libraries]"
```

And with this, we are done. We have successfully fought all the false positives of a content management system with peculiar parameter formats and a ModSecurity rule set pushed to insanely paranoid levels.

I suggest you run the traffic generator again and check the output. I did and I ended up with zero alerts. This confirms that our tuning was effective and we were able to bring down the number of alerts to zero with just four relatively simple iterations.

