At the end of this tutorial we are going to be looking at a variety of directives, which an Apache web server started with our configuration file is familiar with, The different loaded modules extend the server’s set of commands. The available configuration parameters are well documented on the Apache Project’s website. In fact, in special cases it can however be helpful to get an overview of the directives made available from the loaded modules. You can get the directives by using the command line flag _-L_.

```
./bin/httpd -L
```{{execute}}

```
<Directory (core.c)
        Container for directives affecting resources located in the specified directories
        Allowed in *.conf only outside <Directory>, <Files>, <Location>, or <If>
<Location (core.c)
        Container for directives affecting resources accessed through the specified URL paths
        Allowed in *.conf only outside <Directory>, <Files>, <Location>, or <If>
<VirtualHost (core.c)
        Container to map directives to a particular virtual host, takes one or more host addresses
        Allowed in *.conf only outside <Directory>, <Files>, <Location>, or <If>
<Files (core.c)
...
```
The directives follow the order in which they are loaded. A brief description of its function comes after each directive.

Using this list it is now possible to determine whether all of the modules loaded in the configuration, referenced respectively, are actually required. In complicated configurations with a large number of loaded modules it may happen that you are unsure whether all of the modules are actually being used.

You can thus get the modules by reading the configuration file, the output of _httpd -L_ summarized for each module and then look in the configuration file to see if any of the directives listed are being used. This nested manner of sending requests demands a find touch, but is one that I can highly recommend. Personally, I have solved it as follows:


```
$> grep LoadModule conf/httpd.conf | awk '{print $2}' | sed -e "s/_module//" | while read M; do \
  echo "Module $M"; R=$(./bin/httpd -L | grep $M | cut -d\  -f1 | tr -d "<" | xargs | tr " " "|"); \
  egrep -q "$R" ./conf/httpd.conf; \
  if [ $? -eq 0 ]; then echo "OK"; else echo "Not used"; fi; echo; \
  done
```{{execute}}

```
Module mpm_event
OK

Module unixd
OK

Module log_config
OK

Module authn_core
Not used

Module authz_core
OK
```

The _authn_core_ module is thus not being used. This is correct, we described it as such above, since it is being loaded for use in the future. The rest of the modules appear to be needed.


So much for this tutorial. You now have a capable server you can work with. We will continue to extend it in subsequent tutorials.

