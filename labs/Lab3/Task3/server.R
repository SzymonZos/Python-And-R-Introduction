library(shiny)
library(ISLR)
library(ggplot2)
data(Hitters)

# 1
summary_keys <- factor(c("Min", "1st Qu", "Median", "Mean", "3rd Qu", "Max"))

# 3
no_players <- matrix(nrow = 2, ncol = 2)
rownames(no_players) <- c("Division W", "Division E")
colnames(no_players) <- c("League A", "League N")
no_players[1, 1] <- sum(Hitters$Division == "W" & Hitters$League == "A", na.rm = TRUE)
no_players[1, 2] <- sum(Hitters$Division == "W" & Hitters$League == "N", na.rm = TRUE)
no_players[2, 1] <- sum(Hitters$Division == "E" & Hitters$League == "A", na.rm = TRUE)
no_players[2, 2] <- sum(Hitters$Division == "E" & Hitters$League == "N", na.rm = TRUE)
no_players <- as.table(no_players)

# 4
hitters <- subset(Hitters, Salary >= 0)
salaries <- aggregate(hitters$Salary, list(hitters$League), mean)
colnames(salaries) <- c("Leagues", "Salaries")

# Define server logic
shinyServer(function(input, output) {
  
  # Summary
  output$summary <- renderPrint({
    tmp <- summary(Hitters)
    tmp[match(input$summary_key, summary_keys), ]
  })
  
  # Plot
  output$plot1 <- renderPlot({
    hitters <- subset(Hitters, League == input$league_key)
    salaries_runs_plot <- ggplot(hitters, aes(x = Runs, y = Salary)) + # aes, names
      geom_point(size = 2) + # add scatterplot
      facet_grid(. ~ Division)
    
    plot(salaries_runs_plot)
  })
  
  # Number of Players
  output$table1 <- renderTable({
    no_players
  })
  
  # Salaries
  output$table2 <- renderTable({
    which_league <- subset(salaries, Leagues == input$league_key)
  })
  
})
