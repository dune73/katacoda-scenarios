_There is an issue with the way Katacoda configures the bash shell. Please execute the following command to launch a new shell that is properly configured._

```
bash
```{{execute}}

Now we are ready.


There is no point in learning to fight false positives on a lab server without traffic. What you need is a real set of false alarms. This will let you practice writing rules exclusions so the false alarms disappear from the installation. I have prepared two such files for you:

* [tutorial-8-example-access.log](https://www.netnea.com/files/tutorial-8-example-access.log)
* [tutorial-8-example-error.log](https://www.netnea.com/files/tutorial-8-example-error.log)

These files and all the other files in this scenario are ready for you in the `/apache/logs` folder.

It is difficult to provide real production logs for an exercise due to all the sensitive data in the logs. So, I went and created false positives from scratch. With the Core Rule Set 2.2.x, this would have been simple, but with the 3.0 release (CRS3), most of the false positives in the default install are now gone. What I did was set the CRS to Paranoia Level 4 and then install a local Drupal site. I then published a couple of articles and then read the articles in the browser. Rinse and repeat up to 10,000 requests.

Drupal and the core rules are not really in a loving relationship. Whenever the two software packages meet, they tend to have a falling out with each other, since the CRS is so pedantic and Drupal's habit of having square brackets in parameter names drives the CRS crazy. However, the default CRS3 installation at Paranoia Level 1, and especially the new optional exclusion rules for Drupal (see the `crs-setup.conf` file and [this blog post](https://www.netnea.com/cms/2016/11/22/securing-drupal-with-modsecurity-and-the-core-rule-set-crs3/) for details), wards off almost all of the remaining false positives with a core Drupal installation.

But things look completely different when you do not use these exclusion rules and if you raise the Paranoia Level to 4, you will get plenty of false positives. For the 10,000 requests in my test run, I received over 27,000 false alarms. That should do for a training session.

The problem with false positives is that if you are unlucky, they flood you like an avalanche and you do not know where to start the clean up. What you need is a plan and there is no official documentation proposing one. So here we go: This is my recommended approach to fighting false alarms:

* Always work in blocking mode
* Highest scoring requests go first
* Work in several iterations

What does that mean? The default installation comes in blocking mode and with an anomaly threshold of 5 for the requests. In fact, this is a very good goal for our work, but it's an overambitious start on an existing production server. The risk is that a false positive raises an alarm, the wrong customer's browser is blocked, a phone call to the manager ensues and you are forced to switch off the Web Application Firewall. In many installations I have seen, this was the end of the story.

Don't let a badly tuned system catch you like this. Instead, start with a high threshold for the anomaly score. Let's say 10,000 for the requests and also 10,000 for the responses for symmetry's sake (in practice, the responses do not score very high). That way you know that no customer is ever going to be blocked, you get reports of false alarms and you gain time to weed them out.

If you have a proper security program, this is all performed during an extensive testing phase, so the service never hits production without a strict configuration. But if you start with ModSecurity on an existing production service, starting out with a high threshold in production is the preferred method with minimal interruption to existing customers (zero impact, if you work diligently). 

The problem with integrating ModSecurity in production is the fact that false positives and real alarms are intermixed. In order to tune your installation, you need to separate the two groups to really work on the false positives alone. This is not always easy. Manual review helps, restricting to known IP addresses, pre-authentication, testing/tuning on a test system separated from the internet, filtering the access log by country of origin for the IP address, etc... It's a large topic and making general recommendations is difficult. But please do take this seriously. Years ago, I demonstrated the exclusion of a false positive in a workshop - and the example alarm I used turned out to be a real attack. Needless to say, I learned my lesson.

There is another question that we need to get out of the way: Doesn't disabling rules actually lower the security of the site? Yes it does, but we need to keep things in perspective. In an ideal setup, all rules would be intact, the paranoia level would be very high (thus a total of 200 rules in place) and the anomaly limit very low; but the application would run without any problems or false alarms. But in practice, this won't work outside of the rarest of cases. If we raise the anomaly threshold, then the alerts are still there, but the attackers are no longer affected. If we reduce the paranoia level, we disable dozens of rules with one setting. If we talk to the developers about changing their software so that the false positives go away, we spend a lot of time arguing without much chance of success (at least in my experience). So disabling a single rule from a set of 200 rules is the best of all the bad solutions. The worst of all the bad solutions would be to disable ModSecurity altogether. And as this is very real in many organizations, I would rather disable individual rules based on a false positive than run the risk of being forced to kill the WAF.
