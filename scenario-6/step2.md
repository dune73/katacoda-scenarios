We now unpack the source code and initiate the configuration. But before this it is essential to install several packages that constitute the prerequisite for compiling _ModSecurity_. If you did the first tutorial in this series, you should be covered, but it's still worth checking the following list of packages is really ready: A library for parsing XML structures, the base header files of the system’s own Regular Expression Library and everything to work with JSON files. Like in the previous tutorials, we are working on a system from the Debian family. The packages are thus named as follows:

* libxml2-dev
* libexpat1-dev
* libpcre3-dev
* libyajl-dev

The packages are installed here in this Katacoda scenario for you.

The stage is thus set and we are ready for ModSecurity.

```
tar -xvzf modsecurity-2.9.3.tar.gz
cd modsecurity-2.9.3
./configure --with-apxs=/apache/bin/apxs \
--with-apr=/usr/local/apr/bin/apr-1-config \
--with-pcre=/usr/bin/pcre-config
```{{execute}}

We created the <i>/apache</i> symlink in the tutorial on compiling Apache. This again comes to our assistance, because independent from the Apache version being used, we can now have the ModSecurity configuration always work with the same parameters and always get access to the current Apache web server. The first two options establish the link to the Apache binary, since we have to make sure that ModSecurity is working with the right API version. The _with-pcre_ option defines that we are using the system’s own _PCRE-Library_, or Regular Expression Library, and not the one provided by Apache. This gives us a certain level of flexibility for updates, because we are becoming independent from Apache in this area, which has proven to work in practice. It requires the first installed _libpcre3-dev_ package.

