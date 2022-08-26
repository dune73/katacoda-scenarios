Now let’s see if our server will start up. For the moment, this again has to be done by the super user:

`sudo ./bin/httpd -X`

Another trick for test operation: Apache is actually a daemon running as a background process. However, for simple tests this can be quite bothersome, because we have to continually start, stop, reload and otherwise manipulate the daemon. The -X option tells Apache that it can do without the daemon and start as a single process/thread in the foreground. This also simplifies the work.

There is likely to be a warning when starting:

```
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using xxx.xxx.xxx.xxx. Set the 'ServerName' directive globally to suppress this message
```

This is unimportant and we can ignore the warning for the time being.
