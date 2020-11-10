_There is an issue with the way Katacoda configures the bash shell. Please execute the following command to launch a new shell that is properly configured._

```
bash
```{{execute}}

Now we are ready.

The purpose of a reverse proxy is to shield an application server from direct internet access. As somewhat of a prerequisite for this tutorial, we’ll be needing a backend server like this.
In principle, any HTTP application can be used for such an installation and we could very well use the application server from the third tutorial. However, it seems appropriate for me to demonstrate a very simple approach. We’ll be using the tool `socat` short for SOcket CAt.

```
socat -v -v TCP-LISTEN:8000,bind=127.0.0.1,crlf,reuseaddr,fork SYSTEM:"echo HTTP/1.0 200;\
echo Content-Type\: text/plain; echo; echo 'Server response, port 8000.'"
```{{execute}}
 Using this complex command we instruct socat to bind a listener to local port 8000 and to use several echoes to return an HTTP response when a connection occurs. The additional parameters make sure that the listener stays permanently open and error output works.

```
curl -v http://localhost:8000/
```{{execute}}

```
* Hostname was NOT found in DNS cache
*  Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 8000 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost:8000
> Accept: */*
> 
* HTTP 1.0, assume close after body
< HTTP/1.0 200
< Content-Type: text/plain
< 
Server response, port 8000
* Closing connection 0
```

__There is a bug in Katacoda that leads to a failure of this curl call to the local socat service in about 1 in 3 calls. The only workaround I have found so far is to repeat the calls.__

We have set up a backend system with the simplest of means. So easy, that in the future we might come back to this method to verify that a proxy server is working before the real application server is running.
