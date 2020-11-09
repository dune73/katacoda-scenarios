Time to look back and rearrange the configuration file with all the rule exclusions. I have regrouped them a bit, I added some comments and reassigned rule IDs. As outlined before, it is not obvious how to arrange the rules. Here, I ordered them by ID, but also included a block where I cover the search form separately.

```
# === ModSec Core Rule Set: Runtime Exclusion Rules (ids: 10000-49999)

# ModSec Rule Exclusion: 921180 : HTTP Parameter Pollution (multiple variables)
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
    "phase:2,nolog,pass,id:10001,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:ids[]"
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" \
    "phase:2,nolog,pass,id:10002,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:keys"
SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/attachments" \
    "phase:2,nolog,pass,id:10003,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:editors[]"
SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/metadata" \
    "phase:2,nolog,pass,id:10004,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:fields[]"
SecRule REQUEST_URI "@beginsWith /drupal/core/install.php" \
    "phase:2,nolog,pass,id:10005,ctl:ruleRemoveTargetById=921180;TX:paramcounter_ARGS_NAMES:op"

# ModSec Rule Exclusion: 942130 : SQL Injection Attack: SQL Tautology Detected.
# ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/contextual/render" \
    "phase:2,nolog,pass,id:10006,ctl:ruleRemoveTargetById=942130;ARGS:ids[],\
                                 ctl:ruleRemoveTargetById=942431;ARGS:ids[]"

# ModSec Rule Exclusion: 942431 : Restricted SQL Character Anomaly Detection (args): …
SecRule REQUEST_URI "@beginsWith /drupal/index.php/quickedit/attachments" \
    "phase:2,nolog,pass,id:10007,ctl:ruleRemoveTargetById=942431;ARGS:ajax_page_state[libraries]"


# Handling alerts for the search form:
# ModSec Rule Exclusion: 942100 : SQL Injection Attack Detected via libinjection
# ModSec Rule Exclusion: 942190 : Detects MSSQL code execution and information gathering attempts
# ModSec Rule Exclusion: 942200 : Detects MySQL comment-/space-obfuscated injections and backtick …
# ModSec Rule Exclusion: 942260 : Detects basic SQL authentication bypass attempts 2/3
# ModSec Rule Exclusion: 942270 : Looking for basic sql injection. Common attack string for mysql, …
# ModSec Rule Exclusion: 942410 : SQL Injection Attack
SecRule REQUEST_URI "@beginsWith /drupal/index.php/search/node" "phase:2,nolog,pass,id:10100,\
   ctl:ruleRemoveTargetById=942100;ARGS:keys,\
   ctl:ruleRemoveTargetById=942190;ARGS:keys,\
   ctl:ruleRemoveTargetById=942200;ARGS:keys,\
   ctl:ruleRemoveTargetById=942260;ARGS:keys,\
   ctl:ruleRemoveTargetById=942270;ARGS:keys,\
   ctl:ruleRemoveTargetById=942410;ARGS:keys"


# === ModSecurity Core Rule Set Inclusion

Include    /apache/conf/crs/rules/*.conf


# === ModSec Core Rule Set: Startup Time Rules Exclusions

# ModSec Rule Exclusion: 942450 : SQL Hex Encoding Identified
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES"
SecRuleUpdateTargetById 942450 "!REQUEST_COOKIES_NAMES"

# ModSec Rule Exclusion: 920273 : Invalid character in request (outside of very strict set)
# ModSec Rule Exclusion: 942432 : Restricted SQL Character Anomaly Detection (args): 
# number of special characters exceeded (2) (severity:  NONE/UNKOWN)
SecRuleRemoveById 920273
SecRuleRemoveById 942432

# ModSec Rule Exclusion: 930000 - 943999 : All application rules for password parameters
SecRuleUpdateTargetById 930000-943999 "!ARGS:account[pass][pass1]"
SecRuleUpdateTargetById 930000-943999 "!ARGS:account[pass][pass2]"
SecRuleUpdateTargetById 930000-943999 "!ARGS:pass"
```
