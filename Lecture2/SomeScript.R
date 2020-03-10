library(class)

display <- function(x) {
  print(x)
}

sqr <- function(x) {
  return(x*x)
}

doNothing <- function(x) {
  NULL
}

fun <- function(x, y=10, s='abf') {
  print(paste(x, y, s))
}

fun2 <- function(x=1, y) {
  x + y
}

a = 3
display(a)
sqr(a)
display(a)
fun(0)
fun(5, 8)
fun(6, 9, '420')
fun(8.8, s='XDDD')
fun(5, x=1)
fun2(y=3)