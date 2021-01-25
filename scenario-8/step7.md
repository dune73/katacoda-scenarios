We have a new pair of logs: 

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
Reqs with incoming score of   0 |   9561 |  95.6100% |  95.6100% |   4.3900%
Reqs with incoming score of   1 |      0 |   0.0000% |  95.6100% |   4.3900%
Reqs with incoming score of   2 |      0 |   0.0000% |  95.6100% |   4.3900%
Reqs with incoming score of   3 |      0 |   0.0000% |  95.6100% |   4.3900%
Reqs with incoming score of   4 |      0 |   0.0000% |  95.6100% |   4.3900%
Reqs with incoming score of   5 |    439 |   4.3900% | 100.0000% |   0.0000%

Incoming average:   0.2195    Median   0.0000    Standard deviation   1.0244
```

It seems that we are almost done. What rules are behind these remaining alerts?


```
cat tutorial-8-example-access-round-4.log | egrep " 5 [0-9-]+$"  | alreqid > ids
```{{execute}}

```
grep -F -f ids tutorial-8-example-error-round-4.log  | melidmsg | sucs
```{{execute}}

```
     30 921180 HTTP Parameter Pollution (ARGS_NAMES:op)
     41 932160 Remote Command Execution: Unix Shell Code Found
    368 921180 HTTP Parameter Pollution (ARGS_NAMES:fields[])
```

So our friend 921180 is back again for two parameters and another shell execution. Probably another occurrence of the password parameter. Let's check this:

```
grep -F -f ids tutorial-8-example-error-round-4.log  | grep 921180 | modsec-rulereport.rb -m combined
```{{execute}}

```
398 x 921180 HTTP Parameter Pollution (ARGS_NAMES:op)
-----------------------------------------------------
      # ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (ARGS_NAMES:op)
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/metadata" \
              "phase:2,nolog,pass,id:10000,\
              ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:fields[]"
      SecRule REQUEST_URI "@beginsWith /drupal/core/install.php" \
              "phase:2,nolog,pass,id:10001,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:op"
```

It's simple enough to add this in the usual place with new rule IDs. And then the final alert:


```
grep -F -f ids tutorial-8-example-error-round-4.log  | grep 932160 | modsec-rulereport.rb -m combined
```{{execute}}

```
41 x 932160 Remote Command Execution: Unix Shell Code Found
-----------------------------------------------------------
      # ModSec Rule Exclusion: 932160 : Remote Command Execution: Unix Shell Code Found
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/user/login" \
              "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=932160;ARGS:pass"
```

So yes, it is the password field again. I think it is best to execute the same process we performed with the other occurrences of the password. That was probably the registration, while this time it is the login form.

```
SecRuleUpdateTargetById 930000-944999 "!ARGS:pass"
```

And with this, we are done. We have successfully fought all the false positives of a content management system with peculiar parameter formats and a ModSecurity rule set pushed to insanely paranoid levels. 
