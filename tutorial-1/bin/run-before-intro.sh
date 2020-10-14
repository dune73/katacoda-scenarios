#!/bin/sh

apt-get update

apt-get --assume-yes install bzip2 wget

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-1-intro -o /dev/null 2>/tmp/tmp.log

# chmod +x when copying assets does not work. Doing this by hand.
# File is potentially not yet present. Making sure it is. Cp will retain permissions
touch /usr/local/bin/scenario-status
chmod +x /usr/local/bin/scenario-status
