### Step 8: Summarizing all rule exclusions

Time to look back and rearrange the configuration file with all the rule exclusions. I have regrouped them a bit, swapped the rule IDs 10001 and 10002, and I added some comments. It's quite a few of rule exclusions. But then it's also for a site blogging about SQL running at paranoia level 4; not too bad I think.

```
# === ModSec Core Rule Set: Runtime Exclusion Rules (ids: 10000-49999)

# ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
        "phase:1,nolog,pass,id:10000,ctl:ruleRemoveTargetById=942431;ARGS:ids[]"
SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/attachments" \
        "phase:1,nolog,pass,id:10001,ctl:ruleRemoveTargetById=942431;ARGS:ajax_page_state[libraries]"

# ModSec Rule Exclusion: All SQLi rules for parameter keys on search form via tag attack-sqli
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
        "phase:1,nolog,pass,id:10002,ctl:ruleRemoveTargetByTag=attack-sqli;ARGS:keys"


# === ModSecurity Core Rule Set Inclusion

Include    /apache/conf/crs/rules/*.conf


# === ModSec Core Rule Set: Startup Time Rules Exclusions

# ModSec Rule Exclusion: 920273 : Invalid character in request (outside of very strict set)
SecRuleRemoveById 920273

# ModSec Rule Exclusion: 942432 : Restricted SQL Character Anomaly Detection (args): 
# number of special characters exceeded (2)
SecRuleRemoveById 942432

# ModSec Rule Exclusion: 942450 : SQL Hex Encoding Identified (severity: 5 CRITICAL)
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES"
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES_NAMES"


# ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution
SecRuleRemoveById 921180


# ModSec Rule Exclusion: 930000 - 944999 : All application rules for password parameters
SecRuleUpdateTargetById 930000-944999 "!ARGS:account[pass][pass1]"
SecRuleUpdateTargetById 930000-944999 "!ARGS:account[pass][pass2]"
SecRuleUpdateTargetById 930000-944999 "!ARGS:pass"

```

