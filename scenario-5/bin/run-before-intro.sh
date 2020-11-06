#!/bin/sh

# chmod +x when copying assets does not work. Doing this by hand.
chmod +x /usr/local/bin/scenario-status


#apt-get update

# Most of these packages are installed, but sometimes, they are not
#apt-get --assume-yes install bzip2 wget jq sudo

# Get env as prepared in scenario 1
cd /
wget https://netnea.com/files/apache-compiled-2.4.46.tar.bz2
tar xvjf apache-compiled-2.4.46.tar.bz2
ln -s /opt/apache-2.4.46 /apache
chown root:root /usr
chown root:root /usr/local
chown -R root:root /usr/local/apr
chown -R root:root /opt
chown root:root /apache
#FIXME: sudo chown

mv /tmp/tutorial-5-example-access.log.bz2 /apache/logs
bunzip2 /apache/logs/tutorial-5-example-access.log.bz2

echo "Env downloaded and installed" >> /tmp/tmp.log

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-5-intro --silent -o /dev/null 2>&1

