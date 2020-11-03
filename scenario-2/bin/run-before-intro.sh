#!/bin/sh

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-2-intro -o /dev/null 2>/tmp/tmp.log

# Installed env as prepared in scenario 1
cd /opt
pwd >> /tmp/tmp.log
echo "Downloading now" >> /tmp/tmp.log
wget https://netnea.com/files/apache-compiled-2.4.46.tar.bz2 2>>/tmp/tmp.log
echo $? >> /tmp/tmp.log
echo "Downloaded" >> /tmp/tmp.log
tar xvjf https://netnea.com/files/apache-compiled-2.4.46.tar.bz2 2>>/tmp/tmp.log
ln -s /opt/apache-2.4.46 /apache
#FIXME: sudo chown

# chmod +x when copying assets does not work. Doing this by hand.
chmod +x /usr/local/bin/scenario-status

apt-get update

apt-get --assume-yes install bzip2 wget jq


