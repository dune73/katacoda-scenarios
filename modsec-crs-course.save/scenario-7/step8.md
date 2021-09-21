Next we look at excluding an individual parameter from being evaluated by a specific rule. So unlike our example 920300, which looked at the specific Accept header, we are now targeting rules examining the ARGS group of variables.

Let's assume we have a password field in an authentication scheme like we used in the previous tutorial. Users are advised to use hard to guess passwords with lots of special characters which leads to the Core Rule Set sending a steady stream of alerts because of the strange passwords in this parameter field.

Here is an artificial example triggering the rule 942100, which leverages the libinjection library to detect SQL injections. Execute this command and you get an alert:

```
curl --data "password=' or f7x=gZs" localhost/login/login.do
```{{execute}}

There is little wrong with this password from a security perspective. In fact, we should just disable this rule. But of course, it would be wrong to disable this rule completely. It serves a very important purpose with many other parameters. Ideally, we want to exclude the parameter password from being examined by this rule. Here is the startup time rule exclusion performing this task:

```
# ModSec Exclusion Rule: 942100 SQL Injection Attack Detected via libinjection
SecRuleUpdateTargetById 942100 !ARGS:password
```

This directive adds "not ARGS:password" to the list of parameters to be examined by rule 942100. This effectively excludes the parameter from the evaluation. This directive also accepts rule ranges as parameters. Of course, this directive also exists in a variant where we select the rule via its tag:


```
# ModSec Exclusion Rule: 942100 SQL Injection Attack Detected via libinjection
SecRuleUpdateTargetByTag "attack-sqli" !ARGS:password
```

The tag we are using in this example, *attack-sqli*, points to a wide range of SQL injection rules. So it will prevent a whole class of rules from looking at the password parameter. This makes sense for this password parameter, but it might go too far for other parameters. So it really depends on the application and the parameter in question.

A password parameter is generally only used on the login request, so we can work with the `SecRuleUpdateTargetById` directive in practice, so that all occurrences of said parameter are exempt from examination by rule 942100. But let me stress, that this directive is server-wide. If you have multiple services with multiple Apache virtual hosts each running a different application, then `SecRuleUpdateTargetById` and `SecRuleUpdateTargetByTag` will disable the said rule or rules respectively for all occurrences of the password parameter on the whole server.

So let's assume you want to exclude *password* only under certain conditions. For example the rule should still be active when a scanner is submitting the request. One fairly good way to detect scanners is by looking at the *Referer* request header. So the idea is to check the correct header and then exclude the parameter from examination by 942100. This runtime rule exclusion works with a control action, similar to the ones we have seen before:

```
SecRule REQUEST_HEADERS:Referer "@streq http://localhost/login/displayLogin.do" \
    "phase:1,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942100;ARGS:password"
```

The format of the control action is really difficult to grasp now: In addition to the rule ID, we add a semicolon and then the password parameter as part of the ARGS group of variables. In ModSecurity, this is called the ARGS collection with the colon as separator. Try to memorize this! 

In professional use, this is likely the exclusion rule construct that is used the most (not with the Referer header, though, but with the *REQUEST_FILENAME* variable). This exclusion construct is very granular on the parameter level and it can be constructed to have only minimal impact on the requests thanks to the power of *SecRule*. If you would rather go with a tag than with an ID, here is your example: 

```
SecRule REQUEST_HEADERS:Referer "@streq http://localhost/login/displayLogin.do" \
    "phase:1,nolog,pass,id:10000,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:password"
```

This section was very important. Therefore, to summarize once again: We define a rule to suppress another rule. We use a pattern for this which lets us define a path as a condition. This enables us to disable rules for individual parts of an application but only in places where false alarms occur. And at the same time, it prevents us from disabling rules on the entire server.

With this, we have seen all basic methods to handle false positives via rule exclusions. You now use the patterns for *exclusion rules* described above to work through the various *false positives*. 
