# Title     : Lab2
# Objective : Passing labs (:
# Created by: szosgor
# Created on: 12.05.2020

library(ISLR)
library(boot)
library(e1071)
library(ade4)
library(doParallel)
library(ggplot2)
library(viridis)
library(dplyr)

# Task 1
beers <- read.csv("labs/beer.csv", header = TRUE, sep = ",")
summer_winter <- t.test(consumption ~ (season == "summer" | season == "winter"),
                        data = beers)
summer_winter_diff <- summer_winter$p.value # 0.3564787 no statistical diffs.
boxplot(consumption ~ (season == "summer" | season == "winter"), data = beers)

week_weekend <- t.test(consumption ~ weekend, data = beers)
week_weekend_diff <- week_weekend$p.value # 2.131289e-22 statistically sign. diffs.
boxplot(consumption ~ weekend, data = beers)

may_june <- t.test(medium_temp ~ (month == 5 | month == 6), data = beers)
may_june_diff <- may_june$p.value # 9.585879e-19 statistically sign. diffs.
boxplot(medium_temp ~ (month == 5 | month == 6), data = beers)

# Task 2
sample_size <- 0.8 * nrow(beers)
set.seed(69)
train_indeces <- sample(seq_len(nrow(beers)), size = sample_size)
train <- beers[train_indeces, ]
test <- beers[-train_indeces, ]

model_min_temp <- lm(consumption ~ min_temp, data = train)
model_max_temp <- lm(consumption ~ max_temp, data = train)
model_med_temp <- lm(consumption ~ medium_temp, data = train)

rsq_min_temp <- summary(model_min_temp)$r.squared
beta_min_temp <- model_min_temp$coef[-1]
intercept_min_temp <- model_min_temp$coef[1]

rsq_max_temp <- summary(model_max_temp)$r.squared
beta_max_temp <- model_max_temp$coef[-1]
intercept_max_temp <- model_max_temp$coef[1]

rsq_med_temp <- summary(model_med_temp)$r.squared
beta_med_temp <- model_med_temp$coef[-1]
intercept_med_temp <- model_med_temp$coef[1]

testerr_min <- mean((test$min_temp * beta_min_temp +
    intercept_min_temp - test$consumption) ^ 2)
testerr_max <- mean((test$max_temp * beta_max_temp +
    intercept_max_temp - test$consumption) ^ 2)
testerr_med <- mean((test$medium_temp * beta_med_temp +
    intercept_med_temp - test$consumption) ^ 2)
# max is the best

# Leave-one-out crossval
dat <- data.frame(x = beers$max_temp, y = beers$consumption)
mod <- glm(y ~ ., data = dat)
loo_err <- cv.glm(dat, mod)$delta[1] # perform LOO crossvalidation
fold_err <- cv.glm(dat, mod, K = 10)$delta[1] # perform crossvalidation 10 fold
print(loo_err)
print(fold_err)

# Task 3
sub_beers <- subset(beers, season == "autumn" | season == "summer")
sub_beers$season <- droplevels(sub_beers$season)
levels(sub_beers$season) <- c(0, 1) #  0 - "autumn" and 1 - "summer"
sample_size <- floor(0.8 * nrow(sub_beers))

train_indeces <- sample(seq_len(nrow(sub_beers)), size = sample_size)
train <- sub_beers[train_indeces, ]
test <- sub_beers[-train_indeces, ]
regress <- glm(as.factor(sub_beers$consumption) ~ as.factor(sub_beers$min_temp),
               data = sub_beers, family = "binomial")

rsq_min_temp <- summary(regress)$r.squared
beta_min_temp <- regress$coef[-1]
intercept_min_temp <- regress$coef[1]
testerr2_min <- mean((test$min_temp * beta_min_temp +
    intercept_min_temp - test$consumption) ^ 2)

x <- sub_beers$min_temp
x <- cbind(x, sub_beers$consumption)
dat <- data.frame(x = x, y = as.factor(sub_beers$season))
svmfit <- svm(y ~ ., data = dat, kernel = "radial", cost = 10, scale = F)
plot(svmfit, dat)

rsq_min_temp <- summary(svmfit)$r.squared
beta_min_temp <- svmfit$coef[-1]
intercept_min_temp <- svmfit$coef[1]
testerr3_min <- mean((test$min_temp * beta_min_temp +
    intercept_min_temp - test$consumption) ^ 2)

# Task 4
fish <- read.csv("labs/fish.csv", header = TRUE, sep = ",")
labels <- colnames(fish)
labels <- as.vector(as.matrix(labels))
levels(fish$Species) <- c(0, 1, 2, 3, 4)

fish <- t(fish)
my_dist <- dist(fish)

plot(hclust(my_dist, method = "average"), labels = labels,
     main = "average", col = "darkgreen")

fish <- read.csv("labs/fish.csv", header = TRUE, sep = ",")
cl <- kmeans(fish[, c(6,7)],5)
kmeans_res <- factor(cl$cluster)
plot(fish[, c(6,7)], col = fish$Species, cex = 3)
s.class(fish[, c(6,7)], fac = kmeans_res, add.plot = T, col = viridis(5))
# These two variables are not sufficient to obtain satisfactory grouping

# Task 5
# Library doParallel is not working properly under my environment
# so I decided to split this task into 2 subtasks
# Comapring kmeans:

tcga <- read.csv("labs/tcga.csv", header = TRUE, sep = ",")
for (i in 2:10) {
    cl[[i - 1]] <- kmeans(tcga, i)
    #kmeans_res[[i - 1]] <- factor(cl$cluster)
}

min <- 999999999999999
for (i in seq_along(cl)) {
    if(cl[[i]]$tot.withinss < min) {
        min <- cl[[i]]$tot.withinss
        index <- i
    }
}
# For the 10 clusters tot.withinss is minimal

### Second subtask is commented out because I could not test it
## Parallel
#cluster <- makeCluster(2)
#registerDoParallel(cl)
#ptime <- system.time({
#    r <- foreach(i = 2:10, .combine = cbind) %dopar% {
#        cl[[i]] <- kmeans(tcga, i)
#    }
#})
#stopCluster(cluster)
#ptime[3]

## Sequential
#cl <- makeCluster(2)
#registerDoParallel(cluster)
#stime <- system.time({
#    r <- foreach(i = 2:10, .combine = cbind) %do% {
#        cl[[i]] <- kmeans(tcga, i)
#    }
#})
#stopCluster(cluster)
#stime[3]

# I suppose that for parallel operations time is minimal
