Let’s try out the blockade:

```
curl http://localhost/phpmyadmin
```{{execute}}

We expect the following response:

```
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>403 Forbidden</title>
</head><body>
<h1>Forbidden</h1>
<p>You don't have permission to access /phpmyadmin
on this server.</p>
</body></html>
```

Let’s also have a look at what we can find about this in the _error log_:

```
[2017-02-25 06:46:29.793701] [-:error] 127.0.0.1:50430 WLEaNX8AAQEAAFZKT5cAAAAA …
[client 127.0.0.1] ModSecurity: Access denied with code 403 (phase 1). …
Pattern match "/phpmyadmin" at REQUEST_FILENAME. [file "/apache/conf/httpd.conf_pod_2017-02-25_06:45"] …
[line "140"] [id "10000"] [msg "Blocking access to /phpmyadmin."] [tag "Blacklist Rules"]  …
[hostname "localhost"] [uri "/phpmyadmin"] [unique_id "WLEaNX8AAQEAAFZKT5cAAAAA"]
```

Here, _ModSecurity_ describes the rule that was applied and the action taken: First the timestamp. Then the severity of the log entry assigned by Apache. The _error_ stage is assigned to all _ModSecurity_ messages. Then comes the client IP address. Between that there are some empty fields, indicated only by "-". In Apache 2.4 they remain empty, because the log format has changed and *ModSecurity* is not yet able to understand it. Afterwards comes the actual message which opens with action: _Access denied with code 403_, specifically already in phase 1 while receiving the request headers. We then see a message about the rule violation: The string _"/phpMyAdmin"_ was found in the *REQUEST_FILENAME*. This is exactly what we defined. The subsequent bits of information are embedded in blocks of square brackets. In each block first comes the name and then the information separated by a space. Our rule puts us on line 140 in the file */apache/conf/httpd.conf_modsec_minimal*. As we know, the rule has ID 10000. In _msg_ we see the summary of the rule defined in the rule, where the variable *MATCHED_VAR* has been replaced by the path part of the request. Afterwards comes the tag that we set in _SetDefaultAction_; finally, the tag set in addition for this rule. At the end come the hostname, URI and the unique ID of the request.

We will also find more details about this information in the _audit log_ discussed above. However, for normal use the _error log_ is often enough.
