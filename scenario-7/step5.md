So we are looking at 13,000 alerts. And even if the format of the entries in the error log may be clear, without a tool they are very hard to read, let alone analyze. A simple remedy is to use a few *shell aliases*, which extract individual pieces of information from the entries. They are stored in the alias file we discussed in the log format in Tutorial 5.

```
cat ~/.apache-modsec.alias
```{{execute}}

```
...
alias meldata='grep -o "\[data [^]]*" | cut -d\" -f2'
alias melfile='grep -o "\[file [^]]*" | cut -d\" -f2'
alias melhostname='grep -o "\[hostname [^]]*" | cut -d\" -f2'
alias melid='grep -o "\[id [^]]*" | cut -d\" -f2'
alias melip='grep -o "\[client [^]]*" | cut -b9-'
alias melidmsg='sed -e "s/.*\[id \"//" -e "s/\([0-9]*\).*\[msg \"/\1 /" -e "s/\"\].*//" -e "s/(Total .*/(Total ...) .../" -e "s/Incoming and Outgoing Score: [0-9]* [0-9]*/Incoming and Outgoing Score: .../"
alias melline='grep -o "\[line [^]]*" | cut -d\" -f2'
alias melmatch='grep -o " at [^\ ]*\. \[file" | sed -e "s/\. \[file//" | cut -b5-'
alias melmsg='grep -o "\[msg [^]]*" | cut -d\" -f2'
alias meltimestamp='cut -b2-25'
alias melunique_id='grep -o "\[unique_id [^]]*" | cut -d\" -f2'
alias meluri='grep -o "\[uri [^]]*" | cut -d\" -f2'
...
```

These abbreviations all start with the prefix *mel*, short for *ModSecurity error log*, followed by the field name. Let’s try it out to output the rule IDs from the messages:

```
cat logs/error.log | melid | tail
```{{execute}}

```
920440
913100
913100
913100
913100
913100
913100
913100
913100
920440
```

This seems to do the job. So let’s extend the example a few steps:

```
cat logs/error.log | melid | sort | uniq -c | sort -n
```{{execute}}
```
      1 920220
      1 932115
      2 920280
      2 941140
      3 942270
      4 933150
      5 942100
      6 932110
      7 911100
      8 932105
     13 932100
     15 941170
     15 941210
     17 920170
     29 930130
     35 932150
     67 933130
     70 933160
    111 932160
    113 941180
    114 920270
    140 931110
    166 930120
    172 930100
    224 920440
    245 941110
    247 941100
    247 941160
    448 930110
   2262 931120
   2328 913120
   6168 913100
```

```
cat logs/error.log | melid | sort | uniq -c | sort -n | while read STR; do echo -n "$STR "; \
ID=$(echo "$STR" | sed -e "s/.*\ //"); grep $ID logs/error.log | head -1 | melmsg; done
```{{execute}}

```
1 920220 URL Encoding Abuse Attack Attempt
1 932115 Remote Command Execution: Windows Command Injection
2 920280 Request Missing a Host Header
2 941140 XSS Filter - Category 4: Javascript URI Vector
3 942270 Looking for basic sql injection. Common attack string for mysql, oracle and others.
4 933150 PHP Injection Attack: High-Risk PHP Function Name Found
5 942100 SQL Injection Attack Detected via libinjection
6 932110 Remote Command Execution: Windows Command Injection
7 911100 Method is not allowed by policy
8 932105 Remote Command Execution: Unix Command Injection
13 932100 Remote Command Execution: Unix Command Injection
15 941170 NoScript XSS InjectionChecker: Attribute Injection
15 941210 IE XSS Filters - Attack Detected.
17 920170 GET or HEAD Request with Body Content.
29 930130 Restricted File Access Attempt
35 932150 Remote Command Execution: Direct Unix Command Execution
67 933130 PHP Injection Attack: Variables Found
70 933160 PHP Injection Attack: High-Risk PHP Function Call Found
111 932160 Remote Command Execution: Unix Shell Code Found
113 941180 Node-Validator Blacklist Keywords
114 920270 Invalid character in request (null character)
140 931110 Possible Remote File Inclusion (RFI) Attack: Common RFI Vulnerable Parameter Name …
166 930120 OS File Access Attempt
172 930100 Path Traversal Attack (/../)
224 920440 URL file extension is restricted by policy
245 941110 XSS Filter - Category 1: Script Tag Vector
247 941100 XSS Attack Detected via libinjection
247 941160 NoScript XSS InjectionChecker: HTML Injection
448 930110 Path Traversal Attack (/../)
2262 931120 Possible Remote File Inclusion (RFI) Attack: URL Payload Used w/Trailing Question …
2328 913120 Found request filename/argument associated with security scanner
6168 913100 Found User-Agent associated with security scanner
```

This, we can work with. But it’s perhaps necessary to explain the *one-liners*. We extract the rule IDs from the *error log*, then *sort* them, sum them together in a list of found IDs (*uniq -c*) and sort again by the numbers found. That’s the first *one-liner*. A relationship between the individual rules is still lacking, because there’s not much we can do with the ID number yet. We get the names from the *error log* again by looking through the previously run test line-by-line in a loop. We out the ID that we have into this loop (`$STR`). Then we have to separate the number of found items and the IDs again. This is done using an embedded sub-command (`ID=$(echo "$STR" | sed -e "s/.*\ //")`). We then use the IDs we just found to search the *error log* once more for an entry, but take only the first one, extract the *msg* part and display it. Done.

You might now think that it would be better to define an additional alias to determine the ID and description of the rule in a single step. This puts us on the wrong path, though, because there are rules that contain dynamic parts in and following the brackets (anomaly scores in the rules checking the threshold with rule ID 949110 and 980130!). We, of course, want to combine these rules, putting them together in order to map the rule only once. So, to really simplify analysis, we have to get rid of the dynamic items. Here’s an additional *alias*, that is also part of the *.apache-modsec.alias* file, that implements this idea: 

```
alias melidmsg='sed -e "s/.*\[id \"//" -e "s/\([0-9]*\).*\[msg \"/\1 /" -e "s/\"\].*//" \
-e "s/(Total .*/(Total ...) .../" \
-e "s/Incoming and Outgoing Score: [0-9]* [0-9]*/Incoming and Outgoing Score: .../"'
```

```
cat logs/error.log | melidmsg | sucs
```{{execute}}

```
      1 920220 URL Encoding Abuse Attack Attempt
      1 932115 Remote Command Execution: Windows Command Injection
      2 920280 Request Missing a Host Header
      2 941140 XSS Filter - Category 4: Javascript URI Vector
      3 942270 Looking for basic sql injection. Common attack string for mysql, oracle and others.
      4 933150 PHP Injection Attack: High-Risk PHP Function Name Found
      5 942100 SQL Injection Attack Detected via libinjection
      6 932110 Remote Command Execution: Windows Command Injection
      7 911100 Method is not allowed by policy
      8 932105 Remote Command Execution: Unix Command Injection
     13 932100 Remote Command Execution: Unix Command Injection
     15 941170 NoScript XSS InjectionChecker: Attribute Injection
     15 941210 IE XSS Filters - Attack Detected.
     17 920170 GET or HEAD Request with Body Content.
     29 930130 Restricted File Access Attempt
     35 932150 Remote Command Execution: Direct Unix Command Execution
     67 933130 PHP Injection Attack: Variables Found
     70 933160 PHP Injection Attack: High-Risk PHP Function Call Found
    111 932160 Remote Command Execution: Unix Shell Code Found
    113 941180 Node-Validator Blacklist Keywords
    114 920270 Invalid character in request (null character)
    140 931110 Possible Remote File Inclusion (RFI) Attack: Common RFI Vulnerable Parameter Name used w/URL Payload
    166 930120 OS File Access Attempt
    172 930100 Path Traversal Attack (/../)
    224 920440 URL file extension is restricted by policy
    245 941110 XSS Filter - Category 1: Script Tag Vector
    247 941100 XSS Attack Detected via libinjection
    247 941160 NoScript XSS InjectionChecker: HTML Injection
    448 930110 Path Traversal Attack (/../)
   2262 931120 Possible Remote File Inclusion (RFI) Attack: URL Payload Used w/Trailing Question Mark Character (?)
   2328 913120 Found request filename/argument associated with security scanner
   6168 913100 Found User-Agent associated with security scanner
```

So that's something we can work with. It shows that the Core Rules detected a lot of malicious requests and we now have an idea which rules played a role in this. The rule triggered most frequently, 913120, is no surprise, and when you look upwards in the output, this all makes a lot of sense.

Let's do a quiz question to see if you are getting proficient looking at the log files.

>>Quiz: Please execute the following curl call. Then look at the log files and try to the rule id of the rule blocking the request: `curl localhost/index.html -d "a=' or 1=1;"`{{execute}}
=== 942100
