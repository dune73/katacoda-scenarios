Installation is also easily accomplished. Since we continue to be working on a test system, we transfer ownership of the installed module from the root user to ourselves, because for all of the Apache binaries we made sure to be the owner ourselves. This in turn produces a clean setup with uniform ownerships.

```
sudo make install
sudo chown `whoami` /apache/modules/mod_security2.so
```{{execute}}

The module has the number <i>2</i> in its name. This was introduced in the version jump to 2.0 when a reorientation of the module made this necessary. But this is only an minor detail.

