library(dplyr)
library(httr)
library(rjstat)
library(stringr)

source("valgdistrikt.R")

body <- list(
  query = list(
    list(
      code = "Region",
      selection = list(
        filter = "item",
        values = I(valgdistrikt$Kommunenummer)
      )
    ),
    list(
      code = "Tid",
      selection = list(
        filter = "top",
        values = I("1"))
    )
  ),
  response = list(format = "json-stat")
)

response <- POST("http://data.ssb.no/api/v0/no/table/09280", body = body,
                 encode = "json")

stop_for_status(response)

areal <- content(response, as = "text") %>%
  fromJSONstat(naming = "id") %>%
  getElement(1) %>%
  as_tibble() %>%
  select(Kommunenummer = Region, Areal = value) %>%
  full_join(valgdistrikt, by = "Kommunenummer") %>%
  group_by(Valgdistrikt) %>%
  summarise(Areal = as.integer(round(sum(Areal))))
