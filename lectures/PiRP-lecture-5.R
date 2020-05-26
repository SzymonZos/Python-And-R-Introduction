############################
##### PiRaP lecture 7 ######
##### Anna Papież     ######
############################

### Homework ###

library(ISLR)
library(ggplot2)

data(Auto)
attach(Auto)


# Extract car brand names
splitNames <- strsplit(as.character(Auto$name),
                       split=" ")
b <- NULL
for(i in seq_along(splitNames)){
  b <- c(b,splitNames[[i]][1])
}

Auto$brand <- factor(b)

brand8 <- unique(Auto$brand)[1:8]
Auto8 <- Auto[!is.na(match(Auto$brand,brand8)),]

#### Scatter plot

ggplot(Auto, aes(x=acceleration, y=mpg, size=cylinders, color=weight)) +
  geom_point(alpha=0.8) +
  scale_size_continuous() +
  scale_color_distiller(palette = "Spectral") +
  facet_wrap(~origin) +
  theme(axis.text=element_text(size=15)) + 
  theme(axis.title=element_text(size=20)) +
  labs(title="Car parameters by origin")

### Violin plot

ggplot(Auto8, aes(brand, mpg)) +
  geom_violin(aes(fill=brand ), trim=FALSE) +
  scale_fill_brewer(palette="Dark2") +
  theme(axis.text=element_text(size=8)) + 
  theme(axis.title=element_text(size=15))

### Circular barplot

library(dplyr)

meanAuto <- aggregate(Auto8[,1:8],list(Auto8$brand),mean)
names(meanAuto)[1] <- "brand"

ggplot(meanAuto, aes(fill=brand, y=mpg, x=1:dim(meanAuto)[1])) + 
  geom_bar(stat="identity", width = .9) +
  ylim(-10,40) +
  coord_polar() +
  scale_fill_brewer(palette="Accent") +
  scale_x_continuous(breaks = 1:8, expand = c(.005,0)) +
  theme_bw() +
  theme(axis.text.x=element_blank(), axis.text=element_text(size=15), axis.title=element_text(size=15)) +
  # theme(axis.text=element_text(size=8)) + 
  labs(title="Circular barplot for average MPG", x="")


#### Statistical analysis #####

### Probability distributions

x <- seq(-3,3,0.01)
f <- dnorm(x) # probability density function

plot(x,f,pch=19)

# Illustration of cumulative distrbution function
segments(x0 = seq(-3,-1.64,0.001), y0=0, 
         x1=,seq(-3,-1.64,0.001), y1=dnorm(seq(-3,-1.64,0.001)),
         col="red",lwd=4)

pnorm(-1.64) # cumulative distribution function
qnorm(0.05) # inverse cumulative distribution function

pts <- rnorm(10000) # random generator from standard normal distribution
hist(pts,50,add=T,col=rgb(0,0,1, alpha=0.5), freq = F)

### Statistical testing

sAuto <- subset(Auto, cylinders >=6)

# t-test
tt <- t.test(horsepower~cylinders, data=sAuto)

tt$statistic
tt$p.value # There is a significant difference in horsepower between cars with 6 and 8 cylinders

boxplot(horsepower~cylinders,data=sAuto) 

# Fisher's test

# Contingency table
teaTesting <- matrix(c(3,1,1,3), nrow = 2, 
          dimnames = list(Guess=c("Milk","Tea"),Truth=c("Milk","Tea")))

ft <- fisher.test(teaTesting) 
ft$p.value # The lady doesn't know her tea
ft$estimate


### Regression

xtr <- matrix(rnorm(100*100),ncol=100) # generate training set variables
xte <- matrix(rnorm(100000*100),ncol=100) # generate test set variables

beta <- c(rep(1,10),rep(0,90)) # vector of linear beta coefficients

ytr <- xtr%*%beta + rnorm(100) # calculate training response vector
yte <- xte%*%beta + rnorm(100000) # calculate test response vector


rsq <- c() # model fit metric - the higher, the better
trainerr <- c() # training set error - the lower, the better
testerr <- c() # test set error - the lower, the better

for(i in 2:100){
  mod <- lm(ytr~xtr[,1:i])
  rsq <- c(rsq,summary(mod)$r.squared)
  beta <- mod$coef[-1]
  intercept <- mod$coef[1]
  trainerr <- c(trainerr, mean((xtr[,1:i]%*%beta+intercept - ytr)^2))
  testerr <- c(testerr, mean((xte[,1:i]%*%beta+intercept - yte)^2))
}

par(mfrow=c(1,3))
plot(2:100,rsq, xlab='Number of Variables', ylab="R Squared", log="y") # R-squared increases with the number of variables
plot(2:100,trainerr, xlab='Number of Variables', ylab="Training Error",log="y") # Training error increases with the number of variables
plot(2:100,testerr, xlab='Number of Variables', ylab="Test Error",log="y") 
# Test error decreases only up to a certain point - best model should include only 10 variables
abline(v=10,col="red") # draw vertical line
graphics.off()

### Crossvalidation

library(boot)

xtr <- matrix(rnorm(100*100),ncol = 100) # generate data set
beta <- c(rep(1,10),rep(0,90))
ytr <- xtr%*%beta + rnorm(100)

cverr <- c()

for(i in 2:50){
  dat <- data.frame(x=xtr[,1:i],y=ytr)
  mod <- glm(y~.,data=dat)
  cverr <- c(cverr,cv.glm(dat,mod,K=6)$delta[1]) # perform 6-fold crossvalidation
}

plot(2:50, cverr, xlab="Number of Variables", ylab="6-Fold CV Error", log="y") 
# Cross-validation indicates the best model avoiding overfitting
abline(v=10, col="red")
