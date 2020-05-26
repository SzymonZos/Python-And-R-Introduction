# Title     : Lab1
# Objective : Passing labs (:
# Created by: szosgor
# Created on: 05.05.2020

rm(list = ls())
library(ISLR)
library(ggcorrplot)
library(ggplot2)
library(dplyr)
data(Credit)
attach(Credit)

# Task 1
check_credit_compatibility <- function(vector) {
    for (i in seq_along(vector)) {
        if (Credit$ID[i] != vector[i]) {
            return("different")
        }
    }
    return("identical")
}

raw_credit <- apply(Credit, 2, check_credit_compatibility)
Credit$ID = as.character(Credit$ID)
character_credit <- apply(Credit, 2, check_credit_compatibility)
Credit <- Credit[character_credit == "different"]

# Task 2
quantitative_variables <- data.frame(Credit$Income,
                                     Credit$Limit,
                                     Credit$Rating,
                                     Credit$Cards,
                                     Credit$Age,
                                     Credit$Education,
                                     Credit$Balance)
pearson_correlation <- cor(quantitative_variables) # Pearson is default
correlation_plot <- ggcorrplot(pearson_correlation,
                               type = "lower", # show only one half of corr
                               lab = TRUE, # add corr. coeff. on the plot
                               lab_size = 5, # size of values on the plot
                               colors = c("green", "yellow", "red")) # l - h
plot(correlation_plot)
balance_limit_plot <- ggplot(Credit, aes(x = Balance, y = Limit)) +
                      geom_point(aes(col = Income)) + # add scatterplot
                      geom_smooth(method = "lm", col = "orange", se = FALSE) +
                      labs(title = "Credit dataset",
                           subtitle = "Balance and Limit correlation",
                           caption = "ISLR Dataset") # add missing labels
plot(balance_limit_plot)

# Task 3
mean_income <- aggregate(Credit$Income, list(Credit$Ethnicity), mean)
sd_income <- aggregate(Credit$Income, list(Credit$Ethnicity), sd)
income_plot <- ggplot(Credit, aes(Income)) +
               geom_density(aes(fill = factor(Ethnicity)), alpha = 0.7)
plot(income_plot)

# Task 4
sorted_by_balance_and_income <- Credit[order(Balance, desc(Income)), ]
print(paste("The oldest person under these conditions is",
            sorted_by_balance_and_income$Age[1]))

# Task 5
check_age <- function(scalar) {
    return(ifelse(scalar > 60, "Old", "Young"))
}

age <- sapply(list(Credit$Age), check_age)
Credit$BinaryAge <- factor(age)
quantitative_mean <- aggregate(quantitative_variables,
                               list(Credit$BinaryAge),
                               mean)

# Task 6
student_balance_box_plot <- ggplot(Credit,
                                   aes(x = Student,
                                       y = Balance,
                                       fill = Gender)) +
                            geom_boxplot() +
                            scale_fill_brewer(palette = "Accent") +
                            theme_bw() +
                            labs(title = paste("Credit card balance for",
                                               "students vs non-students"))
plot(student_balance_box_plot)
