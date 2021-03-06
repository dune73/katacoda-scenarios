_There is an issue with the way Katacoda configures the bash shell. Please execute the following command to launch a new shell that is properly configured._

```
while [ 1 ]; do grep -q "Env downloaded" /tmp/tmp.log 2>/dev/null && break; sleep 1; done; echo "Environment ready"; bash
```{{execute}}

We previously downloaded the source code for the web server to <i>/usr/src/apache</i>. We will now be doing the same with ModSecurity. To do so, we create the directory <i>/usr/src/modsecurity/</i> as root, we transfer it to ourselves and then download the code into the folder. 

```
sudo mkdir /usr/src/modsecurity
```{{execute}}

```
sudo chown `whoami` /usr/src/modsecurity
```{{execute}}

```
cd /usr/src/modsecurity
```{{execute}}

```
wget https://www.modsecurity.org/tarball/2.9.3/modsecurity-2.9.3.tar.gz
```{{execute}}

Compressed, the source code is just over four megabytes in size. We now need to verify the checksum. It is provided in SHA256 format.

```
wget https://www.modsecurity.org/tarball/2.9.3/modsecurity-2.9.3.tar.gz.sha256
sha256sum --check modsecurity-2.9.3.tar.gz.sha256
```{{execute}}

We expect the following response:

```
modsecurity-2.9.3.tar.gz: OK
```
