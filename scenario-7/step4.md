
From now on, we will need a 2nd terminal open. See the plus symbol above the terminal window. Use the 2nd terminal to start and stop the webserver (-> Hint: (/apache/bin/httpd -X`).

For starters, we will do something easy. It is a request that will trigger exactly one rule by attempting to execute a bash shell. We know that our simple lab server is not vulnerable to such a blatant attack, but ModSecurity does not know this and will still try to protect us:

```
curl localhost/index.html?exec=/bin/bash
```{{execute}}

```
<html><body><h1>It works!</h1></body></html>
```
As predicted, we have not been blocked, but let's check the logs to see if anything happened:

```
tail -1 /apache/logs/access.log
```{{execute}}

```
127.0.0.1 - - [2016-10-25 08:40:01.881647] "GET /index.html?exec=/bin/bash HTTP/1.1" 200 48 "-" …
"curl/7.47.0" localhost 127.0.0.1 40080 - - + "-" WA7@QX8AAQEAABC4maIAAAAV - - 98 234 -% 7672 2569 …
117 479 5 0
```

It looks like a standard `GET` request with a status 200. The interesting bit is the second field from the end. In the log file tutorial, we defined a lengthy Apache access log format with two items reserved for the anomaly score. So far, these values have been empty; now they are being filled. The first of the two numbers at the end is the request's inbound anomaly score. Our submission of `/bin/bash` as parameter got us a score of 5. This is considered a critical rule violation by the Core Rules. An error level violation is set at 4, a warning at 3 and a notice at 2. However, if you look over the rules in all the files, most of them score as critical violations with a score of 5.

But now we want to know what rule triggered the alert. This information can be found in the error log. We could simply tail the error log and look at the last entry but in a real world scenario, this entry might be buried somewhere in the middle of the error log. Therefore we find the request ID in the access log entry and then search for all entries in the error log that are related to that request ID.

```
[2016-10-25 08:40:01.881938] [authz_core:debug] 127.0.0.1:42732 WA7@QX8AAQEAABC4maIAAAAV AH01626: …
authorization result of Require all granted: granted
[2016-10-25 08:40:01.882000] [authz_core:debug] 127.0.0.1:42732 WA7@QX8AAQEAABC4maIAAAAV AH01626: …
authorization result of <RequireAny>: granted
[2016-10-25 08:40:01.884172] [-:error] 127.0.0.1:42732 WA7@QX8AAQEAABC4maIAAAAV [client 127.0.0.1] …
ModSecurity: Warning. Matched phrase "/bin/bash" at ARGS:exec. …
[file "/apache/conf/crs/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf"] [line "448"] [id "932160"] …
[rev "1"] [msg "Remote Command Execution: Unix Shell Code Found"] [data "Matched Data: /bin/bash found …
within ARGS:exec: /bin/bash"] [severity "CRITICAL"] [ver "OWASP_CRS/3.1.0"] [maturity "1"] [accuracy "8"] …
[tag "application-multi"] [tag "language-shell"] [tag "platform-unix"] [tag "attack-rce"] …
[tag "OWASP_CRS/WEB_ATTACK/COMMAND_INJECTION"] [tag "WASCTC/WASC-31"] [tag "OWASP_TOP_10/A1"] …
[tag "PCI/6.5.2"] [hostname "localhost"] [uri "/index.html"] [unique_id "WA7@QX8AAQEAABC4maIAAAAV"]
```

The authorization modules report twice in the log file since we are running on level debug. But on the third line, we see the rule alert we are looking for. Let's look at this in detail. The Core Rule Set messages contain much more information than normal Apache messages, making it worthwhile to discuss the log format once more.

The beginning of the line consists of the Apache-specific parts such as the timestamp and the severity of the message as the Apache server sees it. *ModSecurity* messages are always set to *error* level. ModSecurity's alert format and the Apache error log format we configured lead to some redundancy. The first occurrence client IP address with the source port number and the unique ID of the request are fields written by Apache. The square bracket with the same client IP address again marks the beginning of ModSecurity's alert message. The characteristic marker of a Core Rule Set alert is `ModSecurity: Warning`. It describes a rule being triggered without blocking the request. This is because the alert only raised the anomaly score. It is very easy to distinguish between the issuing of alarms and actual blocking in the Apache error log. Particularly since the individual Core Rules increase the anomaly score, but they do not trigger a blockade. The blockade itself is performed by a separate blocking rule taking the limit into account. But given the insanely high limit, this is not expected to appear anytime soon. ModSecurity logs normal rule violations in the error log as *ModSecurity. Warning ...*, and blockades will be logged as *ModSecurity. Access denied ...*. A *warning* never has any direct impact on the client: Unless you see the *Access denied ...*, the client was unaffected.

What comes next? A reference to the pattern found in the request. The specific phrase `/bin/bash` was found in the argument `exec`. Then comes a series of information chunks that always have the same pattern: They are within square brackets and have their own identifier. First you'll see the *file* identifier. It shows us the file in which the rule that triggered the alarm is defined. This is followed by *line* for the line number within the file. The *id* parameter is an important one. The rule in question, `932160`, can be found in the set of rules that defend against remote command execution in the 932,000 - 932,999 rule block. Then comes *rev* as a reference to the revision number of the rule. In Core Rules, this parameter expresses how often the rule has been revised. If a modification is made to a rule, the developer that makes the change increases the rule's *rev* by one. However, this is not always done in practice and should not be relied upon. *msg*, short for *message*, describes the type of attack detected. The relevant part of the request, the *exec* parameter appears in *data*. In my example, this is obviously a case of *Remote Code Execution* (RCE).

Then we have the *severity* level of the rule that set off the alarm and corresponds with the anomaly score of the rule. We have already established the fact that our rule is considered critical, that's why it is being reported here at this severity. At *ver*, we come to the release of the core rule set, followed by *maturity* and then *accuracy*. Both values are meant to be references to the quality of the rule. But the support is in fact inconsistent and you should not trust these values very much.

What follows is a series of *tags* assigned to the rule. They are included along with every alert message. These tags often classify the type of attack. These references can, for example, be used for analysis and statistics. Towards the end of the alarm comes three additional values, *hostname*, *uri* and *unique_id*, that more clearly specify the request (the *unique_id*, already listed by Apache, is somewhat redundant). 

With this, we have covered the full alert message that led to the inbound anomaly score of 5. That was only a single request with a single alert. Let's generate more alerts. *Nikto* is a simple tool that can help us in this situation. It's a security scanner that has been around for ages. It's not very proficient, but it is fast and easy to use. Just the right tool to generate alerts for us. *Nikto* may still have to be installed. The scanner is, however, included in most distributions.

```
nikto -h localhost
```{{execute}}

```
- Nikto v2.1.5
---------------------------------------------------------------------------
+ Target IP:          127.0.0.1
+ Target Hostname:    localhost
+ Target Port:        80
+ Start Time:         2019-03-21 07:50:40 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache
+ Server leaks inodes via ETags, header found with file /, fields: 0x2d 0x56852b3a6389e 
+ The anti-clickjacking X-Frame-Options header is not present.
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Allowed HTTP Methods: GET, POST, OPTIONS, HEAD 
+ 6544 items checked: 0 error(s) and 3 item(s) reported on remote host
+ End Time:           2019-03-21 07:51:19 (GMT1) (39 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

This scan should have triggered numerous *ModSecurity alarms* on the server. Let’s take a close look at the *Apache error log*. In my case, there were over 13,300 entries in the error log. Combine this with the authorization messages and infos on many 404s (Nikto probes for files that do not exist on the server) and you end up with a fast-growing error log. The single Nikto run resulted in an 11 MB logfile. Looking over the audit log tree reveals 92 MB of logs. It's obvious: you need to keep a close eye on these log files or your server will collapse due to denial of service via log file exhaustion.
