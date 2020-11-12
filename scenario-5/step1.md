_There is an issue with the way Katacoda configures the bash shell. Please execute the following command to launch a new shell that is properly configured._

```
while [ 1 ]; do grep -q "Env downloaded" /tmp/tmp.log 2>/dev/null && exit; sleep 1; done
```{{execute}}

The _common_ log format is a very simple format that is hardly ever used any more. It has the advantage of being space-saving and hardly ever writing unnecessary information.

```
LogFormat "%h %l %u %t \"%r\" %>s %b" common
...
CustomLog logs/access.log common
```

We use the _LogFormat_ directive to define a format and give it a name, _common_ in this case.

We invoke this name in the definition of the log file using the _CustomLog_ directive. We can use these two directives multiple times in the configuration. Thus, multiple log formats with several name abbreviations can be defined next to one another and log files written in different formats. It’s possible for different services to write to separate log files on the same server.

The individual elements of the _common_ log format are as follows:

_%h_ designates the _remote host_, normally the IP address of the client making the request. But if the client is behind a proxy server, then we'll see the IP address of the proxy server here. So, if multiple clients share the proxy server then they will have the same _remote host_ entry. It’s also possible to retranslate the IP addresses using DNS reverse lookup on our server. If we configure this (which is not recommended), then the host name determined for the client would be entered here.

_%l_ represents the _remote log name_. It is usually empty and output as a hyphen (“-“). In fact, this is an attempt to identify the client via _ident_ access to the client. This has little client support and results in the biggest performance bottlenecks which is why _%l_ is an artifact from the early 1990s.

_%u_ is more commonly used and designates the user name of an authenticated user. The name is set by an authentication module and remains empty (thus the ”-”), for as long as access without authentication on the server takes.

_%t_ means the time of access. For big, slow requests the time means the moment the server receives the request line. Since Apache writes a request in the log file only after completing the response, it may occur that a slower request with an earlier time may appear several entries below a short request started later. Up to now this has resulted in confusion when reading the log file.

By default, the time is output between square brackets. It is normally the local time including the deviation from standard time. For example:

```
[25/Nov/2014:08:51:22 +0100]
```

This means November 25, 2014, 8:51 am, 1 hour before standard time. The format of the time can also be changed if necessary. This is done using the _%{format}t_ pattern, where _format_ follows the specification of _strftime(3)_. We have already made use of this option in Tutorial 2. But let’s use an example to take a closer look:

```
%{[%Y-%m-%d %H:%M:%S %z (%s)]}t
```

In this example we put the date in the order _Year-Month-Day_, to make it sortable. And after the de
viation from standard time we add the time in seconds since the start of the Unix age in January 1970. This format is more easily read and interpreted via a script.

This example gives us entries using the following pattern:

```
[2014-11-25 09:34:33 +0100 (1322210073)]
```

So much for _%t_.
This brings us to _%r_ and the request line. This is the first line of the HTTP request as it was sent from the client to the server. Strictly speaking, the request line does not belong in the group of request headers, but it is normally subsumed along with them. In any case, in the request line the client transmits the identification of the resource it is demanding.

Specifically, the line follows this pattern:

```
Method URI Protocol
```

In practice, it’s a simple example such as this:

```
GET /index.html HTTP/1.1
```

The _GET_ method is being used. This is followed by a space, then the absolute path of the resource on the server. The index file in this case. Optionally, the client can, as we are aware, add a _query string_ to the path. This _query string_ normally begins with a question mark and comes with a number of parameter value pairs. The _query string_ is also output in the log file. Finally, the protocol that is most likely to be HTTP version 1.1. Version 1.0 still continues to be used by some agents (automated scripts). The new HTTP/2 protocol does not appear in the request line of the initial request. In HTTP/2 an update from HTTP/1.1 to HTTP/2 takes place during the request. The start follows the pattern above.

The following format element follows a somewhat different pattern: _%>s_. This means the status of the response, such as _200_ for a successfully completed request. The angled bracket indicates that we are interesting in the final status. It may occur that a request is passed off within the server. In this case what we are interested in is not the status that passing it off triggered, but the status of the response for the final internal request.

One typical example would be a request that causes an error on the server (Status 500). But if the associated error page is unavailable, this results in status 404 for the internal transfer. Using the angled bracket means that in this case we want 404 to be written to the log file. If we reverse the direction of the angled bracket, then Status 500 would be logged. Just to be certain, it may be advisable to log both values using the following entry (which is not usual in practice):

```
%<s %>s
```

_%b_ is the last element of the _common_ log format. It shows the number of bytes announced in the content-length response headers. In a request for _http://www.example.com/index.html_ this value is the size of the _index.html_ file. The _response headers_ also transmitted are not counted. And there is an additional problem with this number: It is a calculation by the webserver and not an account of the bytes that have actually been sent in the response.

