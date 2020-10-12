#!/bin/sh

apt-get update

apt-get --assume-yes install bzip2 wget

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-1-intro -o /dev/null 2>/tmp/tmp.log

# chmod +x when copying assets does not work. Doing this by hand.
# the asset has not been copied when this script here runs. We
# prepare a chmodded file and the +x will persist then the asset 
# is copied
chmod +x /usr/local/bin/scenario-status
