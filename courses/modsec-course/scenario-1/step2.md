Since the release of version 2.4, the Apache web server comes without two important libraries that used to be part of the distribution. We now have to install `apr` and `apr-util` ourselves before being able to compile Apache. `apr` is the Apache Portable Runtime library. It adds additional features to the normal set of C libraries typically needed by server software. They include features for managing hash tables and arrays. These libraries aren’t used by the Apache web server alone, but also by other Apache Software Foundation projects, which is why they were removed from Apache’s source code. Like `apr`, `apr-util` is part of the Portable Runtime libraries supplemented by `apr-util`.

Let’s start with apr and download the package.

`wget https://www-eu.apache.org/dist/apr/apr-1.7.0.tar.bz2`{{execute}}

We’ll now download the checksum of the source code file from Apache. We’ll verify the integrity of the source code we downloaded that way. For better security we’ll be using a secure connection for downloading. Without https this verification doesn’t make much sense. Both files, the source code and the small checksum file, should be placed together in `/usr/src/apache`. We can now verify the checksum:

Get the checksum file:

`wget https://www.apache.org/dist/apr/apr-1.7.0.tar.bz2.sha256`{{execute}}

And now run the check:

`sha256sum --check apr-1.7.0.tar.bz2.sha256`{{execute}}

`apr-1.7.0.tar.bz2: OK`

The test should not result in any problems, OK. We can now continue with unpacking, pre-configuring and compiling `apr`.

Unpack the repository:

`tar -xvjf apr-1.7.0.tar.bz2`{{execute}}

Change into the folder:

`cd apr-1.7.0`{{execute}}

Configure the compilation process:

`./configure --prefix=/usr/local/apr/`{{execute}}

After unpacking, we now change to the new directory containing the source code and start configure. This configures the compiler. We specify the installation path and configure gathers a variety of information and settings about our system. Sometimes, a warning about `libtoolT` is printed but it can be ignored. The configure command frequently complains about missing components. One thing is certain: Without a working compiler we will be unable to compile and it’s configure’s task to check whether everything is assembled correctly.

Things typically missing:

    build-essential
    binutils
    gcc

And once we are at it, let's install everything else we are going to need throughout this and the following tutorials:

    gawk
    libexpat1-dev
    libpcre3-dev
    libssl-dev
    libxml2-dev
    libyajl-dev
    nikto
    ruby
    ssl-cert
    uuid
    zlibc
    zlib1g-dev

Here is how to install all this stuff with a single command:

`sudo apt-get --assume-yes install build-essential binutils gcc libpcre3-dev libssl-dev zlibc zlib1g-dev ssl-cert ruby uuid gawk libxml2-dev libexpat1-dev libyajl-dev`{{execute}}


These are the package names on Debian-based distributions. The packages may have different names elsewhere. The absence of these files can be easily rectified by re-installing them using the utilities from your own distribution. Afterwards, run configure again, perhaps re-install something again and eventually the script will run successfully (individual warnings during the configure steps are no big problem. We just need to be sure the script did not die unexpectedly).

Once it runs without a problem, we can assume that the time for compiling has come.

`make`{{execute}}

This takes a moment after which we get the compiled apr, which we promptly install.

`sudo make install`{{execute}}

Once this is successful, we'll do the same with apr-util.

Move back to the apache source code folder:

`cd /usr/src/apache`{{execute}}

Get the `apr-util` source code.

`wget https://www-eu.apache.org/dist/apr/apr-util-1.6.1.tar.bz2`{{execute}}

Get the checksum file:

`wget https://www.apache.org/dist/apr/apr-util-1.6.1.tar.bz2.sha256`{{execute}}

Perform the check:

`sha256sum --check apr-util-1.6.1.tar.bz2.sha256`{{execute}}

`apr-util-1.6.1.tar.bz2: OK`

Extract the source code from the archive:

`tar -xvjf apr-util-1.6.1.tar.bz2`{{execute}}

Enter the folder:

`cd apr-util-1.6.1`{{execute}}

Configure the compiler:

`./configure --prefix=/usr/local/apr/ --with-apr=/usr/local/apr/`{{execute}}

Run the compilation:

`make`{{execute}}

Install the compiled binaries:

`sudo make install`{{execute}}

Once this works in both cases we're ready for the web server itself.
