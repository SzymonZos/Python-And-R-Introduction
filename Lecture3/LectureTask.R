library('ISLR')

## XDDDDD to jest moje
test = Auto
# print(length(Auto))
for(variable in test) {
  if (is.numeric(variable[1])) {
    print(str('Mean: ', mean(variable)))
    print('Sd: ', sd(variable))
  }
}
## str is not string cast xDDDDDDDDDDDD

data("Auto")
attach(Auto)
head(Auto)
str(Auto)

min(Auto$mpg)
max(Auto$mpg)

mins = c()
maxs = c()
for (i in 1:8) {
  mins[i] = min(Auto[,i])
  maxs[i] = max(Auto[,i])
}

names(mins) = colnames(Auto[,1:8])
names(maxs) = colnames(Auto[,1:8])

library(matrixStats)
colMins(data.matrix(Auto[,-9]))
colMaxs(data.matrix(Auto[,-9]))
summary(Auto)

colSds(data.matrix(Auto[,-9]))
Auto1 = Auto[-c(10:85),]
summary(Auto1)
colSds(data.matrix(Auto1[,-9]))

plot(Auto[,-9], cex=3)
