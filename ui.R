library(shiny)

shinyUI(fluidPage(

    titlePanel("Fordeling av stortingsmandatene"),

    sidebarLayout(
        sidebarPanel(
            selectInput("periode",
                        "Stortingsperiode",
                        list("2005–2013" = 2004,
                             "2013–2021" = 2012,
                             "2021–2029" = 2020,
                             "2029–2037" = 2028,
                             "2037–2045" = 2036))
        ),

        mainPanel(
            dataTableOutput("tabell")
        )
    )
))
