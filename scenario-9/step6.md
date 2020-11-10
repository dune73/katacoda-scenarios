In addition to the `ProxyPass` directive, the Rewrite module can be used to enable reverse proxy features. Compared to ProxyPass, it enables more flexible configuration. We have not seen ModRewrite up to this point. Since this is a very important module, we should take a good look at it.

ModRewrite defines its own rewrite engine used to manipulate, or change, HTTP requests; This rewrite engine can run in the server or VirtualHost context. Strictly speaking, we are using two separate rewrite engines. The rewrite engine in the VirtualHost context can also be configured from the Proxy container that we learned about above. If we define a rewrite engine in the server context, then it could be shortcut if there is an engine in the VirtualHost context. In this case we have to manually ensure that the rewrite rules are being inherited. We are therefore setting up a rewrite engine in the server context, configuring an example rule and initiating the inheritance.

```
LoadModule              rewrite_module          modules/mod_rewrite.so

...

RewriteEngine           On
RewriteOptions          InheritDownBefore

RewriteRule             ^/$     %{REQUEST_SCHEME}://%{HTTP_HOST}/index.html  [redirect,last]
```

We initialize the engine on the server level. We then instruct the engine to pass on our rules to other rewrite engines. Specifically, so that our rules are performed before the rules further down. Then comes the actual rule. We tell the server to instruct the client to send a new request to `/index.html` for a request without a path or a request for "/" respectively. This is a redirect. What’s important is for the redirect to indicate the schema of the request, http or https as well as the host name. Relatives paths won’t work. But because we are outside the VirtualHost, we don’t see the type. And we don’t want to hard code the host name, but prefer to take the host names from client requests. Both of these values are available as variables as you can see in the example above.

Then appearing within square brackets come the flags influencing the behavior of the rewrite rule. As previously mentioned, we want a redirect and tell the engine that this is the last rule to process (`last`).

Let’s have a look at a request like this and the redirect returned:

```
curl -v http://localhost/
* Hostname was NOT found in DNS cache
*  Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost
> Accept: */*
> 
< HTTP/1.1 302 Found
< Date: Thu, 10 Dec 2015 05:24:42 GMT
* Server Apache is not blacklisted
< Server: Apache
< Location: http://localhost/index.html
< Content-Length: 211
< Content-Type: text/html; charset=iso-8859-1
< 
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>302 Found</title>
</head><body>
<h1>Found</h1>
<p>The document has moved <a href="http://localhost/index.html">here</a>.</p>
</body></html>
* Connection #0 to host localhost left intact
```

The server now responds with HTTP status code `302 Found`, corresponding to the typical redirect status code. Alternatively, 301, 303, 307 or very rarely 308 also appear. The differences are subtle, but influence the behavior of the browser. What's important then is the location header. It tells the client to make a new request, specifically for the fully qualified URL with a schema specified here. This is required for the location header. Only returning the path here, assuming that the client would then correctly conclude that it’s the same server name, would be incorrect and prohibited according to the specification (even if it works with most browsers).

In the body part of the response the redirect is included as a link in HTML text. This is provided for users to click manually, if the browser does not initiate the redirect. However, this is very unlikely and is probably only included for historical reasons.

You could now ask yourself why we are opening a rewrite engine in the server context and not dealing with everything on the VirtualHost level. In the example I chose you see that this would result in redundancy, because the redirect from "/" to "index.html" should take place on port 80 and also on encrypted port 443. This is the rule of thumb: It’s best for us to define and inherit everything being used on all VirtualHosts in the server context. We also deal with individual rules for a single VirtualHost on this level. Typically, the following rule is used to redirect all requests from port 80 to port 443, where encryption is enabled:

```
<VirtualHost 127.0.0.1:80>
      
      RewriteEngine   On

      RewriteRule     ^/(.*)$   https://%{HTTP_HOST}/$1  [redirect,last]

      ...

</VirtualHost>
```

The schema we want is now clear. But to the left of it comes a new item. We don’t suppress the path as quickly as above. We instead put it in parenthesis and use `$1` to reference the content of the parenthesis again in the redirect. This means that we are forwarding the request on port 80 using the same URL on port 443.

ModRewrite has been introduced. For further examples refer to the documentation or the sections of this tutorial below where it will become familiar with yet more recipes.
