Let's use ModRewrite to configure a reverse proxy. We do this as follows:

```

<VirtualHost *:443>

    ...

    RewriteEngine     On

    RewriteRule       ^/service1/(.*)   http://localhost:8000/service1/$1 [proxy,last]
    ProxyPassReverse  /                 http://localhost:8000/

    <Proxy http://localhost:8000/service1>

        Require all granted

        Options None

        ProxySet enablereuse=on

    </Proxy>

</VirtualHost>
```

The instruction follows a pattern similar to the variation using ProxyPass. Here however, the last part of the path has to be explicitly intercepted by using a bracket and again indicated by "$1" as we saw above. Instead of the suggested redirect flag the keyword proxy is used here. ProxyPassReverse and the proxy container remain almost identical to the setup using ProxyPass. There is an additional instruction however: ProxySet. It is vital for performance reasons and a somewhat odd behavior of the Apache webserver: When we define proxying via ProxyPass, Apache will implictly set up a resource pool for the backend connection. This resource pool allows for HTTP keep-alive on the backend connection. With the RewriteRule proxy construct, this resource pool is not created automatically. In fact, it is only prepared when we issue a ProxySet statement. The exact nature of the statement does not matter. In fact, enablereuse=on is the default value, but it does not come into play until the resource pool is set up and that only happens with the ProxySet. So we use enablereuse=on as a dummy and activate HTTP keep-alive that way.

So much for the configuration using a rewrite rule. There is no real advantage over ProxyPass syntax in this example. Referencing parts of paths by using `$1`, `$2`, etc. does provide a bit of flexibility, though. But if we are working with rewrite rules anyway, then by rewrite rule proxying we ensure that RewriteRule and ProxyPass don’t come into conflict by touching the same request and impacting one another.

However, it may now be that we want to use a single reverse proxy to combine multiple backends or to distribute the load over multiple servers. This calls for our own load balancer. We’ll be looking at it in the next section.
