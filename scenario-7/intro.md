This is a Katacoda scenario based on a tutorial that has been published as part of a larger series of Apache / ModSecurity / OWASP Core Rule Set tutorials at [netnea](https://netnea.com/apache-tutorials).

### What are we doing?

We are embedding the OWASP ModSecurity Core Rule Set in our Apache web server and eliminating false alarms.


### Why are we doing this?

The ModSecurity Web Application Firewall, as we set up in Tutorial 6, still has barely any rules. The protection only works when you configure an additional rule set. The Core Rule Set provides generic blacklisting. This means that they inspect requests and responses for signs of attacks. The signs are often keywords or typical patterns that may be suggestive of a wide variety of attacks. This also entails false alarms (false positives) being triggered and we have to eliminate these for a successful installation.

### Requirements

**The requirements are already met here on Katacoda. So nothing to do for you and you can start immediately.**

* An Apache web server, ideally one created using the file structure shown in [Tutorial 1 (Compiling Apache)](https://www.netnea.com/cms/apache-tutorial-1_compiling-apache/).
* Understanding of the minimal configuration in [Tutorial 2 (Configuring a Minimal Apache Web Server)](https://www.netnea.com/cms/apache-tutorial-2_minimal-apache-configuration/).
* An Apache web server with SSL/TLS support as in [Tutorial 4 (Enabling Encryption with SSL/TLS)](https://www.netnea.com/cms/apache-tutorial-4_configuring-ssl-tls/).
* An expanded access log and a set of shell aliases as discussed in [Tutorial 5 (Extending and analyzing the access log)](https://www.netnea.com/cms/apache-tutorial-5/apache-tutorial-5_extending-access-log/)
* An Apache web server with ModSecurity as shown in [Tutorial 6 (Embedding ModSecurity)](https://www.netnea.com/cms/apache-tutorial-6/apache-tutorial-6_embedding-modsecurity/).

