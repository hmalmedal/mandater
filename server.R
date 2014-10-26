library(shiny)

source("mandatfordelingsdata.R")

shinyServer(function(input, output) {
  tabell <- reactive({
    mandatfordelingsdata %>%
      filter(Tid == input$periode) %>%
      select(-Tid)
  })

  output$tabell <- renderDataTable({
    tabell()
  })

})
