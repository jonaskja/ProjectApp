

shinyServer(function(input, output) {
 
  Data <- read.csv2("Data.csv")
  
  output$caption <- renderText({
    paste(input$variable)
  })
  
  output$caption1 <- renderText({
    paste(input$binvar)
  })
  

output$Dataview <- renderDataTable({
  library(ggplot2)
  Data[, input$show_vars, drop = FALSE]
})
      
  
  output$histplot <- renderPlot({
    x    <- Data[, input$variable]
    
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(as.numeric(x), breaks=bins, col = 'lightgrey', border = 'white', main="", ylab="Number of units", xlab="Variable values")
  })
  output$binplot <- renderPlot({
    x    <- Data[,input$binvar]
    
    #bins <- seq(min(x), max(x))
    barplot(table(x), col = 'lightgrey', border = 'white', main="", ylab="Number of units", xlab="Variable values")
  })
  
  output$desc.table <- renderTable({
    desc.table <- cbind(
      round(apply(Data[,input$desctable],2,FUN=mean), 2),
      round(apply(Data[,input$desctable],2,FUN=sd, na.rm=T), 2), 
      round(apply(Data[,input$desctable],2,min, na.rm=T), 2),
      round(apply(Data[,input$desctable],2,max, na.rm=T), 2),
      colSums(is.na(Data[,input$desctable])))
    colnames(desc.table) <- c("mean", "s.d.","min","max", "missing")
    print(desc.table)
  })

  output$nbmodel.table <- renderTable({
    library(MASS)
    glm.nb(as.formula(paste(input$dependent," ~ ",paste(input$independent,collapse="+"))),data=Data)
  })

output$lmmodel.table <- renderTable({
  lm(as.formula(paste(input$dependent," ~ ",paste(input$independent,collapse="+"))),data=Data)
})

  output$downloadData <- downloadHandler(
      filename = function() {
        paste('data-', Sys.Date(), '.csv', sep='')
      },
      content = function(con) {
        write.csv2(Data, con)
      }
    )
  })
