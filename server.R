library(shiny)

source("mandatfordelingsdata.R")

shinyServer(function(input, output) {

  output$tabell <- DT::renderDataTable({
    mandatfordelingsdata %>%
      filter(Tid == input$periode) %>%
      select(-Tid)
  },
  options = list(pageLength = 19))

})
