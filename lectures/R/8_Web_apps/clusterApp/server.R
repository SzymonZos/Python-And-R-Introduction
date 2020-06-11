library(shiny)


shinyServer(function(input, output) {
  library(ade4)
  
  # reactive clustering
  kmeansRes <- reactive({
    cl <- kmeans(iris[,c(1,2)],input$slider)
    return(cl$cluster)
  })
  
  # data table
  output$table <- renderTable({
    iris[,c(1,2,5)]
  })
  
  output$plot1 <- renderPlot({
    plot(iris[,c(1,2)],col=iris$Species,cex=3)
    library(viridis)
    s.class(iris[,c(1,2)],fac=factor(kmeansRes()), add.plot = T, col=viridis(input$slider))
  })
  
})
