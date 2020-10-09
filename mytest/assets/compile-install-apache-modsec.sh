#!/bin/bash

ERROR=0
VER_APR="1.7.0"
VER_APRUTIL="1.6.1"
VER_APACHE="2.4.46"
VER_MODSECURITY="2.9.3"
APACHE_MIRROR=https://www-eu.apache.org/dist


function break_on_error {
	if [ $1 -ne 0 ]; then
		echo
		echo "FAILED. This is fatal. Aborting"
		exit 1
	fi
}

echo -n "Installing conditions ... "
echo;
sudo apt-get update
sudo apt-get install build-essential binutils gcc libpcre3-dev libssl-dev zlibc zlib1g-dev ssl-cert ruby gawk libxml2-dev libexpat1-dev libyajl-dev wget
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"


if [ ! -e /usr/src/apache ]; then
	sudo mkdir /usr/src/apache
	ERROR=$(($ERROR|$?))	# logical OR
fi
break_on_error $ERROR


sudo chown `whoami` /usr/src/apache
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR


cd /usr/src/apache


# Installation of APR
echo -n "Downloading apr ... "
echo; if [ ! -f apr-$VER_APR.tar.bz2 ]; then 
	wget $APACHE_MIRROR/apr/apr-$VER_APR.tar.bz2
fi
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Downloading apr checksum ... "
echo; if [ ! -f apr-$VER_APR.tar.bz2.sha256 ]; then
	wget https://www.apache.org/dist/apr/apr-$VER_APR.tar.bz2.sha256
fi
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Checking apr checksum ... "
sha256sum --check --quiet apr-$VER_APR.tar.bz2.sha256
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Untarring ... "
echo; tar -xvjf apr-$VER_APR.tar.bz2
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

cd apr-$VER_APR
echo -n "Configuring ... "
echo; ./configure --prefix=/usr/local/apr/
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Compiling ... "
echo; make
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Installing ... "
echo; sudo make install
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"



# Installation of APR-URIL
cd /usr/src/apache

echo -n "Downloading apr-util ... "
echo; if [ ! -f apr-util-$VER_APRUTIL.tar.bz2 ]; then
	wget $APACHE_MIRROR/apr/apr-util-$VER_APRUTIL.tar.bz2
fi
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Downloading apr-util checksum ... "
echo; if [ ! -f apr-util-$VER_APRUTIL.tar.bz2.sha256 ]; then
	wget https://www.apache.org/dist/apr/apr-util-$VER_APRUTIL.tar.bz2.sha256
fi
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Checking apr-util checksum ... "
sha256sum --check --quiet apr-util-$VER_APRUTIL.tar.bz2.sha256
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Untarring ... "
echo; tar -xvjf apr-util-$VER_APRUTIL.tar.bz2
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

cd apr-util-$VER_APRUTIL
echo -n "Configuring ... "
echo; ./configure --prefix=/usr/local/apr/ --with-apr=/usr/local/apr/
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"


echo -n "Compiling ... "
echo; make
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Installing ... "
echo; sudo make install
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"


cd /usr/src/apache



# Installation of Apache

echo "Downloading apache ... "
echo; if [ ! -f httpd-$VER_APACHE.tar.bz2 ]; then
	wget $APACHE_MIRROR/httpd/httpd-$VER_APACHE.tar.bz2
fi
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"


echo "Downloading checksum ... "
echo; if [ ! -f httpd-$VER_APACHE.tar.bz2.sha1 ]; then
	wget https://www.apache.org/dist/httpd/httpd-$VER_APACHE.tar.bz2.sha1
fi
sha1sum --check --quiet httpd-$VER_APACHE.tar.bz2.sha1 
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"


if [ -d httpd-$VER_APACHE ]; then
	echo -n "Cleaning destination before untarring ... "
	rm -r httpd-$VER_APACHE
	echo "done"
fi


echo "Untarring ... "
echo; tar -xvjf httpd-$VER_APACHE.tar.bz2
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

cd httpd-$VER_APACHE


echo "Configuring ... "
echo; ./configure --prefix=/opt/apache-$VER_APACHE  --with-apr=/usr/local/apr/bin/apr-1-config \
   --with-apr-util=/usr/local/apr/bin/apu-1-config \
   --enable-mpms-shared=event \
   --enable-mods-shared=all \
   --enable-nonportable-atomics=yes
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo "Building ... "
echo; make
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo "Installing ... "
echo; sudo make install
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"




sudo chown -R `whoami` /opt/apache-$VER_APACHE
if [ -L /apache ]; then
	echo "Removing existing /apache link ... "
	echo; sudo rm /apache
	ERROR=$(($ERROR|$?))	# logical OR
	break_on_error $ERROR
	echo "done"
fi
echo "Creating & chowning /apache link ..."
echo; echo sudo ln -s /opt/apache-$VER_APACHE /apache
echo; sudo ln -s /opt/apache-$VER_APACHE /apache
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
sudo chown `whoami` --no-dereference /apache
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

if [ ! -e /usr/src/modsecurity ]; then
	sudo mkdir /usr/src/modsecurity
	ERROR=$(($ERROR|$?))	# logical OR
fi
break_on_error $ERROR

sudo chown `whoami` /usr/src/modsecurity
cd /usr/src/modsecurity



echo "Downloading ModSecurity ... "
echo; if [ ! -f modsecurity-$VER_MODSECURITY.tar.gz ]; then
	wget https://www.modsecurity.org/tarball/$VER_MODSECURITY/modsecurity-$VER_MODSECURITY.tar.gz
fi
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo "Downloading checksum ... "
echo; if [ ! -f modsecurity-$VER_MODSECURITY.tar.gz.sha256 ]; then
	wget https://www.modsecurity.org/tarball/$VER_MODSECURITY/modsecurity-$VER_MODSECURITY.tar.gz.sha256
fi
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo -n "Checking checksum ... "
sha256sum --check modsecurity-$VER_MODSECURITY.tar.gz.sha256
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"


if [ -d modsecurity-$VER_MODSECURITY ]; then
	echo -n "Cleaning destination before untarring ... "
	rm -r modsecurity-$VER_MODSECURITY
	echo "done"
fi

echo -n "Untarring ... "
echo; tar -xvzf modsecurity-$VER_MODSECURITY.tar.gz
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

cd modsecurity-$VER_MODSECURITY

echo "Configuring ... "
echo; ./configure --with-apxs=/apache/bin/apxs \
--with-apr=/usr/local/apr/bin/apr-1-config \
--with-pcre=/usr/bin/pcre-config
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo "Building ... "
echo; make
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

echo "Installing ... "
echo; sudo make install
ERROR=$(($ERROR|$?))	# logical OR
break_on_error $ERROR
echo "done"

sudo chown `whoami` /apache/modules/mod_security2.so

