This is a Katacoda scenario based on a tutorial that has been published as part of a larger series of Apache / ModSecurity / OWASP Core Rule Set tutorials at [netnea](https://netnea.com/apache-tutorials).

### What are we doing?

We are compiling the ModSecurity module, embedding it in the Apache web server, creating a base configuration and dealing with false positives for the first time.


### Why are we doing this?

ModSecurity is a security module for the web server. The tool enables the inspection of both the request and the response according to predefined rules. This is also called a Web Application Firewall. It gives the administrator direct control over the requests and the responses passing through the system. The module also provides new options for monitoring, because the entire traffic between client and server can be written 1:1 to the hard disk. This helps with debugging.


### Requirements

**The requirements are already met here on Katacoda. So nothing to do for you and you can start immediately.**

* An Apache web server, ideally one created using the file structure shown in [Tutorial 1 (Compiling Apache)](https://www.netnea.com/cms/apache-tutorial-1_compiling-apache/).
* Understanding of the minimal configuration in [Tutorial 2 (Configuring a Minimal Apache Web Server)](https://www.netnea.com/cms/apache-tutorial-2_minimal-apache-configuration/).
* An Apache web server with SSL/TLS support as in [Tutorial 4 (Enabling Encryption with SSL/TLS)](https://www.netnea.com/cms/apache-tutorial-4_configuring-ssl-tls/).
* An expanded access log and a set of shell aliases as discussed in [Tutorial 5 (Extending and analyzing the access log)](https://www.netnea.com/cms/apache-tutorial-5/apache-tutorial-5_extending-access-log/)


## License / Copying / Further use

This Katacoda scenario is licensed under a **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License**.
