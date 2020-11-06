Analyses using a real log file from a production server are much more exciting. You have one
ready for your inspection in `/apache/logs/tutorial-5-example-access.log`.

If you want, you can also fetch it from [netnea.com](https://www.netnea.com/files/tutorial-5-example-access.log).

```
cd /apache/logs
head tutorial-5-example-access.log
```{{execute}}
```
192.31.242.0 US - [2019-01-21 23:51:44.365656] "GET …
/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/ HTTP/1.1" 200 10273 …
"https://www.google.com/" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, …
like Gecko) Chrome/71.0.3578.98 Safari/537.36" "-" 13258 www.example.com 192.168.3.7 443 …
redirect-handler - + "ReqID--" XEZNAMCoAwcAAAxAiBgAAAAA TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 …
776 14527 -% 360398 2128 0 0 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:44.943942] "GET …
/cds/snippets/themes/customizr/assets/shared/fonts/fa/css/fontawesome-all.min.css?ver=4.1.12 …
HTTP/1.1" 200 7439 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 13258 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAMCoAwcAAAxAiBkAAAAA …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 507 7950 -% 2509 1039 0 164 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:44.947470] "GET …
/cds/snippets/themes/customizr/inc/assets/css/tc_common.min.css?ver=4.1.12 HTTP/1.1" 200 28225 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 32554 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAMCoAwcAAAxDkkUAAAAD …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 754 32406 -% 6714 1338 0 168 0-0-0-0 0-0-0-0 0 0
212.147.59.0 CH - [2019-01-21 23:51:44.849966] "GET /cds/ HTTP/1.1" 200 31332 "-" "check_http/v2.1.4 …
(nagios-plugins 2.1.4)" "-" 16291 www.example.com 192.168.3.7 443 application/x-httpd-php - - …
"ReqID--" XEZNAMCoAwcAAAxEZFIAAAAE TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 586 35548 -% 144762 1180 0 …
13771 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:45.143819] "GET …
/cds/snippets/themes/customizr-child/inc/assets/css/neagreen.min.css?ver=4.1.12 HTTP/1.1" 200 2458 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 13258 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAcCoAwcAAAxAiBoAAAAA …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 494 2969 -% 1946 1070 0 141 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:45.269615] "GET …
/cds/snippets/themes/customizr-child/style.css?ver=4.1.12 HTTP/1.1" 200 483 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 22078 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAcCoAwcAAAxBiDkAAAAB …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 737 4544 -% 4237 2221 0 241 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:45.309680] "GET …
/cds/snippets/themes/customizr/assets/front/js/libs/fancybox/jquery.fancybox-1.3.4.min.css?ver=4.9.8 …
HTTP/1.1" 200 981 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 32554 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAcCoAwcAAAxDkkYAAAAD …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 515 1461 -% 2830 1656 0 200 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:45.467686] "GET …
/cds/includes/js/jquery/jquery-migrate.min.js?ver=1.4.1 HTTP/1.1" 200 4014 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 35193 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAcCoAwcAAAyCROcAAAAF …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 721 8120 -% 3238 1536 0 142 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:45.469159] "GET …
/cds/snippets/themes/customizr/assets/front/js/libs/fancybox/jquery.fancybox-1.3.4.min.js?ver=4.1.12 …
HTTP/1.1" 200 5209 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 46005 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAcCoAwcAAAxCwlQAAAAC …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 765 9315 -% 2938 1095 0 246 0-0-0-0 0-0-0-0 0 0
192.31.242.0 US - [2019-01-21 23:51:45.469177] "GET …
/cds/snippets/themes/customizr/assets/front/js/libs/modernizr.min.js?ver=4.1.12 HTTP/1.1" 200 5926 …
"https://www.example.com/cds/2016/10/16/using-ansible-to-fetch-information-from-ios-devices/" …
"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 …
Safari/537.36" "-" 42316 www.example.com 192.168.3.7 443 - - + "ReqID--" XEZNAcCoAwcAAAyDuEIAAAAG …
TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 744 10032 -% 3022 1094 0 245 0-0-0-0 0-0-0-0 0 0
```

Let’s have a look at the distribution of _GET_ and _POST_ requests here:

```
cat tutorial-5-example-access.log  | egrep -o '"(GET|POST)'  | cut -b2- | sort | uniq -c
```{{execute}}

```
   9466 GET
    115 POST
```

This is a clear result. Do we actually see many errors? Or requests answered with an HTTP error code?

```
cat tutorial-5-example-access.log | cut -d\" -f3 | cut -d\  -f2 | sort | uniq -c
```{{execute}}
```
   9397 200
      3 206
    233 301
     67 304
      9 400
     58 403
    233 404
```

Besides the nine requests with the “400 Bad Request” HTTP response there is a large number of 404s (“404 Not Found”). HTTP status 400 means a protocol error. As is commonly known, 404 is a page not found. This is where we should have a look at the permissions. But before we continue, a note about the request using the _cut_ command. We have subdivided the log line using the _”_-delimiter, extracted the third field with this subdivision and then further subdivided the content, but this time with a space (note the _\_ character) as the delimiter and extracted the second field, which is now the status. Afterwards this was sorted and the _uniq function_ used in count mode. We will be seeing that this type of access to the data is a pattern that repeats itself.
Let’s take a closer look at the log file.

Further above we discussed encryption protocols and how their analyses was a foundation for deciding on an appropriate reaction to the _POODLE_ vulnerability. In practice, which encryption protocols are actually on the server since then:

```
cat tutorial-5-example-access.log | cut -d\" -f11 | cut -d\  -f3 | sort | uniq -c | sort -n
```{{execute}}
```
      4 -
    155 TLSv1
   9841 TLSv1.2
```

It appears that Apache is not always recording an encryption protocol. This is a bit strange, but because it is a very rare case, we won’t be pursuing it for the moment. What’s more important are the numerical ratios between the TLS protocols. After disabling _SSLv3_, the _TLSv1.2_ protocol is dominant and _TLSv1.0_ is slowly being phased out.

We again got to the desired result by a series of _cut_ commands. It would actually be advisable to take note of these commands, because will be needing them again and again. It would then be an alias list as follows:

```
alias alip='cut -d\  -f1'
alias alcountry='cut -d\  -f2'
alias aluser='cut -d\  -f3'
alias altimestamp='cut -d\  -f4,5 | tr -d "[]"'
alias alrequestline='cut -d\" -f2'
alias almethod='cut -d\" -f2 | cut -d\  -f1 | sed "s/^-$/**NONE**/"'
alias aluri='cut -d\" -f2 | cut -d\  -f2 | sed "s/^-$/**NONE**/"'
alias alprotocol='cut -d\" -f2 | cut -d\  -f3 | sed "s/^-$/**NONE**/"'
alias alstatus='cut -d\" -f3 | cut -d\  -f2'
alias alresponsebodysize='cut -d\" -f3 | cut -d\  -f3'
alias alreferer='cut -d\" -f4 | sed "s/^-$/**NONE**/"'
alias alreferrer='cut -d\" -f4 | sed "s/^-$/**NONE**/"'
alias aluseragent='cut -d\" -f6 | sed "s/^-$/**NONE**/"'
alias alcontenttype='cut -d\" -f8'
...
```

All of the aliases begin with _al_. This stands for _ApacheLog_ or _AccessLog_. This is followed by the field name. The individual aliases are not sorted alphabetically. They instead follow the sequence of the fields in the format of the log file.

This list with alias definitions is available in the file [.apache-modsec.alias](https://raw.githubusercontent.com/Apache-Labor/labor/master/bin/.apache-modsec.alias). They have been put together there with a few additional aliases that we will be defining in subsequent tutorials. If you often work with Apache and its log files, then it is advisable to place these alias definitions in the home directory and to load them when logging in. By using the following entry in the _.bashrc_ file or via another related mechanism. (The entry also has a 2nd functionality: it adds the `bin` subfolder of your home folder to the PATH if it is not there already. This is often not the case and we are using this folder to place additional custom scripts that play with the apache-modsec file. So it's a good moment to prepare this immediately.)


```
# Load apache / modsecurity aliases if file exists
test -e $HOME/.apache-modsec.alias && . $HOME/.apache-modsec.alias

# Add $HOME/bin to PATH
[[ ":$PATH:" != *":$HOME/bin:"* ]] && PATH="$HOME/bin:${PATH}"
```

Please download the alias file to your `$HOME` folder with `wget` and enable it for your shell as described above. You can then start a new shell by typing `bash` and the new environment is immediately available. Please do that!

Let’s use the new alias right away:
```
cat tutorial-5-example-access.log | alsslprotocol | sort | uniq -c | sort -n
```{{execute}}
```
      4 -
    155 TLSv1
   9841 TLSv1.2
```

This is a bit easier. But the repeated typing of _sort_ followed by _uniq -c_ and then a numerical _sort_ yet again is tiresome. Because it is again a repeating pattern, an alias is also worthwhile here, which can be abbreviated to _sucs_: a merger of the beginning letters and the _c_ from _uniq -c_.

```Dbash
alias sucs='sort | uniq -c | sort -n'
```

This then enables us to do the following:


```
cat tutorial-5-example-access.log | alsslprotocol | sucs
```{{execute}}
```
      4 -
    155 TLSv1
   9841 TLSv1.2
```

This is now a simple command that is easy to remember and easy to write. We now have a look at the numerical ratio of 1764 to 8150. We have a total of exactly 10,000 requests; the percentage values can be derived by looking at it. In practice however log files may not counted so easily, we will thus be needing help calculating the percentages.


And another quiz question for you:

>>Quiz: How many requests with the legacy AES256-SHA cipher are there in the example log?<<
( ) 7
(*) 23
( ) 65
( ) 134
