The `ProxyPass` directive we are using has forwarded all requests for `/service1` to the backend. However, in practice it is often the case that you don’t want to forward everything. Let’s suppose there’s a path `/service1/admin` that we don’t want to expose to the internet. This can also be prevented by the appropriate `ProxyPass` setting, where the exception is initiated by using an exclamation mark. What's important is to define the exception before configuring the actual proxy command:

```
ProxyPass          /service1/admin !
ProxyPass          /service1         http://localhost:8000/service1
ProxyPassReverse   /service1         http://localhost:8000/service1
```

You often see configurations that forward the entire namespace below `/` to the backend. Then a number of exceptions to the pattern above are often defined. I think this is the wrong approach and I prefer to forward only what is actually being processed. The advantage is obvious: scanners and automated attacks looking for their next victim from a pool of IP addresses on the internet make requests for a lot of non-existent paths on our server. We can now forward them to the backend and may overload the backend or even put it in danger. Or we can just drop these requests on the reverse proxy server. The latter is clearly preferable for security-related reasons.

An essential directive which may optionally be part of the proxy concerns the timeout. We defined our own timeout value for our server. This timeout is also used by the server for the connection to the backend. But this is not always wise, because while we can expect from the client that it will quickly make its request and not take its sweet time, depending on the backend application, it can take a while until the response is processed. For a short, general timeout which is wise to have for the client for defensive reasons, the reverse proxy would interrupt access to the backend too quickly. For this reason, there is a ProxyTimeout directive which affects only the connection to the backend. By the way, time measurement is not the total processing time on the backend, but the duration of time between IP packets: When the backend sends part of the response the clock is reset.

```
ProxyTimeout            60
```

Now comes time to fix the host header. Via the HTTP request host header the client specifies which of a server’s VirtualHosts to use for the request. If there are multiple VirtualHosts being operated using the same IP address, this value is important. However, when forwarding the reverse proxy normally sets a new host header, specifically the one from the backend system. This is often undesired, because in many cases the backend system sets its links based on the host header. Fully qualified links for a backend application may be a bad practice, but we avoid conflicts if we make clear from the beginning that the host header should be preserved and forwarded as is by the backend.

```
ProxyPreserveHost       On
```

Backend systems often pay less attention to security than a reverse proxy. Error messages are one place this is obvious. Detailed error messages are often desirable since they enable the developer or backend administrator to get at the root of the problem. But we don’t want to distribute them over the internet, because without authentication on the reverse proxy an attacker could always be lurking behind the client. It's better to hide error messages from the backend application or to replace them with an error message from the reverse proxy. The `ProxyErrorOverride` directive intervenes in the HTTP response body and replaces it if a status code greater than or equal to 400 is present. Requests with normal statuses below 400 are not affected by this directive.

```
ProxyErrorOverride      On
```
