# rm(list=ls()) clears workspace

V = c(1, 2, 3, 4)
U = c(c(1, 2), c(3, 4))
print(U)
X = c('dupa', 'kupa', 'XD')
Y = c(123, TRUE, 'xyz')
Z = c(X, Y)
a = V[1]
V[3] = 10
V[10] = 69
print(is.na(V[5]))
length(V) = 20 # WTF?! what these guys had on mind?!
X[length(X)] = 12

W = V[c(1, 4)]
W[1] = 3.5

Z = c(1L, 2L)
Z[1] = 8.9
Z[2] = 'XDDDDD'

n = 5000000
r = 1.5
x1 = 0.5

system.time({
  X = x1
  for(i in 2:n) {
    X[i] = r * X[i-1] * (1 - X[i-1])
  }
})

system.time({
  Y = numeric(n) # preallocation
  Y[1] = x1
  for(i in 2:n) {
    Y[i] = r * Y[i-1] * (1 - Y[i-1])
  }
})

system.time({
  Z = numeric(n)
  Z[1] = zi = x1
  for(i in 2:n) {
    zi = (1 - zi) * r * Z[i - 1] # tu siê coœ zgubi³o, nie rozumiem tego pomys³u
    Z[i] = zi
  }
})

I = (X == Y)
J = (X == Z)
head(I, 15)
all(I)
all(J)

any(J)

#####################

V = c(1, 2, 3)
2 %in% V
c(3, 5) %in% V
names(V) <- c('A', 'B', 'C')
V['A'] #with names
V[['A']] # no names

coeffs = c(1, 2, 5, 10, 20, 50)
sizes = 10^5 * coeffs
subsetSize = 10^4
keys = as.character(1:10^4)
times = numeric()

# to nie dzia³a (:

for(i in 1:length(sizes)) {
  V = 1:sizes[i]
  names(V) = V
  X = sample(V)
  t0 = Sys.time()
  subV = V[keys]
  t1 = Sys.time()
  times[i] = as.numeric(t1, t0, units = 'secs')
}

dev.new(width=5, height=4, unit='in')
plot(log(sizes), log(times), type='o', col='red',
     xaxt='n', yaxtn='n',
     ylim=log(c(0.009, 1)))

axis(side=1, at=log(sizes), labels=FALSE)
xlabels=parse(text=paste(coeffs, "%*% 10^5 ", sep=''))

text(x=log(sizes), 
     y=par('usr')[3]*0.1, 
     labels=xlabels,
     srt=45,
     pos=1,
     xpd=TRUE)

# abline # nice

dev.off()

# (:

A = c(TRUE, FALSE)
B = c(TRUE, TRUE)
C = c(FALSE, TRUE)

A & B
A && B
A && C

