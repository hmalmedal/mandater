library(shiny)

source("mandatfordelingsdata.R")

shinyServer(function(input, output) {

  output$tabell <- renderDataTable({
    mandatfordelingsdata %>%
      filter(Tid == input$periode) %>%
      select(-Tid)
  })

})
