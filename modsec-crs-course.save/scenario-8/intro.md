This is a Katacoda scenario based on a tutorial that has been published as part of a larger series of Apache / ModSecurity / OWASP Core Rule Set tutorials at [netnea](https://netnea.com/apache-tutorials).

### What are we doing?

To successfully ward off attackers, we are reducing the number of *false positives* for a fresh installation of *OWASP ModSecurity Core Rule Set* and set the anomaly limits to a stricter level step by step.



### Why are we doing this?

A fresh installation of *core rules* will typically have some false alarms. In some special cases, namely at higher paranoia levels, there can be thousands of them. In the last tutorial, we saw a number of approaches for suppressing individual false alarms. It's always hard at the beginning. What we're missing is a strategy for coping with different kinds of false alarms. Reducing the number of false alarms is the prerequisite for lowering the *Core Rule Set* (CRS) anomaly threshold and this, in turn, is required in order to use *ModSecurity* to actually ward off attackers. And only after the false alarms really are disabled, or at least curtailed to a large extent, do we get a picture of the real attackers.

### Requirements

**The requirements are already met here on Katacoda. So nothing to do for you and you can start immediately.**

* An Apache web server, ideally one created using the file structure shown in [Tutorial 1 (Compiling Apache)](https://www.netnea.com/cms/apache-tutorial-1_compiling-apache/).
* Understanding of the minimal configuration in [Tutorial 2 (Configuring a Minimal Apache Web Server)](https://www.netnea.com/cms/apache-tutorial-2_minimal-apache-configuration/).
* An Apache web server with SSL/TLS support as in [Tutorial 4 (Enabling Encryption with SSL/TLS)](https://www.netnea.com/cms/apache-tutorial-4_configuring-ssl-tls/).
* An expanded access log and a set of shell aliases as discussed in [Tutorial 5 (Extending and analyzing the access log)](https://www.netnea.com/cms/apache-tutorial-5/apache-tutorial-5_extending-access-log/)
* An Apache web server with ModSecurity as shown in [Tutorial 6 (Embedding ModSecurity)](https://www.netnea.com/cms/apache-tutorial-6/apache-tutorial-6_embedding-modsecurity/).
* An Apache web server with the Core Rule Set, as shown in [Tutorial 7 (Including the Core Rule Set)](https://www.netnea.com/cms/apache-tutorial-7_including-modsecurity-core-rules/)



## License / Copying / Further use

This Katacoda scenario is licensed under a **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License**.
