In day-to-day work you are often looking for specific requests or you are unsure of which requests are causing an error. It has often been shown to be useful to have specific additional values written to the log file. Any request and response headers or environment variables can be easily written. Our log format makes extensive use of it.

The _\"%{Referer}i\"_ and _\"%{User-Agent}i\"_ values are request header fields. The balancer route in *%{BALANCER_WORKER_ROUTE}e* is an environment variable. The pattern is clear: _%{Header/Variable}<Domain>_. Request headers are assigned to the _i_ domain. Environment variables to domain _e_, the response headers to domain _o_ and the variables of the _SSL_ modules to the _x_ domain.

So, for debugging purposes we will be writing an additional log file. We will no longer be using the _LogFormat_ directive, but instead defining the format together with the file on one line. This is a shortcut, if you want to use a specific format one time only.

```bash
CustomLog logs/access-debug.log "[%{%Y-%m-%d %H:%M:%S}t.%{usec_frac}t] %{UNIQUE_ID}e \
\"%r\" %{Accept}i %{Content-Type}o"
```

With this additional log file we see the wishes expressed by the client in terms of the content type and what the server actually delivered. Normally this interplay between client and server works very well. But in practice there are sometimes inconsistencies, which is why an additional log file of this kind can be useful for debugging.
The result could then look something like this:

```bash
$> cat logs/access-debug.log
2015-09-02 11:58:35.654011 VebITcCoAwcAADRophsAAAAX "GET / HTTP/1.1" */* text/html
2015-09-02 11:58:37.486603 VebIT8CoAwcAADRophwAAAAX "GET /cms/feed/ HTTP/1.1" text/html,application/xhtml+xml… 
2015-09-02 11:58:39.253209 VebIUMCoAwcAADRoph0AAAAX "GET /cms/2014/04/17/ubuntu-14-04/ HTTP/1.1" */* text/html
2015-09-02 11:58:40.893992 VebIU8CoAwcAADRbdGkAAAAD "GET /cms/2014/05/13/download-softfiles HTTP/1.1" */* … 
2015-09-02 11:58:43.558478 VebIVcCoAwcAADRbdGoAAAAD "GET /cms/2014/08/25/netcapture-sshargs HTTP/1.1" */* … 
...
```

This is how log files can be very freely defined in Apache. What’s more interesting is analyzing the data. But we’ll need some data first.

