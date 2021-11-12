The character of the application, the paranoia level and the amount of traffic all influence the amount of false positives you get in your logs. In the first run, a couple of thousand or one hundred thousand requests will do. Once you have that in your access log, it's time to take a look. Let's get an overview of the situation: Let's look at the example logs!

There is the ModSecurity Audit log of course, but I rarely look at it unless I have a very specific interest. For most of the cases, the ModSecurity alert message in the error log is all I need. But this is not where I start. Let's look looking at the access log first. We defined the log format in a way that gives us the anomaly scores for every request and that's exactly what we will be using at this stage.


In the previous tutorial, we used the script [modsec-positive-stats.rb](https://www.netnea.com/files/modsec-positive-stats.rb). We return to this script with the example access log as the target:

```
cat tutorial-8-example-access.log | alscores | modsec-positive-stats.rb
```{{execute}}

```
INCOMING                     Num of req. | % of req. |  Sum of % | Missing %
Number of incoming req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. incoming score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with incoming score of   0 |   5014 |  50.1399% |  50.1399% |  49.8601%
Reqs with incoming score of   1 |      0 |   0.0000% |  50.1399% |  49.8601%
Reqs with incoming score of   2 |      0 |   0.0000% |  50.1399% |  49.8601%
Reqs with incoming score of   3 |      0 |   0.0000% |  50.1399% |  49.8601%
Reqs with incoming score of   4 |      0 |   0.0000% |  50.1399% |  49.8601%
Reqs with incoming score of   5 |   3562 |  35.6200% |  85.7599% |  14.2401%
Reqs with incoming score of   6 |      0 |   0.0000% |  85.7599% |  14.2401%
Reqs with incoming score of   7 |      0 |   0.0000% |  85.7599% |  14.2401%
Reqs with incoming score of   8 |      1 |   0.0100% |  85.7700% |  14.2300%
Reqs with incoming score of   9 |      0 |   0.0000% |  85.7700% |  14.2300%
Reqs with incoming score of  10 |      2 |   0.0200% |  85.7899% |  14.2101%
Reqs with incoming score of  11 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  12 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  13 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  14 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  15 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  16 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  17 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  18 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  19 |      0 |   0.0000% |  85.7899% |  14.2101%
Reqs with incoming score of  20 |     41 |   0.4100% |  86.1999% |  13.8001%
Reqs with incoming score of  21 |      0 |   0.0000% |  86.1999% |  13.8001%
Reqs with incoming score of  22 |      0 |   0.0000% |  86.1999% |  13.8001%
Reqs with incoming score of  23 |      0 |   0.0000% |  86.1999% |  13.8001%
Reqs with incoming score of  24 |     50 |   0.5000% |  86.6999% |  13.3001%
Reqs with incoming score of  25 |      0 |   0.0000% |  86.6999% |  13.3001%
Reqs with incoming score of  26 |      0 |   0.0000% |  86.6999% |  13.3001%
Reqs with incoming score of  27 |      0 |   0.0000% |  86.6999% |  13.3001%
Reqs with incoming score of  28 |      0 |   0.0000% |  86.6999% |  13.3001%
Reqs with incoming score of  29 |      0 |   0.0000% |  86.6999% |  13.3001%
Reqs with incoming score of  30 |     76 |   0.7600% |  87.4599% |  12.5401%
Reqs with incoming score of  31 |      0 |   0.0000% |  87.4599% |  12.5401%
Reqs with incoming score of  32 |      0 |   0.0000% |  87.4599% |  12.5401%
Reqs with incoming score of  33 |      0 |   0.0000% |  87.4599% |  12.5401%
Reqs with incoming score of  34 |      0 |   0.0000% |  87.4599% |  12.5401%
Reqs with incoming score of  35 |     76 |   0.7600% |  88.2200% |  11.7800%
Reqs with incoming score of  36 |      0 |   0.0000% |  88.2200% |  11.7800%
Reqs with incoming score of  37 |      5 |   0.0500% |  88.2700% |  11.7300%
Reqs with incoming score of  38 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  39 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  40 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  41 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  42 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  43 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  44 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  45 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  46 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  47 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  48 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  49 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  50 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  51 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  52 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  53 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  54 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  55 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  56 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  57 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  58 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  59 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  60 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  61 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  62 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  63 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  64 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  65 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  66 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  67 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  68 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  69 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  70 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  71 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  72 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  73 |      0 |   0.0000% |  88.2700% |  11.7300%
Reqs with incoming score of  74 |    388 |   3.8800% |  92.1499% |   7.8501%
Reqs with incoming score of  75 |      0 |   0.0000% |  92.1499% |   7.8501%
Reqs with incoming score of  76 |      0 |   0.0000% |  92.1499% |   7.8501%
Reqs with incoming score of  77 |      0 |   0.0000% |  92.1499% |   7.8501%
Reqs with incoming score of  78 |     76 |   0.7600% |  92.9100% |   7.0900%
Reqs with incoming score of  79 |      1 |   0.0100% |  92.9200% |   7.0800%
Reqs with incoming score of  80 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  81 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  82 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  83 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  84 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  85 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  86 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  87 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  88 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  89 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  90 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  91 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  92 |      0 |   0.0000% |  92.9200% |   7.0800%
Reqs with incoming score of  93 |    701 |   7.0100% |  99.9300% |   0.0700%
Reqs with incoming score of  94 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of  95 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of  96 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of  97 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of  98 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of  99 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 100 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 101 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 102 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 103 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 104 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 105 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 106 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 107 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 108 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 109 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 110 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 111 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 112 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 113 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 114 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 115 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 116 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 117 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 118 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 119 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 120 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 121 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 122 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 123 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 124 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 125 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 126 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 127 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 128 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 129 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 130 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 131 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 132 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 133 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 134 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 135 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 136 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 137 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 138 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 139 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 140 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 141 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 142 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 143 |      0 |   0.0000% |  99.9300% |   0.0700%
Reqs with incoming score of 144 |      1 |   0.0100% |  99.9400% |   0.0600%
Reqs with incoming score of 145 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 146 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 147 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 148 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 149 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 150 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 151 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 152 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 153 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 154 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 155 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 156 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 157 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 158 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 159 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 160 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 161 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 162 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 163 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 164 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 165 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 166 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 167 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 168 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 169 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 170 |      0 |   0.0000% |  99.9400% |   0.0600%
Reqs with incoming score of 171 |      6 |   0.0600% | 100.0000% |   0.0000%

Incoming average:  12.6065    Median   0.0000    Standard deviation  27.5065
OUTGOING                     Num of req. | % of req. |  Sum of % | Missing %
Number of outgoing req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. outgoing score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with outgoing score of   0 |  10000 | 100.0000% | 100.0000% |   0.0000%

Outgoing average:   0.0000    Median   0.0000    Standard deviation   0.0000
```

So we have 10,000 requests and about half of them pass without raising an alarm. Over 3,500 requests come in with an anomaly score of 5 and of the remaining requests form two distinct anomaly score clusters around 74 and 93. Then there is a very long tail with the highest group of requests scoring 171. That's more than 30 critical alerts on a single request (a critical alert gives 5 points, 30 critical alerts will thus score 150). Wow!

Let's visualize this:

<img src="https://www.netnea.com/files/tutorial-8-distribution-untuned.png" alt="Untuned Distribution" width="950" height="550" />

_A quick overview over the stats generated above_



This is only a graph cobbled together on the fly. But it shows the problem that most requests are located near the left. They did not score at all, or they scored exactly 5 points. But there requests with higher scores and there is even a handful of outliers beyond the frame on the right. So where do we start? 

We start with the request returning the highest anomaly score, we start on the right side of the graph! This makes sense because we are in blocking mode and we would like to reduce the threshold. The group of requests standing in our way are the six requests with a score of 171 and the single request with a score of 144. Let's write rule exclusions to suppress the alarms leading to these scores, because it's these 7 requests that stop us from reducing the anomaly threshold from 10,000 to say 100.

