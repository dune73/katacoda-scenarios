After the first batch of rule exclusions, we would observe the service and end up with the following new logs:

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
Reqs with incoming score of   0 |   8944 |  89.4400% |  89.4400% |  10.5600%
Reqs with incoming score of   1 |      0 |   0.0000% |  89.4400% |  10.5600%
Reqs with incoming score of   2 |      0 |   0.0000% |  89.4400% |  10.5600%
Reqs with incoming score of   3 |      0 |   0.0000% |  89.4400% |  10.5600%
Reqs with incoming score of   4 |     20 |   0.2000% |  89.6400% |  10.3600%
Reqs with incoming score of   5 |    439 |   4.3900% |  94.0300% |   5.9700%
Reqs with incoming score of   6 |      0 |   0.0000% |  94.0300% |   5.9700%
Reqs with incoming score of   7 |      0 |   0.0000% |  94.0300% |   5.9700%
Reqs with incoming score of   8 |    368 |   3.6800% |  97.7100% |   2.2900%
Reqs with incoming score of   9 |      0 |   0.0000% |  97.7100% |   2.2900%
Reqs with incoming score of  10 |      1 |   0.0100% |  97.7200% |   2.2800%
Reqs with incoming score of  11 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  12 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  13 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  14 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  15 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  16 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  17 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  18 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  19 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  20 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  21 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  22 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  23 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  24 |      0 |   0.0000% |  97.7200% |   2.2800%
Reqs with incoming score of  25 |     76 |   0.7600% |  98.4800% |   1.5200%
Reqs with incoming score of  26 |      0 |   0.0000% |  98.4800% |   1.5200%
Reqs with incoming score of  27 |      0 |   0.0000% |  98.4800% |   1.5200%
Reqs with incoming score of  28 |      0 |   0.0000% |  98.4800% |   1.5200%
Reqs with incoming score of  29 |      0 |   0.0000% |  98.4800% |   1.5200%
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

Incoming average:   1.3969    Median   0.0000    Standard deviation   6.3634


OUTGOING                     Num of req. | % of req. |  Sum of % | Missing %
Number of outgoing req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. outgoing score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with outgoing score of   0 |   9980 |  99.8000% |  99.8000% |   0.2000%
Reqs with outgoing score of   1 |      0 |   0.0000% |  99.8000% |   0.2000%
Reqs with outgoing score of   2 |      0 |   0.0000% |  99.8000% |   0.2000%
Reqs with outgoing score of   3 |      0 |   0.0000% |  99.8000% |   0.2000%
Reqs with outgoing score of   4 |     20 |   0.2000% | 100.0000% |   0.0000%

Outgoing average:   0.0080    Median   0.0000    Standard deviation   0.1787
```

If we compare this to the first run of the statistic script, we reduced the average score from 12.5 to 1.4. This is very impressive. So by focusing on a handful of high scoring requests, we improved the whole service by a lot.

We could expect the high scoring requests of 231 and 189 to be gone, but funnily enough, the cluster at 98 and the one at 10 have also disappeared. We only covered 7 requests in the initial tuning, but two clusters with alerts from over 400 repectively over 3,000 requests are gone, too. And this is not an exceptional effect. It is the standard behaviour if we work with this tuning method: a few rule exclusions that we derieved from the highest scoring requests does away with most of the false alarms.

Our next goal is the group of requests with a score of 60. Let's extract the rule IDs and then examine the alerts a bit.

```
egrep " 60 [0-9-]+$" tutorial-8-example-access-round-2.log | alreqid > ids
```{{execute}}

```
grep -F -f ids tutorial-8-example-error-round-2.log | melidmsg | sucs
```{{execute}}

```
     76 921180 HTTP Parameter Pollution (ARGS_NAMES:keys)
     76 942100 SQL Injection Attack Detected via libinjection
    152 942190 Detects MSSQL code execution and information gathering attempts
    152 942200 Detects MySQL comment-/space-obfuscated injections and backtick …
    152 942260 Detects basic SQL authentication bypass attempts 2/3
    152 942270 Looking for basic sql injection. Common attack string for mysql, …
    152 942410 SQL Injection Attack
```

```
grep -F -f ids tutorial-8-example-error-round-2.log | meluri | sucs
```{{execute}}

```
    912 /drupal/index.php/search/node
```

So this points to a search form and payloads resembling SQL injections (outside of the first rule 921180, which we have seen before). It's obvious that a search form will attract SQL injection attacks. But then I know this was legitimate traffic (I filled in the forms personally when I searched for SQL statements in the Drupal articles I had posted as an exercise) and we are now facing a dilemma: If we suppress the rules, we open a door for SQL injections. If we leave the rules intact and reduce the limit, we will block legitimate traffic. I think it is OK to say that nobody should be using the search form to look for sql statements in our articles. But I could also say that Drupal is smart enough to fight off SQL attacks via the search form. As this is an exercise, this is our position for the moment: Let's exclude these rules. Let's feed it all into our helper script:

```
grep -F -f ids tutorial-8-example-error-round-2.log | modsec-rulereport.rb -m combined
```{{execute}}

```
76 x 921180 HTTP Parameter Pollution (ARGS_NAMES:keys)
------------------------------------------------------
      # ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (ARGS_NAMES:keys)
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:keys"

76 x 942100 SQL Injection Attack Detected via libinjection
----------------------------------------------------------
      # ModSec Rule Exclusion: 942100 : SQL Injection Attack Detected via libinjection
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942100;ARGS:keys"

152 x 942190 Detects MSSQL code execution and information gathering attempts
----------------------------------------------------------------------------
      # ModSec Rule Exclusion: 942190 : Detects MSSQL code execution and information gathering attempts
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10001,ctl:ruleRemoveTargetById=942190;ARGS:keys"

152 x 942200 Detects MySQL comment-/space-obfuscated injections and backtick termination
----------------------------------------------------------------------------------------
      # ModSec Rule Exclusion: 942200 : Detects MySQL comment-/space-obfuscated injections and backtick …
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10002,ctl:ruleRemoveTargetById=942200;ARGS:keys"

152 x 942260 Detects basic SQL authentication bypass attempts 2/3
-----------------------------------------------------------------
      # ModSec Rule Exclusion: 942260 : Detects basic SQL authentication bypass attempts 2/3
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10003,ctl:ruleRemoveTargetById=942260;ARGS:keys"

152 x 942270 Looking for basic sql injection. Common attack string for mysql, oracle and others.
------------------------------------------------------------------------------------------------
      # ModSec Rule Exclusion: 942270 : Looking for basic sql injection. Common attack string for mysql, …
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10004,ctl:ruleRemoveTargetById=942270;ARGS:keys"

152 x 942410 SQL Injection Attack
---------------------------------
      # ModSec Rule Exclusion: 942410 : SQL Injection Attack
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10005,ctl:ruleRemoveTargetById=942410;ARGS:keys"
```

We had separated a spot for 921180 exclusions before. We put the first rule into that position and end up with the following:

```
# ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (multiple variables)
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
    "phase:2,nolog,pass,id:10001,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:ids[]"
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
    "phase:2,nolog,pass,id:10002,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:keys"
```

With 942100, the case is quite clear. But let's look at the alert message itself. There we see that ModSecurity used a special library to identify what it thought an SQL injection attempt. So instead of a regular expression, a dedicated injection parser was used.

```
grep -F -f ids tutorial-8-example-error-round-2.log | grep 942100 | head -1
```{{execute}}

```
[2017-08-28 08:45:06.834969] [-:error] - - [client 127.0.0.1] ModSecurity: Warning. detected SQLi using  …
libinjection with fingerprint 'UEkn' [file "/core-rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf"]  …
[line "68"] [id "942100"] [rev "1"] [msg "SQL Injection Attack Detected via libinjection"]  …
[data "Matched Data: UEkn found within ARGS:keys: union select from users"] [severity "CRITICAL"] …
[ver "OWASP_CRS/3.0.0"] [maturity "1"] [accuracy "8"] [tag "application-multi"]  …
[tag "language-multi"] [tag "platform-multi"] [tag "attack-sqli"]  …
[tag "OWASP_CRS/WEB_ATTACK/SQL_INJECTION"] [tag "WASCTC/WASC-19"] [tag "OWASP_TOP_10/A1"]  …
[tag "OWASP_AppSensor/CIE1"] [tag "PCI/6.5.2"] [hostname "localhost"]  …
[uri "/drupal/index.php/search/node"] [unique_id "WCGCgn8AAQEAACWpwx4AAAAR"]
```

For the treatment of the false positive, this does not matter though, and we take the proposal by the script:

```
# ModSec Rule Exclusion: 942100 : SQL Injection Attack Detected via libinjection
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
    "phase:2,nolog,pass,id:10003,ctl:ruleRemoveTargetById=942100;ARGS:keys"
```

With the remaining ones, we use a shortcut:

```
grep -F -f ids tutorial-8-example-error-round-2.log | grep -v "942100\|921180" | \
modsec-rulereport.rb -m combined | sort
```{{execute}}

```
...
      # ModSec Rule Exclusion: 942190 : Detects MSSQL code execution and information gathering attempts
      # ModSec Rule Exclusion: 942200 : Detects MySQL comment-/space-obfuscated injections and backtick …
      # ModSec Rule Exclusion: 942260 : Detects basic SQL authentication bypass attempts 2/3
      # ModSec Rule Exclusion: 942270 : Looking for basic sql injection. Common attack string for mysql, …
      # ModSec Rule Exclusion: 942410 : SQL Injection Attack
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942190;ARGS:keys"
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10001,ctl:ruleRemoveTargetById=942200;ARGS:keys"
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10002,ctl:ruleRemoveTargetById=942260;ARGS:keys"
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10003,ctl:ruleRemoveTargetById=942270;ARGS:keys"
      SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
              "phase:2,nolog,pass,id:10004,ctl:ruleRemoveTargetById=942410;ARGS:keys"

```

We can simplify this into the following rule, which is then appended to the previous run-time exclusion rule for 942100:


```
# ModSec Rule Exclusion: 942100 : SQL Injection Attack Detected via libinjection
# ModSec Rule Exclusion: 942190 : Detects MSSQL code execution and information gathering attempts
# ModSec Rule Exclusion: 942200 : Detects MySQL comment-/space-obfuscated injections and backtick …
# ModSec Rule Exclusion: 942260 : Detects basic SQL authentication bypass attempts 2/3
# ModSec Rule Exclusion: 942270 : Looking for basic sql injection. Common attack string for mysql, …
# ModSec Rule Exclusion: 942410 : SQL Injection Attack
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" "phase:2,nolog,pass,id:10004,\
    ctl:ruleRemoveTargetById=942100;ARGS:keys,\
    ctl:ruleRemoveTargetById=942190;ARGS:keys,\
    ctl:ruleRemoveTargetById=942200;ARGS:keys,\
    ctl:ruleRemoveTargetById=942260;ARGS:keys,\
    ctl:ruleRemoveTargetById=942270;ARGS:keys,\
    ctl:ruleRemoveTargetById=942410;ARGS:keys"
```

And done. This time, we cleaned out all the scores above 50. Time to reduce the anomaly threshold to 50, let it rest a bit and then examine the logs for the third batch.
