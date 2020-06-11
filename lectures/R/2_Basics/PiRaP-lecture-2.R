library(ggplot2)
library(lintr)

# no explicit return value
# return the last statement
display <- function(x) {
    print(x)
}

# explicit return
sqr <- function(x) {
    return(x * x)
}

# function that does nothing
do_nothing <- function(x) {
    NULL
}

b <- display("abc") # b is "abc’
p <- sqr(2) # p is 4

# default and named arguments
fun <- function(x, y=10, s="abc") {
    print(paste(x, y, s))
}

fun(0) # same as fun(0, 10, "abc")
fun(1, 3.14, "xyz")
fun(2, s = "PS") # named argument - fun(2, 10, PS")
fun(y = 4, x = 1) # named arguments - fun(1, 4, "abc")
fun(5, x = 1) # strange order, but ok - fun(1, 5, "abc")

fun2 <- function(x = 1, y) { # non-default may follow default
    x + y
}
fun2(y = 3) # same as fun2(1, 3)

# Iterate over collection
vector <- c("a", "b", "c") # vector def.
for (element in vector) {
    print(element)
}

# Iterate over range (right included)
for (i in 0:9) {
    print(i)
}

# while loop
i <- 10
while (i > 0) {
    print(i)
    i <- i - 1
}

# 100, 95, ..., 5, 0
for (i in seq(100, 0, -5)) {
    print(i)
}

# reversed collection
for (element in rev(vector)) {
    print(element)
}

# break, next
for (i in 0:99) {
    if (i == 50) {
        break # break the loop
    }
    if (i %% 2 == 1) {
        next # next iteration
    }
    print(i)
}

rm(list = ls())

##############################################################################
# Type: vector
# - represents a 1-dimensional array
# - 1-based indexing
# - can store any type of data
# - all elements have to be of same (basic) type

vector <- c(1, 2, 3, 4) # four-element numeric vector
vector2 <- c(c(1, 2), c(2, 4)) # another four-element numeric vector


char_vector <- c("abc", "pqr", "abracadabra")  # chr vector
cast_vector <- c(123, TRUE, "xyz") # type conversion: chr vector
cat_vector <- c(char_vector, cast_vector) # six element vector

a <- vector[1] # get an element
vector[3] <- 10 # set an element
vector[10] <- 15 # automatic extension (unknown values filled with NA)
is.na(vector[5])
length(vector)
length(vector) <- 100 # extension
char_vector[length(char_vector)] <- 12 # set the last element

subvector<- vector[c(1, 3)] # get a subvector (copy)
subvector[1] <- 3.14   # does not modify V

int_vector <- c(1L, 2L)     # integer vector
int_vector[1] <- 6.7        # type conversion: numeric
int_vector[2] <- "qwerty"   # type conversion: chr

# Task: calculate 5 * 10^6 elements of a logistic map
# variant 1: automatic extension
n <- 50000000
r <- 1.5
x1 <- 0.5

system.time({
                char_vector <- x1
                for (i in 2:n) {
                    char_vector[i] <- r * char_vector[i-1] *
                        (1 - char_vector[i-1])
                }
            })

# variant 2: with preallocation
system.time({
                cast_vector <- numeric(n)
                cast_vector[1] <- x1
                for (i in 2:n) {
                    cast_vector[i] <- r * cast_vector[i-1] *
                        (1 - cast_vector[i-1])
                }
            })

# variant 3: less memory accesses
system.time({
                int_vector <- numeric(n)
                int_vector[1] <- zi <- x1
                for (i in 2:n) {
                    zi <- r * zi * (1 - zi)
                    int_vector[i] <- zi
                }
            })

# logical vector
I <- (char_vector == cast_vector)
J <- (char_vector == int_vector)

# check if all/any elements are true
all(I)
all(J)
any(I)

I[1] <- FALSE

all(I)
any(I)

# checking if element is in vector
rm(list = ls())
vector <- c(1, 2, 3)
2 %in% vector
c(3, 5) %in% vector

# Naming elements
names(vector) <- c("A", "B", "C") # set names
print(vector)
x <- vector["B"]                  # get named number
y <- vector[["B"]]                # get unnamed number


# Vector naming performance
rm(list = ls())
coeffs <- c(1, 2, 5, 10, 20, 50)
sizes <- 10^5 * coeffs
subsetSize <- 10^4
keys <- as.character(1:subsetSize)

times <- numeric()

for (i in seq_along(sizes)) {
    vector <- 1:sizes[i]
    names(vector) <- vector
    char_vector <- sample(vector)
    t0 <- Sys.time()
    subV <- vector[keys]
    t1 <- Sys.time()
    times[i] <- as.numeric(t1 - t0, units="secs")
}

# plot example
dev.new(width=5, height=4, unit="in")         # create new window
plot (log(sizes), log(times),                 # plot arguments and values in logarithmic scale
      type="o",                               # lines and points
      col="blue",
      xaxt="n", yaxt="n",                     # suppress the axes
      xlab = expression(paste("array size ", italic(N))),     # use math notation 
      ylab = expression(paste(delta, italic(t), " [s]")),
      ylim = log(c(0.009,1))
)

# format X axis
axis(side=1, at=log(sizes), labels = FALSE)            # add ticks
xlabels <- parse(text= paste0(coeffs, "%*% 10^5 "))  # format tick labes with math notation
text(
    x = log(sizes),          # horizontal ticks coordinates
    y = par("usr")[3] - 0.1, # y coordinate of horizontal axis
    labels = xlabels,        # tock
    srt = 45,      # rotation in degrees
    pos = 1,       # text below coordinate
    xpd = TRUE
)    # clipping to the figure region (not plot region)

# format Y axis
yticks <- c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1.0)
axis(side=2, at=log(yticks), labels = FALSE)
text(
    x = par("usr")[1], # x coordinate of vertical axis
    y = log(yticks),   # vertical ticks coordinates
    labels = yticks,
    pos = 2,
    xpd = TRUE
)

# grid lines
abline(v = log(sizes), lty = 6)
abline(h = log(yticks), lty = 6)

dev.off()

# alternative - write to file
pdf("../chart.pdf", width=5, height=4)
# ploting
dev.off()

# logical operators
A <- c(TRUE, FALSE)
B <- c(TRUE, TRUE)
C <- c(FALSE, TRUE)

A & B # per-element logical operator
A && B # first-element logical operator
A && C # first-element logical operator
