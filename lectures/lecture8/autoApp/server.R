library(shiny)
library(ISLR)
library(ggplot2)

data(Auto)

splitNames <- strsplit(as.character(Auto$name), split=" ")

b <- c()
for(i in 1:length(splitNames)){
  b <- c(b,splitNames[[i]][1])
}

Auto$brand <- factor(b)

shinyServer(function(input, output){
  dat <- reactive({
    Auto[Auto$brand == input$brand,]
  })
  
  #mytable
  output$table <- renderTable({
    dat()
  })
  
  # plot
  output$plot1 <- renderPlot({
    tmp <- dat()
    ggplot(tmp, aes(x=acceleration, y=mpg, size=cylinders, color=weight)) +
      geom_point(alpha=0.8) +
      scale_size_continuous() +
      scale_color_distiller(palette = "Spectral") +
      labs(title="Car parameters")
  })
  
  #summary
  output$summary <- renderPrint({
    tmp <- dat()
    summary(tmp)
  })
}

)

