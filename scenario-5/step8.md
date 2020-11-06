If you take a close look at the example log output above you will see that the duration of the requests are not evenly distributed and that there is a single outlier. We can identify the outlier as follows:

```
egrep -o "\% [0-9]+ " logs/access.log | cut -b3- | tr -d " " | sort -n
```{{execute}}

Using this one-liner we cut out the value that specifies the duration of a request from the log file. We use the percent sign of the Deflate value as an anchor for a simple regular expression and take the number following it. _egrep_ makes sense here, because we want to work with regex, the _-o_ option results in only the match itself being output, not the entire line. This is very helpful.
One detail that will help us to avoid errors in the future is the space following the plus sign. It only accepts values that have a space following the number. The problem is the user agent that also appears in our log format and which has up to now also included percent signs. We assume here that percent signs can be followed by a space and a whole number. But this is not followed by another space and this combination only appears at the end of the log file line after the _Deflate space savings_ percent sign. We then use _cut_ so that only the third and subsequent characters are output and finally we use _tr_ to separate the closing space (see regex). We are then ready for numerical sorting. This delivers the following result:

```
...
354
355
357
363
363
363
1740
```

In our example, almost all of the requests have been handled very fast. Yet, there is a single one with a duration of over 1,000 microseconds, or more than one millisecond. This is still within reason, but interesting to see how this request is setting itself apart from the other values as a statistical outlier.

We know that we made 100 GET and 100 POST requests. But for the sake of practice, let’s count them again:

```
egrep -c "\"GET " logs/access.log 
```{{execute}}

This should result in 100 GET requests:

```
100
```

We can also compare GET and POST with one another. We do this as follows:

```
egrep -o '"(GET|POST)' logs/access.log | cut -b2- | sort | uniq -c
```{{execute}}

Here, we filter out the GET and the POST requests using the method that follows a quote mark. We then cut out the quote mark, sort and count grouped:

```
    100 GET 
    100 POST 
```

So much for these first finger exercises. On the basis of this self-filled log file this is unfortunately not yet very exciting. So let’s try it with a real log file from a production server.


Before we advance to the next step, let's see if you can answer this quiz question on your own:

>>Quiz: What is the response size (HTTP response body size) of the POST requests you executed?
=== 45
