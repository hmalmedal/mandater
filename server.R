library(shiny)
library(dplyr)

mandatfordelingsdata <- read.csv("mandatfordelingsdata.csv",
                                 stringsAsFactors = F)

source("areal.R")
source("folkemengde.R")

fylker <- unique(mandatfordelingsdata$Fylke)

areal <- areal %>%
    mutate(fylkesnr = factor(fylkesnr,
                             levels = unique(fylkesnr),
                             labels = fylker)) %>%
    select(Fylke = fylkesnr, Areal = areal)

folk <- ungroup(folk) %>%
    mutate(region = factor(region,
                           levels = unique(region),
                           labels = fylker)) %>%
    select(Fylke = region, Folketall = folkemengde, Tid = tid)

arealfolk <- inner_join(folk, areal)

mandatfordelingsdata  <- mandatfordelingsdata %>%
    mutate(Fylke = factor(Fylke, levels = unique(Fylke), labels = fylker))
mandatfordelingsdata <- rbind(mandatfordelingsdata, arealfolk)

mandatfordelingsdata  <- mandatfordelingsdata %>%
    arrange(Tid, Fylke)

source("saintelague.R")

mandatfordelingsdata <- mandatfordelingsdata %>%
    group_by(Tid) %>%
    mutate(Mandater = saintelague(169, Folketall + 1.8 * Areal))

shinyServer(function(input, output) {
    tabell <- reactive({
        ungroup(mandatfordelingsdata) %>%
            filter(Tid == input$periode) %>%
            select(-Tid)
    })

    output$tabell <- renderDataTable({
        tabell()
    })

})
