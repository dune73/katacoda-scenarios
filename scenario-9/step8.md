We first have to load the Apache load balancer module:

```
LoadModule        proxy_balancer_module           modules/mod_proxy_balancer.so
LoadModule        lbmethod_byrequests_module      modules/mod_lbmethod_byrequests.so
LoadModule        slotmem_shm_module              modules/mod_slotmem_shm.so
```

Besides the load balancer module itself we also need a module that can help us distribute the requests to the different backends. We’ll take the easiest route and load the lbmethod_byrequests module.
It’s the oldest module from a series of four modules and distributes requests evenly across backends by counting them sequentially. Once to the left and once to the right for two backends.

Here is a list of all four available algorithms:

* mod_lbmethod_byrequests (counts requests)
* mod_lbmethod_bytraffic (totals sizes of requests and responses)
* mod_lbmethod_bybusyness (Load balancing based on active threads in an connection established with the backend. The backend with the lowest number of threads is given the next request)
* mod_lbmethod_heartbeat (the backend can even communicate via a heartbeat on th network and use it to inform the reverse proxy whether it has any free capacity).

The different modules are well documented online so this brief description will have to suffice for now.

Finally, we still need a module to help us manage shared segments of memory. These features are required by the proxy balancer module and provided by `mod_slotmem_shm.so`.

We are now ready to configure the load balancer. We can set it up via the RewriteRule. This modification also affects the proxy stanza, where the balancer just defined must be referenced and resolved:

```
    RewriteRule         ^/service1/(.*)       balancer://backend/service1/$1   [proxy,last]
    ProxyPassReverse    /                     balancer://backend/

    <Proxy balancer://backend>
        BalancerMember http://localhost:8000 route=backend-port-8000
        BalancerMember http://localhost:8001 route=backend-port-8001

        Require all granted

        Options None

        ProxySet enablereuse=on

    </Proxy>
```

We are also defining two backends, one on the previously configured port 8000 and a second on port 8001. I recommend using `socat` to quickly set up this service on a second port and then to try it out. I have defined a number of different responses so we will be able to see from the HTTP response which backend has processed the request. This then looks like this:

```
curl -v -k https://localhost/service1/index.html https://localhost/service1/index.html
```{{execute}}

```
* Rebuilt URL to: https://localhost:40443/
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 40443 (#0)
* found 173 certificates in /etc/ssl/certs/ca-certificates.crt
* found 697 certificates in /etc/ssl/certs
* ALPN, offering http/1.1
* SSL connection using TLS1.2 / ECDHE_RSA_AES_256_GCM_SHA384
*        server certificate verification SKIPPED
*        server certificate status verification SKIPPED
*        common name: ubuntu (does not match 'localhost')
*        server certificate expiration date OK
*        server certificate activation date OK
*        certificate public key: RSA
*        certificate version: #3
*        subject: CN=ubuntu
*        start date: Mon, 27 Feb 2017 20:46:21 GMT
*        expire date: Thu, 25 Feb 2027 20:46:21 GMT
*        issuer: CN=ubuntu
*        compression: NULL
* ALPN, server accepted to use http/1.1
> GET /service1/index.html HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost
> Accept: */*
> 
< HTTP/1.1 200 
< Date: Thu, 10 Dec 2015 05:42:14 GMT
* Server Apache is not blacklisted
< Server: Apache
< Content-Type: text/plain
< Content-Length: 28
< 
Server response, port 8000
* Connection #0 to host localhost left intact
* Found bundle for host localhost: 0x24e3660
* Re-using existing connection! (#0) with host localhost
* Connected to localhost (127.0.0.1) port 443 (#0)
> GET /service1/index.html HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost
> Accept: */*
> 
< HTTP/1.1 200 
< Date: Thu, 10 Dec 2015 05:42:14 GMT
* Server Apache is not blacklisted
< Server: Apache
< Content-Type: text/plain
< Content-Length: 28
< 
Server response, port 8001
* Connection #0 to host localhost left intact
```

In this somewhat unusual curl call two identical request are being initiated via a single curl command. What’s also interesting is the fact that with this method curl can use HTTP keep-alive. The first request lands on the first backend, and the second one on the second backend. Let’s have a look at the entries for this in the reverse proxy’s access log:

```
127.0.0.1 - - [2015-12-10 06:42:14.390998] "GET /service1/index.html HTTP/1.1" 200 28 "-" "curl/7.35.0"\
localhost 127.0.0.1 443 proxy-server backend-port-8000 + "-" VmkQtn8AAQEAAH@M3zAAAAAN TLSv1.2 \
ECDHE-RSA-AES256-GCM-SHA384 538 1402 -% 7856 1216 3708 381 0 0
127.0.0.1 - - [2015-12-10 06:42:14.398995] "GET /service1/index.html HTTP/1.1" 200 28 "-" "curl/7.35.0"\
localhost 127.0.0.1 443 proxy-server backend-port-8001 + "-" VmkQtn8AAQEAAH@M3zEAAAAN TLSv1.2 \
ECDHE-RSA-AES256-GCM-SHA384 121 202 -% 7035 1121 3752 354 0 0
```

Besides the keep-alive header, the request handler is also of interest. The request was thus processed by the `proxy server handler`. We also see entries for the route, specifically the values defined as `backend-port-8000` and `backend-port-8001`. This makes it possible to determine from the server's access log the exact route a request took.

In a subsequent tutorial we will be seeing that the proxy balancer can also be used in other situations. For the moment we will however be content with what is happening and will now be turning to RewriteMaps. A RewriteMap is an auxiliary structure which again increases the power of ModRewrite. Combined with the proxy server, flexibility rises substantially.
