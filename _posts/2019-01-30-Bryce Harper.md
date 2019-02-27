---
layout: KaTeX
title: Is Bryce Harper a Good Investment for the Phillies? (part 1)
subtitle: I'm biased so I asked the data
tags: baseball, Sabermetrics
published: true
---

In order to distract myself from the fact that the Eagles are no longer the reigning Super Bowl Champs, I have been listening to Phillies trade rumors. The biggest story from this beat is without a doubt the potential for us to pick up Bryce Harper (Outfielder, 26 y.o.) from our National League East rival the Nationals. 

To be honest, I am not excited about this. I know Harper is a formidable opponent and not having to play against him would be nice, but I have never been a big fan of him since he came into the MLB as a 19 year old with great hair and a lot of swagger. Compared to Mike Trout, who's about the same age and made his MLB debut the season before Harper, his lack of maturity and humility is notable. All of this is to say, I understand the hype around Harper, but I'm not convinced his stats and attitude make him an optimal addition to the Phillies.

As a 26 year old myself who is still waiting to make her MLB debut, I thought I would try to Moneyball this situation to see if my personal bias against Harper is unwarranted. To do this, I used what I've been learning in my spare time from the helpful folks at [MIT](https://ocw.mit.edu/courses/sloan-school-of-management/15-071-the-analytics-edge-spring-2017/index.htm) to model the Phillies' and Harper's stats to see how he could potentially contribute to the team. I also analyzed the stats of Odubel Herrara (Outfielder, 27 y.o.) who the Phillies are most likely to trade to make room for Harper, should they sign him. Harper and Herrera are both outfielders and typically hit 2nd or 3rd in the batting order.

## Moneyball

If you're unfamiliar with Moneyball, I highly recommend you read the book and/or watch the movie. It's a great and true story of how a Harvard statistician (Paul DePodesta) helped the Oakland A's make the playoffs an astounding number of years in a row on a tight budget. Essentially, DePodesta broke down the game into a couple of key components, built a highly effective predictive model and worked with the general manager, Billy Beane, to recruit players who had excellent numbers in certain areas while eschewing traditional methods of scouting and big name players.

A key part of DePodesta's observations was that teams need to win 95 games during the regular season in order to make the playoffs. Of course, winning 95 games does not guarantee a playoff berth because a given team could be in a particularly tough division where many teams do very well. However, the NL East is not known for being an overly competitive division and looking at team historic records, this assumption holds up for the purposes of this project.

**The "money" part of Moneyball**

In Harper's first season in the MLB (2012), he was making the MLB's minimum salary which was $500,000 at the time. While we don’t know how big Harper's contract will be in 2019, we do know that he’s leaving the Nationals after making $21.6M last year, so we can safely assume it will be a massive contract. The latest speculations are $300M over 10 years.

On the other hand, Herrara is signed with the Phillies through 2021 with options through 2023. His current contract is $30MM over 5 years.

## Predicting how good the Phillies will be in 2019

The first thing I wanted to know was how the Phillies are expected to do assuming they don't make any big changes. To do to this, I used the same premise that DePodesta applied: figure out how many runs a team will score vs. how many runs they will allow their opponents to score in a given season and use this to determine wins. As I said before, DePodesta believed that certain stats were better predictors of a player's success than others. For example, traditional scouting puts a lot of emphasis on a player's batting average (BA = number of hits/number of at bats). While it is useful to know how often a player gets a hit, using at bats (AB) rather than plate appearances (PA) is a little misleading if our ultimate goal is to know how many runs a player can generate. For example, a sacrifice fly that causes a runner to score would not count as a hit or an at bat. The same goes for a walk with the bases loaded that forces a run to score. Both of these instances would count as PAs but not ABs.

Fortunately, we have a lot of options when it comes to baseball statistics and as DePodesta found, a player's on-base percentage (OBP) and slugging percentage (SLG) are highly predictive of how many runs they score throughout the course of a season.

![]({{site.baseurl}}/img/OBPformula.png = 24x48)

As you can see, these stats tell us much more about a player's ability to get on base and generate runs than their batting average. Similarly, a team's opponent's OBP (OOBP) and SLG (OSLG) are indicative of how many runs a team will allow against given opponents.

Using the Phillies' numbers from the last 49 years, I created the following dataframe, using the original baseball dataset from MIT's *Analytics Edge* course (sourced from [Baseball-Reference.com](https://www.baseball-reference.com)), adding a variable for run difference (RD = runs scored - runs allowed) and removing excess variables I didn't need: 

```
baseball = read.csv("baseball.csv") #only goes to 2012
Phillies = subset(baseball, Team == "PHI" & Year > 1968)

#NL East officially formed in 1969

Phillies$RD = Phillies$RS - Phillies$RA
Phillies$Team = NULL
Phillies$League = NULL
Phillies$RankPlayoffs = NULL
Phillies$RankSeason = NULL
Phillies$Playoffs = NULL
```
Since this dataset only went to 2012, I needed to add some additional years. I started by pulling the data I needed from Baseball- Reference, creating a dataset, and then adding them to the existing dataframe:
```
total = read.csv("Phillies.csv")
recent = subset(total, Year > 2012)
Phillies = rbind(recent, Phillies)
```
Now let's get a sense of what the dataframe looks like:
```
summary(Phillies)
     Year            RS              RA              W               OBP        
 Min.   :1969   Min.   :558.0   Min.   :529.0   Min.   : 63.00   Min.   :0.2980  
 1st Qu.:1982   1st Qu.:647.0   1st Qu.:681.8   1st Qu.: 71.50   1st Qu.:0.3140  
 Median :1994   Median :699.0   Median :718.5   Median : 80.00   Median :0.3270  
 Mean   :1994   Mean   :710.6   Mean   :719.0   Mean   : 80.54   Mean   :0.3255  
 3rd Qu.:2007   3rd Qu.:764.0   3rd Qu.:749.0   3rd Qu.: 88.75   3rd Qu.:0.3370  
 Max.   :2018   Max.   :892.0   Max.   :846.0   Max.   :102.00   Max.   :0.3540  
                                                                                 
      SLG               BA               G            OOBP       
 Min.   :0.3500   Min.   :0.2330   Min.   :161   Min.   :0.2960  
 1st Qu.:0.3762   1st Qu.:0.2490   1st Qu.:162   1st Qu.:0.3207  
 Median :0.3950   Median :0.2550   Median :162   Median :0.3290  
 Mean   :0.3973   Mean   :0.2559   Mean   :162   Mean   :0.3273  
 3rd Qu.:0.4138   3rd Qu.:0.2655   3rd Qu.:162   3rd Qu.:0.3345  
 Max.   :0.4580   Max.   :0.2790   Max.   :163   Max.   :0.3470  
                                                 NA's   :26      
      OSLG              RD          
 Min.   :0.3610   Min.   :-186.000  
 1st Qu.:0.4065   1st Qu.: -94.250  
 Median :0.4250   Median : -10.000  
 Mean   :0.4233   Mean   :  -8.391  
 3rd Qu.:0.4472   3rd Qu.:  68.500  
 Max.   :0.4600   Max.   : 213.000  
 NA's   :26  
 ```

This generally looks good, with the exception of OOBP and OSLG where we have 26 NA's in each! Isolating these variables, it is clear that these stats were not collected by Baseball-Reference until 1992. This is unfortunate and points out an issue with data analytics in sports today: while we are very good at collecting data now, it may take years to see what new stats are actually predictive and which are not.

## Linear Regressions

Using this dataframe, I ran two linear regressions to help me make predictions about how many runs the Phillies will score, how many they will allow, and finally, how that translates into wins:


#### Runs Scored

```
RunsScored = lm(RS ~ OBP + SLG, data =Phillies)
summary(RunsScored)


Residuals:
   Min     1Q Median     3Q    Max 
-74.37 -11.52   3.49  12.83  55.59 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -753.88      79.48  -9.486 4.18e-12 ***
OBP          2556.32     408.25   6.262 1.52e-07 ***
SLG          1591.61     224.07   7.103 9.13e-09 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 24.26 on 43 degrees of freedom
Multiple R-squared:  0.9182,	Adjusted R-squared:  0.9144 
F-statistic: 241.4 on 2 and 43 DF,  p-value: < 2.2e-16
```

#### Runs Allowed

```
RunsAllowed = lm(RA ~ OOBP + OSLG, data = Phillies)
summary(RunsAllowed)


Residuals:
    Min      1Q  Median      3Q     Max 
-39.566 -17.663  -0.786  20.038  46.522 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   -796.3      146.3  -5.444 4.37e-05 ***
OOBP          2548.7      717.1   3.554 0.002441 ** 
OSLG          1652.0      363.0   4.551 0.000283 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 24.97 on 17 degrees of freedom
  (26 observations deleted due to missingness)
Multiple R-squared:  0.9043,	Adjusted R-squared:  0.893 
F-statistic: 80.29 on 2 and 17 DF,  p-value: 2.182e-09
```

These results looked good to me overall and aligned with the projections on [Baseball-Reference.com](https://www.baseball-reference.com/teams/PHI/2018.shtml). Making the equations provided by the regression output, we have:
```
Run Scored = -753.88 + 2556.32*OBP + 1591.61*SLG

Runs Allowed = -796.3 + 2548.7*OOBP + 1652.0*OSLG

```
#### Wins
```
Wins = lm(W ~ RD, data = Phillies)
summary(WinsModern)


Residuals:
    Min      1Q  Median      3Q     Max 
-8.6347 -2.7141  0.3276  2.7372  7.7286 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 81.359516   0.564342  144.17   <2e-16 ***
RD           0.097248   0.005395   18.02   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.815 on 44 degrees of freedom
Multiple R-squared:  0.8807,	Adjusted R-squared:  0.878 
F-statistic: 324.9 on 1 and 44 DF,  p-value: < 2.2e-16
```
This gives us the following equation:

```
Wins = 81.36 + 0.097*RD
```

Just looking at this equation, I thought it intuitively made sense with its intercept at 81, since teams play 162 games per season. To confirm this, I looked at Phillies' wins over time

![]({{site.baseurl}}/img/ggplotWins.png)

This graph not only strengthened my confidence in my model, but also highlighted some key years in franchise history, namely our World Series wins in 1980 and 2008, as well as our NL Pennant wins in 1993 and 2009. (Not to mention our horrific 2015 season where we nearly lost 100 games...)

At this point, I felt that I had a good handle on how the Phillies would do in 2019, specifically: RS = 672, RA = 688, RD = -15, W = 80, L = 82

From here, I was able to analyze the impact Bryce Harper could have on the team. Stay tuned for Part 2
