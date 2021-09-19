So the *Nikto* scan set off thousands of alarms. They were likely justified. In the normal use of *ModSecurity*, things are a bit different. The Core Rule Set is designed and optimized to have as few false alarms as possible in paranoia level 1. But in production use, there are going to be false positives sooner or later. Depending on the application, a normal installation will also see alarms and a lot of them will be false. And when you raise the paranoia level to become more vigilant towards attacks, the number of false positives will also rise. Actually, it will rise steeply when you move to PL 3 or 4; so steeply, some would call it exploding.

In order to run smoothly, the configuration has to be fine tuned first. Legitimate requests and exploitation attempts need to be distinct. We want to achieve a high degree of separation between the two. We wish to configure *ModSecurity* and the CRS so the engine knows exactly how to distinguish between legitimate requests and attacks.

We differentiate between two categories of errors when examining requests. We already discussed false positives (or false alarms) above. The other category of errors is called *false negatives* and they consist of attacks that are not detected. The Core Rules are strict and careful to keep the number of *false negatives* low. An attacker needs to possess a great deal of savvy to circumvent the system of rules, especially at higher paranoia levels. Unfortunately, this strictness also results in alarms being triggered for normal requests. It is commonly the case that at a low degree of separation, you either get a lot of *false negatives* or a lot of *false positives*. Reducing the number of *false negatives* leads to an increase in *false positives* and vice versa. Both correlate highly with one another.

We have to overcome this link: We want to increase the degree of separation in order to reduce the number of *false positives* without increasing the number of *false negatives*. We can do this by fine tuning the system of rules in a few places. We have to exclude certain rules from being executed for certain requests or parameters. But first we need to have a clear picture of the current situation: How many *false positives* are there and which of the rules are being violated in a particular context? How many *false positives* are we willing to allow on the system? Reducing them to zero will be extremely difficult to do, but percentages are something we can work with. A possible target would be: 99.99% of legitimate requests should pass without being blocked by the web application firewall. This is realistic, but involves a bit of work depending on the application. 99.99% of requests without a false alarm is also a number where professional use starts. But I have setups where we are not willing to accept more than 1 false alarm in 1 million of requests. That's 99.9999%.

To reach such a goal, we will need one or two tools to help us get a good footing. Specifically, we need to find out about these numbers. Then, in a second step, we look at the error log to understand the rules that led to these alerts. We have seen that the access log reports the anomaly scores of the requests. Let's try to extract these scores and to present them in a suitable form.

In Tutorial 5 we worked with a sample log file containing 10,000 entries. We’ll be using this log file again here: [tutorial-5-example-access.log](https://www.netnea.com/apache-tutorials/git/laboratory/tutorial-5/tutorial-5-example-access.log). The file comes from a real server, but the IP addresses, server names and paths have been simplified or rewritten. However, the information we need for our analysis is still there. Let’s have a look at the distribution of *anomaly scores*:

(The example log file is ready for you in your `/apache/logs` folder.)

```
egrep -o "[0-9-]+ [0-9-]+$" tutorial-5-example-access.log | cut -d\  -f1 | sucs
```{{execute}}
```
      3 10
      5 3
      6 2
     55 5
   9931 0
```

```
egrep -o "[0-9-]+$" tutorial-5-example-access.log | sucs
```{{execute}}
```
  10000 0
```

The first command line reads the inbound *anomaly score*. It’s the second-to-last value in the *access log line*. We take the two last values (*egrep*) and then *cut* the first one out. We then sort the results using the familiar *sucs* alias. The outbound *anomaly score* is the last value in the *log line*. This is why there is no *cut* command on the second command line.

The results give us an idea of the situation: The vast majority of requests pass the *ModSecurity module* with no rule violation: 9931 requests with score 0. 69 requests violated one or more rules. This is not a standard situation for the Core Rules. In fact, I provoked additional false alarms to give us something to look at. The Core Rule Set is so optimized these days that you need a lot of traffic to get a reasonable amount of alerts - or you need to raise the paranoia level very high on a non-tuned system.

A score of 10 appears three times, corresponding to two violations in the same request (most rules score 5 points when violated), which is fairly standard in practice. In all likelihood, we will be seeing a fair number of violations from the requests and very few alarms from the responses; 0 in our example above.

But this still doesn’t give us the right idea about the *tuning steps* that would be needed to run this install smoothly. To present this information in a suitable form, I have prepared a ruby script that analyzes *anomaly scores* and made it available in this Katacoda scenario. You can download the script here: [modsec-positive-stats.rb](https://www.netnea.com/files/modsec-positive-stats.rb) and place it in your private _bin_ directory (You might have to install the _ruby_ package to get it working). It takes the two anomaly scores as input and we need to separate them with a semicolon in order to pipe them into the script. We can do this like this:

```
cat tutorial-5-example-access.log  | egrep -o "[0-9-]+ [0-9-]+$" | tr " " ";" | modsec-positive-stats.rb
```{{execute}}

```
INCOMING                     Num of req. | % of req. |  Sum of % | Missing %
Number of incoming req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. incoming score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with incoming score of   0 |   9931 |  99.3100% |  99.3100% |   0.6900%
Reqs with incoming score of   1 |      0 |   0.0000% |  99.3100% |   0.6900%
Reqs with incoming score of   2 |      6 |   0.0600% |  99.3700% |   0.6300%
Reqs with incoming score of   3 |      5 |   0.0500% |  99.4200% |   0.5800%
Reqs with incoming score of   4 |      0 |   0.0000% |  99.4200% |   0.5800%
Reqs with incoming score of   5 |     55 |   0.5499% |  99.9700% |   0.0300%
Reqs with incoming score of   6 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of   7 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of   8 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of   9 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  10 |      3 |   0.0300% | 100.0000% |   0.0000%

Incoming average:   0.0332    Median   0.0000    Standard deviation   0.4163


OUTGOING                     Num of req. | % of req. |  Sum of % | Missing %
Number of outgoing req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. outgoing score   |      0 |   0.0000% |   0.0000% | 100.0000%
Reqs with outgoing score of   0 |  10000 | 100.0000% | 100.0000% |   0.0000%

Outgoing average:   0.0000    Median   0.0000    Standard deviation   0.0000
```

The script divides the inbound from the outbound *anomaly scores*. The incoming ones are handled first. Before the script can handle the scores, it describes how often an empty *anomaly score* has been found (*empty incoming score*). In our case, this was 41 times, as we saw before. Then comes the statement about *score 0*: 9920 requests. This is covering 99.2% of the requests. Together with the empty scores, this is already covering 99.61% (*Sum of %*). 0.39% had a higher *anomaly score* (*Missing %*). Above, we set out to have 99.99% of requests able to pass the server. We are about 0.38% or 38 requests away from this target. The next *anomaly score* is 2. It appears 11 times or 0.11%. The *anomaly score* 3 appears 17 times and a score of 5 can be seen 8 times. All in all, we are at 99.97%. Then there is one request with a score of 21 and finally 2 requests with with a score of 41. To achieve 99.99% coverage we have get to this limit (and, based on the log file, thus achieve 100% coverage).

There are probably some *false positives*. In practice, we have to make certain of this before we start fine tuning the rules. It would be totally wrong to assume a false positive based on a justified alarm and suppress the alarm in the future. Before tuning, we must ensure that no attacks are present in the log file. This is not always easy. Manual review helps, restricting to known IP addresses, pre-authentication, testing/tuning on a test system separated from the internet, filtering the access log by country of origin for the IP address, etc... It's a big topic and making general recommendations is difficult. But please do take this seriously.

Before we move to the next step, here is a quiz question for you:

>>Quiz: What was the IP address of the requests with an incoming anomaly score of "2"<<
=== 192.168.3.0
