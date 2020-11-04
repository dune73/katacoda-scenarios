#!/bin/sh

# chmod +x when copying assets does not work. Doing this by hand.
chmod +x /usr/local/bin/scenario-status

apt-get update

# Most of these packages are installed, but sometimes, they are not
apt-get --assume-yes install bzip2 wget jq sudo

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-1-intro -o /dev/null 2>/tmp/tmp.log

