But does it really work? Here are some attempts:

```
curl http://localhost/login/displayLogin.do
```{{execute}}

-> OK (ModSecurity permits access. But this page itself does not exist. So we get 404, Page not Found)


```
curl http://localhost/login/displayLogin.do?debug=on
```{{execute}}

-> FAIL

```
curl http://localhost/login/admin.html
```{{execute}}

-> FAIL (Again a 404, but the error log should show a deny with status 404)

```
curl -d "username=john&password=test" http://localhost/login/login.do
```{{execute}}

-> OK (ModSecurity permits access. But this page itself does not exist. So we get 404, Page not Found)

```
curl -d "username=john&password=test&backdoor=1" http://localhost/login/login.do
```{{execute}}

-> FAIL

```
curl -d "username=john5678901234567890123456789012345678901234567890123456789012345&password=test" \
http://localhost/login/login.do
```{{execute}}

-> FAIL

```
curl -d "username=john'&password=test" http://localhost/login/login.do
```{{execute}}

-> FAIL

```
curl -d "username=john&username=jack&password=test" http://localhost/login/login.do
```{{execute}}
-> FAIL

A glance at the server’s error log proves that the are applied exactly as we defined them (excerpt filtered)

```
[2017-12-17 16:04:06.363090] [-:error] 127.0.0.1:53482 WjaHZrq3BsfzODHx0EBwoQAAAAM [client 127.0.0.1] …
ModSecurity: Access denied with code 403 (phase 2). Match of "rx ^(username|password|sectoken)$" …
against "ARGS_NAMES:debug" required. [file "/apache/conf/httpd.conf_pod_2017-12-17_12:10"] [line "227"] …
[id "11300"] [msg "Unknown parameter: ARGS_NAMES:debug"] [tag "Login Whitelist"] [hostname "localhost"] …
[uri "/login/displayLogin.do"] [unique_id "WjaHZrq3BsfzODHx0EBwoQAAAAM"]
[2017-12-17 16:04:13.818721] [-:error] 127.0.0.1:53694 WjaHbbq3BsfzODHx0EBwogAAAAU [client 127.0.0.1] …
ModSecurity: Access denied with code 404 (phase 1). Unconditional match in SecAction. [file …
"/apache/conf/httpd.conf_pod_2017-12-17_12:10"] [line "220"] [id "11299"] …
[msg "Unknown URI /login/admin.html"] [tag "Login Whitelist"] [hostname "localhost"] …
[uri "/login/admin.html"] [unique_id "WjaHbbq3BsfzODHx0EBwogAAAAU"]
[2017-12-17 16:04:27.427211] [-:error] 127.0.0.1:54314 WjaHe7q3BsfzODHx0EBwpAAAAAk [client 127.0.0.1] …
ModSecurity: Access denied with code 403 (phase 2). Match of "rx ^(username|password|sectoken)$" …
against "ARGS_NAMES:backdoor" required. [file "/apache/conf/httpd.conf_pod_2017-12-17_12:10"] …
[line "227"] [id "11300"] [msg "Unknown parameter: ARGS_NAMES:backdoor"] [tag "Login Whitelist"] …
[hostname "localhost"] [uri "/login/login.do"] [unique_id "WjaHe7q3BsfzODHx0EBwpAAAAAk"]
[2017-12-17 16:04:34.347509] [-:error] 127.0.0.1:54616 WjaHgrq3BsfzODHx0EBwpQAAAAo [client 127.0.0.1] …
ModSecurity: Access denied with code 403 (phase 2). Match of "rx ^[a-zA-Z0-9.@-]{1,64}$" against …
"ARGS:username" required. [file "/apache/conf/httpd.conf_pod_2017-12-17_12:10"] [line "243"] [id …
"11500"] [msg "Invalid parameter format: ARGS:username (john56789012345678901234567890123)"] [tag …
"Login Whitelist"] [hostname "localhost"] [uri "/login/login.do"] …
[unique_id "WjaHgrq3BsfzODHx0EBwpQAAAAo"]
[2017-12-17 16:04:42.069838] [-:error] 127.0.0.1:54850 WjaHirq3BsfzODHx0EBwpgAAAAw [client 127.0.0.1] …
ModSecurity: Access denied with code 403 (phase 2). Match of "rx ^[a-zA-Z0-9.@-]{1,64}$" against …
"ARGS:username" required. [file "/apache/conf/httpd.conf_pod_2017-12-17_12:10"] [line "243"] …
[id "11500"] [msg "Invalid parameter format: ARGS:username (john')"] [tag "Login Whitelist"] …
[hostname "localhost"] [uri "/login/login.do"] [unique_id "WjaHirq3BsfzODHx0EBwpgAAAAw"]
[2017-12-17 16:04:55.542582] [-:error] 127.0.0.1:55288 WjaHl7q3BsfzODHx0EBwpwAAAAs [client 127.0.0.1] …
ModSecurity: Access denied with code 403 (phase 2). Operator GT matched 1 at ARGS. [file …
"/apache/conf/httpd.conf_pod_2017-12-17_12:10"] [line "232"] [id "11400"] [msg "ARGS occurring …
more than once"] [tag "Login Whitelist"] [hostname "localhost"] [uri "/login/login.do"] …
[unique_id "WjaHl7q3BsfzODHx0EBwpwAAAAs"]
```

It works from top to bottom and it seems the behaviour is just what we expected.
