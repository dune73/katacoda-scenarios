#!/bin/sh

apt-get update

apt-get --assume-yes install bzip2 wget jq

# Installed env as prepared in scenario 1
cd /
wget https://netnea.com/files/apache-compiled-2.4.46.tar.bz2
tar xvjf apache-compiled-2.4.46.tar.bz2
ln -s /opt/apache-2.4.46 /apache
#FIXME: sudo chown

echo "Env downloaded and installed" >> /tmp/tmp.log

# chmod +x when copying assets does not work. Doing this by hand.
chmod +x /usr/local/bin/scenario-status


curl -X HEAD https://netnea.com/ping/katacoda-tutorial-2-intro -o /dev/null 2>/tmp/tmp.log

