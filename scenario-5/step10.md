What we are lacking is a command that works similar to the _sucs_ alias, but
converts the number values into percentages in the same pass: _sucspercent_.
It’s important to know that this script is based on an expanded *awk*
implementation (yes, there are several). The package is normally named *gawk*
and it makes sure that the `awk` command uses the Gnu awk implementation.

```
alias sucspercent='sort | uniq -c | sort -n | $HOME/bin/percent.awk'
```{{execute}}

Traditionally, _awk_ is used for quick calculations in Linux. In addition to
the above linked _alias_ file, which also includes the _sucspercent_, the _awk_
script _percent.awk_ is also available. It is ideally placed in the _bin_
directory of your home directory.  The _sucspercent_ alias above then assumes
this setup. The _awk_ script is available
[here](https://raw.githubusercontent.com/Apache-Labor/labor/master/bin/percent.awk).
Please make sure it is executable or you will get a permission denied.

```
cat tutorial-5-example-access.log | alsslprotocol | sucspercent 
```{{execute}}
```
                         Entry        Count Percent
---------------------------------------------------
                             -            4   0.04%
                         TLSv1          155   1.55%
                       TLSv1.2        9,841  98.41%
---------------------------------------------------
                         Total        10000 100.00%
```

Wonderful. We are now able to output the numerical ratios for any repeating
values. How does it look, for example, with the encryption method used?


```
cat tutorial-5-example-access.log | alsslcipher | sucspercent 
```{{execute}}
```
                         Entry        Count Percent
---------------------------------------------------
                             -            4   0.04%
                    AES256-SHA           23   0.23%
     DHE-RSA-AES256-GCM-SHA384           42   0.42%
       ECDHE-RSA-AES128-SHA256           50   0.50%
          ECDHE-RSA-AES256-SHA          156   1.56%
   ECDHE-RSA-AES128-GCM-SHA256          171   1.71%
       ECDHE-RSA-AES256-SHA384          234   2.34%
   ECDHE-RSA-AES256-GCM-SHA384        9,320  93.20%
---------------------------------------------------
                         Total        10000 100.00%
```

A good overview on the fly. We can be satisfied with this for the moment. Is
there anything to say about the HTTP protocol versions?

```
cat tutorial-5-example-access.log | alprotocol | sucspercent 
```{{execute}}
```
                         Entry        Count Percent
---------------------------------------------------
                      HTTP/1.0           66   0.66%
                      HTTP/1.1        9,934  99.34%
---------------------------------------------------
                         Total        10000 100.00%
```

The obsolete _HTTP/1.0_ still appears, but _HTTP/1.1_ is clearly dominant.
With the different aliases for the extraction of values from the log file and the two _sucs_ and _sucspercent_ aliases we have come up with a handy tool enabling us to simply answer questions about the relative frequency of repeating values using the same pattern of commands.

For measurements that no longer repeat, such as the duration of a request or the size of the response, these percentages are not very useful. What we need is a simple statistical analysis. What are needed are the mean, perhaps the median, information about the outliers and, for logical reasons, the standard deviation.

Such a script is also available for download: [basicstats.awk](https://raw.githubusercontent.com/Apache-Labor/labor/master/bin/basicstats.awk). Similar to percent.awk, it is advisable to place this script in your private _bin_ directory. 

```
cat tutorial-5-example-access.log | alioout | basicstats.awk
```{{execute}}
```
Num of values:          10,000.00
         Mean:          19,360.91
       Median:           7,942.00
          Min:               0.00
          Max:       3,920,007.00
        Range:       3,920,007.00
Std deviation:          52,480.41
```

These numbers give a clear picture of the service. With a mean response size of 19 KB and a median of 7.9 KB we have a typical web service. Specifically, the median means that half of the responses were smaller than 7.9 KB. The largest response came in at almost 4 MB, the standard deviation of just over 52 KB means that the large values were less frequent overall.

How does the duration of the requests look? Do we have a similar homogeneous picture?

```
$> cat tutorial-5-example-access.log | alduration | basicstats.awk
```{{execute}}
```
Num of values:          10,000.00
         Mean:          74,852.49
       Median:           3,684.50
          Min:             641.00
          Max:      31,360,516.00
        Range:      31,359,875.00
Std deviation:         695,283.17
```

It’s important to remember that we are dealing in microseconds here. The median was 3,684 microseconds, which is just over 3 milliseconds. At 74 milliseconds, the mean is much larger. We obviously have a lot of outliers which have pushed up the mean. In fact, we have a maximum value of 31 seconds and less surprisingly a standard deviation of 695 milliseconds. The picture is thus less homogeneous and we have at least some requests that should be investigated. But this is now getting a bit more complicated. The suggested method is only one of many possible and is included here as a suggestion and inspiration for further work with the log file:

```
cat tutorial-5-example-access.log | grep "\"GET " | aluri | cut -d\/ -f1,2,3 | sort | uniq \
| while read P; do MEAN=$(grep "GET $P" tutorial-5-example-access.log | alduration | basicstats.awk \
| grep Mean | sed 's/.*: //'); echo "$MEAN $P"; done \
| sort -n
```{{execute}}
```
...
        ...
        122,309.45 /cds/holiday-planner-download
        124,395.18 /cds/tools-inventory
        137,230.18 /cds/weather-app
        143,830.30 /cds/2016
        146,114.83 /cds/2015
        163,269.89 /cds/category
        216,229.88 /cds/tutorials
        576,129.71 /storage/static
```

What happens here in order? We use _grep_ to filter _GET_ requests. We extract the _URI_ and use _cut_ to cut it. We are only interested in the first part of the path. We limit ourselves here in order to get a reasonable grouping, because too many different paths will add little value. The path list we get is then sorted alphabetically and reduced by using _uniq_. This is half the work.

We now sequentially place the paths into variable _P_ and use _while_ to make a loop. In the loop we calculate the basic statistics for the path saved in _P_ and filter the output for the mean. In doing so, we use _sed_ to filter in such a way that the _MEAN variable includes only a number and not the _Mean_ name itself. We now output this average value and the path names. End of the loop. Last, but not least, we sort everything numerically and get an overview of which paths resulted in requests with longer response times. A path named _/storage/static_ apparently comes out on top. The keyword _storage_ makes this appear plausible.

This brings us to the end of this tutorial. The goal was to introduce an expanded log format and to demonstrate working with the log files. In doing so, we repeatedly used a series of aliases and two _awk_ scripts, which can be chained in different ways. With these tools and the necessary experience in their handling you will be able to quickly get at the information available in the log files.

Almost done. Here are some final quiz questions.

>>Quiz question 1: How many requests to the file `style.css` do you count in the example access log (Hint: Use `wc -l` to count lines)?
=== 368


>>Quiz question 2: How many microseconds did the fastest request in the example access log take (enter only the number)?
=== 641

>>Quiz question 3: How many successful POST requests do you count in the example access log?
=== 70
