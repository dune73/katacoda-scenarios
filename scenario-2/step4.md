Now we can again communicate with the server from a web browser. But working in the shell at first can be more effective, making it easier to understand what is going on.

```
curl http://localhost/index.html
```{{execute}}

Returns the following:

```
<html><body><h1>It works!</h1></body></html>
```{{execute}}

We have thus sent an HTTP request and have received a response from our minimally configured server, meeting our expectations.
