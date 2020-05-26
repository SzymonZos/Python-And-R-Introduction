library(shiny)
library(ISLR)
data(Hitters)

# 1
summary_keys <- factor(c("Min", "1st Qu", "Median", "Mean", "3rd Qu", "Max"))

# 2 and 4
league_keys <- factor(c("A", "N"))

# Define UI for application
shinyUI(fluidPage(

  titlePanel("Task 3"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("summary_key",
                  "Choose the stat of summary",
                  levels(summary_keys)
      ),
      selectInput("league_key",
                  "Choose the league",
                  levels(league_keys)
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", verbatimTextOutput("summary")),
        tabPanel("Plot", plotOutput("plot1", width = 600)),
        tabPanel("Number of players", tableOutput("table1")),
        tabPanel("Salaries", tableOutput("table2"))
      )
    )
  )
))
