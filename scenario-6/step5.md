We can now commence setting up a base configuration. ModSecurity is a module loaded by Apache. For this reason it is configured in the Apache configuration. Normally, it is proposed to configure ModSecurity in its own file and then to reload it as an <i>include</i>. We will however only be doing this with a part of the rules (in a subsequent tutorial). We will be pasting the base configuration into the Apache configuration to always keep it in view. In doing so, we will be expanding on our base Apache configuration. You can of course also combine this configuration using the <i>SSL setup</i> and the <i>application server setup</i>. For simplicity’s sake we won’t be doing the latter here. But we are embedding the extended log format that we became familiar with in the 5th tutorial. For this we are adding an additional, optional performance log that will help us find speed bottlenecks.

```
read -r -d '' CONFIG << 'EOF'
ServerName        localhost
ServerAdmin       root@localhost
ServerRoot        /apache
User              www-data
Group             www-data
PidFile           logs/httpd.pid

ServerTokens      Prod
UseCanonicalName  On
TraceEnable       Off

Timeout           10
MaxRequestWorkers 100

Listen            *:80
Listen            *:443

LoadModule        mpm_event_module        modules/mod_mpm_event.so
LoadModule        unixd_module            modules/mod_unixd.so

LoadModule        log_config_module       modules/mod_log_config.so
LoadModule        logio_module            modules/mod_logio.so

LoadModule        authn_core_module       modules/mod_authn_core.so
LoadModule        authz_core_module       modules/mod_authz_core.so

LoadModule        ssl_module              modules/mod_ssl.so
LoadModule        headers_module          modules/mod_headers.so

LoadModule        unique_id_module        modules/mod_unique_id.so
LoadModule        security2_module        modules/mod_security2.so

ErrorLogFormat          "[%{cu}t] [%-m:%-l] %-a %-L %M"
LogFormat "%h %{GEOIP_COUNTRY_CODE}e %u [%{%Y-%m-%d %H:%M:%S}t.%{usec_frac}t] \"%r\" %>s %b \
\"%{Referer}i\" \"%{User-Agent}i\" \"%{Content-Type}i\" %{remote}p %v %A %p %R \
%{BALANCER_WORKER_ROUTE}e %X \"%{cookie}n\" %{UNIQUE_ID}e %{SSL_PROTOCOL}x %{SSL_CIPHER}x \
%I %O %{ratio}n%% %D %{ModSecTimeIn}e %{ApplicationTime}e %{ModSecTimeOut}e \
%{ModSecAnomalyScoreInPLs}e %{ModSecAnomalyScoreOutPLs}e \
%{ModSecAnomalyScoreIn}e %{ModSecAnomalyScoreOut}e" extended

LogFormat "[%{%Y-%m-%d %H:%M:%S}t.%{usec_frac}t] %{UNIQUE_ID}e %D \
PerfModSecInbound: %{TX.perf_modsecinbound}M \
PerfAppl: %{TX.perf_application}M \
PerfModSecOutbound: %{TX.perf_modsecoutbound}M \
TS-Phase1: %{TX.ModSecTimestamp1start}M-%{TX.ModSecTimestamp1end}M \
TS-Phase2: %{TX.ModSecTimestamp2start}M-%{TX.ModSecTimestamp2end}M \
TS-Phase3: %{TX.ModSecTimestamp3start}M-%{TX.ModSecTimestamp3end}M \
TS-Phase4: %{TX.ModSecTimestamp4start}M-%{TX.ModSecTimestamp4end}M \
TS-Phase5: %{TX.ModSecTimestamp5start}M-%{TX.ModSecTimestamp5end}M \
Perf-Phase1: %{PERF_PHASE1}M \
Perf-Phase2: %{PERF_PHASE2}M \
Perf-Phase3: %{PERF_PHASE3}M \
Perf-Phase4: %{PERF_PHASE4}M \
Perf-Phase5: %{PERF_PHASE5}M \
Perf-ReadingStorage: %{PERF_SREAD}M \
Perf-WritingStorage: %{PERF_SWRITE}M \
Perf-GarbageCollection: %{PERF_GC}M \
Perf-ModSecLogging: %{PERF_LOGGING}M \
Perf-ModSecCombined: %{PERF_COMBINED}M" perflog

LogLevel                      debug
ErrorLog                      logs/error.log
CustomLog                     logs/access.log extended
CustomLog                     logs/modsec-perf.log perflog env=write_perflog

# == ModSec Base Configuration

SecRuleEngine                 On

SecRequestBodyAccess          On
SecRequestBodyLimit           10000000
SecRequestBodyNoFilesLimit    64000

SecResponseBodyAccess         On
SecResponseBodyLimit          10000000

SecPcreMatchLimit             100000
SecPcreMatchLimitRecursion    100000

SecTmpDir                     /tmp/
SecUploadDir                  /tmp/
SecDataDir                    /tmp/

SecDebugLog                   /apache/logs/modsec_debug.log
SecDebugLogLevel              0

SecAuditEngine                RelevantOnly
SecAuditLogRelevantStatus     "^(?:5|4(?!04))"
SecAuditLogParts              ABEFHIJKZ

SecAuditLogType               Concurrent
SecAuditLog                   /apache/logs/modsec_audit.log
SecAuditLogStorageDir         /apache/logs/audit/

SecDefaultAction              "phase:2,pass,log,tag:'Local Lab Service'"


# == ModSec Rule ID Namespace Definition
# Service-specific before Core Rule Set: 10000 -  49999
# Service-specific after Core Rule Set:  50000 -  79999
# Locally shared rules:                  80000 -  99999
#  - Performance:                        90000 -  90199
# Recommended ModSec Rules (few):       200000 - 200010
# OWASP Core Rule Set:                  900000 - 999999


# === ModSec timestamps at the start of each phase (ids: 90000 - 90009)

SecAction "id:90000,phase:1,nolog,pass,setvar:TX.ModSecTimestamp1start=%{DURATION}"
SecAction "id:90001,phase:2,nolog,pass,setvar:TX.ModSecTimestamp2start=%{DURATION}"
SecAction "id:90002,phase:3,nolog,pass,setvar:TX.ModSecTimestamp3start=%{DURATION}"
SecAction "id:90003,phase:4,nolog,pass,setvar:TX.ModSecTimestamp4start=%{DURATION}"
SecAction "id:90004,phase:5,nolog,pass,setvar:TX.ModSecTimestamp5start=%{DURATION}"
                      
# SecRule REQUEST_FILENAME "@beginsWith /" \
#       "id:90005,phase:5,t:none,nolog,noauditlog,pass,setenv:write_perflog"



# === ModSec Recommended Rules (in modsec src package) (ids: 200000-200010)

SecRule REQUEST_HEADERS:Content-Type "(?:application(?:/soap\+|/)|text/)xml" \
  "id:200000,phase:1,t:none,t:lowercase,pass,nolog,ctl:requestBodyProcessor=XML"

SecRule REQUEST_HEADERS:Content-Type "application/json" \
  "id:200001,phase:1,t:none,t:lowercase,pass,nolog,ctl:requestBodyProcessor=JSON"

SecRule REQBODY_ERROR "!@eq 0" \
  "id:200002,phase:2,t:none,deny,status:400,log,\
  msg:'Failed to parse request body.',logdata:'%{reqbody_error_msg}',severity:2"

SecRule MULTIPART_STRICT_ERROR "!@eq 0" \
  "id:200003,phase:2,t:none,deny,status:403,log, \
  msg:'Multipart request body failed strict validation: \
  PE %{REQBODY_PROCESSOR_ERROR}, \
  BQ %{MULTIPART_BOUNDARY_QUOTED}, \
  BW %{MULTIPART_BOUNDARY_WHITESPACE}, \
  DB %{MULTIPART_DATA_BEFORE}, \
  DA %{MULTIPART_DATA_AFTER}, \
  HF %{MULTIPART_HEADER_FOLDING}, \
  LF %{MULTIPART_LF_LINE}, \
  SM %{MULTIPART_MISSING_SEMICOLON}, \
  IQ %{MULTIPART_INVALID_QUOTING}, \
  IP %{MULTIPART_INVALID_PART}, \
  IH %{MULTIPART_INVALID_HEADER_FOLDING}, \
  FL %{MULTIPART_FILE_LIMIT_EXCEEDED}'"

SecRule TX:/^MSC_/ "!@streq 0" \
  "id:200005,phase:2,t:none,deny,status:500,\
  msg:'ModSecurity internal error flagged: %{MATCHED_VAR_NAME}'"


# === ModSecurity Rules 
#
# ...
                

# === ModSec timestamps at the end of each phase (ids: 90010 - 90019)

SecAction "id:90010,phase:1,pass,nolog,setvar:TX.ModSecTimestamp1end=%{DURATION}"
SecAction "id:90011,phase:2,pass,nolog,setvar:TX.ModSecTimestamp2end=%{DURATION}"
SecAction "id:90012,phase:3,pass,nolog,setvar:TX.ModSecTimestamp3end=%{DURATION}"
SecAction "id:90013,phase:4,pass,nolog,setvar:TX.ModSecTimestamp4end=%{DURATION}"
SecAction "id:90014,phase:5,pass,nolog,setvar:TX.ModSecTimestamp5end=%{DURATION}"


# === ModSec performance calculations and variable export (ids: 90100 - 90199)

SecAction "id:90100,phase:5,pass,nolog,\
  setvar:TX.perf_modsecinbound=%{PERF_PHASE1},\
  setvar:TX.perf_modsecinbound=+%{PERF_PHASE2},\
  setvar:TX.perf_application=%{TX.ModSecTimestamp3start},\
  setvar:TX.perf_application=-%{TX.ModSecTimestamp2end},\
  setvar:TX.perf_modsecoutbound=%{PERF_PHASE3},\
  setvar:TX.perf_modsecoutbound=+%{PERF_PHASE4},\
  setenv:ModSecTimeIn=%{TX.perf_modsecinbound},\
  setenv:ApplicationTime=%{TX.perf_application},\
  setenv:ModSecTimeOut=%{TX.perf_modsecoutbound},\
  setenv:ModSecAnomalyScoreInPLs=%{tx.anomaly_score_pl1}-%{tx.anomaly_score_pl2}-%{tx.anomaly_score_pl3}-%{tx.anomaly_score_pl4},\
  setenv:ModSecAnomalyScoreOutPLs=%{tx.outbound_anomaly_score_pl1}-%{tx.outbound_anomaly_score_pl2}-%{tx.outbound_anomaly_score_pl3}-%{tx.outbound_anomaly_score_pl4},\
  setenv:ModSecAnomalyScoreIn=%{TX.anomaly_score},\
  setenv:ModSecAnomalyScoreOut=%{TX.outbound_anomaly_score}"


SSLCertificateKeyFile   /etc/ssl/private/ssl-cert-snakeoil.key
SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem

SSLProtocol             All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite          'kEECDH+ECDSA kEECDH kEDH HIGH +SHA !aNULL !eNULL !LOW !MEDIUM !MD5 \
!EXP !DSS !PSK !SRP !kECDH !CAMELLIA !RC4'
SSLHonorCipherOrder     On

SSLRandomSeed           startup file:/dev/urandom 2048
SSLRandomSeed           connect builtin

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

<VirtualHost *:443>
    
      SSLEngine On
      Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains" env=HTTPS

      <Directory /apache/htdocs>

              Require all granted

              Options None

      </Directory>

</VirtualHost>
echo "$CONFIG" > /apache/conf/httpd.conf
```{{execute}}

What has been added are the *mod_security2.so* and *mod_unique_id.so* modules and the additional performance log. At first we define the _LogFormat_ and then a few lines below the _logs/modsec-perf.log_ file. A condition is added to the end of this line: Only when the *write_perflog* environment variable is set will this log file actually be written. We can thus decide whether we need performance data or not for each request. This saves resources and gives us the option of working with pinpoint precision: We can thus include only specific paths in the log or concentrate on individual client IP addresses.

The ModSecurity base configuration begins on the next line: We define the base settings of the module in this part. Then in a separate part come individual security rules, most of which are a bit complicated. Let’s go through this configuration step-by-step: _SecRuleEngine_ is what enables ModSecurity in the first place. We then enable access to the request body and set two limits: By default only the header lines of the request are examined. This is like looking only at the envelope of a letter. Inspecting the body and thus the content of the request of course involves more work and takes more time, but a large number of attacks are not detectable from outside, which is why we are enabling this. We then limit the size of the request body to 10 MB. This includes file uploads. For requests with body, but without file upload, such as an online form, we then specify 64 KB as the limit. In detail, *SecRequestBodyNoFilesLimit* is responsible for *Content-Type application/x-www-form-urlencoded*, while *SecRequestBodyLimit* takes care of *Content-Type: multipart/form-data*.

On the response side we enable body access and in turn define a limit of 10 MB. No differentiation is made here in the transfer of forms or files; all of them are files.

Now comes the memory reserved for the _PCRE library_. ModSecurity documentation suggests a value of 1000 matches. But this quickly leads to problems in practice. Our base configuration with a limit of 100000 is much more robust. If problems still occur, values above 100000 are also manageable; memory requirements grow only marginally.

ModSecurity requires three directories for data storage. We put all of them in the _tmp directory_. For productive operation this is of course the wrong place, but for the first baby steps it’s fine and it is not easy to give general recommendations for the right choice of this directory, because the local environment plays a big role.  For the aforementioned directories this concerns temporary data, a storage for file uploads that raised suspicion and finally about session data that should be retained after a server restart, 

ModSecurity has a very detailed _debug log_. The configurable log level ranges from 0 to 9. We leave it at 0 and are prepared to be able to increase it when problems occur in order to see exactly how the module is working. In addition to the actual _rule engine_, an _audit engine_ also runs within ModSecurity. It organizes the logging of requests. Because in case of attack we would like to get as much information as possible. With _SecAuditEngine RelevantOnly_ we define that only _relevant_ requests should be logged. What’s relevant to us is what we define on the next line via a regular expression: All requests whose HTTP status begins with 4 or 5, but not 404. At a later point in time we will see that other things can be defined as relevant, but this rough classification is good enough for the start. It then continues with a definition of the parts of this request that should be logged. We are already familiar with the request header (part B), the request body (part I), the response header (part F) and the response body (part E). Then comes additional information from ModSecurity (parts A, H, K, Z) and details about uploaded files, which we do not map completely (part J). A detailed explanation of these audit log parts are available in the ModSecurity reference manual.

Depending on request, a large volume of data is written to the audit log. There are often several hundred lines for each request. On a server under a heavy load with many simultaneous requests this can cause problems writing the file. This is why the _Concurrent Log Format_ was introduced. It keeps a central audit log including the most important information. The detailed information in the parts just described are stored in in individual files. These files are placed in the directory tree defined using the _SecAuditLogStorageDir_ directive. Every day, ModSecurity creates a directory in this tree and another directory for each minute of the day (however, only if a request was actually logged within this minute). In them are the individual requests with file names labeled by date, time and the unique ID of the request.

Here is an example from the central audit log:

```
localhost 127.0.0.1 - - [17/Oct/2015:15:54:54 +0200] "POST /index.html HTTP/1.1" 200 45 "-" "-" \
UYkHrn8AAQEAAHb-AM0AAAAB "-" /20130507/20130507-1554/20130507-155454-UYkHrn8AAQEAAHb-AM0AAAAB \
0 20343 md5:a395b35a53c836f14514b3fff7e45308
```

We see some information about the request, the HTTP status code and shortly afterward the _unique ID_ of the request, which we also find in our access log. An absolute path follows a bit later. But it only appears to be absolute. Specifically, we have to add this part of the path to the value in _SecAuditLogStorageDir_. For us this means _/apache/logs/audit/20130507/20130507-1554/20130507-155454-UYkHrn8AAQEAAHb-AM0AAAAB_. We can then find the details about the request in this file.

```
--5a70c866-A--
[17/Oct/2013:15:54:54 +0200] UYkHrn8AAQEAAHb-AM0AAAAB 127.0.0.1 42406 127.0.0.1 80
--5a70c866-B--
POST /index.html HTTP/1.1
User-Agent: curl/7.35.0 (x86_64-pc-linux-gnu) libcurl/7.35.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 …  
Accept: */*
Host: 127.0.0.1
Content-Length: 3
Content-Type: application/x-www-form-urlencoded

...

```

The parts described divide the file into sections. What follows is part _--5a70c866-A--_ as part A, then _--5a70c866-B--_ as part B, etc. We will be having a look at this log in detail in a subsequent tutorial. This introduction should suffice for the moment. But what is not sufficient is our file system. Because, in order to write the _audit log_ at all, the directory must first be created and the appropriate permissions assigned:

```
sudo mkdir /apache/logs/audit
sudo chown www-data:www-data /apache/logs/audit
```{{execute}}

This brings us to the _SecDefaultAction_ directive. It denotes the basic setting of a security rule. Although we can define this value for each rule, it is normal to work with one default value which is then inherited by all of the rules. ModSecurity is aware of five phases. Phase 1 listed here starts once the request headers have arrived on the server. The other phases are the _request body phase (phase 2)_. We take this as the default phase for a rule. This phase is followed by the _response header phase (phase 3)_, _response body phase (phase 4)_ and the _logging phase (phase 5)_. We then say that when a rule takes effect we would normally like the request to pass. We will be defining blocking measures separately. We would like to log; meaning that we would like to see a message about the triggered rule in the Apache server's _error log_ and ultimately assign each of these log entries a *tag*. The tag set, _Local Lab Service_, is only one example of the strings, even several of them, that can be set. In a larger company it can for example be useful for adding additional information about a service (contract number, customer contact details, references to documentation, etc.). This information is then included along with every log entry. This may first sound like a waste of resources, but one employee on an operational security team may be responsible for several hundred services and the URL alone is not enough at this time for unknown services. These service metadata, added by using tags, enable a quick and appropriate reaction to attacks.

This brings us to the ModSecurity rules. Although the module works with the limits defined above, the actual functionality lies mainly in the individual rules that can be expressed in their own rule language. But before we have a look at the individual rules, a comment section with definitions of the namespace of the rule ID numbers follows in the Apache configuration. Each ModSecurity rule has a number for identification. In order to keep the rules manageable, it is useful to cleanly divide up the namespace.

The OWASP ModSecurity Core Rule Set project provides a basic set of over 200 ModSecurity rules. We will be embedding these rules in the next tutorial. They have IDs beginning with the number 900,000 and range up to 999,999. For this reason, we shouldn't set up any rules in this range. The ModSecurity sample configuration provides a few rules in the range starting at 200,000. Our own rules are best organized in the big spaces in between. I suggest keeping in the range below 100,000.

If ModSecurity is being used for multiple services, eventually some shared rules will be used. These are self-written rules configured for each of their own instances. We put these in the 80,000 to 99,999 range. For the other service-specific rules it often plays a role as to whether they are defined before or after the core rules. For logical reasons, we therefore divide the remaining space into two sections: 10,000 to 49,999 for service-specific rules before the core rules and 50,000 to 79,999 after the core rules. Although we won’t yet be embedding the core rules in this tutorial, we will be preparing for them. It bears mentioning that the rule ID has nothing to do with the order of the execution of the rules.

This brings us to the first rules. We start off with a block of performance data. There are not yet any security-related rules, but the definition of information for the path of the request within ModSecurity. We use the _SecAction_ directive. A _SecAction_ is always performed without condition. A comma separated list with instructions follows as parameters. We initially define the rule ID, then the phase in which the rule is to run (1 to 5). We do no wish to have an entry in the server’s error log (_nolog_). Furthermore, we let the request _pass_ and set multiple internal variables: We define a timestamp for each ModSecurity phase. As it were, an intermediate time within the request when starting each individual phase. This is done by using the clock running in the form of the _Duration_ variables which begin ticking in microseconds at the start of the request.

The rule with ID 90005 is commented out. We can enable it in order to set the Apache *write_perflog* environment variable. Once we do that the performance log defined in the Apache section will be written. This rule is no longer defined as _SecAction_, but as _SecRule_. A preceding condition is added to the rule instruction here. In our case we inspect *REQUEST_FILENAME* with respect to the beginning of the string. If the string begins with _/_, then the subsequent instructions including setting the environment variables should be performed. Of course, the path component of every request URI begins with the _/_ character. But if we only want to enable the log for specific paths (e.g. _/login_), we are then prepared for this and only need to modify the path.

So much for this performance part. Now come the rules proposed by the *ModSecurity* project in the sample configuration file. They have rule IDs starting at 200,000 and are not very numerous. The first rule inspects the _request headers Content-Type_. The rule applies when these headers match the text _text/xml_. It is evaluated in phase 1. After the phase comes the _t:none_ instruction. This means _transformation: none_. We do not want to transform the parameters of the request prior to processing this rule. Following _t:none_ a transformation with the self-explanatory name _t:lowercase_ is applied to the text. Using _t:none_ we delete all predefined default transformations if need be and then execute _t:lowercase_. This means that we will be touching _text/xml_, _Text/Xml_, _TEXT/XML_ and all other combinations in the _Content-Type_ header. If this rule applies, then we perform a _control action_ at the very end of the line: We choose _XML_ as the processor of the _request body_. There is one detail still to be explained: The preceding commented out rule introduced the operator _@beginsWith_. By contrast, no operator is designated here. _Default-Operator @rx_ is applied. This is an operator for regular expressions (_regex_). As expected, _beginsWith_ is a very fast operator while working with regular expressions is cumbersome and slow.

The next rule is an almost exact copy of this rule. It uses the same mechanism to apply the JSON request body processor to the request body. This allows us access to the individual parameters inside the post payload.

By contrast, the next rule is a bit more complicated. We are inspecting the internal *REQBODY_ERROR* variable. In the condition part we use the numerical comparison operator _@eq_. The exclamation mark in front negates its value. The syntax thus means if the *REQBODY_ERROR* is not equal to zero. Of course, we could also work with a regular expression here, but the _@eq_ operator is more efficient when being processed by the module. In the action part of the rule _deny_ is applied for the first time. The request should thus be blocked if processing the request body resulted in an error. Specifically, we return HTTP status code _400 Bad Request_ (_status:400_). We would like to log first and specify the message. As additional information we also write to a separate log field called _logdata_ the exact description of the error. This information will appear in both the server’s error log as well as in the audit log. Finally, the _severity_ is assigned to the rule. This is the degree of importance for the rule, which can be used in evaluating very many rule violations.

The rule with the ID 200003 also deals with errors in the request body. This concerns _multipart HTTP bodies_. It applies if files are to be transferred to the server via HTTP requests. This is very useful on the one hand, but poses a big security problem on the other. This is why ModSecurity very precisely inspects _multipart HTTP bodies_. It has an internal variable called *MULTIPART_STRICT_ERROR*, which combines the numerous checks. If there is a value other than 0 here, then we block the request using status code 403 (_forbidden_). In the log message we then report the results of the individual checks. In practice you have to know that in very rare cases this rule may also be applied to legitimate requests. If this is the case, it may have to be modified or disabled as a _false positive_. We will be returning to the elimination of false positives further below and will become familiar with the topic in detail in a subsequent tutorial.

The ModSecurity distribution sample configuration has another rule with ID 200004. However, I have not included it in the tutorial, because in practice it blocks too many legitimate requests (_false positives_). The *MULTIPART_UNMATCHED_BOUNDARY* variable is checked. This value, which signifies an error in the boundary of multipart bodies, is prone to error and frequently reports text snippets which do not indicate boundaries. In my opinion, it has not shown itself to be useful in practice.

With 200005 comes another rule which intercepts internal processing errors. Unlike the preceding internal variables, here we are looking for a group of variables dynamically provided along with the current request. A data sheet called _TX_ (transaction) is opened for each request. In ModSecurity jargon we refer to a _collection_ of variables and values. While processing a request ModSecurity now in some circumstances sets additional values in the _TX collection_, in addition to the variables already inspected. The names of these variables begin with the prefix *MSC_*. We now access in parallel all variables of this pattern in the collection. This is done via the *TX:/^MSC_/* construct. Thus, the transaction collection and then variable names matching the regular expression *^MSC_*: A word beginning with *MSC_*. If one of these found variables is not equal to zero, we then block the request using HTTP status 500 (_internal server error_) and write the variable names in the log file.

We have now looked at a few rules and have become familiar with the principle functioning of the ModSecurity _WAF_. The rule language is demanding, but very systematic. The structure is unavoidably oriented to the structure of Apache directives. Because before ModSecurity is able to process the directives, they are read by Apache's configuration parser. This is also accompanied by complexity in the way they are expressed. *ModSecurity* is currently being developed in a direction making the module independent from Apache. We will hopefully be benefitting from a configuration that is easier to read.

Now comes a comment in the configuration file which marks the spot for additional rules to be entered. Following this block, which in some circumstances can become very large, come yet more rules that provide performance data for the performance log defined above. The block containing rule IDs 90010 to 90014 stores the time of the end of the individual ModSecurity phases. This corresponds to the 90000 - 90004 block of IDs we became familiar with above. Calculations with the performance data collected are then performed in the last ModSecurity block. For us this means that we totaling up the time that phase 1 and phase 2 need in the *perf_modsecinbound* variable. In the rule with ID 90100 this variable is first set to the performance of phase 1. Then, the performance of phase 2 is added to it. We have to calculate the variable *perf_application* from the timestamps. To do this, we subtract the end of phase 2 from the start of phase 3 in the subsequent `setvar` actions of the same rule. This is of course not an exact calculation of the time that the application itself needs on the server, because other Apache modules play a role (such as authentication), but the value is an indication that sheds light on whether ModSecurity is actually limiting performance or whether the problem more likely lies with the application. The final variable calculations in the rule work on phases 3 and 4, similar to phases 1 and 2. This gives us three relevant values which simply summarize performance: *perf_modsecinbound*, *perf_application* and *perf_modsecoutbound*. They appear in a separate performance log. We have, however, provided enough space for these three values in the normal access log. There we have _ModSecTimeIn_, _ApplicationTime_ and _ModSecTimeOut_. The following `setenv` actions, still in the same rule, are used to export our _perf_ values to the corresponding environment variables in order for them to appear in the _access log_. And finally, we export the _OWASP ModSecurity Core Rule Set_ anomaly values. These values are not yet written, but because we will be making these rules available in the next tutorial, we can already prepare for variable export here.

We are now at the point that we can understand the performance log. The definition above is accompanied by the following parts:

```
LogFormat "[%{%Y-%m-%d %H:%M:%S}t.%{usec_frac}t] %{UNIQUE_ID}e %D \
PerfModSecInbound: %{TX.perf_modsecinbound}M \
PerfAppl: %{TX.perf_application}M \
PerfModSecOutbound: %{TX.perf_modsecoutbound}M \
TS-Phase1: %{TX.ModSecTimestamp1start}M-%{TX.ModSecTimestamp1end}M \
TS-Phase2: %{TX.ModSecTimestamp2start}M-%{TX.ModSecTimestamp2end}M \
TS-Phase3: %{TX.ModSecTimestamp3start}M-%{TX.ModSecTimestamp3end}M \
TS-Phase4: %{TX.ModSecTimestamp4start}M-%{TX.ModSecTimestamp4end}M \
TS-Phase5: %{TX.ModSecTimestamp5start}M-%{TX.ModSecTimestamp5end}M \
Perf-Phase1: %{PERF_PHASE1}M \
Perf-Phase2: %{PERF_PHASE2}M \
Perf-Phase3: %{PERF_PHASE3}M \
Perf-Phase4: %{PERF_PHASE4}M \
Perf-Phase5: %{PERF_PHASE5}M \
Perf-ReadingStorage: %{PERF_SREAD}M \
Perf-ReadingStorage: %{PERF_SWRITE}M \
Perf-GarbageCollection: %{PERF_GC}M \
Perf-ModSecLogging: %{PERF_LOGGING}M \
Perf-ModSecCombined: %{PERF_COMBINED}M" perflog
```

   * %{%Y-%m-%d %H:%M:%S}t.%{usec_frac}t means, as in our normal log, the timestamp the request was received with a precision of microseconds.
   * %{UNIQUE_ID}e : The unique ID of the request
   * %D : The total duration of the request from receiving the request line to the end of the complete request in microseconds.
   * PerfModSecInbound: %{TX.perf_modsecinbound}M : Summary of the time needed by ModSecurity for an inbound request.
   * PerfAppl: %{TX.perf_application}M : Summary of the time used by the application
   * PerfModSecOutbound: %{TX.perf_modsecoutbound}M :  Summary of the time needed in ModSecurity to process the response
   * TS-Phase1: %{TX.ModSecTimestamp1start}M-%{TX.ModSecTimestamp1end}M : The timestamps for the start and end of phase 1 (after receiving the request headers)
   * TS-Phase2: %{TX.ModSecTimestamp2start}M-%{TX.ModSecTimestamp2end}M : The timestamps for the start and end of phase 2 (after receiving the request body)
   * TS-Phase3: %{TX.ModSecTimestamp3start}M-%{TX.ModSecTimestamp3end}M : The timestamps for the start and end of phase 3 (after receiving the response headers) 
   * TS-Phase4: %{TX.ModSecTimestamp4start}M-%{TX.ModSecTimestamp4end}M : The timestamps for the start and end of phase 4 (after receiving the response body)
   * TS-Phase5: %{TX.ModSecTimestamp5start}M-%{TX.ModSecTimestamp5end}M : The timestamps for the start and end of phase 5 (logging phase) 
   * Perf-Phase1: %{PERF_PHASE1}M : Calculation of the performance of the rules in phase 1 performed by ModSecurity
   * Perf-Phase2: %{PERF_PHASE2}M : Calculation of the performance of the rules in phase 2 performed by ModSecurity
   * Perf-Phase3: %{PERF_PHASE3}M : Calculation of the performance of the rules in phase 3 performed by ModSecurity
   * Perf-Phase4: %{PERF_PHASE4}M : Calculation of the performance of the rules in phase 4 performed by ModSecurity
   * Perf-Phase5: %{PERF_PHASE5}M : Calculation of the performance of the rules in phase 5 performed by ModSecurity
   * Perf-ReadingStorage: %{PERF_SREAD}M : The time required to read the ModSecurity session storage
   * Perf-WritingStorage: %{PERF_SWRITE}M : The time required to write the ModSecurity session storage
   * Perf-GarbageCollection: s%{PERF_GC}M \ The time required for garbage collection
   * Perf-ModSecLogging: %{PERF_LOGGING}M : The time used by ModSecurity for logging, specifically the error log and the audit log
   * Perf-ModSecCombined: %{PERF_COMBINED}M : The time ModSecurity requires in total for all work

This long list of numbers can be used to very well narrow down ModSecurity performance problems and rectify them if necessary. When you need to look even deeper, the _debug log_ can help, or make use of the *PERF_RULES* variable collection, which is well explained in the reference manual.
