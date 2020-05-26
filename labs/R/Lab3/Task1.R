library(knitr)
library(shiny)

setwd("D:\\Projekty\\DataScience\\Python-And-R-Introduction\\labs")
load("Dmel.RData")

# Task 1
sequence <- chartr("ATCG","TAGC", dmel)
count <- matrix(0, nrow = length(dmel), ncol = 4)
for (i in 1:length(dmel)) {
  count[i, 1] <- lengths(regmatches(sequence[i], gregexpr("T", sequence[i])))
  count[i, 2] <- lengths(regmatches(sequence[i], gregexpr("A", sequence[i])))
  count[i, 3] <- lengths(regmatches(sequence[i], gregexpr("G", sequence[i])))
  count[i, 4] <- lengths(regmatches(sequence[i], gregexpr("C", sequence[i])))
}
