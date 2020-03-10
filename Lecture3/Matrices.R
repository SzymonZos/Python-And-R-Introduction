A = matrix(data = c(1, 2, 3, 4), nrow=2, ncol=2) # by columns
B = matrix(data = c(1, 2, 3, 4), nrow=2, ncol=2, byrow=T) # by rows

D = matrix(data = c(1, 2, 3, 4), nrow=4, ncol=1)
E = matrix(data = c(1, 2, 3, 4), nrow=1, ncol=4)

F = array(data=seq(1,8), dim=c(2,2,2)) #multiple dimension matrices must be arrays

U = matrix(nrow=2, ncol=2) # NA values
Z = matrix(data=0, nrow=2, ncol=2) # Zero init
I = array(data=1, dim=c(2,2,2)) # Ones
Id = diag(3) # "eye'

m = 5
n = 4

U = matrix(data=runif(m*n, 100, 200), nrow=m, ncol=n) # rng unifrom distribution
N = matrix(data=rnorm(m*n, mean=2, sd=4), nrow=m, ncol=n) # rng normal distribution

A = matrix(seq(1,6), nrow = 3, ncol = 2, byrow = T)
A[1,1] # operator[] as in c++ except you can [1,1] instead of [0][0]
A[1,2] = 8
# A[5,1] = 7 # out of bonds error; in vector one can, matrix cannot
A[,1] = 5 # first row
A2 = A[-2,] # exclude row 2 with operator-

n_reps = 1
m = 10000
A = matrix(runif(m*m, 0, 1), nrow = m, ncol = m)
B = A
system.time(
  for (r in 1:n_reps) {
    for (i in 1:m) {
      A[i,] = 2*A[i,]
    }
  }
)

system.time( #access by columns is faster
  for (r in 1:n_reps) {
    for (i in 1:m) {
      B[,i] = 2*B[,i]
    }
  }
)

M = matrix(c(1,2,3,4), nrow = 2, ncol = 2)
N = matrix(c(5,6,7,8), nrow = 2, ncol = 2)

vMN = rbind(M, N)
hMN = rbind(M, N)

dim(hMN) = c(1, 8)
