---
layout: post
title: Is Bryce Harper a Good Investment for the Phillies? (part 2)
subtitle: I'm biased so I asked the data
tags: baseball Sabermetrics
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

### Model 1 - Total Bases + RBIs

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
![]({{site.baseurl}}/img/QQlm.png)

Here we see that our Q-Q plot leaves something to be desired. Not only do we see a siginifant outlier, but there are two other points that fall off the fit line.
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

We can see here that the Shapiro-Wilk and Anderson-Darling tests just barely support the null hypothesis while the Kolmogorov-Smirnow and Cramer-von Mises tests do not (i.e. this result does not satisfactorily prove that the residuals of this model are normally distributed).
```
ols_test_correlation(lm)
> 0.99
```
```
ols_plot_resid_hist(lm)
```
![]({{site.baseurl}}/img/ResHistlm.png)

We can see on this histogram that the mean of the residuals is clearly at 0 but the data are skewed.

Finally, I calculated the standard deviation and variance of the residuals:
```
var(lm$residuals)
> 3.85
sd(lm$residuals)
> 1.96
```

### Model 2 - OBP + SLG + PA

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
summary(lm2$residuals) #mean = 0
var(lm2$residuals) #6.76
sd(lm2$residuals) # sd = 2.60
lmtest::bptest(lm2) #p-value > 0.05, df = 3
car::ncvTest(lm2) #p-value > 0.05, Chisquare = 0.0118
hist(lm2$residuals)
```
3. Look for normality in the distribution of the residuals (using oslrr package)

```
ols_plot_resid_qq(lm2)
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
