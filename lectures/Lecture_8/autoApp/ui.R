library(shiny)
library(ISLR)

data(Auto)

splitNames <- strsplit(as.character(Auto$name), split=" ")

b <- c()
for(i in 1:length(splitNames)){
  b <- c(b,splitNames[[i]][1])
}

Auto$brand <- factor(b)

shinyUI(fluidPage(
  titlePanel("Auto dataset"),
  sidebarLayout(
    sidebarPanel(
      selectInput("brand",
                  "Choose the brand",
                  levels(Auto$brand)
      )
    ),
    
    mainPanel(
      p("Chosen car brand:"),
      br(),
      tabsetPanel(
        tabPanel("Graph", plotOutput("plot1", width = 500)),
        tabPanel("Summary", verbatimTextOutput("summary")),
        tabPanel("Data", tableOutput("table"))
      )
    )
  )
))