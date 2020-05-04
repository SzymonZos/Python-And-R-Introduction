##############################################################################
# Type: matrix
# - extension of vector type,
# - can store any type of data,
# - all elements have to be of same type,
# - stored in a column-major order

rm( list = ls())

# initializing from data
A = matrix(data=c(1,2,3,4), nrow=2, ncol=2)                 # 2D 2x2 float array, elements initialized by columns
B = matrix(data=c(1L,2L,3L,4L), nrow=2, ncol=2, byrow=TRUE) # 2D 2x2 integer array, elements initialized by rows (always stored by columns)
print(A)
print(B)
D = matrix(data=c(1,2), nrow=1, ncol=2)               # 2D 1x2 row vector
E = matrix(data=c(1,2), nrow=2, ncol=1)               # 2D 2x1 column vector
F = array(data=seq(1,8), dim = c(2,2,2))    # 3D 2x2x2 array
print(F)


# special initialization
U = matrix(nrow=2, ncol=3)          # 2x3 NA array (float)
Z = matrix(data=0, nrow=2, ncol=3)  # 2x3 zeros array (float)
O = array(data=1, dim = c(1,2,3))   # 1x2x3 ones array (float)
I = diag(3)                         # 3x3 identity array (float)

# random matrices
m = 5
n = 3
U = matrix(data=runif(m*n,100,200), nrow=m, ncol=n) # m-by-n array, uniform distribution [100,200]
N = matrix(data=rnorm(m*n,2,10), nrow=m, ncol=n)    # m-by-n array, normal distribution (2,10)

# Accessing elements
# - getting submatrix creates a copy

A = matrix(data=seq(1,6), nrow=3, ncol=2, byrow=TRUE)
a = A[1,1]    # get an element
A[1,2] = 8    # set an element
A[5,1] = 6    # no autoextension
A[,1] = 5     # set a column
rowA = A[-1,]  # get a row copy as 1D vector
rowA[1] = 55  # does not modify A

B = A         # create a copy
B[1,1] = 7    # does not modify A

A = matrix(data=seq(1,100), nrow = 10, ncol = 10, byrow = TRUE)
rowA = A[3,]              # get row copy
colA = A[,2]              # get column copy
subA = A[seq(10,1,-3),seq(1,10,2)]

# Access times
n_reps = 1
m = 10000
A = matrix(data = runif(m*m,0,1), nrow=m, ncol=m)
B = A

# row-wise access
system.time(
  for (r in 1:n_reps){
    for (i in 1:m) {
      A[i,] = 2 * A[i,] 
    }
  })

# column-wise
system.time(
  for (r in 1:n_reps){
    for (i in 1:m) {
      B[,i] = 2 * B[,i] 
    }
  })

all(A == B)

# concatenation
A = matrix(data=c(1,2,3,4), nrow=2, ncol=2)                 # 2D 2x2 float array, elements initialized by columns
B = matrix(data=c(1L,2L,3L,4L), nrow=2, ncol=2, byrow=TRUE) # 2D 2x2 integer array, elements initialized by rows (always stored by columns)

vAB = rbind(A, B) # stack vertically
hAB = cbind(A, B) # stack horizontally

# reshape matrix
dim(hAB) = c(1,8)

# diagonals
A = matrix(data=seq(1,9), nrow = 3, ncol = 3)
D = diag(A) # dimensionality reduction: extract diagonal
X = diag(D) # dimensionality extension: build matrix from diagonal

diag(A) = 2 * D # set matrix diagonal

##############################################################################
# Type: list
# - like vector, but more flexible
# - every element can be of any type (array of pointers)

rm( list=ls())

A = list(1, 2, 3)         # list of three numerics
B = list(1, 'abc', TRUE, list(2,5))  # list of numeric, chr, logical, other list
subA = A[1]               # copy sublist of lengh 1
subB = B[1:2]             # copy sublist of length 2

a = A[[2]]                # get an element
A[[1]] = 100              # set an element

A[["xyz"]] = 4            # add an element with a string key
b = A[["xyz"]]            # get an element with a string key
c = A$xyz                 # alternative get syntax

A = c(A, 123)             # extend a list by an element
A = c(A, B)               # concatenate lists

n = 1000000
X=runif(n,0,1)
L = as.list(X)            # see the memory footprint

# Access time - vector
t = proc.time()
n_reps = 10
for (r in 1:n_reps) {
  for (i in 1:n) {
    X[i] = X[i] * 3
  }
}
print((proc.time() - t)/n_reps)

# Access time - list
t = proc.time()
n_reps = 10
for (r in 1:n_reps) {
  for (i in 1:n) {
    L[[i]] = L[[i]] * 3
  }
}
print((proc.time() - t)/n_reps)

###############################################################################

# Practice #1
install.packages("ISLR")
library(ISLR)

data("Auto")
attach(Auto)

head(Auto)
str(Auto)

min(Auto$mpg)
max(Auto$mpg)

mins <- c()
maxs <- c()
for(i in 1:8){
  mins[i] <- min(Auto[,i])
  maxs[i] <- max(Auto[,i])
}

names(mins) <- colnames(Auto[,1:8])
names(maxs) <- colnames(Auto[,1:8])

mins
maxs

library(matrixStats)
colMins(data.matrix(Auto[,-9]))
colMaxs(data.matrix(Auto[,-9]))

summary(Auto)

colMeans(data.matrix(Auto[,-9]))
colSds(data.matrix(Auto[,-9]))


Auto <- Auto[-(10:85),]
summary(Auto)
colSds(data.matrix(Auto[,-9]))

plot(Auto[,-9], cex.labels=3)



