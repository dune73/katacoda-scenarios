Before coming to the end of this tutorial here’s one more tip that often proves useful in practice: _ModSecurity_ is not just a _Web Application Firewall_. It is also a very precise debugging tool. The entire traffic between client and server can be logged. This is done as follows:

```
SecRule REMOTE_ADDR  "@streq 127.0.0.1"   "id:12000,phase:1,pass,log,auditlog,\
	msg:'Initializing full traffic log'"
```
We then find the traffic for the client 127.0.0.1 specified in the rule in the audit log.

```
curl localhost
```{{execute}}

```
sudo tail -1 /apache/logs/modsec_audit.log
```{{execute}}

This should look similar to the following:

```
localhost 127.0.0.1 - - [17/Oct/2015:06:17:08 +0200] "GET /index.html HTTP/1.1" 404 214 "-" "-" …
UcAmDH8AAQEAAGUjAMoAAAAA "-" /20151017/20151017-0617/20151017-061708-UcAmDH8AAQEAAGUjAMoAAAAA …
0 15146 md5:e2537a9239cbbe185116f744bba0ad97 
```

Here is a crafty one-liner to dump the full traffic of the last request in the `modsec_audit.log` file:

```
sudo cat /apache/logs/audit/$(tail -1 /apache/logs/modsec_audit.log  | cut -d\  -f16)
```{{execute}}

```
--c54d6c5e-A--
[17/Oct/2015:06:17:08 +0200] UcAmDH8AAQEAAGUjAMoAAAAA 127.0.0.1 52386 127.0.0.1 80
--c54d6c5e-B--
GET /index.html HTTP/1.1
User-Agent: curl/7.35.0 (x86_64-pc-linux-gnu) libcurl/7.35.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 …
Host: localhost
Accept: */*

--c54d6c5e-F--
HTTP/1.1 200 OK
Date: Tue, 27 Oct 2015 21:39:03 GMT
Server: Apache
Last-Modified: Tue, 06 Oct 2015 11:55:08 GMT
ETag: "2d-5216e4d2e6c03"
Accept-Ranges: bytes
Content-Length: 45

--c54d6c5e-E--
<html><body><h1>It works!</h1></body></html>
...

```

The rule that logs traffic can of course be customized, enabling us to precisely see what goes into the server and what it returns (only a specific client IP, a specific user, only a application part with a specific path, etc.). It often allows you to quickly find out about the misbehavior of an application.

We have reached the end of this tutorial. *ModSecurity* is an important component for the operation of a secure web server. This tutorial has hopefully provided a successful introduction to the topic.
