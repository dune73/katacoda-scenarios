The _TraceEnable_ directive was described above. We have turned it _off_ as a precaution. It can however be very useful in debugging. So, let’s give it a try. Let’s set the option to on in the configuration file (`/apache/conf/httpd.conf`).

```
TraceEnable On
```

After you have edited the file, you have to stop and start the server anew in the separate terminal tab. Then let's make the following curl request:

```
curl -v --request TRACE http://localhost/index.html
```{{execute}}

We are thus accessing the known _URL_ using the _HTTP TRACE method_ (in place of _GET_). We expect the following as the result:

```
* Hostname was NOT found in DNS cache
*  Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 80 (#0)
> TRACE /index.html HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost
> Accept: */*
> 
< HTTP/1.1 200 OK
< Date: Thu, 24 Sep 2015 09:38:01 GMT
* Server Apache is not blacklisted
< Server: Apache
< Transfer-Encoding: chunked
< Content-Type: message/http
< 
TRACE /index.html HTTP/1.1
User-Agent: curl/7.35.0
Host: localhost
Accept: */*

* Connection #0 to host localhost left intact
```

In the _body_ the server repeats the information about the request sent to it as intended. In fact, the lines are identical here. We are thus able to confirm that nothing has happened to the request in transit. If however we had passed through one or more interposed proxy servers, then there would be additional _header_ lines that we would also be able to see as a _client_. At a later point we will become familiar with more powerful tools for debugging. Nevertheless, we don’t want to completely ignore the _TRACE_ method.

Don’t forget to turn _TraceEnable_ off again.

