Before completing the tutorial, we’d like to take a closer look at the server. Let’s open the engine compartment and take a peek inside. We can get information about our binary as follows:

`sudo ./bin/httpd -V`{{execute}}

```
Server version: Apache/2.4.43 (Unix)
Server built:   November 12 2019 13:32:29
Server's Module Magic Number: 20120211:83
Server loaded:  APR 1.7.0, APR-UTIL 1.6.1
Compiled using: APR 1.7.0, APR-UTIL 1.6.1
Architecture:   64-bit
...
```

Because we specified the version when we compiled, `apr` is mentioned and the `event` MPM appears further below. Incidentally, at the very bottom we see a reference to the web server’s default configuration file and a bit above this the path we can use to find the default _errorlog_.

You can however get even more information from the system and inquire about the modules compiled firmly into the server.

`sudo ./bin/httpd -l`{{execute}}

```
Compiled in modules:
  core.c
  mod_so.c
  http_core.c
```

This and the information above can be helpful for debugging and useful when submitting bug reports. These are typically the first questions that the developer asks.

The binary itself (`/apache/bin/httpd`) is approx. 2.0 MB in size and the list of modules appears as follows:

`ls -lh modules`{{execute}}

```
total 8.8M
-rw-r--r-- 1 myuser root    14K Mar  5 21:09 httpd.exp
-rwxr-xr-x 1 myuser root    36K Mar  5 21:16 mod_access_compat.so
-rwxr-xr-x 1 myuser root    34K Mar  5 21:17 mod_actions.so
-rwxr-xr-x 1 myuser root    49K Mar  5 21:17 mod_alias.so
-rwxr-xr-x 1 myuser root    31K Mar  5 21:17 mod_allowmethods.so
-rwxr-xr-x 1 myuser root    30K Mar  5 21:17 mod_asis.so
-rwxr-xr-x 1 myuser root    47K Mar  5 21:16 mod_auth_basic.so
-rwxr-xr-x 1 myuser root   102K Mar  5 21:16 mod_auth_digest.so
...
```

These are all of the modules distributed along with the server by Apache and we are well aware that we selected the all option for the modules to compile. Additional modules are available from third parties. We don’t need all of these modules, but there are some you'll almost always want to have: They are ready to be included.

