library(shiny)
library(dplyr)

mandatfordelingsdata <- read.csv("mandatfordelingsdata.csv",
                                 stringsAsFactors = F)

source("areal.R")
source("folkemengde.R")

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
