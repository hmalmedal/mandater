library(shiny)

shinyUI(fluidPage(

  titlePanel("Fordeling av stortingsmandatene"),

  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "periode",
                  label = "Periode",
                  choices = list("2005–2013" = 2004,
                                 "2013–2021" = 2012,
                                 "2021–2029" = 2020,
                                 "2029–2037" = 2028,
                                 "2037–2045" = 2036),
                  selected = 2012),
      p("Dette er en oversikt over fordelingene av stortingsmandatene.
De to første periodene bruker de faktiske tallene for folketall og areal,
mens resten bruker Statistisk sentralbyrås framskrevne befolkningstall."),
      a(href = "https://github.com/hmalmedal/mandater", "GitHub")
    ),

    mainPanel(
      dataTableOutput("tabell")
    )
  )
))
