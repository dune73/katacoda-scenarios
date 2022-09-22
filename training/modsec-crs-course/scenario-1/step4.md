After verification we can unpack the package.

Extract the source code:

`tar -xvjf httpd-2.4.54.tar.bz2`{{execute}}

This results in approximately 38 MB.

We now enter the directory and configure the compiler with our entries and with information about our system. Unlike apr, our entries are very extensive.

Change into the folder:

`cd httpd-2.4.54`{{execute}}

Configure the compilaton process:

```./configure --prefix=/opt/apache-2.4.54  --with-apr=/usr/local/apr/bin/apr-1-config \
   --with-apr-util=/usr/local/apr/bin/apu-1-config \
   --enable-mpms-shared=event \
   --enable-mods-shared=all \
   --enable-nonportable-atomics=yes
```{{execute}}

This is where we define the target directory for the future Apache web server, again compiling in compliance with the FHS. Following this, there are two options for linking the two libraries installed as a precondition. We use `--enable-mpms-shared` to select a process model for the server. Simply put, this is like an engine type: gasoline (petrol) or diesel. In our case, `event`, `worker`, `prefork` and a few experimental engines are available. In this case we’ll take the `event` model, which is the new standard in 2.4 and has significantly better performance over the other architectures. In the 2.0 and 2.2 version lines there was significantly more to consider besides performance, but this set of problems has been significantly defused since 2.4 and it’s best for us to continue with `event`. More information about the different process models (MPMs) is available from the Apache Project.

We then define that we want all (all) modules to be compiled. Of note here is that all does not really mean all. For historical reasons all means only all of the core modules, of which there are quite a few. The shared keyword indicates that we would like to have the modules compiled separately in order to then be able to link them as optional modules. And lastly, `enable-nonportable-atomics` is a compiler flag which instructs the compiler to use special options which are available only on modern x86 processors and have a favorable impact on performance.

When executing the `configure` command for the web server, it may be necessary to install additional packages. However, if you have installed all those named in the second step, you should be covered.
