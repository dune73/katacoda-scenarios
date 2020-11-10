In Tutorial 6, in which we embedded ModSecurity itself, we marked out a section for the Core Rule Set. We now add two *Include* directives into this section. Specifically, four parts are added to the existing configuration. (1) The Core Rules base configuration, (2) a part for self-defined rule exclusions before the Core Rules. Then (3) the Core Rules themselves and finally a part (4) for rule exclusions after the Core Rules.

The rule exclusions are directives and rules used for managing the false alarms described above. Some false alarms must be prevented before the corresponding Core Rule is loaded. Some false alarms can only be intercepted following the definition of the core rule itself. But one thing at a time. Here is the new block of configuration which we will insert into the base configuration we assembled when we enabled ModSecurity:

```
# === ModSec Core Rule Set Base Configuration (ids: 900000-900999)

Include    /apache/conf/crs/crs-setup.conf

SecAction "id:900110,phase:1,pass,nolog,\
  setvar:tx.inbound_anomaly_score_threshold=10000,\
  setvar:tx.outbound_anomaly_score_threshold=10000"

SecAction "id:900000,phase:1,pass,nolog,\
  setvar:tx.paranoia_level=1"


# === ModSec Core Rule Set: Runtime Exclusion Rules (ids: 10000-49999)

# ...


# === ModSecurity Core Rule Set Inclusion

Include    /apache/conf/crs/rules/*.conf


# === ModSec Core Rule Set: Startup Time Rules Exclusions (no ids)

# ...

```

The Core Rule Set comes with a base configuration file named `crs-setup.conf` which we prepared during the installation. Copying the original example file guarantees that we can update the Core Rule Set distribution without harming our copy of the config file unless we want to. 

We have the option to edit settings in that base configuration file. However, the strategy for this series of tutorials has been to define all the important things in our single Apache configuration file. We do not want to insert the complete contents of the `crs-setup.conf` file into our configuration (but we include it) in order to get the minimal set of configuration items needed to run the Core Rules. I do not want to dive into all the options in the settings file, but it is worth having a look at.

For now, we leave the file untouched, but we take three important values out of `crs-setup.conf` and define them in our config so we have them in sight at all times. We define two thresholds in the unconditional rule _900110_: The inbound anomaly score and the outbound anomaly score. This is done via the `setvar` action which sets both values to 10000.

What does that mean? The Core Rule Set works with a scoring mechanism by default. For every rule a request violates, there is a score being raised. When all the request rules have passed, the score is compared to the limit. If if hits the limit, the request is blocked. The same thing happens with the responses, where we want to avoid information leaks to the client.

The Core Rule Set comes in blocking mode by default. If a rule is violated and the score hits the limit, the blocking will be effective immediately. But we are not yet sure our service runs smoothly and the danger of false alarms is always there. We want to avoid unwanted blocks, so we set the threshold at a value of 10000. Rule violations score 5 points at most, so even if cumulation is possible, a request is unlikely to hit the limit. Yet, we remain in blocking mode and when we grow more confident in our configuration, we can lower the threshold gradually.

The second rule, id `900000`, defines the _Paranoia Level_ to 1. The Core Rules are divided in four groups at paranoia levels 1 - 4. As the name suggests, the higher the paranoia level, the more paranoid the rules. The default is paranoia level 1, where the rules are quite sane and false alarms are rare. When you raise the PL to 2, additional rules are enabled. Starting with PL 2, you will face more and more false alarms, also called false positives. This number grows with PL3 and when you arrive at PL4, you are likely to face false alarms as though your web application firewall has become quite paranoid, so to speak. We will deal with false positives later in this tutorial, but for the moment you just need to be aware that you can control the aggressiveness of the rule set with the paranoia level setting and that PL3 and PL4 are really for advanced users with very high security needs.
