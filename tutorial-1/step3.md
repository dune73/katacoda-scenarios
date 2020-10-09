## Step 3 - Downloading the source code and verifying the checksum

We’ll now download the program code from the internet. This can be done by downloading it directly from Apache in a browser or, to save the Apache Project’s bandwidth, by using wget to get it from a mirror.

Move back to the apache source code folder:

`cd /usr/src/apache`{{execute}}

Get the source code:

`wget https://www-eu.apache.org/dist//httpd/httpd-2.4.43.tar.bz2`{{execute}}

The compressed source code is approximately 5 MB in size.

We’ll now download the checksum of the source code file from Apache. At least it’s available as a sha1 checksum. We’ll again be using a secure connection for better security. Without https this verification doesn’t make much sense.

Get the checksum file:

`wget https://www.apache.org/dist/httpd/httpd-2.4.43.tar.bz2.sha256`{{execute}}

Execute the check:

`sha256sum --check httpd-2.4.43.tar.bz2.sha256`{{execute}}

` httpd-2.4.43.tar.bz2: OK`
