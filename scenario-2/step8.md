So much for the simple server. But just for fun we can put it to the test. We’ll perform a small performance test using ab, short for ApacheBench. This is a very simple benchmarking program that is always at hand and able to quickly give you initial performance results. I like to run it before and after a configuration change to get an idea about whether anything in terms of performance has changed. ab is very powerful and calling it locally does not give you clean results. But you can get an initial impression using this tool.

```
./bin/ab -c 1 -n 1000 http://localhost/index.html
```{{execute}}

We are starting ab using concurrency 1. The means that we are executing only one request at a time. In total, we will be executing 1,000 requests from the known URL. This is the output from ab:

```
This is ApacheBench, Version 2.3 <$Revision: 1663405 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        Apache
Server Hostname:        localhost
Server Port:            80

Document Path:          /index.html
Document Length:        45 bytes

Concurrency Level:      1
Time taken for tests:   0.676 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      250000 bytes
HTML transferred:       45000 bytes
Requests per second:    1480.14 [#/sec] (mean)
Time per request:       0.676 [ms] (mean)
Time per request:       0.676 [ms] (mean, across all concurrent requests)
Transfer rate:          361.36 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     0    1   0.2      1       3
Waiting:        0    0   0.1      0       2
Total:          0    1   0.2      1       3

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%      1
  95%      1
  98%      1
  99%      1
 100%      3 (longest request)
```{{execute}}

What’s of primary interest to us is the number of errors (Failed requests) and the number of requests per second (Requests per second). A value above one thousand is a good start. Especially considering that we are still working with a single process and not a parallelized daemon (which is also why the concurrency level is set to 1).
