#!/bin/sh

# --------------------------------------------------------------
# General Init
# --------------------------------------------------------------

# chmod +x when copying assets does not work. Doing this by hand.
chmod +x /usr/local/bin/scenario-status

# create bin folder for custom scripts
mkdir /root/bin

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

# Move aliases and scripts from where the asset mechanism in index.json placed them
mv /usr/local/etc/.apache-modsec.alias /root
mv /usr/local/etc/basicstats.awk /root/bin
mv /usr/local/etc/httpd.conf /root/bin
mv /usr/local/etc/modsec-positive-stats.rb /root/bin
mv /usr/local/etc/modsec-rulereport.rb /root/bin
mv /usr/local/etc/percent.awk /root/bin

read -r -d '' BASHRC << 'EOF'
# Load apache / modsecurity aliases if file exists
test -e $HOME/.apache-modsec.alias && . $HOME/.apache-modsec.alias

# Add $HOME/bin to PATH
[[ ":$PATH:" != *":$HOME/bin:"* ]] && PATH="$HOME/bin:${PATH}"
EOF
echo "$BASHRC" >> /root/.bashrc

echo "Aliases and custom scripts ready" >> /tmp/tmp.log


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

apt-get install --assume-yes ruby gawk uuid nikto ssl-cert

echo "Packages installed" >> /tmp/tmp.log

cd /

# --------------------------------------------------------------
# Bailout
# --------------------------------------------------------------
echo "Env downloaded and installed" >> /tmp/tmp.log

curl -X HEAD https://netnea.com/ping/katacoda-tutorial-7-intro --silent -o /dev/null 2>&1
