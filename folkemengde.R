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
      code = "ContentsCode",
      selection = list(
        filter = "item",
        values = I("Personer"))
    ),
    list(
      code = "Tid",
      selection = list(
        filter = "item",
        values = I(c("2020", "2028", "2036")))
    )
  ),
  response = list(format = "json-stat")
)

response <- POST("http://data.ssb.no/api/v0/no/table/11668", body = body,
                 encode = "json")

stop_for_status(response)

folk <- content(response, as = "text") %>%
  fromJSONstat(naming = "id") %>%
  getElement(1) %>%
  as_tibble() %>%
  mutate_at(vars(Tid), funs(as.integer)) %>%
  select(Kommunenummer = Region, Tid, Folketall = value) %>%
  inner_join(valgdistrikt, by = "Kommunenummer") %>%
  group_by(Valgdistrikt, Tid) %>%
  summarise(Folketall = as.integer(sum(Folketall, na.rm = TRUE)))
