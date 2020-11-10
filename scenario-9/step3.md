This brings us to the actual proxying settings: There are many ways for instructing Apache to forward a request to a backend application. We’ll be looking at each option in turn. The most common way of proxying requests is based on the ProxyPass directive. It is used as follows:

```
ProxyPass          /service1    http://localhost:8000/service1
ProxyPassReverse   /service1    http://localhost:8000/service1

<Proxy http://localhost:8000/service1>

      Require all granted

      Options None

</Proxy>
```

The most important directive is ProxyPass. It defines a `/service1` path and specifies how it is mapped to the backend: To the service defined above running on our own host, localhost, on port 8000. The path to the application server is again `/service1`. We are proxying symmetrically, because the frontend path is identical to the backend path. This mapping is however not absolutely required. Technically, it would be entirely possible to proxy `service1` to `/`, but this results to administrative difficulties and misunderstandings, if a path in the application log file no longer maps to the path on the reverse proxy and the requests can no longer be correlated easily.

On the next line comes a related directive that despite having a similar name performs only a small auxiliary function. Redirect responses from the backend are fully qualified in http-compliant form. Such as `https://backend.example.com/service1`, for example. The address is however not accessible by the client. For this reason, the reverse proxy has to rewrite the backend’s location header, `backend.example.com`, replacing it with its own name and thus mapping it back to its own namespace. ProxyPassReverse, with such a great name, only has a simple search and replace feature touching the location headers. As already seen in the ProxyPass directive, proxying is again symmetric: the paths are rewritten 1:1. We are free to ignore this rule, but I urgently recommend keeping it, because misunderstandings and confusion lie beyond. In addition to accessing location headers, there is a series of further reverse directives for handling things like cookies. They can be useful from case to case.

