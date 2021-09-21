This is a Katacoda scenario based on a tutorial that has been published as part of a larger series of Apache / ModSecurity / OWASP Core Rule Set tutorials at [netnea](https://netnea.com/apache-tutorials).

### What are we doing?

We are configuring a reverse proxy protecting access to the application and shielding the application server from the internet. In doing so, we’ll become familiar with several configuration methods and will be working with ModRewrite for the first time.


### Why are we doing this?

A modern application architecture has multiple layers. Only the reverse proxy is exposed to the internet. It conducts a security check on the HTTP payload and forwards the requests found to be good to the application server in the second layer. This in turn is connected to a database server located in yet another layer. This is referred to as a three-tier model. In a staggered defense spanning three levels, the reverse proxy or to be technically correct, the gateway server, provides the first look into the encrypted requests. On the way back it is in turn the last instance in which the responses can be checked one last time.

There are a number of ways for converting an Apache server into a reverse proxy. More importantly, there are multiple ways of communicating with the application server. In this tutorial we will be restricting ourselves to the normal HTTP-based `mod_proxy_http`. We will not be discussing other methods of communication such as FastCGI proxy or AJP here. There are also several ways of getting the proxy process going in Apache. We will start by looking at the normal setup using ProxyPass and will afterwards discuss other options using ModRewrite.

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
