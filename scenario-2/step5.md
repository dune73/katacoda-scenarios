This is what happens during an HTTP request. But what exactly is the server saying to us? To find ou
t, let’s start _curl_. This time with the _verbose_ option.

```
$> curl --verbose http://localhost/index.html
```{{execute}}

This brings the following output:

```
* Hostname was NOT found in DNS cache
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET /index.html HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost
> Accept: */*
> 
< HTTP/1.1 200 OK
< Date: Thu, 24 Sep 2015 09:27:02 GMT
* Server Apache is not blacklisted
< Server: Apache
< Last-Modified: Mon, 11 Jun 2007 18:53:14 GMT
< ETag: "2d-432a5e4a73a80"
< Accept-Ranges: bytes
< Content-Length: 45
< 
<html><body><h1>It works!</h1></body></html>
* Connection #0 to host localhost left intact
```

The lines marked with a asterisk (*) describe messages concerning opening and closing the connection
. They do not reflect network traffic. The request follows > and the response <.

Specifically, an HTTP request comprises 4 parts:

* Request line and request header
* Request body (optional and missing here for a GET request)
* Response header
* Response body

We don’t have to worry about the first parts just yet. It’s the _response headers_ that are interest
ing. This is the part used by the web server to describe the response. The actual response, the _res
ponse body_, follows after an empty line.

In order, what do the headers mean?

At first comes the _status_ line including the _protocol_, the version, followed by the _status code
_. _200 OK_ is the normal response from a web server. On the next line we see the date and time of t
he server. The next line begins with an asterisk, _*_, signifying a line belonging to _curl_. The me
ssage is related to _curl’s_ handling of HTTP pipelining, which we don’t have to concern ourselves w
ith. Then comes the _server_ line on which our Apache web server identifies itself. This is the shor
test possible identification. We have defined it using _ServerTokens_ Prod.

The server will then tell us when the file the response is based on was last changed, i.e. the _Unix
 modified timestamp_. _ETag_ and _Accept_ ranges don’t require our attention for the moment. What’s 
more interesting is _Content-Length_. This specifies how many bytes to expect in the _response body_. 45 bytes in our case.

Incidentally, the order of these headers is characteristic for web servers. _NginX_ uses a different order and, for instance, puts the _server header_ in front of the date. Apache can still be identified even if the server line is intended to be misleading.

