The reverse proxy server shields the application server from direct client access. However, this also means that the application server is no longer able to see certain types of information about the client and its connection to the reverse proxy. To compensate for this loss, the Proxy module sets three HTTP request header lines that describe the reverse proxy:

* X-Forwarded-For : The IP address of the client
* X-Forwarded-Host : The original HTTP host header in the client request
* X-Forwarded-Server : The name of the reverse proxy server

If multiple reverse proxies are staggered behind one another then the additional IP addresses and server names are comma separated. In addition to this information about the connection, it is also a good idea to pass along yet more information. This would of course include the unique ID, uniquely identifying the request. A well-configured backend server will create a key value similar to our reverse proxy in the log file. Being able to easily correlate the different log file entries simplifies debugging in the future.

A reverse proxy is frequently used to perform authentication. Although we haven’t set that up yet, it is still wise to add this value to an expanding basic configuration. If authentication is not defined, this value simply remains empty. And finally, we want to tell the backend system about the type of encryption the client and reverse proxy agreed upon. The entire block looks like this:

```
RequestHeader set "X-RP-UNIQUE-ID"     "%{UNIQUE_ID}e"
RequestHeader set "X-RP-REMOTE-USER"   "%{REMOTE_USER}e"
RequestHeader set "X-RP-SSL-PROTOCOL"  "%{SSL_PROTOCOL}s"
RequestHeader set "X-RP-SSL-CIPHER"    "%{SSL_CIPHER}s"
```

Let’s see how this affects the request between the reverse proxy and the backend:

```
GET /service1/index.html HTTP/1.1
Host: localhost
User-Agent: curl/7.35.0
Accept: */*
X-RP-UNIQUE-ID: VmpSwH8AAQEAAG@hXBcAAAAC
X-RP-REMOTE-USER: (null)
X-RP-SSL-PROTOCOL: TLSv1.2
X-RP-SSL-CIPHER: ECDHE-RSA-AES256-GCM-SHA384
X-Forwarded-For: 127.0.0.1
X-Forwarded-Host: localhost
X-Forwarded-Server: localhost
Connection: close
```

The different extended header lines are listed sequentially and are filled in with values where present.
