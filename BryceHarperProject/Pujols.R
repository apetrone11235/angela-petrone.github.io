## Pujols

PujolsBatting <- read.csv("PujolsBatting.csv")
summary(PujolsBatting)

plot(PujolsBatting$R)
AP1 <- ggplot(PujolsBatting, aes(Year, R, color = "R")) + geom_point() +
  labs(x = "Year", y = "Runs Scored", colour = "Stats") +
  theme(legend.position = "none")
AP1

BA <- lm(R ~ BA, data = BryceHarperHitting)
summary(BA)

BryceHarperHitting$TotalWalks = BryceHarperHitting$IBB + BryceHarperHitting$BB
TW <- ggplot(BryceHarperHitting, aes(Year, TotalWalks)) + geom_line() +
  labs(x = "Year", y = "Total Walks") +
  theme(legend.position = "none")
TW
