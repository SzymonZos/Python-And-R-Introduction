library(shiny)

shinyUI(fluidPage(
  titlePanel("Iris clusters"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "slider",
        "Number of clusters",
        min=2,max=5,value=1
      )
    ),
    mainPanel(
      p("Clusterins results"),
      br(),
      tabsetPanel(
        tabPanel("Clustering",plotOutput("plot1",width=500)),
        tabPanel("Data",tableOutput("table"))
      )
    )
  )
))