The simple way of dealing with a *false positive* is to simply disable the rule. We are thus making the alarm disappear by excluding a certain rule from the rule set. The CRS term for this technique is called *Rules Exclusion* or *Exclusion Rules*. It is called *Rule* because this exclusion involved writing rules or directives resembling rules themselves.

Excluding a rule completely takes very little effort, but it is, of course, potentially risky because the rule is not being disabled for just legitimate users, but for attackers as well. By completely disabling a rule, we are restricting the capability of *ModSecurity*. Or, expressed more drastically, we’re pulling the teeth out of the *WAF*.

Especially at higher paranoia levels, there are rules that just fail to work with some applications and trigger false alarms in all sorts of situations. So there is a use for disabling a rule completely. One notable example is rule ID `920300`: *Request Missing an Accept Header*. There are just so many user agents that submit requests without an accept header, there is a rule dedicated to the problem. Let's raise the paranoia level to 2 by setting the `tx.paranoia_level` variable to 2 in rule ID 900,000.  Then we will send a request without an `Accept` header to trigger an alert as follows (I recommend returning the paranoia level to 1 again afterwards):

```
curl -v -H "Accept;" http://localhost/index.html
```{{execute}}

```
...
> GET /index.html HTTP/1.1
> User-Agent: curl/7.47.0
> Host: localhost
> Accept:
...
```

```
tail /apache/logs/error.log | melidmsg
```{{execute}}

```
920300 Request Missing an Accept Header
```

So the rule has been triggered as desired. Let us now exclude the rule. We have multiple options and we start with the simplest one: We exclude the rule at startup time for Apache. This means it removes the rule from the set of loaded rules and no processor cycles will be spent on the rule once the server has started. Of course, we can only remove things which have been loaded before. So this directive has to be placed after the CRS include statement. In the config recipe earlier in this tutorial, we reserved some space for these sorts of exclusion rules. We fill in our exclusion directive in this location:

```
# === ModSec Core Rule Set: Startup Time Rules Exclusion (no ids)

# ModSec Exclusion Rule: 920300 Request Missing an Accept Header
SecRuleRemoveById 920300
```

The example comes with a comment, which describes the rule being excluded. This is a good practice, which you should adopt as well. We have the option to exclude by ID (as we just did), to add several comma separated rule IDs, to configure a rule range or we can select the rule by one of its tags. Here is an example using one of the tags of the rule 920,300:

```
# ModSec Exclusion Rule: 920300 Request Missing an Accept Header
SecRuleRemoveByTag "MISSING_HEADER_ACCEPT$"
```

As you can see, this directive accepts regular expressions as parameters. Unfortunately, the support is not universal: For example, the *OR* functionality, expressed with a pipe character, is not implemented. In practice, you will have to try it out and see for yourself what works and what does not.

Technically, there is an additional directive, `SecRuleRemoveByMsg`. However, the messages are not guaranteed to be stable between releases and they are not very consistent anyways. So you should not try to build exlcusion rules for the Core Rule Set via this directive.

So these are startup rule exclusions. Excluding a rule in this manner is simple and readable, but it is also a drastic step which we will not use in a production setup very often. Because, if our issues with the rule 920300 are limited to a single legitimate agent checking the availability of our service by requesting the index page, we can limit the exclusion to this individual request. This is no longer a startup time rule exclusion, but a runtime exclusion which is being applied on certain conditions. Runtime exclusions leverage the *SecRule* directive combined with a special action executing the rule exclusion. This depends on the SecRule statement running before the rule in question is applied. That's why runtime rule exclusions have to be placed before the Core Rule Set include statement, where we also reserved a space for this type of exclusion rule:

```
# === ModSec Core Rule Set: Runtime Exclusion Rules (ids: 10000-49999)

# ModSec Exclusion Rule: 920300 Request Missing an Accept Header
SecRule REQUEST_FILENAME "@streq /index.html" \
    "phase:1,nolog,pass,id:10000,ctl:ruleRemoveById=920300"
```

Now this is harder to read. Watch out for the *ctl* statement: `ctl:ruleRemoveById=920300`. This is the control action, which is used for runtime changes of the configuration of the ModSecurity rule engine. We use *ruleRemoveById* as the control statement and apply it to rule ID 920300. This block is placed within a standard *SecRule* directive. This allows us to use the complete power of *SecRule* to exclude rule 920300 in very specific situations. Here we exclude it based on the path of the request, but we could apply it depending on the agent's IP address - or a combination of the two in a chained rule statement.

As with the startup rule exclusions, we are not limited to an exclusion by rule ID. Exclusions by tag will work just as well (`ctl:ruleRemoveByTag`). Again, regular expressions are supported, but only to a certain extent.

Startup time rule exclusions and runtime rule exclusions have the same effect, but internally, they are really different. With the runtime exclusions, you gain granular control at the cost of performance, as the exclusion is being evaluated for every single request. Startup time exclusions are performing faster and they are easier to read and write.
