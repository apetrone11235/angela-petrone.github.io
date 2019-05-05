##Is Bryce Harper worth it for the Phillies?

baseball = read.csv("baseball.csv") #only goes to 2012
summary(baseball)
Phillies = subset(baseball, Team == "PHI" & Year > 1968)
#NL East officially formed in 1969
Phillies$RD = Phillies$RS - Phillies$RA
Phillies$Team = NULL
Phillies$League = NULL
Phillies$RankPlayoffs = NULL
Phillies$RankSeason = NULL
Phillies$Playoffs = NULL

#need to add 2013 - 2018 data
total = read.csv("Phillies.csv")
#this has 136 years of Phillies stats! but for our purposes, we'll keep things in the modern era
recent = subset(total, Year > 2012)
Phillies = rbind(recent, Phillies)
summary(Phillies)

#Data exploration
library(ggplot2)

k <- ggplot(Phillies, title = "Phillies Hitting") + geom_point(aes(Year, OBP, color = "OBP")) +geom_point(aes(Year, SLG, color = "SLG"))
m <- k + labs( x = "Year", y = "Hitting Stats", colour = "Stats")
m + labs(title = "Phillies Hitting Stats")
m

#need to show vars I'm regressing are normally distributed by making histograms
#RS, RA, W

rs <- ggplot(Phillies) + geom_histogram(aes(RS), binwidth = 50, fill = "gray", color = "blue") 
rs <- rs + labs(title = "Runs Scored", x = "Runs Allowed")
rs

ra <- ggplot(Phillies) + geom_histogram(aes(RA), binwidth = 50, fill = "gray", color = "pink") 
ra <- ra + labs(title = "Runs Allowed", x = "Runs Allowed")
ra

w <-ggplot(Phillies) + geom_histogram(aes(W), binwidth = 3.5, fill = "gray", color = "red")
wins <- w + labs(title = "Wins", x = "Wins") 
wins

#Phillies wins over time
u <- ggplot(Phillies, aes(Year, W)) +geom_bar(stat = "identity", aes(Year, W, color = "Wins"))
u <- u + geom_bar(stat = "identity", aes(Year, RD, color = "Run Diff"))
u <- u + labs(x = "Year", y = "Wins", colour = "") + theme(legend.position="right")
u
summary(Phillies$W)

ggplot(Phillies, aes(RD, W)) +
  geom_point(aes(color = "cyl")) +
  theme(legend.position = "none")
  theme_bw()
  
rs <- ggplot(Phillies, aes(RS, OBP)) +
  geom_point()+
  geom_point(aes(SLG, color = "blue"))
  geom_point(aes(color = "cyl")) 
  theme(legend.position = "none")
rs

p <- ggplot(Phillies, aes(OBP, RS, color = "OBP")) + geom_point()
p <- p + geom_point(aes(SLG, RS, color = "SLG")) +
    labs(x = "Hitting Stats", y = "Runs Scored", colour = "Stats") +
    theme(legend.position="right")
p

summary(Phillies$OOBP)##26 NA's in this??
table(Phillies$Year, Phillies$OOBP)

  ggplot(Phillies, aes(RS, OBP + SLG)) +
    geom_point(aes(color = "cyl")) +
    theme(legend.position = "none")
  theme_bw()
table(Phillies$OSLG > 0, Phillies$Year)
  
  #Phillies linear regressions
Wins = lm(W ~ RD, data = Phillies)
summary(Wins)## this is great
#WinsModern = 81.459200 + (0.094913)RD

RunsScored = lm(RS ~ OBP + SLG, data = Phillies)
summary(RunsScored) #high significance but large error terms
#RS = -771.67 + 2706.01(OBP) + 1512.56(SLG)
#RS19 = 672.45

Recent = subset(Phillies, Year > 1998) #remove years w/o necessary stats
RunsAllowed = lm(RA ~ OOBP + OSLG, data = Recent)

summary(RunsAllowed) #high significance but large error terms
#RA = -731.3 + 2417(OOBP) + 1609.9(OSLG)
#RA19 = 687.7

summary(PhilliesModern$RD)
#RD: min = -172, med = 10, mean = 8.638, max = 213
#RD19 = -15.25

summary(PhilliesModern$W)
#Wins: min = 65, med = 84, mean = 82.46, max = 102
#actual RD = -51 for 2018 which puts the 2019 est at 76.6


########Nationals Regressions
nats = read.csv("nats.csv")
Nationals = subset(baseball, Team == "WSN" | Team =="MON")
summary(Nationals)
nats$RA.G = NULL
Nationals$RD = Nationals$RS - Nationals$RA
Nationals$Team = NULL
Nationals$League = NULL
Nationals$RankPlayoffs = NULL
Nationals$RankSeason = NULL
Nationals$Playoffs = NULL
nats$OPS = NULL
Nationals = rbind(nats, Nationals)

WinsWSN = lm(W ~ RD, data = Nationals)
summary(WinsWSN)## this is great
#WinsWSN = 80.945259 + (0.105271)RD
#Wins2019 = 90.31

RunsWSN = lm(RS ~ OBP + SLG, data = Nationals)
summary(RunsWSN) #great
#RS = -771.33 + 2794.15(OBP) + 1408.97(SLG)
#RS19 = 755.07

RunsAllowedWSN = lm(RA ~ OOBP + OSLG, data = Nationals)
summary(RunsAllowedWSN) #great
#RA = -845.4 + 2139.3(OOBP) + 2132.8(OSLG)
#RA19 = 697.15

summary(Nationals$RD)
#RD: min = -209, med = -4, mean = -22.61, max = 151
#RD19 = 57.92

###What does Bryce Harper bring to the table?
BryceHarperHitting = read.csv("BryceHarperHitting.csv")
summary(BryceHarperHitting)

bh <- ggplot(BryceHarperHitting, aes(OBP, R, color = "OBP")) + geom_point() +
  geom_point(aes(SLG, R, color = "SLG")) +
  labs(x = "Hitting Stats", y = "Runs Scored", colour = "Stats") +
  theme(legend.position="right")
bh

bh2 <- ggplot(BryceHarperHitting, aes(RBI, R, color = "RBI")) + geom_point() +
  geom_point(aes(TB, R, color = "TB")) +
  labs(x = "Hitting Stats", y = "Runs Scored", colour = "Stats") +
  theme(legend.position="right")
bh2


bh0 <- ggplot(BryceHarperHitting, aes(Year, R)) + geom_area() +
  labs(x = "Year", y = "Runs Scored") +
  theme(legend.position = "none")
bh0

cor(BryceHarperHitting$TB, BryceHarperHitting$RBI)
#=0.74

lm1 <- lm(R ~ TB, data = BryceHarperHitting)
lm2 <- lm(R ~ RBI, data = BryceHarperHitting)
lm3 <- lm(R ~ RBI + TB, data = BryceHarperHitting)

lm4 <- lm(R ~ OBP +SLG + TB + RBI, data = BryceHarperHitting)
lm5 <- lm(R ~ OBP + SLG + PA, data = BryceHarperHitting)

summary(lm1)
summary(lm2)
summary(lm3) #def the best espec related to Rsqr and significance

summary(lm4) #so bad with OBP + SLG and not much better isolating vars
summary(lm5) #this is the best so far!

#adding TB and RBIs helps but let's test for colinn
cov(BryceHarperHitting$SLG, BryceHarperHitting$OBP) #0.003
cov(BryceHarperHitting$SLG, BryceHarperHitting$TB) #2.98
cov(BryceHarperHitting$SLG, BryceHarperHitting$RBI) #1.15
cov(BryceHarperHitting$OBP, BryceHarperHitting$RBI) #0.69
cov(BryceHarperHitting$OBP, BryceHarperHitting$TB) #1.31

plot(lm4) #this looks better
summary(lm4$residuals) #mean = 0
var(lm4$residuals) #3.85
sd(lm4$residuals) #1.96
hist(lm4$residuals) #looks a little skewed
#testing for heterosced
lmtest::bptest(lm4) #p-value >> 0.05, df = 4
car::ncvTest(lm4) #p-value > 0.05, Df = 1, chisqr = 2.86
#given p-values of these tests, can accept null hyp 
#that there isn't heterosced
hist(lm4$residuals)

#check is resids are normally distrubuted (installed olsrr pckg)
ols_plot_resid_qq(lm4)
ols_test_normality(lm4) #why is CVM test so low? Everything else looks good
ols_test_correlation(lm4) #0.99
ols_plot_resid_hist(lm4) #this looks good; include

#check for variable independence (OBP +SLG + RBI + TB)



table(lm3$residuals)
hist(lm3$residuals)
a <- ggplot(lm3, aes(.resid))
a <- a + geom_histogram(binwidth = 0.5)
a
(sum(-6.19716905109543, -5.2910500278493, -0.69189586700307, -0.101733729348189, 0.835305790363549, 1.43619142282834, 3.40544805298794, 6.60490340911616))/8
# = -1.110223e-16
summary(r)
#tells us that mean = 0 and now check that sd = 1
sd = sd(r)
var = var(r)
n <- NULL
plot(var)
lmtest::bptest(lm3) #p-value < 0.05
car::ncvTest(lm3) #p-value >> 0.05
plot(lm3) #shows that residuals vs fitted are not random

BryceHarperHitting$OPS = BryceHarperHitting$OBP + BryceHarperHitting$SLG
r <- c(-6.19716905109543, -5.2910500278493, -0.69189586700307, -0.101733729348189, 0.835305790363549, 1.43619142282834, 3.40544805298794, 6.60490340911616)

RunsScoredHarper = lm(R ~ RBI + TB, data = BryceHarperHitting) #best so far
summary(RunsScoredHarper)
#Runs = -20.20948 + 0.36256RBI + 0.32104TB = (TB = 273, RBI = 100) 103 (dead on for 2018)

plot(BryceHarperHitting$OBP, type = "l")
BryceHarperHitting$R.G = BryceHarperHitting$R/BryceHarperHitting$G
BryceHarperHitting$OPS = BryceHarperHitting$OBP + BryceHarperHitting$SLG
BryceHarperHitting$BasesPerGame = BryceHarperHitting$TB/BryceHarperHitting$G

cor(BryceHarperHitting$R, BryceHarperHitting$TB)
plot(BryceHarperHitting$Year, BryceHarperHitting$BasesPerGame, type = "l")
plot(BryceHarperHitting$Year, BryceHarperHitting$TB, type = "l")
plot(BryceHarperHitting$Year, BryceHarperHitting$R.G, type = "l", xlab = "Year", ylab = "Runs per Game")



##Manny Machado
MannyMachado = read.csv("MachadoStats.csv")
summary(MannyMachado)
plot(MannyMachado$Year, MannyMachado$R, type = "l")
RunsScoredMachado = lm(R ~ OBP + SLG, data = MannyMachado)
summary(RunsScoredMachado)

##still no coeffs statistically significant >:(
#RunsScoredMacado = -176.5 + 381.3(.367) + 261.3(0.539) = 104

##Williams&Herrara
WilliamsHerrara = read.csv("WilliamHerraraStats.csv")
summary(WilliamsHerrara)
WilliamsHerrara$Herrara.G = NULL
RunsScoredWH = lm(R ~ OBP + SLG, data = WilliamsHerrara)
summary(RunsScoredWH)
##RS = -119.18 + 75.21OBP + 530.03SLG
##RS2019 = -119.18 + 75.21*0.328 + 530.03*0.422 = 129

##### Testing the model


# 1. Check for collinearity

summary(Wins) #just RD so no collin test necessary

summary(RunsScored)
cov(Phillies$SLG, Phillies$OBP) #0.00

summary(RunsAllowed)
cov(Recent$OSLG, Recent$OOBP)  #0.00

# 2. Check for heterskedacity
plot(Wins)
summary(Wins$residuals) #mean = 0
var(Wins$residuals) #14.23
sd(Wins$residuals) # sd = 3.77

plot(RunsScored)
summary(RunsScored$residuals) #mean = 0
var(RunsScored$residuals) #562.27
sd(RunsScored$residuals) # sd = 23.71

plot(RunsAllowed)
summary(RunsAllowed$residuals) #mean = 0
var(RunsAllowed$residuals) #557.89
sd(RunsAllowed$residuals) # sd = 23.62


# 3. Check is residuals are normally distrubuted (installed olsrr pckg)
ols_plot_resid_qq(Wins)
ols_test_normality(Wins) #why is CVM so low?
ols_test_correlation(Wins) #0.99
ols_plot_resid_hist(Wins)

summary(Wins$residuals)
skewness(Wins$residuals) #-0.24

ols_plot_resid_qq(RunsScored)
ols_test_normality(RunsScored) #all scores very low
ols_test_correlation(RunsScored) #0.96
ols_plot_resid_hist(RunsScored)

summary(RunsScored$residuals)
skewness(RunsScored$residuals) #-0.84

ols_plot_resid_qq(RunsAllowed)
ols_test_normality(RunsAllowed) #why is CVM so low?
ols_test_correlation(RunsAllowed) #0.99
ols_plot_resid_hist(RunsAllowed)

summary(RunsAllowed$residuals)
skewness(RunsAllowed$residuals) #-0.01
