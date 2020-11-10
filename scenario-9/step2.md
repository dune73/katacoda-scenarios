Several modules are required to use Apache as a proxy server. We compiled them in the first tutorial and can now simply link them.

```
LoadModule              proxy_module            modules/mod_proxy.so
LoadModule              proxy_http_module       modules/mod_proxy_http.so
```

The proxying feature set is provided by a basic proxy module and a proxy HTTP module. Proxying actually means receiving a request and forwarding it to another server. In our case we will be defining the backend system from the beginning and then accept requests from different clients for this backend service. It’s a different situation if you set up a proxy server that accepts requests from a group of clients and sends then onward to any server on the internet. This is referred to as a forward proxy. This is useful for when you don’t want to directly expose clients on a corporate network to the internet since the proxy server appears as a client to the servers on the internet.

This mode is also possible in Apache, even if for historical reasons. Alternative software packages offering these features have become well established, e.g. squid. The case is relevant insofar as a faulty configuration may have fatal consequences, particularly if the forward proxy accepts requests from any client and sends them onward to the internet in anonymized form. This is referred to as an open proxy. It’s essential to prevent this since we don’t want to operate Apache in this mode. That requires a directive in the past used to reference the risky default `on` value, but is now correctly predefined as `off`:

```
ProxyRequests Off
```

This directive actually means forwarding requests to servers on the internet, even if the name indicates a general setting. As mentioned before, the directive is correctly set for Apache 2.4 and it is only being mentioned here to guard against questions or incorrect settings in the future.
