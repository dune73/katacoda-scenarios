We have become familiar with the _combined_ format, the most widespread Apache log format. However, 
to simplify day-to-day work, the information shown is just not enough. Additional useful information
 has to be included in the log file.

It is advisable to use the same log format on all servers. Now, instead of just propagating one or t
wo additional values, these instructions describe a comprehensive log format that has proven useful 
in a variety of scenarios.

However, in order to be able to configure the log format below, we first have to enable the _Logio_ 
module. And on top if the the Unique-ID module, which useful from the start.

If the server has been compiled as described in Tutorial 1, then these modules are already present a
nd only have to be added to the list of modules being loaded in the server’s configuration file.

```
LoadModule              logio_module            modules/mod_logio.so
LoadModule              unique_id_module        modules/mod_unique_id.so
```

We need this module to be able to write two values. _IO In_ and _IO Out_. This means the total number of bytes of the HTTP request including header lines and the total number of bytes in the response, also including header lines. The Unique-ID module is calculating a unique identifier for every request. We'll return to this later on.

