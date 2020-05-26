library(shiny)

shinyServer(function(input,output){
  output$table <- renderTable({
    iris[iris$Species == input$Species,]
  })
}

)