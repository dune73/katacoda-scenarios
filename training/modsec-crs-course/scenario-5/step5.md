The new log format adds 23 values to the access log. This may seem excessive at first glance, but there are in fact good reasons for all of them and having these values available in day-to-day work makes it a lot easier to track down errors.

Let’s have a look at the values in order.

In the description of the _common_ log format we saw that the second value, the _logname_ entry, displays an unused artifact right after the client IP address. We’ll replace this item in the log file with the country code for the client IP address. This is useful, because this country code is strongly characteristic of an IP address. (In many cases there is a big difference whether the request originates nationally or from the South Pacific). It is now practical to place it right next to the IP address and have it add more in-depth information to the meaningless number.

After this comes the time format defined in Tutorial 2, which is oriented to the time format of the error log and is now congruent with it. We are also keeping track of microseconds, giving us precise timing information. We are familiar with the next values.

_\"%Content-Type}i\" describes the Content-Type Request header. This is usually empty, however requests with the HTTP method POST that are used to submit forms or upload data make use of this header. We are ultimately planning to add ModSecurity to our service. Together with that module, the information about the content type becomes really important as the behavior of the ModSecurity engine changes a lot depending on this header.

_%{remote}p_ is the next addition. It stands for port number of the client. So whenever a client opens a TCP connection to a server address and port, he uses one of his own ports. Information about this port can tell us just how many connections a client opens to our server. And in a situation where multiple clients connect using the same IP address (thanks to Network Address Translation NAT), it can help to tell the clients apart.

_%v_ refers to the canonical host name of the server that handled the request. If we talk to the server via an alias, the actual name of the server will be written here, not the alias. In a virtual host setup the virtual host server names are also canonical. They will thus also show up here and we can distinguish among them in the log file.

_%A_ is the IP address of the server that received the request. This value helps us to distinguish among servers if multiple log files are combined or multiple servers are writing to the same log file.

_%p_ then describes the port number on which the request was received. This is also important to be able to keep some entries apart if we combine different log files (such as those for port 80 and those for port 443).

_%R_ shows the handler that generated the response to a request. This value may also be empty (“-“) if a static file was sent. Or it uses _proxy_ to indicate that the request was forwarded to another server.

*%{BALANCER_WORKER_ROUTE}e* also has to do with forwarding requests. If we alternate among target servers this value represents where the request was sent.

_%X_ shows the status of the TCP connection after the request has been completed. There are three possible values: The connection is closed (_-_), the connection is being kept open using _Keep-Alive_ (_+_) or the connection was lost before the request could be completed (_X_).

_"%{cookie}n"_ is a value employed by user tracking. This enables us to use a cookie to identify a client and recognize it at a later point in time, provided it still has the cookie. If we set the cookie for the whole domain, e.g. to example.com and not limited to www.example.com, then we are even able to track a client across multiple hosts. Ideally, this would also be possible from the client’s IP address, but this may change over the course of a session and multiple clients may be sharing a single IP address.

*%{UNIQUE_ID}e* is a very helpful value. A unique ID is created on the server for every request. When we output this value on an error page for instance, then a request in the log file can be easily identified using a screenshot, and ideally the entire session can be reproduced on the basis of the user tracking cookies.

Now come two values made available by *mod_ssl*. The encryption module provides the log module values in its own name space, indicated by _x_. The individual values are explained in the *mod_ssl* documentation. For the operation of a server the protocol and encryption used are of primary interest. These two values, referenced by *%{SSL_PROTOCOL}x* and *%{SSL_CIPHER}x* help us get an overview of encryption use. Sooner or later there will come a time when we have to disable the _TLSv1_ protocol. But first we want to be certain that is it no longer playing a significant role in practice. The log file will help us do that. It is similar to the encryption algorithm that tells us about the _ciphers_ actually being used and helps us make a statement about which ciphers are no longer being used. The information is important. If, for example, vulnerabilities in individual versions of protocols or individual encryption methods become known, then we can assess the effect of our measures by referring to the log file. In spring 2015, these log files proved to be extremely valuable and allowed us to quickly assess the impact of disabling SSLv3 as follows: “Immediately disabling the SSLv3 protocol as a reaction to the POODLE vulnerability will cause an error in approx. 0.8% of requests. Extrapolated to our customer base, xx number of customers will be impacted." Based on these numbers, the risk and the effect of the measures were predictable.

_%I_ and _%O_ are used to define the values used by the _Logio_ module. It is the total number of bytes in the request and the total number of bytes in the response. We are already familiar with _%b_ for the total number of bytes in the response body. _%O_ is a bit more precise here and helps us recognize when the request or its response violates size limits.

_%{ratio}n%%_ means the percentage by which the transferred data were able to be compressed by using the _Deflate_ module. This is of no concern for the moment, but will provide us interesting performance data in the future.

_%D_ specifies the complete duration of the request in microseconds. Measurement takes place from the time the request line is received until the last part of the response leaves the server.

We’ll continue with performance data. In the future we will be using a stopwatch to separately measure the request on its way to the server, onward to the application and while processing the response. The values for this are set in the _ModSecTimeIn_, _ApplicationTime_ and _ModSecTimeOut_ environment variables.

And, last but not least, there are other values provided to us by the _OWASP ModSecurity Core Rule Set_ (to be handled in a subsequent tutorial), specifically the anomaly scores of the request and the response. For the moment it's not important to know all of this. What’s important is that this highly extended log format gives us a foundation upon which we can build without having to adjust the log format again.

