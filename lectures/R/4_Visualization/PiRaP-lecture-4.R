	############################
##### PiRaP lecture 6 ######
##### Anna Papież     ######
############################

# Homework from lecture 5

library("ISLR")
data(Auto)
attach(Auto)

### Task 1
apply(Auto[,-9],2,mean)
apply(Auto[,-9],2,sd)

### Task2
aggregate(Auto[,-9], by=list(cylinders,year), FUN=mean)

### Task 3
library(dplyr)
sortedData <- arrange(Auto,desc(cylinders),mpg)

####################################################################

# Load ggplot package
library(ggplot2)

# Load package with data
library(ISLR)
data(Auto)
attach(Auto)

# Initialize a ggplot
g <- ggplot(Auto, aes(x=acceleration, y=mpg)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE)
plot(g)

# Zoom in on plot
g1 <- g + coord_cartesian(xlim=c(10,25),ylim=c(10,40))
plot(g1)


# Change titles
g1 + labs(title="Plot of mileage vs acceleration", 
          subtitle = "Auto data",
          x = "Acceleration",
          y = "MPG",
          caption = "ISLR dataset")

# Change marker size and color
g2 <- ggplot(Auto, aes(x=acceleration, y=mpg)) +
  geom_point(col="purple", size=3) +
  geom_smooth(method="lm", col="darkgreen",size=2) +
  coord_cartesian(xlim=c(10,25),ylim=c(10,40)) +
  labs(title="Plot of mileage vs acceleration", 
       subtitle = "Auto data",
       x = "Acceleration",
       y = "MPG",
       caption = "ISLR dataset")
plot(g2)

# Change color gradient
g3 <- ggplot(Auto, aes(x=acceleration, y=mpg)) +
  geom_point(aes(col=year), size=3) +
  geom_smooth(method="lm", col="darkgreen",size=2) +
  coord_cartesian(xlim=c(10,25),ylim=c(10,40)) +
  labs(title="Plot of mileage vs acceleration", 
       subtitle = "Auto data",
       x = "Acceleration",
       y = "MPG",
       caption = "ISLR dataset")

g3 + scale_color_gradient(low="green",high="red")

# Change axis tick density and labels
g3 + scale_x_continuous(breaks = seq(10,25,3), 
                        labels = function(x){paste0(x, 'm/s^2')})
g3 + scale_x_reverse()

# Change plot theme
g3 + theme_bw() + labs(subtitle="BW theme")


# Different regression model
g4 <- ggplot(Auto, aes(x=acceleration, y=mpg)) +
  geom_point(aes(col=year), size=3) +
  geom_smooth(method="loess", col="magenta", se=F) +
  coord_cartesian(xlim=c(10,25),ylim=c(10,40)) +
  labs(title="Plot of mileage vs acceleration", 
       subtitle = "Auto data",
       x = "Acceleration",
       y = "MPG",
       caption = "ISLR dataset")
plot(g4)

# Extra boxplots

library(ggExtra)
ggMarginal(g4, type="boxplot", fill="transparent")


# Correlogram
correl <- cor(Auto[,1:8])

library(ggcorrplot)

ggcorrplot(correl,
           type="lower",
           lab=TRUE,
           lab_size=3,
           method="circle",
           colors= c("pink","white","purple"))


# Deviation plot

# Extract car brand names
splitNames <- strsplit(as.character(Auto$name),
                       split=" ")
b <- NULL
for(i in seq_along(splitNames)){
  b <- c(b,splitNames[[i]][1])
}

Auto$brand <- factor(b)

# Calculate deviations from the mean                
uniqueAuto <- Auto[!duplicated(Auto$brand),]

meanMPG <- mean(uniqueAuto$mpg)

uniqueAuto$mpg_dev <- uniqueAuto$mpg -meanMPG
uniqueAuto$mpg_type <- ifelse(uniqueAuto$mpg_dev <0,
                              "below",
                              "above")
uniqueAuto <- uniqueAuto[order(uniqueAuto$mpg_dev),]
uniqueAuto$brand <- factor(uniqueAuto$brand, 
                            levels = uniqueAuto$brand)

# Deviation bar plot
ggplot(uniqueAuto, aes(x=brand, y=mpg_dev, labels=mpg_dev)) +
  geom_bar(stat="identity", aes(fill=mpg_type),width=0.5) +
  scale_fill_manual(name="Mileage",
                    labels=c("Above Average", "Below Average"),
                    values = c("above"="hotpink","below"="turquoise"))+
  coord_flip()
  
# Density plot

g6 <- ggplot(Auto, aes(mpg))
g6 + geom_density(aes(fill=factor(cylinders)), alpha=0.7)


# Boxplot

brand8 <- unique(Auto$brand)[1:8]
Auto8 <- Auto[!is.na(match(Auto$brand,brand8)),]

library(RColorBrewer)
g <- ggplot(Auto8,aes(brand,mpg))
g + geom_boxplot(fill=brewer.pal(8,"Set2"))+
  geom_dotplot(binaxis = 'y',
               stackdir="center",
               dotsize=0.5,
               fill="white")+
theme(axis.text = element_text(size=12))


# Fancy animation (may require installing dependencies)
library(gganimate)

g7 <- ggplot(Auto,aes(acceleration,mpg,colour=cylinders))+
  geom_point() +
  facet_wrap(~origin) +
  labs(title="Year: {closest_state}") +
  transition_states(year, transition_length = 2, 
                    state_length = 1)
animate(g7)


