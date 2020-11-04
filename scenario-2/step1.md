Our web server is stored in `/apache` on the file system. Its default configuration is located in `/apache/conf/httpd.conf`. It is very extensive and contains many comments and commented out configuration lines. This makes it rather difficult to understand but at least everything is still in a single file. For packaged versions of Apache, on many Linux distributions, the default configuration is not only very complicated, it is also fragmented into a handful of separate files that are spread across multiple directories. This can make it hard to get a good overview of what is actually going on. To simplify things, we will be replacing this extensive configuration file with the following, greatly simplified configuration.

FIXME: New Configuration


