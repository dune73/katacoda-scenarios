If you do this the first time, it all looks a bit overwhelming. But then it's only been an hour of work or so, which seems reasonable - even more so if you stretch it out over multiple iterations. One thing to help you get up to speed is getting an overview of all the alerts standing behind the scores. It’s a good idea to have a look at the distribution of the scores as described above. A good next step is to get a report of how exactly the *anomaly scores* occurred, such as an overview of the rule violations for each anomaly score. The following construct generates a report like this. On the first line, we extract a list of anomaly scores from the incoming requests which actually appear in the log file. We then build a loop around these *scores*, read the *request ID* for each *score*, save it in the file `ids` and perform a short analysis for these *IDs* in the *error log*.

```
cat tutorial-8-example-access.log | alscorein | sort -n | uniq | egrep -v -E "^0" > scores
```{{execute}}

```
cat scores | while read S; do echo "INCOMING SCORE $S";\
grep -E " $S [0-9-]+$" tutorial-8-example-access.log \
| alreqid > ids; grep -F -f ids tutorial-8-example-error.log | melidmsg | sucs; echo ; done 
```{{execute}}

```
INCOMING SCORE 5
     30 921180 HTTP Parameter Pollution (ARGS_NAMES:op)
   3532 942450 SQL Hex Encoding Identified

INCOMING SCORE 8
      1 920273 Invalid character in request (outside of very strict set)
      1 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)

INCOMING SCORE 10
      4 920273 Invalid character in request (outside of very strict set)

INCOMING SCORE 20
     41 932160 Remote Command Execution: Unix Shell Code Found
    123 920273 Invalid character in request (outside of very strict set)

INCOMING SCORE 24
     50 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
     50 942450 SQL Hex Encoding Identified
    100 920273 Invalid character in request (outside of very strict set)
    100 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)

INCOMING SCORE 30
     76 920273 Invalid character in request (outside of very strict set)
     76 942190 Detects MSSQL code execution and information gathering attempts
     76 942200 Detects MySQL comment-/space-obfuscated injections and backtick termination
     76 942260 Detects basic SQL authentication bypass attempts 2/3
     76 942270 Looking for basic sql injection. Common attack string for mysql, oracle and others
     76 942480 SQL Injection Attack

INCOMING SCORE 35
     76 920273 Invalid character in request (outside of very strict set)
     76 942100 SQL Injection Attack Detected via libinjection
     76 942190 Detects MSSQL code execution and information gathering attempts
     76 942200 Detects MySQL comment-/space-obfuscated injections and backtick termination
     76 942260 Detects basic SQL authentication bypass attempts 2/3
     76 942270 Looking for basic sql injection. Common attack string for mysql, oracle and others
     76 942480 SQL Injection Attack

INCOMING SCORE 37
      5 921180 HTTP Parameter Pollution (ARGS_NAMES:ids[])
      5 942450 SQL Hex Encoding Identified
     15 920273 Invalid character in request (outside of very strict set)
     20 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)

INCOMING SCORE 74
    388 921180 HTTP Parameter Pollution (ARGS_NAMES:editors[])
    388 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
    388 942450 SQL Hex Encoding Identified
   2716 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)
   3104 920273 Invalid character in request (outside of very strict set)

INCOMING SCORE 78
     76 921180 HTTP Parameter Pollution (ARGS_NAMES:keys)
     76 942100 SQL Injection Attack Detected via libinjection
     76 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)
    152 942190 Detects MSSQL code execution and information gathering attempts
    152 942200 Detects MySQL comment-/space-obfuscated injections and backtick termination
    152 942260 Detects basic SQL authentication bypass attempts 2/3
    152 942270 Looking for basic sql injection. Common attack string for mysql, oracle and others
    152 942480 SQL Injection Attack
    228 920273 Invalid character in request (outside of very strict set)

INCOMING SCORE 79
      8 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)
     11 920273 Invalid character in request (outside of very strict set)

INCOMING SCORE 171
      6 921180 HTTP Parameter Pollution (ARGS_NAMES:ids[])
      6 942450 SQL Hex Encoding Identified
     30 942431 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (6)
     96 920273 Invalid character in request (outside of very strict set)
    132 942432 Restricted SQL Character Anomaly Detection (args): # of special characters exceeded (2)
```

Before we finish with this tutorial, let me iterate my tuning policy again:

* Always work in blocking mode
* Highest scoring requests go first
* Work in several iterations

When you grow more proficient, you can reduce the number of iterations and tackle more false alarms in a single batch. Or you can concentrate on the rules that are triggered most often. That may work as well and in the end, when all rule exclusions are in place, you should end up with the same configuration. But in my experience, the policy with the three simple guiding rules is the one with the highest chance of success and the one with the lowest drop out rate.

We have now reached the end of the block consisting of three *ModSecurity tutorials*. The next one will look into setting up a *reverse proxy*.

```

A similar script that has been slightly extended is part of my private toolbox.

Before we finish with this tutorial, let me present my tuning policy again:

* Always work in blocking mode
* Highest scoring requests go first
* Work in several iterations

When you grow more proficient, you can reduce the number of iterations and tackle more false alarms in a single batch. Or you can concentrate on the rules that are triggered most often. That may work as well and in the end, when all rule exclusions are in place, you should end up with the same configuration. But in my experience, this policy with three simple guiding rules is the one with the highest chance of success and the lowest drop out rate. This is how you end up with a tight ModSecurity CRS setup in blocking mode with a low anomaly scoring limit.

We have now reached the end of the block consisting of three *ModSecurity tutorials*. The next one will look into setting up a *reverse proxy*.
