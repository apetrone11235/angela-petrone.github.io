---
layout: post
title: Is Bryce Harper a Good Investment for the Phillies? (part 2)
subtitle: I'm biased so I asked the data
tags: baseball Sabermetrics
published: true
---

## How good is Bryce Harper?

My main objective in evaluating Bryce Harper's value to the Phillies was determining how good he is offensively, especially with regards to run production. I was much less concerned with his defensive ability because, as an outfielder, he is unlikely to change the score of a given game on the field. Of course, a truly terrible outfielder who misses routine fly balls and can't make a decent through to the plate will cost their team some runs, but considering Harper is not a liability in the outfield, I chose to focus on his hitting.

As I outlined in part 1 of this project, the key offensive stats I looked at were Runs, OBP, and SLG. Considering Harper has been in the league for only 8 years, I wanted to get a sense of his average run production before trying to make any assumptions about his future production. 

![]({{site.baseurl}}/img/bhRunsggplot.png)

The first thing I noticed about this graph was the inconsistency in production over not that many years. In 2014 when he was just 22, Harper only played 100 games due to a knee injury that required surgery. It seems like the surgery was not just successful but also gave him either a lot of motivation to perform in 2015 or hitting super powers, because in 2015 he came back to lead the league in runs and HRs, lead the entire MLB in OBP and SLG, was an All Star, the NL MVP, and won the NL [Silver Slugger Award](https://en.wikipedia.org/wiki/Silver_Slugger_Award).

While these two seasons are definitely critical for understanding Harper as an offensive player, they make his stats pretty challenging to predict. For example, when I took a look at the relationship between runs scored, OBP and SLG, I got this:

![]({{site.baseurl}}/img/bhHittingStatsgg.png)

Statistically, the results of the basic model were unusable

```
Call:
lm(formula = R ~ OBP + SLG, data = BryceHarperHitting)

Residuals:
      1       2       3       4       5       6       7       8 
 21.967  -8.841  15.452   2.472 -23.931  -8.209  20.318 -19.227 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   -27.12      90.39  -0.300    0.776
OBP           -20.87     486.36  -0.043    0.967
SLG           234.59     248.60   0.944    0.389

Residual standard error: 21.11 on 5 degrees of freedom
Multiple R-squared:  0.481,	Adjusted R-squared:  0.2734 
F-statistic: 2.317 on 2 and 5 DF,  p-value: 0.1941
```

This was not a welcome discovery, so I decided to see what other significant statistical relationships I could find to predict Harper's run production. From here, I tried many different combinations of the dependent variables to see if any could make a statistically valid prediction about Harper's run production.

**Model 2: OBP + SLG + G**

First, I thought about what other factors might be able to strenghten the original assumption that OBP and SLG predict runs. When I had graphed Harper's runs over time, it was obvious that the season he got knee surgery he scored the fewest runs on account of the injury and amount of time spent on the bench. Therefore, I added games played to the model:

```
lm <- lm(R ~ OBP + SLG + G, data = BryceHarperHitting)
summary(lm)

Call:
lm(formula = R ~ OBP + SLG + G, data = BryceHarperHitting)

Residuals:
      1       2       3       4       5       6       7       8 
 1.5634  6.9580  3.8655 -5.6864 -4.8989 -2.4194 -0.3697  0.9874 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)   
(Intercept)  -52.2981    24.5241  -2.133  0.09992 . 
OBP         -378.7796   138.2093  -2.741  0.05187 . 
SLG          343.8607    68.2622   5.037  0.00730 **
G              0.8304     0.1030   8.065  0.00128 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.681 on 4 degrees of freedom
Multiple R-squared:  0.9699,	Adjusted R-squared:  0.9474 
F-statistic:    43 on 3 and 4 DF,  p-value: 0.001679
```

This result showed a big improvement from my inital model, but I wanted to run some diagnostic tests to see how usable it was. 

#### Analysis

The first thing I checked for was if there was collinearity between variables

```
cov(BryceHarperHitting$SLG, BryceHarperHitting$OBP)
> 0.003
cov(BryceHarperHitting$SLG, BryceHarperHitting$G)
> 0.40
cov(BryceHarperHitting$G, BryceHarperHitting$OBP)
> 0.30
```
I was not totally happy with these results but I wanted to look at the residuals to have a more comprehensive way to compare potential predictive models. 

Using the olsrr package, I ran the following 

```
ols_plot_resid_qq(lm)
```
![]({{site.baseurl}}/img/QQ0.png)

```
ols_test_normality(lm)

-----------------------------------------------
       Test             Statistic       pvalue  
-----------------------------------------------
Shapiro-Wilk              0.9711         0.9066 
Kolmogorov-Smirnov        0.123          0.9981 
Cramer-von Mises          0.6558         0.0140 
Anderson-Darling          0.1535         0.9278 
-----------------------------------------------
```

Here we see that our Q-Q plot is pretty good and that all but Cramer-von Mises test support the null hypothesis that the residuals of the model are normally distributed.

```
ols_plot_resid_hist(lm)
```
![]({{site.baseurl}}/img/ResHistlm0.png)

Additionally, this histogram shows that the mean of the residuals is clearly at 0 but the data might be skewed. I tested for this and found that the distribution was approximately symmetric.

```
skewness(lm$residuals)
> 0.1321866
```

Finally, I calculated the standard deviation and variance of the residuals:
```
var(lm$residuals)
> 18.44
sd(lm$residuals)
> 4.29
```



#### Prediction

Let's see how many runs this model predicts and how that compares to other predictive resources out there. The equation we have is:

```
Runs = -52.30 + (-378.78)*OBP + 343.86*SLG + 0.83*G
```
Using 2018 numbers, we get the following prediction for 2019:

```
Runs = -52.30 + (-378.78)*0.393 + 343.86*0.496 + 0.83*159
Runs= 101
```



