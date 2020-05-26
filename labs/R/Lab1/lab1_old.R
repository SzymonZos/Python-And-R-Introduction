# Title     : Lab 1
# Objective : Passing labs (:
# Created by: szosgor
# Created on: 05.05.2020

rm(list = ls())
library("ISLR")
library(ggcorrplot)
data(Carseats)

check_us_superiority <- function(vector) {
    return(ifelse(sum(vector == "Yes") > 2 / 3 * length(vector), "Yes", "No"))
}

# Task 1
quantitative_variables <- data.frame(Carseats$Sales,
                                     Carseats$CompPrice,
                                     Carseats$Income,
                                     Carseats$Advertising,
                                     Carseats$Population,
                                     Carseats$Price,
                                     Carseats$Age,
                                     Carseats$Education)
qualitative_variables <- data.frame(Carseats$ShelveLoc,
                                    Carseats$Urban,
                                    Carseats$US)

# Task 2
pearson_correlation <- cor(quantitative_variables) # Pearson is default
correlation_plot <- ggcorrplot(pearson_correlation,
                               type = "lower", # show only one half of corr
                               lab = TRUE, # add corr. coeff. on the plot
                               lab_size = 5, # size of values on the plot
                               colors = c("blue", "white", "red")) # low - high
plot(correlation_plot)
sales_price_plot <- ggplot(Carseats, aes(x = Price, y = Sales)) + # aes, names
                    geom_point() + # add scatterplot
                    geom_smooth(method = "lm", col = "orange", se = FALSE) +
                    labs(title = "Carseats dataset",
                         subtitle = "Sales and Price correlation",
                         caption = "ISLR Dataset") # add missing labels
plot(sales_price_plot)

# Task 3; aggregate parameters in that oreder: x, by, FUN <- nice convetion
mean_price <- aggregate(Carseats$Price, list(Carseats$ShelveLoc), mean)
median_price <- aggregate(Carseats$Price, list(Carseats$ShelveLoc), median)
price_box_plot <- ggplot(Carseats,
                         aes(x = ShelveLoc,
                             y = Price,
                             fill = ShelveLoc)) + # add default colors
                         geom_boxplot()
plot(price_box_plot)

# Task 4
sales_df <- aggregate(Carseats$Sales, list(Carseats$Education), mean)
colnames(sales_df) <- c("education", "mean") # rename columns in data frame
temp <- aggregate(Carseats$Sales, list(Carseats$Education), sd)
sales_df$std_dev <- temp$x
temp <- aggregate(Carseats$US, list(Carseats$Education), check_us_superiority)
sales_df$us_superiority <- temp$x
sales_df <- sales_df[order(sales_df$std_dev), ]
std_dev_plot <- ggplot(sales_df,
                       aes(x = reorder(education, std_dev), y = std_dev)) +
                geom_bar(stat = "identity", aes(fill = us_superiority)) +
                labs(title = "Standard deviation and education",
                     x = "Education",
                     y = "Standard deviation",
                     fill = "US privilage") # add missing labels
plot(std_dev_plot)

# Task 5
sales_us_plot <- ggplot(Carseats, aes(Urban, Sales)) +
                 geom_violin(aes(fill = Urban)) +
                 labs(title = "Sales within US vs sales outside US") +
                 facet_wrap(Carseats$US, ncol = 2) +
                 scale_fill_brewer(palette = "Dark2")
plot(sales_us_plot)
