#!/bin/sh

# --------------------------------------------------------------
# General Init
# --------------------------------------------------------------

# chmod +x when copying assets does not work. Doing this by hand.
chmod +x /usr/local/bin/scenario-status

# create bin folder for custom scripts
mkdir /root/bin

# Move aliases and scripts from where the asset mechanism in index.json placed them
mv /usr/local/etc/.apache-modsec.alias /root
mv /usr/local/etc/basicstats.awk /root/bin
mv /usr/local/etc/modsec-positive-stats.rb /root/bin
mv /usr/local/etc/modsec-rulereport.rb /root/bin
mv /usr/local/etc/percent.awk /root/bin
cat /usr/local/etc/.bashrc_snippet >> /root/.bashrc
cat /usr/local/etc/.bashrc_snippet

echo "Aliases and custom scripts ready" >> /tmp/tmp.log

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

cd /apache/modules
wget https://netnea.com/files/mod_security2.so
mkdir /apache/logs/audit
chown www-data:www-data /apache/logs/audit

echo "Apache downloaded and installed" >> /tmp/tmp.log



# --------------------------------------------------------------
# Scenario Specific Init
# --------------------------------------------------------------

# Get example access log
mv /tmp/tutorial-5-example-access.log.bz2 /apache/logs
bunzip2 /apache/logs/tutorial-5-example-access.log.bz2

echo "Example log ready" >> /tmp/tmp.log

cp /usr/local/etc/httpd.conf /apache/conf/httpd.conf

echo "httpd.conf ready" >> /tmp/tmp.log

apt-get update

echo "apt list updated" >> /tmp/tmp.log

apt-get install --assume-yes build-essential binutils gcc libpcre3-dev libssl-dev zlibc zlib1g-dev ssl-cert ruby gawk uuid libxml2-dev libexpat1-dev libyajl-dev

echo "Packages installed" >> /tmp/tmp.log

cd /

# --------------------------------------------------------------
# Bailout
# --------------------------------------------------------------
echo "Env downloaded and installed" >> /tmp/tmp.log

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-6-intro --silent -o /dev/null 2>&1

