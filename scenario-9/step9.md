RewriteMaps come in a number of different variations. They works by assigning a value to a key parameter at every request. A hash table is a simple example. But it is then also possible to configure external scripts as a programmable RewriteMap. The following types of maps are possible:

* txt : A key value pair in a text file is searched for here.
* rnd : Several values can be specified for each key here. They are then selected at random.
* dbm : This variation works like the txt variation, but provides a big speed advantage as a binary hash table is used.
* int : This abbreviation stands for internal function and refers to a function from the following list: `toupper`, `tolower`, `escape` and `unescape`.
* prg : An external script is invoked in this variation. The script is started along with the server and each time the RewriteMap is accessed receives new input via STDIN.
* dbd und fastdbd : The response value is searched for in a database request.

This list makes clear that RewriteMaps are extremely flexible and can be used in a variety of situations. Determining the backend for proxying is only one of many possible applications. In our example we want to ensure that the request from a specific client always goes to the same backend. There are a number of different ways of doing this, specifically, by setting a cookie. But we don’t want to intervene in the requests. We could divide by network ranges. But how to prevent a large number of clients from a specific network range from all being taken to the same backend? Some kind of distribution has to take place. To do so, we combine ModSecurity with using ModRewrite and a RewriteMap. Let’s have a look at it step by step.

First, we calculate a hash value from the client’s IP address. This means that we are converting the IP address into a seemingly random hexadecimal string using ModSecurity:

```
SecRule REMOTE_ADDR   "^(.)" \
   "phase:1,id:50001,capture,nolog,t:sha1,t:hexEncode,setenv:IPHashChar=%{TX.1}"
```

We have used hexEncode to convert the binary hash value we generated using sha1 into readable characters. We then apply the regular expression to this value. "^(.)" means that we want to find a match on the first character. Of the ModSecurity flags that follow `capture` is of interest. It indicates that we want to capture the value in the parenthesis in the previous regex condition. We then put it into the IPHashChar environment variable.

If there is any uncertainty as to whether this will really work, then the content of the variable `IPHashChar` can be printed and checked using `%{IPHashChar}e` in the server’s access log. This brings us to RewriteMap and the request itself:

```
RewriteMap hashchar2backend "txt:/apache/conf/hashchar2backend.txt"

RewriteCond     "%{ENV:IPHashChar}"     ^(.)
RewriteRule     ^/service1/(.*) \
                     http://${hashchar2backend:%1|localhost:8000}/service1/$1 [proxy,last]

<Proxy http://localhost:8000/service1>

    Require all granted

    Options None

    ProxySet enablereuse=on

</Proxy>

<Proxy http://localhost:8001/service1>

    Require all granted

    Options None

    ProxySet enablereuse=on

</Proxy>
```

We introduce the map by using the RewriteMap command. We assign it a name, define its type and the path to the file. RewriteMap is invoked in a RewriteRule. Before we really access the map, we enable a rewrite condition. This is done using the RewriteCond directive. There we reference the IPHashChar environment variable and determine the first byte of the variable. We know that only a single byte is included in the variation, but this won’t put a stop to our plans. On the next line then the typical start of the Proxy directive. But instead of now specifying the backend, we reference RewriteMap by the name previously assigned. After the colon comes the parameter for the request. Interestingly, we use `%1` to communicate with the rewrite conditions captured in parenthesis. The RewriteRule variable is not affected by this and continues to be referenced via `$1`. After the `%1` comes the default value separated by a pipe character. Should anything go wrong when accessing the map, then communication with localhost takes place over port 8000.

All we need now is the RewriteMap. In the code sample we specified a text file. Better performance is provided by a hash file, but this is not the focus at present. Here’s the `/apache/conf/hashchar2backend.txt` map file:

```
##
## RewriteMap linking hex characters with one of two backends
##
1	localhost:8000
2	localhost:8000
3	localhost:8000
4	localhost:8000
5	localhost:8000
6	localhost:8000
7	localhost:8000
8	localhost:8000
9	localhost:8001
0	localhost:8001
a	localhost:8001
b	localhost:8001
c	localhost:8001
d	localhost:8001
e	localhost:8001
f	localhost:8001
```

We are differentiating between two backends and can perform the distribution any way we want. All in all, this is more indicative of a complex recipe that we put together forming a hash for each IP address and using the first character in order to determine one of two backends in the hash tables we just saw. If the client IP address remains constant (which does not always have to be the case in practice) the result of this lookup will always be the same. This means that the client will always end up on the same backend. This is called IP stickiness. However, since this entail a hash operation and not a simple IP address lookup, two clients with a similar IP address will be given a completely different hash and will not necessarily end up on the same backend. This gives us a somewhat flat distribution of the requests yet we can still be sure that specific clients will always end up on the same backend until the IP address changes.
