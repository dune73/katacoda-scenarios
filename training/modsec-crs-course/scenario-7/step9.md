Handling false positives is tedious at times. However, with the goal of protecting the application, it is most certainly worthwhile. When we introduced the statistic script I stated that we should make sure that at least 99.99% of requests pass through the rule set without any false positives. The remaining positives, the ones caused by attackers, should be blocked. But we are still running with an anomaly limit of 10,000. We need to reduce this to a decent level. Any limit above 30 or 40 is unlikely to stop anything serious. With a threshold of 20, you start to see an effect and then with 10 you get fairly good protection from standard attackers. Even if an individual rule only scores 5 points, some attack classes like SQL injections typically trigger multiple alarms, so a limit of 10 catches quite a few attack requests. In other categories, the coverage with rules is less extensive. This means, the accumulation of multiple rules is less intense. So it is perfectly possible to stay beneath a score of 10 with a certain attack payload. That's why a limit of 5 for the inbound score and 4 for the outbound score gives you a good level security. These are the default values of the CRS.

But how to lower the limit from 10,000 to 5 without harming production? It takes a certain trust in your tuning skills to perform this step. A more natural approach is to go over multiple iterations: An initial tuning round is performed with a limit of 10,000. When the most blatant sources of false positives are eliminated this way, you wait for a given amount of time and then lower the limit to 50 and examine the logs again. Tune and reduce to 30, then 20, 10 and finally 5. After every reduction, you need to check the new log files and run the statistic script. By looking at the statistics, you see what you can expect from a reduction of the limit. Let's look once more at the stats we examined before:

```
INCOMING                     Num of req. | % of req. |  Sum of % | Missing %
Number of incoming req. (total) |  10000 | 100.0000% | 100.0000% |   0.0000%

Empty or miss. incoming score   |     41 |   0.4100% |   0.4100% |  99.5900%
Reqs with incoming score of   0 |   9920 |  99.2000% |  99.6100% |   0.3900%
Reqs with incoming score of   1 |      0 |   0.0000% |  99.6100% |   0.3900%
Reqs with incoming score of   2 |     11 |   0.1100% |  99.7200% |   0.2800%
Reqs with incoming score of   3 |     17 |   0.1699% |  99.8900% |   0.1100%
Reqs with incoming score of   4 |      0 |   0.0000% |  99.8900% |   0.1100%
Reqs with incoming score of   5 |      8 |   0.0800% |  99.9700% |   0.0300%
Reqs with incoming score of   6 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of   7 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of   8 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of   9 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  10 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  11 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  12 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  13 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  14 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  15 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  16 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  17 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  18 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  19 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  20 |      0 |   0.0000% |  99.9700% |   0.0300%
Reqs with incoming score of  21 |      1 |   0.0100% |  99.9800% |   0.0200%
Reqs with incoming score of  22 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  23 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  24 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  25 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  26 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  27 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  28 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  29 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  30 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  31 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  32 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  33 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  34 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  35 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  36 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  37 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  38 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  39 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  40 |      0 |   0.0000% |  99.9800% |   0.0200%
Reqs with incoming score of  41 |      2 |   0.0200% | 100.0000% |   0.0000%
```

10,000 requests is not really a big log file, but it will do for our purposes. Based on the data, we can immediately decide to reduce the limit to 50. It is unlikely that a request will hit that threshold - and if it does, it is an isolated transaction which is very rare.

Reducing the limit to 30 would probably be a bit overzealous, because the column on the right states that 0.02% of the requests scored higher than 30. We should get rid of the false positives at 41 before we should reduce the limit to 30. 

With this statistical data, the iterative tuning process becomes quite clear: The *modsec-positive-stats.rb* script brings sense and reason to the process.

For the outbound responses, the situation is a bit simpler as you will hardly see any scores above 5. There simply are not enough rules to have any cumulative effect; probably because there is not much you can check in a response. So, I reduce the response threshold down to 5 or 4 rather quickly (which happens to be the default value of the Core Rule Set outbound request threshold).

I think the tuning concept and the theory are now quite clear. In the next tutorial, we will continue with tuning false positives to gain some practice with the methods demonstrated here. And I will also introduce a script which helps with the construction of the more complicated exclusion rules.
