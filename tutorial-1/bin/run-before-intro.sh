#!/bin/sh

apt-get update

apt-get --assume-yes install bzip2

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-1-intro -o /dev/null 2>/tmp/tmp.log

touch /tmp/xxx

echo "HI" >> /tmp/xxx
