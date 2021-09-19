During communication it is possible to get a somewhat more detailed view in _curl_. We use the _--trace-ascii_ command line parameter to do this:

```
curl  http://localhost/index.html --trace-ascii -
```{{execute}}

```
== Info: Hostname was NOT found in DNS cache
== Info:   Trying 127.0.0.1...
== Info: Connected to localhost (127.0.0.1) port 80 (#0)
=> Send header, 83 bytes (0x53)
0000: GET /index.html HTTP/1.1
001a: User-Agent: curl/7.35.0
0033: Host: localhost
0044: Accept: */*
0051: 
<= Recv header, 17 bytes (0x11)
0000: HTTP/1.1 200 OK
<= Recv header, 37 bytes (0x25)
0000: Date: Thu, 24 Sep 2015 11:46:17 GMT
== Info: Server Apache is not blacklisted
<= Recv header, 16 bytes (0x10)
0000: Server: Apache
<= Recv header, 46 bytes (0x2e)
0000: Last-Modified: Mon, 11 Jun 2007 18:53:14 GMT
<= Recv header, 26 bytes (0x1a)
0000: ETag: "2d-432a5e4a73a80"
<= Recv header, 22 bytes (0x16)
0000: Accept-Ranges: bytes
<= Recv header, 20 bytes (0x14)
0000: Content-Length: 45
<= Recv header, 2 bytes (0x2)
0000: 
<= Recv data, 45 bytes (0x2d)
0000: <html><body><h1>It works!</h1></body></html>.
<html><body><h1>It works!</h1></body></html>
== Info: Connection #0 to host localhost left intact
```{{execute}}

_--trace-ascii_ requires a file as a parameter in order to make an _ASCII dump_ of communication in it. "-" works as a shortcut for _STDOUT_, enabling us to easily see what is being logged.

Compared to _verbose_, _trace-ascii_ provides more details about the number of transferred bytes in the _request_ and _response_ phase. The request headers in the example above are thus 83 bytes. The bytes are then listed for each header in the response and overall for the body in the response: 45 bytes. This may seem like we are splitting hairs. But in fact, it can be crucial when something is missing and it is not quite certain what or where in the sequence it was delivered. Thus, it’s worth noting that 2 bytes are added to each header line. These are the CR (carriage returns) and NL (new lines) in the header lines included in the HTTP protocol. In the response body, on the other hand, only the actual content of the file is returned. This is obviously only one NL without CR here. On the third to last line (_000: <html ..._) a point comes after the greater than character This is code for the NL character in the response, which like other escape sequences is output in the form of a point.

