############################
##### PiRaP lecture 9 ######
##### Anna Papież     ######
############################

### Homework ####

# Part 1
#1
pbinom(4,size=10,prob=0.25)

#2

library(ISLR)

data(Auto)
attach(Auto)

# Extract car brand names
splitNames <- strsplit(as.character(Auto$name),
                       split=" ")
b <- c()
for(i in 1:length(splitNames)){
  b <- c(b,splitNames[[i]][1])
}

Auto$brand <- factor(b)

dtAuto <- subset(Auto,brand=="dodge" | brand=="toyota")

t.test(mpg~brand,data=dtAuto)


# Part 2
# Crossvalidation

train <- sample(392,196)
lm.fit <- lm(mpg~horsepower,data = Auto,subset=train)

mean((mpg-predict(lm.fit,Auto))[-train]^2)

# LOO

library(boot)
glm.fit <- glm(mpg~horsepower,data=Auto)

loocv <- cv.glm(Auto,glm.fit)
loocv$delta

# K-fold crossvalidation

kfold <- c()
for(i in 1:5){
  glm.fit <- glm(mpg~poly(horsepower,i),data=Auto)
  kfold[i] <- cv.glm(Auto,glm.fit,K=10)$delta[1]
}

### Logistic regression

# Auto data subset - only Fords and Chevrolets
fcAuto <- subset(Auto,brand=="ford" | brand=="chevrolet")
fcAuto$brand <- droplevels(fcAuto$brand) # drop all the unused levels
levels(fcAuto$brand)
levels(fcAuto$brand) <- c(0,1) # transform levels to 0 "chevrolet" and 1 "ford"
levels(fcAuto$brand)

# Logistic regression model fit
mod <-glm(brand~mpg+horsepower+acceleration,data=fcAuto,
          family="binomial")

# Is my car more likely a ford or a chevrolet?
mycar <- data.frame(mpg=15,horsepower=133, acceleration=8)
predict(mod,mycar)


### Support Vector Machine

library(e1071)
set.seed(104) # this ensures the same random result every time you start the code

x = matrix(rnorm(20*2),ncol=2) # generate dataset
y=c(rep(-1,10),rep(1,10)) # category vector

dat = data.frame(x=x, y=as.factor(y)) # transform data matrix to data frame

# Run SVM classification with a linear kernel, cost of a violation 10 and without data scaling
svmfit = svm(y~.,data=dat,kernel="linear",cost=10,scale=F)
# Plot classification results
plot(svmfit,dat)
# Red markers belong to one class, black ones to the other
# The brown area shows SVM prediction for one class, yellow for the other
# Circles represent simple data points, 
# x markers represent support vectors - the points which participate in forming the separating hyperplane



### Hierarchical clustering ###


mydata <- read.table("nci.data")
mydata <-t(mydata)
mydata <- scale(mydata, center=F, scale=T)

labels <- read.table("nci.info", skip=20)
labels <- as.vector(as.matrix(labels))

mydist <- dist(mydata)

par(mfrow=c(1,3))
plot(hclust(mydist), labels=labels, main="Complete", col="darkgreen")
plot(hclust(mydist,method="average"), labels=labels, main="Average", col="blue")
plot(hclust(mydist, method="single"), labels=labels, main="Single", col="orange")
graphics.off()

### K-means clustering ###

library(ade4)

cl <- kmeans(iris[,c(1,2)],3)
kmeansRes <- factor(cl$cluster)

plot(iris[,c(1,2)],col=iris$Species,cex=3)

library(viridis)

s.class(iris[,c(1,2)],fac=kmeansRes, add.plot = T, col=viridis(3))



### Parallelization ###

library(doParallel)

x <- iris[which(iris[,5] != "setosa"), c(1,5)]
trials <- 10000

# Parallel
cl <- makeCluster(2)
registerDoParallel(cl)
ptime <- system.time({
  r <- foreach(icount(trials), .combine = cbind) %dopar% {
    ind <- sample(100,100, replace=TRUE)
    result1 <- glm(x[ind,2]~x[ind,1], family = binomial(logit))
    coefficients(result1)
  }
})
stopCluster(cl)
ptime[3]

# Sequential
cl <- makeCluster(2)
registerDoParallel(cl)
stime <- system.time({
  r <- foreach(icount(trials), .combine = cbind) %do% {
    ind <- sample(100,100, replace=TRUE)
    result1 <- glm(x[ind,2]~x[ind,1], family = binomial(logit))
    coefficients(result1)
  }
})
stopCluster(cl)
stime[3]


#### Easter card ####

library(onion)
library(rgl)

data("bunny")

bg3d(texture = "~/Desktop/meadow.png", col = "white")
plot3d(bunny[,c(3,1,2)],col = "pink", axes=F, xlab = "", ylab="", zlab="")
if (!rgl.useNULL()) movie3d(spin3d(axis = c(0, 0, 1), rpm = 10), duration = 10, movie="~/Desktop/easter.gif")





