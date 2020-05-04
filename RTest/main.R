# Title     : TODO
# Objective : TODO
# Created by: szosgor
# Created on: 01.05.2020

library(ISLR)
library(ggplot2)
library(ggcorrplot)
library(RColorBrewer)
library(dplyr)

# Relation:             < > <= >= == !=
# Assignment:           = <- <<- -> ->>
# Special:              %in%
rm(list = ls())
i <- 10L
x <- 40.0
s <- 'abc'

print(i / 4L)      # 2.5 - floating-point division
print(i %/% 4)	 # 2 - integer division
print(i/4.0)     # 2.5
print(c(i,x,s)) # 10 10 abc
print(paste0(s,'xyz'))  # abcxyz
print(paste0(rep(s,2))) # abcabc
print(is.integer(i)) # True
print(typeof(s)=='logical') # False
q <- as.integer(3.7) # narrowing conversion
j <- as.integer('123') # conversion
k <- as.integer('123.55') # conversion

# --------------------------------------------------------------------
# Code organization
#
# Blocks defined by braces
id <- 4
if (id > 0) {
  x <- 1
  y <- 1
} else if (id == 0) {
  x <- 2; y <- 3
} else if (id < 0)
  x <- 3 else x <- 4


# --------------------------------------------------------------------
# Input and output

age <- 44
name <- 'Peter'
avg <- 4.333333

# formatted output
c <- sprintf('%s is %d years old and has an average grade of %.2f', name, age, avg)
print(c)

# string input (interactive)
s <- readline('How old are you?')

# string input (script)
# print('How old are you?')
# a <- readLines("stdin",n=1) BUGGED XD

# manual conversion
age <- strtoi(s)

if (is.na(age)) {
  print('Parsing error')
} else {
  print(paste0('You are ', age))
}
