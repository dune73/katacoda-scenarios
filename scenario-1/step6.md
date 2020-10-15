When compiling is successful, we then install the Apache web server we built ourselves. Installation must be performed by the super user. But right afterwards we’ll see how we can again take ownership of the web server. This is much more practical for a test system.

`sudo make install`{{execute}}

Installation may also take some time.

`sudo chown -R $(whoami) /opt/apache-2.4.46`{{execute}}

And now for a trick: If you work professionally with Apache then you often have several different versions on the test server. Different versions, different patches, other modules, etc. result in tedious and long pathnames with version numbers and other descriptions. To ease things, I create a soft link from /apache to the current Apache web server when I switch to a new version. Care must be given that we and not the root user are the owners of the soft link (this is important in configuring the server).

Create a softlink to access the installation quickly:

`sudo ln -s /opt/apache-2.4.46 /apache`{{execute}}

Take ownership of the installation:

`sudo chown $(whoami) --no-dereference /apache`{{execute}}

Enter the installation folder:

`cd /apache`{{execute}}

Our web server now has a pathname clearly describing it by version number. We will however simply use `/apache` for access. This makes work easier.
