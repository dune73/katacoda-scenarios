It’s not all that important where the source code is located. The following is a recommendation based on the [File Hierarchy Standard](http://www.pathname.com/fhs/). The FHS defines the path structure of a Unix system; the structure for all stored files. Note that in the second command whoami evaluates to the username and not root (despite sudo).

Create folder:

`sudo mkdir /usr/src/apache`{{execute}}

Take ownership of folder:

`sudo chown $(whoami) /usr/src/apache`{{execute}}

Change directory to the folder:

`cd /usr/src/apache`{{execute}}
