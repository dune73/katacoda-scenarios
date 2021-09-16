I've executed the traffic generator after applying the 2nd batch of rule exclusions. If you want to skip that step, here are the log files I ended up with:

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
Reqs with incoming score of   0 |   9535 |  95.3500% |  95.3500% |   4.6500%
Reqs with incoming score of   1 |      0 |   0.0000% |  95.3500% |   4.6500%
Reqs with incoming score of   2 |      0 |   0.0000% |  95.3500% |   4.6500%
Reqs with incoming score of   3 |    388 |   3.8800% |  99.2299% |   0.7701%
Reqs with incoming score of   4 |      0 |   0.0000% |  99.2299% |   0.7701%
Reqs with incoming score of   5 |     41 |   0.4100% |  99.6399% |   0.3601%
Reqs with incoming score of   6 |      0 |   0.0000% |  99.6399% |   0.3601%
Reqs with incoming score of   7 |      0 |   0.0000% |  99.6399% |   0.3601%
Reqs with incoming score of   8 |      0 |   0.0000% |  99.6399% |   0.3601%
Reqs with incoming score of   9 |      0 |   0.0000% |  99.6399% |   0.3601%
Reqs with incoming score of  10 |     36 |   0.3600% |  99.9999% |   0.0001%

Incoming average:   0.1729    Median   0.0000    Standard deviation   0.8842
```

So again, a great deal of the false positives disappeared because of a bunch of exclusions for a score of 60. The original plan was to go from limit 50 to limit 20 first. But the stats are much better now. If we handle the 36 request standing in our way we can go to 10 immediately.

```
egrep " 10 [0-9-]+$" tutorial-8-example-access-round-3.log | alreqid > ids
grep -F -f ids tutorial-8-example-error-round-3.log | melidmsg | sucs
```{{execute}}
```
     72 932160 Remote Command Execution: Unix Shell Code Found
```

Wow, that's really simple. A single rule triggering twice for every request. But what does "Remote Command Execution" mean in this context?

```
grep -F -f ids tutorial-8-example-error-round-3.log | melmatch | sucs
```{{execute}}
```
ARGS:account[pass][pass1]
ARGS:account[pass][pass2]

```
$> grep -F -f ids tutorial-8-example-error-round-3.log | grep 932160 | meldata | sucs
```{{execute}}
```
     72 Matched Data: /bin/bash found within ARGS:account[pass
```

This looks like there is a password `/bin/bash` here. That is probably not the smartest choice, but nothing that should really harm us, since passwords are rarely executed like a shell script. In fact a decent piece of software like Drupal will hash the payload before it is used to check the identity of a user. So we can easily suppress this rule for the password parameter. Or looking forward a bit, we can expect other funny passwords to trigger all sorts of rules on the password field. In fact, this is another situation where it makes sense to disable a whole class of rules. We have multiple options. We can disable by tag as we've done before, or we can disable by rule ID range. Let's look over the various rules files for a moment:

```
REQUEST-901-INITIALIZATION.conf
REQUEST-903.9001-DRUPAL-EXCLUSION-RULES.conf
REQUEST-903.9002-WORDPRESS-EXCLUSION-RULES.conf
REQUEST-903.9003-NEXTCLOUD-EXCLUSION-RULES.conf
REQUEST-903.9004-DOKUWIKI-EXCLUSION-RULES.conf
REQUEST-903.9005-CPANEL-EXCLUSION-RULES.conf
REQUEST-903.9006-XENFORO-EXCLUSION-RULES.conf
REQUEST-903.9007-PHPBB-EXCLUSION-RULES.conf
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
REQUEST-944-APPLICATION-ATTACK-JAVA.conf
REQUEST-949-BLOCKING-EVALUATION.conf
RESPONSE-950-DATA-LEAKAGES.conf
RESPONSE-951-DATA-LEAKAGES-SQL.conf
RESPONSE-952-DATA-LEAKAGES-JAVA.conf
RESPONSE-953-DATA-LEAKAGES-PHP.conf
RESPONSE-954-DATA-LEAKAGES-IIS.conf
RESPONSE-959-BLOCKING-EVALUATION.conf
RESPONSE-980-CORRELATION.conf
```
We do not want to ignore the protocol attacks, but all the application stuff should be off limits. So let's kick the rules from `REQUEST-930-APPLICATION-ATTACK-LFI.conf` to `REQUEST-944-APPLICATION-ATTACK-JAVA.confa for the parameters in question`. This is effectively the rule range from 930,000 to 944,999. The script can't do rule ranges, but we can easily complement this ourselves:

```
# ModSec Rule Exclusion: 930000 - 944999 : All application rules for password parameters
SecRuleUpdateTargetById 930000-944999 "!ARGS:account[pass][pass1]"
SecRuleUpdateTargetById 930000-944999 "!ARGS:account[pass][pass2]"
```

Time to reduce the limit once more (down to 10!) and see what happens.

