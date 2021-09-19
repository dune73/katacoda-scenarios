The most widespread log format, _combined_, is based on the _common_ log format, extending it by two items.

```
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
...
CustomLog logs/access.log combined
```

_"%{Referer}i"_ is used for the referrer. It is output in quotes. The referrer means any resource from which the request that just occurred was originally initiated. This complicated paraphrasing can best be illustrated by an example. Suppose you click a link at a search engine to get to _www.example.com_. But when you send your request, you are automatically redirected to _shop.example.com_. The log entry for _shop.example.com_ will include the search engine as the referrer and not the link to _www.example.com_. If however a CSS file dependent on _shop.example.com_ is loaded, the referer would normally be attributed to _shop.example.com_. However, despite all of this, the referrer is part of the client's request. The client is required to follow the protocol and conventions, but can in fact send any kind of information, which is why you cannot rely on headers like these when security is an issue.

Finally, _"%{User-Agent}i"_ means the client user agent, which is also placed in quotes. This is also a value controlled by the client and which we should not rely on too much. The user agent is the client browser software, normally including the version, the rendering engine, information about compatibility with other browsers and various installed plugins. This results in very long user agent entries which can in some cases include so much information that an individual client can be uniquely identified, because they feature a particular combination of different add-ons of specific versions.
