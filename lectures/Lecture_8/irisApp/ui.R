library(shiny)

shinyUI(fluidPage(
  titlePanel("Iris dataset"),
  p("Iris species"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "Species",
        "Select species",
        levels(iris$Species),
        "setosa"
      )
    ),
    mainPanel(
      p("Iris species data"),
      br(),
      tableOutput("table")
    )
  )
)
)