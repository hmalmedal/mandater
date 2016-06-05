library(dplyr)
library(httr)
library(jsonlite)
library(rjstat)

q <- list(
  query = list(
    list(
      code = unbox("Region"),
      selection = list(
        filter = unbox("item"),
        values = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
                   "11", "12", "14", "15", "16", "17", "18", "19", "20")
      )
    ),
    list(
      code = unbox("Tid"),
      selection = list(
        filter = unbox("top"),
        values = "1")
    )
  ),
  response = list(format = unbox("json-stat"))
)

q <- toJSON(q)

r <- POST("http://data.ssb.no/api/v0/no/table/09280", body = q)

areal <- content(r, as = "text") %>%
  fromJSONstat(use_factors = TRUE) %>%
  getElement(1) %>%
  mutate(Areal = round(value)) %>%
  select(Fylke = region, Areal)
