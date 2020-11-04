Our web server is stored in `/apache` on the file system. Its default configuration is located in `/apache/conf/httpd.conf`. It is very extensive and contains many comments and commented out configuration lines. This makes it rather difficult to understand but at least everything is still in a single file. For packaged versions of Apache, on many Linux distributions, the default configuration is not only very complicated, it is also fragmented into a handful of separate files that are spread across multiple directories. This can make it hard to get a good overview of what is actually going on. To simplify things, we will be replacing this extensive configuration file with the following, greatly simplified configuration.

```
read -r -d '' CONFIG << 'EOF'

ServerName              localhost
ServerAdmin             root@localhost
ServerRoot              /apache
User                    www-data
Group                   www-data
PidFile                 logs/httpd.pid

ServerTokens            Prod
UseCanonicalName        On
TraceEnable             Off

Timeout                 10
MaxRequestWorkers       100

Listen                  *:80

LoadModule              mpm_event_module        modules/mod_mpm_event.so
LoadModule              unixd_module            modules/mod_unixd.so

LoadModule              log_config_module       modules/mod_log_config.so

LoadModule              authn_core_module       modules/mod_authn_core.so
LoadModule              authz_core_module       modules/mod_authz_core.so

ErrorLogFormat          "[%{cu}t] [%-m:%-l] %-a %-L %M"
LogFormat               "%h %l %u [%{%Y-%m-%d %H:%M:%S}t.%{usec_frac}t] \"%r\" %>s %b \
\"%{Referer}i\" \"%{User-Agent}i\"" combined

LogLevel                debug
ErrorLog                logs/error.log
CustomLog               logs/access.log combined

DocumentRoot            /apache/htdocs

<Directory />

    Require all denied

    Options SymLinksIfOwnerMatch

</Directory>

<VirtualHost *:80>

      <Directory /apache/htdocs>

        Require all granted

        Options None

      </Directory>

</VirtualHost>

EOF

echo "$CONFIG" > /apache/conf/httpd.conf
```{{execute}}

