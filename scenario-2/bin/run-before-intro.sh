#!/bin/sh

# --------------------------------------------------------------
# General Init
# --------------------------------------------------------------

# chmod +x when copying assets does not work. Doing this by hand.
chmod +x /usr/local/bin/scenario-status

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

# --------------------------------------------------------------
# Scenario Specific Init
# --------------------------------------------------------------

# Nothing to do here

# --------------------------------------------------------------
# Bailout
# --------------------------------------------------------------
echo "Env downloaded and installed" >> /tmp/tmp.log

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-2-intro --silent -o /dev/null 2>&1

