We are now ready for a new, comprehensive log format. The format also includes values that the server is as of yet unaware of with the modules defined up to now. It will leave them empty or show them as a hyphen _"-"_. Only with the _Logio_ module just enabled this won’t work. The server will crash if we request these values without them being present.

We will gradually be filling in these values in the instructions below. But, as explained above, because it is useful to use the same log format everywhere, we will now be getting a bit ahead of ourselves in the configuration below.

We’ll be starting from the _combined_ format and will be extending it to the right. The advantage of this is that the extended log files will continue to be readable in many standard tools, because the additional values are simply ignored. Furthermore, it is very easy to convert the extended log file back into the basic version and then still end up with a _combined_ log format.

We define the log format as follows:

```bash

LogFormat "%h %{GEOIP_COUNTRY_CODE}e %u [%{%Y-%m-%d %H:%M:%S}t.%{usec_frac}t] \"%r\" %>s %b \
\"%{Referer}i\" \"%{User-Agent}i\" \"%{Content-Type}i\" %{remote}p %v %A %p %R \
%{BALANCER_WORKER_ROUTE}e %X \"%{cookie}n\" %{UNIQUE_ID}e %{SSL_PROTOCOL}x %{SSL_CIPHER}x \
%I %O %{ratio}n%% %D %{ModSecTimeIn}e %{ApplicationTime}e %{ModSecTimeOut}e \
%{ModSecAnomalyScoreInPLs}e %{ModSecAnomalyScoreOutPLs}e \
%{ModSecAnomalyScoreIn}e %{ModSecAnomalyScoreOut}e" extended

...

CustomLog               logs/access.log extended

```

