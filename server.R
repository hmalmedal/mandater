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

pre2004 <- c(8, 15, 16, 8, 7, 7, 8, 6, 4, 5, 11, 17, 5, 10, 10, 6, 12, 6, 4)

mandatfordelingsdata <- ungroup(mandatfordelingsdata) %>%
    mutate(Endring = diff(c(pre2004, Mandater), lag = 19))

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
