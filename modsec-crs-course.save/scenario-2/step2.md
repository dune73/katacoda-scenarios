Let’s go through this configuration step-by-step.

It's probably best if you open the configuration file and browse it side by side with the text here.

```
less /apache/conf/httpd.conf
```{{execute}}

We are defining _ServerName_ as _localhost_, because we are still working in a lab-like setup. In production the fully qualified host name of the service has to be entered here.

The server requires an administrator e-mail address, primarily for display on error pages. This is defined in _ServerAdmin_.

The _ServerRoot_ directory indicates the main or root directory of the server. It is a symbolic link set as a trick in Tutorial 1. We’ll make good use of this, because by reassigning this symbolic link we will be able to test a series of different compiled versions of Apache without having to change anything in the configuration file.

We then assign the user and group to _User_ and _Group_. This is a good idea, because we want to prevent the server from running as a root process. In fact, the master or parent process will be running as root, but the actual server or child processes and their threads will be running under the name defined here. The _www-data_ user is the name normally used on Debian/Ubuntu systems. Other distributions use different names. Make sure that the user name and associated group you choose are actually present on the system.

The _PidFile_ specifies the file that Apache writes its process ID number to. The path selected is the default. It is mentioned here so you don’t have to look for this path in the documentation later on.

_ServerTokens_ defines how the server identifies itself. Productive tokens are defined using _Prod_. This means that the server identifies itself only as _Apache_ without the version number and loaded modules which is a bit more discreet. Let’s not fool ourselves: The version of the server can be easily determined over the internet, but we still don't have to send it along as part of the sender for every communication.

_UseCanonicalName_ tells the server which _host names_ and _ports_ to use when it has to write a link to itself. The _On_ value defines that the _ServerName_ is to be used. One alternative would be to use the host header sent by the client, which however we don’t want in our setup.

The _TraceEnable_ directive prevents certain types of spying attacks on our setup. The HTTP _TRACE_ method instructs the web server to return the requests it receives 1:1. This enables us to determine whether a proxy server is interposed and whether it has modified the request. This is no loss in our simple setup, but this information is better kept confidential on a corporate network. So, for the sake of security we are turning _TraceEnable_ off by default.

Broadly speaking, _Timeout_ indicates the maximum time in seconds that may be used to process a request. In reality it is a bit more complicated, but we don’t need to worry about the details at the moment. The default value of 60 seconds is very high. We’ll lower it to 10 seconds.

_MaxRequestWorkers_ is the maximum number of threads working in parallel to reply to requests. The default value is once again a bit high. Let’s set it to 100. If this value is reached in production, then we have a lot of traffic.

By default, the Apache server listens to any available URL on the internet. As we are running this on Katacoda, we will leave it like this. On a production server, this should be restricted to the IP address that is actually used to accessed the server (and not all interfaces that are available). It’s possible to have multiple _Listen_ directives one after the other, but having only one is sufficient for our purposes at the moment.

Let’s now load five modules:

* mpm_event_module : “event” process model
* unixd_module : access to Unix user names and groups
* log_config_module : freely defined access log
* authn_core_module : core module for authentication
* authz_core_module : core module for authorization



We already compiled all of the modules supplied by Apache in Tutorial 1. We will now be adding the most important ones to our configuration. _mpm_event_module_ and _unixd_module_ are needed to operate the server. When compiling in the first tutorial we chose the _event_ process model, which we will now be enabling by loading the module. Of interest: In Apache 2.4 such a fundamental setting as the process model of the server can be set in the configuration. We need the _unixd_ module to run the server (as described above) under the user name we defined.

_log_config_module_ enables us to freely define the access log, which we will be making use of shortly. And finally, there are the two _authn_core_module_ and _authz_core_module_ modules. The first part of the name indicates authentication (_authn_) and authorization (_authz_). Core then means that these two modules are the basis for these functions.

In terms of access security, we often hear about _AAA_, short for _authentication_, _authorization_ and _access control_. Authentication means checking the identity of the user. Authorization means you define the access permissions for a user that has been authenticated. Finally, access control means the decision as to whether access is granted to an authenticated user with the access permissions defined for him. We lay the foundation for this mechanism by loading these two modules. There are a lot of other modules with the _authn_ and _authz_ prefixes which require these modules. For the moment we actually only need the authorization module, but by loading the authentication module we are preparing for extensions later on.

We use _ErrorLogFormat_ to change the format of the error log file. We will be extending the customary log format a bit by precisely defining the time stamp. `[%{cu}t]` will then produce entries such as `[2015-09-24 06:34:29.199635]`. This means the date written backwards, then the time with a precision of microseconds. Writing the date backwards makes it more easily sortable in the log file; the microseconds provide precise information as to the time of the entry and enable conclusions to be made about how long processing takes in the different modules. This is also the purpose of the next configuration part, `[%-m:%-l]`, that specifies the module doing the logging and the _log level_, i.e. the severity of the error. After this come the IP address of the client (` %-a`), a unique identifier for the request (`%-L`) (a unique ID which can be used in later tutorials in correlation to requests) and the actual message, which we reference using `%M`.

We use _LogFormat_ to define a format for the access log file. We give it the name _combined_. This common format includes the client IP address, time stamp, methods, path, HTTP version, HTTP status code, response length, referer and the name of the browser (User-Agent). For the timestamp we are selecting a structure that is quite complicated. The reason for this is the desire to use the same format for timestamps as in the error log and access logs. While easy identification is available in the error log, we have to painstakingly put together the timestamp for the access log format.

By using _debug_ we are setting the _LogLevel_ for the error log file to the highest level. This is too chatty for production, but it makes perfect sense in a lab-like setting. Apache is not very chatty in general so the volume of data is usually easy enough to handle.

We assign the error log file by adding the path _logs/error.log_ to _ErrorLog_. This path is relative to the _ServerRoot_ directory.

We now use _LogFormat combined_ for our access log file called _logs/access.log_.

The web server delivers files. It searches for them on a disk partition or generates them with help from an installed application. We are still using a simple case here and tell the server to look for the files in _DocumentRoot_. _/apache/htdocs_ is an absolute path below _ServerRoot_. A relative path could be entered, but it's best to make things clear here! Specifically, _DocumentRoot_ means that the URL path _/_ is being mapped to the _/apache/htdocs_ operating system path.

Now comes a _directory_ block. We use this block to prevent files from being delivered outside the _DocumentRoot_ we defined. We forbid any access to the / path using the _Require all denied_ directive. This entry refers to the authentication (_all_), makes a statement about authorization (_Require_) and defines access: _denied_, i.e. no access for anyone, at least to the _/_ directory.

We set the _Options_ directive to _SymLinksIfOwnerMatch_. We can use _Options_ to define the special features to take into account when sending the / directory. Actually, none at all and that’s why in production we would write Options _None_. But in our case we have set _DocumentRoot_ to a symbolic link and it can only be searched for and found if we assign _SymLinksIfOwnerMatch_ to the server, also allowing symlinks below /. At least if the permissions are clear. For security reasons, on production systems it is best to not to rely on symlinks when serving files. But convenience still takes precedence on our test system.

Let’s now open up a _VirtualHost_. It corresponds to the _Listen_ directive defined above. Together with the _Directory_ block we just defined, it defines that by default our web server does not permit any access at all. However, we want to permit access to IP address _127.0.0.1, Port 80_, which is defined in this block.

Specifically, we permit access to our _DocumentRoot_. The final instruction here is _Require all granted_, where unlike the _/_ directory we permit full access. Unlike above, from this path on no provision is made for symlinks or any special capabilities: _Options None_.

