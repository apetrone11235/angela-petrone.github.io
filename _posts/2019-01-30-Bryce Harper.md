---
layout: post
title: Is Bryce Harper Worth it for the Phillies? (part 1)
tags: baseball
published: true
---

In order to distract myself from the fact that the Eagles are no longer the reigning Super Bowl Champs, I have been listening to Phillies trade rumors. The biggest story from this beat is without a doubt the potential for us to pick up Bryce Harper (OF, 26 y.o.) from our NL East rival the Nationals. 

To be honest, I am not excited about this. I know Harper is a formidable opponent and not having to play against him would be nice, but I have never been a big fan of him and he could just as easily not play against us on the Yankees. He came into the MLB as a 19 year old with great hair and a lot of swagger. Compared to Mike Trout, who's about the same age and made his MLB debut the season before Harper, the difference in maturity and humility is stark. All of this is to say, I get the hype around Harper but I'm not convinced his stats and attitude make him an optimal addition to the Phillies.

As a 26 year old myself who is still waiting to make her MLB debut, I thought I would try to Moneyball this situation to see if my personal bias against Harper is unwarranted. To do this, I used what I've been learning in my spare time from the helpful folks at [MIT](https://ocw.mit.edu/courses/sloan-school-of-management/15-071-the-analytics-edge-spring-2017/index.htm) to model the Phillies' and Harper's stats to see how he could potentially contribute. I also analyzed the stats of Nick Williams (RF, 25 y.o.) and Odubel Herrara (CF, 27 y.o.) who the Phillies are most likely to trade to make room for Harper, should they sign him. Harper, Herrera and Williams are all outfielders and typically hit 2nd or 3rd in the batting order.

**Moneyball:**

If you're unfamiliar with Moneyball, I highly recommend you read the book and/or watch the movie. It's a great and true story of how a Harvard statistician (Paul DePodesta) helped the Oakland A's make the playoffs an astounding number of years in a row on a tight budget. Essentially, DePodesta broke down the game into a couple of key components, built a highly effective predictive model and worked with the general manager, Billy Beane, to recruit players who had excellent numbers in certain areas while eschewing traditional methods of scouting and big name players.

*Fun Philly Fact: Former Phillies GM Ed Wade (an actor, sadly not the actual guy) makes a brief appearance in the movie agreeing to trade for Jeremy Giambi. This was a terrible decision because the guy had stones for hands and was a disaster in the locker room, so you may understand why I'm a little wary of the Phillies' front office decisions.* 

**The "money" part of Moneyball**

In Harper's first season in the MLB (2012), he was making the Major Leagues minimum salary which was $500,000 at the time. While we don’t know how big Harper's contract will be in 2019, we do know that he’s leaving the Nationals after making $21.6M last year, so we can safely assume it will be a massive contract. The latest speculations are $300M over 10 years.

On the other hand, Herrara is signed with the Phillies through 2021 with options through 2023. His current contract is $30MM over 5 years. Williams makes the MLB minimum of $553,000 with no long-term contract. 

**Predicting how good the Phillies will be in 2019**

The first thing I wanted to know was how the Phillies are expected to do assuming they didn't make any big changes. To do to this, I used the same premise that DePodesta applied: figure out how many runs a team will score vs. how many runs they will allow their opponents to score in a given season and use this to determine wins. As I said before, DePodesta believed that certain stats were better predictors of a player's success than others. For example, traditional scouting puts a lot of emphasis on a player's batting average (BA = number of hits/number of at bats). While it is definitely useful to know how often a player gets a hit, using at bats (AB) rather than plate appearances (PA) is a little misleading if our ultimate goal is to know how many runs a player can generate. For example, a sacrifice fly that causes a runner to score would not count as a hit or an at bat. The same goes for a walk with the bases loaded that forces a run to score.

Fortunately, we have a lot of options when it comes to baseball statistics and as DePodesta found, a player's on-base percentage (OBS) and slugging percentage (SLG) are highly predictive of how many runs they score during the course of a season.

*OBP = (Hits + Walks + Hit by Pitch)/AB + Hits + Walks + Hit by Pitch + Sacrifice Flies)
SLG = (Singles + 2xDoubles + 3xTriples + 4xHRs)/AB*

As you can see, these stats tell us much more about a player's ability to get on base and generate runs. Using the Phillies' numbers from the last 50 years, I created the following dataframe: 

![]({{site.baseurl}}/img/PhilliesCode1.jpg)

Using this dataframe, I ran two linear regressions to help me make predictions about how many runs the Phillies will score and allow:

![]({{site.baseurl}}/img/PhilliesCode2.png)

These results looked good to me and aligned with the projections on Baseball-Reference.com, so I moved on to running a regression to predict wins using run difference (RD = Runs Scored - Runs Allowed)

![]({{site.baseurl}}/img/PhilliesCode3.png)

Just looking at this equation, I felt that it made intuitive sense with its intercept at 81. To confirm this, I looked at Phillies' wins over time
![]({{site.baseurl}}/img/Phillies Wins Over Time.png)

This graph not only strengthed my confidence in my model, but also highlights some key years in franchise history, namely our World Series wins in 1980 and 2008, as well as our NL Penant wins in 1993 and 2009. (Not to mention our horrific 2015 season where we nearly lost 100 games...)
