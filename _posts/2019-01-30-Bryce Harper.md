---
layout: post
title: Is Bryce Harper Worth it for the Phillies? (part 1)
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

*OBP = (Hits + Walks + Hit by Pitch)/AB + Hits + Walks + Hit by Pitch + Sacrifice Flies)*

*SLG = (Singles + 2xDoubles + 3xTriples + 4xHRs)/AB*

As you can see, these stats tell us much more about a player's ability to get on base and generate runs than their batting average. Using the Phillies' numbers from the last 50 years, I created the following dataframe: 

``` baseball = read.csv("baseball.csv") #only goes to 2012
```summary(baseball)
```Phillies = subset(baseball, Team == "PHI" & Year > 1968)
```#NL East officially formed in 1969
```Phillies$RD = Phillies$RS - Phillies$RA
```Phillies$Team = NULL
```Phillies$League = NULL
```Phillies$RankPlayoffs = NULL
```Phillies$RankSeason = NULL
```Phillies$Playoffs = NULL

![]({{site.baseurl}}/img/PhilliesCode1.jpg)

Using this dataframe, I ran two linear regressions to help me make predictions about how many runs the Phillies will score and allow:

![]({{site.baseurl}}/img/PhilliesCode2.png)

These results looked good to me and aligned with the projections on [Baseball-Reference.com](https://www.baseball-reference.com/teams/PHI/2018.shtml), so I moved on to running a regression to predict wins using run difference (RD = Runs Scored - Runs Allowed)

![]({{site.baseurl}}/img/PhilliesCode3.png)

Just looking at this equation, I thought it intuitively made sense with its intercept at 81, since teams play 162 games per season. To confirm this, I looked at Phillies' wins over time
![]({{site.baseurl}}/img/ggplotWins.png)

This graph not only strengthened my confidence in my model, but also highlighted some key years in franchise history, namely our World Series wins in 1980 and 2008, as well as our NL Pennant wins in 1993 and 2009. (Not to mention our horrific 2015 season where we nearly lost 100 games...)

At this point, I felt that I had a good handle on how the Phillies would do in 2019, specifically: RS = 672, RA = 688, RD = -15, W = 80, L = 82

From here, I was able to analyze the impact Bryce Harper could have on the team. Stay tuned for Part 2
