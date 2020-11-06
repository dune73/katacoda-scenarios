This is a Katacoda scenario based on a tutorial that has been published as part of a larger series of Apache / ModSecurity / OWASP Core Rule Set tutorials at [netnea](https://netnea.com/apache-tutorials).

### What are we doing?

We are configuring a minimal Apache web server and will occasionally be talking to it with curl, the TRACE method and ab.

### Why are we doing this?

A secure server is one that permits only as much as what is really needed. Ideally, you would build a server based on a minimal system by enabling additional features individually. This is also preferable in terms of understanding what’s going on, because this is the only way of knowing what is really configured.
Starting with a minimal system is also helpful in debugging. If the error is not present in the minimal system, features are added individually and the search for the error goes on. When the error occurs, it is identified to be related to the last configuration directive added.

### Requirements

**The requirements are already met here on Katacoda. So nothing to do for you and you can start immediately.**

* An Apache web server, ideally one created using the file structure shown in [Tutorial 1 (Compiling an Apache web server)](https://www.netnea.com/cms/apache-tutorial-1_compiling-apache).

