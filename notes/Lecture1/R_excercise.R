rm(list = ls())
someDouble = 1 # by default double
someInt = 10L

x <- 3.14 # <- is an assignment operator in R
someString <- 'abcd'
someBool <- TRUE
someBool2 <- T

typeof(someString)

print(x / someInt) # double is a result
print(x %/% someInt) # int is a result
print(c(someInt, someBool, someString))

print(paste0(someString, ' XD'))
print(paste0(rep(someString, 4)))

print(is.integer(someInt))


id = 0
if (id > 0) {
  x = 1
  y = 1
} else if (id == 0) {
  x = 2
  y = 2
} else {
  x = 3
}

dupa = sprintf('%s xd %d dupa', someString, someInt)
s = readline('xxxxd')
age = strtoi(s)

if (is.na(age)) { # not a number
  print('elo')
} else {
  print(paste0('number: %d'), age)
}

# importing external packages: library()
# installing -||-: install.packages()