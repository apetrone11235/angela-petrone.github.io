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

This was not a welcome discovery, so I decided to see what other significant statistical relationships I could find to predict Harper's run production. From here, I tried many different combinations of the dependent variables to see if any could make a statistically valid prediction about Harper's run production. I will spare you the details of all of my exploration, but I want to highlight three models and explain their shortcomings. 

**Model 1: OBP + SLG + G**

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

Seeing this result, my main concern was the error terms, but I wanted to run some diagnostic tests on the model before writing it off. The first thing I checked for was if there was collinearity between variables

```
cov(BryceHarperHitting$SLG, BryceHarperHitting$OBP)
> 0.003
cov(BryceHarperHitting$SLG, BryceHarperHitting$G)
> 0.40
cov(BryceHarperHitting$G, BryceHarperHitting$OBP)
> 0.30
```
Again, I was not totally happy with these results but I wanted to look at the residuals to have a more comprehensive way to compare potential predictive models. 

Using the olsrr package, I ran the following 

```
ols_plot_resid_qq(lm)
```
![]({{site.baseurl}}/img/QQ0.png)

Here we see that our Q-Q plot is pretty good.
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

We can see here that all but Cramer-von Mises test support the null hypothesis that the residuals of the model are normally distributed. Looking at the 

```
ols_plot_resid_hist(lm)
```
![]({{site.baseurl}}/img/ResHistlm0.png)

We can see on this histogram that the mean of the residuals is clearly at 0 but the data are skewed.

Finally, I calculated the standard deviation and variance of the residuals:
```
var(lm$residuals)
> 18.44
sd(lm$residuals)
> 4.29
```

### Model 2: OBP + SLG + PA

Finding my first model unsatisfactory, I tried to think about other variables that could strengthen the original model. As I discussed in the first part of this post, plate appearances (PA) are the number of times a player steps to the plate, regardless of the outcome. I figured that knowing how ofter a player has a chance to hit would probably be indicative of how much they actually hit. This is a standard strategy in baseball evidenced by managers putting their best hitters early in the lineup to get them more PAs.

Graphically, Harper's stats look like this:

![]({{site.baseurl}}/img/PAbh5.png)

From here, I built my model
```
lm2 <- lm(R ~ OBP + SLG + PA, data = BryceHarperHitting)
summary(lm2)

Call:
lm(formula = R ~ OBP + SLG + PA, data = BryceHarperHitting)

Residuals:
       1        2        3        4        5        6        7        8 
-0.55857  4.05017  2.94722 -2.95191 -2.53824 -2.28508  0.08549  1.25092 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -42.46744   14.77506  -2.874 0.045274 *  
OBP         -336.89958   82.61986  -4.078 0.015127 *  
SLG          309.39699   40.89223   7.566 0.001636 ** 
PA             0.17981    0.01325  13.573 0.000171 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.441 on 4 degrees of freedom
Multiple R-squared:  0.989,	Adjusted R-squared:  0.9807 
F-statistic: 119.5 on 3 and 4 DF,  p-value: 0.0002273
```

Since adding PAs to the original model clearly helped, I moved onto running diagnostic tests:

1. Check for collinearity

```
cov(BryceHarperHitting$SLG, BryceHarperHitting$OBP)
> 0.003
cov(BryceHarperHitting$SLG, BryceHarperHitting$PA)
> 2.33
cov(BryceHarperHitting$OBP, BryceHarperHitting$PA)
> 1.55
```


2. Check for heterskedacity

```
plot(lm2)
summary(lm2$residuals)
>    Min. 1st Qu.  Median   Mean   3rd Qu.   Max. 
> -2.9519 -2.3484 -0.2365  0.0000  1.6750  4.0502 

var(lm2$residuals)
> 6.76
sd(lm2$residuals)
> 2.60

lmtest::bptest(lm2)
> studentized Breusch-Pagan test
> data:  lm2
> BP = 2.8282, df = 3, p-value = 0.4189

car::ncvTest(lm2)
> Non-constant Variance Score Test 
> Variance formula: ~ fitted.values 
> Chisquare = 0.01179326, Df = 1, p = 0.91352

```
3. Look for normality in the distribution of the residuals (using oslrr package)

```
ols_plot_resid_qq(lm2)
```

![]({{site.baseurl}}/img/QQlm5.png)

```
ols_test_normality(lm2)

-----------------------------------------------
       Test             Statistic       pvalue  
-----------------------------------------------
Shapiro-Wilk              0.9275         0.4940 
Kolmogorov-Smirnov        0.1852         0.9032 
Cramer-von Mises          0.7028         0.0104 
Anderson-Darling          0.2668         0.5793 
-----------------------------------------------
```
```
ols_test_correlation(lm2)
> 0.97

ols_plot_resid_hist(lm2)
```
![]({{site.baseurl}}/img/ResHistlm5.png)
