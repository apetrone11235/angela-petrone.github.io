---
layout: post
title: Is Bryce Harper a Good Investment for the Phillies? (part 2)
subtitle: I'm biased so I asked the data
tags: baseball, Sabermetrics
published: false
---

## How good is Bryce Harper?

My main objective in evaluating Bryce Harper's value to the Phillies was determining how good he is offensively, especially with regards to run production. I was much less concerned with his defensive ability because, as an outfielder, he is unlikely to change the score of a given game on the field. Of course, a truly terrible outfielder who misses routine fly balls and can't make a decent through to the plate will cost their team some runs, but considering Harper is not a liability in the outfield, I chose to focus on his hitting.

As I outlined in part 1 of this project, the key offensive stats I looked at were Runs, OBP, and SLG. Considering Harper has been in the league for only 8 years, I wanted to get a sense of his average run production before trying to make any assumptions about his future production. 

![]({{site.baseurl}}/img/bhRunsggplot.png)

The first thing I noticed about this graph was the inconsistency in production over not that many years. In 2014 when he was just 22, Harper only played 100 games due to a knee injury that required surgery. It seems like the surgery was not just successful but also gave him either a lot of motivation to perform in 2015 or hitting super powers, because in 2015 he came back to lead the league in runs and HRs, lead the entire MLB in OBP and SLG, was an All Star, the NL MVP, and won the NL [Silver Slugger Award](https://en.wikipedia.org/wiki/Silver_Slugger_Award).

While these two seasons are definitely critical for understanding Harper as an offensive player, they make his stats pretty challenging to predict. For example, when I took a look at the relationship between runs scored, OBP and SLG, I got this:

![]({{site.baseurl}}/img/bhHittingStatsgg.png)

This was not a welcome discovery, so I decided to see what other significant statistical relationships I could find to predict Harper's run production. From here, I tried many different combinations of the dependent variables to see if any could make a statistically valid prediction about Harper's run production. I will spare you the details of all of my exploration, but I want to highlight three models and explain their shortcomings. 

#### Model 1 - Total Bases + RBIs

Thinking about what variables could be natural predictors for runs scored, I started by looking at total bases (TB) and runs batted in (RBIs). 

![]({{site.baseurl}}/img/bhTBRBIgg.png)

Graphically, this looked pretty good so I went ahead and created the model:

``lm <- lm(R ~ RBI + TB, data = BryceHarperHitting) ``

which produced the following:

```
Call:
lm(formula = R ~ RBI + TB, data = BryceHarperHitting)

Residuals:
      1       2       3       4       5       6       7       8 
-0.6919  3.4054  1.4362 -6.1972 -5.2911  0.8353  6.6049 -0.1017 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)   
(Intercept) -20.20948    8.80053  -2.296  0.07009 . 
RBI           0.36256    0.11532   3.144  0.02555 * 
TB            0.32104    0.05201   6.173  0.00162 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.997 on 5 degrees of freedom
Multiple R-squared:  0.9709,	Adjusted R-squared:  0.9593 
F-statistic: 83.45 on 2 and 5 DF,  p-value: 0.0001443
```
Seeing this result, my main concerns were the error term and lack of significance on the intercept, but I wanted to run some diagnostic tests on the model before writing it off. The first thing I checked for was if there was collinearity between variables

```
cov(BryceHarperHitting$SLG, BryceHarperHitting$OBP)
> 0.003
```
```
cov(BryceHarperHitting$SLG, BryceHarperHitting$TB)
> 2.98
```
```
cov(BryceHarperHitting$SLG, BryceHarperHitting$RBI)
> 1.15
```
```
cov(BryceHarperHitting$OBP, BryceHarperHitting$RBI)
> 0.69
```
```
cov(BryceHarperHitting$OBP, BryceHarperHitting$TB)
> 1.31
```
Again, I was not totally happy with these results but I wanted to look at the residuals to have a more comprehensive way to compare potential predictive models. 

Using the olsrr package, I ran the following 

```
ols_plot_resid_qq(lm)
```
```
ols_test_normality(lm)

-----------------------------------------------
       Test             Statistic       pvalue  
-----------------------------------------------
Shapiro-Wilk              0.8183         0.0448 
Kolmogorov-Smirnov        0.2955         0.4085 
Cramer-von Mises          0.1967         0.2771 
Anderson-Darling          0.706          0.0390 
-----------------------------------------------
```
```
ols_test_correlation(lm)
> 0.99
```
```
ols_plot_resid_hist(lm)
```
