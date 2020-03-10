# rm(list=ls())

#lists consist of vectors 

A = list(1, 2, 3)
B = list(1, 'abc', TRUE, list(2, 5))

subA = A[1] # list of one vector
subB = B[1:2] # list of two vectors

a = A[[1]] # vector
A[[1]] = 100

A[['xyz']] = 4 #adds 4th element and names it
A$xyz = 'xD' #nice

A = c(A, 123) #new element in list

t = proc.time()
n_reps = 10

n = 1000000
X = runif(n, 0, 1)
L = as.list(X)

for (r in 1:n_reps) {
  for(i in 1:n) {
    X[i] = 3*X[i]
  }
}

print((proc.time() - t) / n_reps)

t = proc.time()
n_reps = 10

n = 1000000
X = runif(n, 0, 1)
L = as.list(X)

for (r in 1:n_reps) {
  for(i in 1:n) {
    L[[i]] = 3*L[[i]]
  }
}

print((proc.time() - t) / n_reps) #twice as long access time in comparison to vector