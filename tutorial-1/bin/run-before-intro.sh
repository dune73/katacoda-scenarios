#!/bin/sh

touch /tmp/run-before-into-start

apt-get update

touch /tmp/run-before-intro-x2

apt-get --assume-yes install bzip2

touch /tmp/run-before-intro-x3

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-1-intro -o /dev/null

touch /tmp/run-before-into-done
