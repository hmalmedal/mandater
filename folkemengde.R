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
      code = unbox("ContentsCode"),
      selection = list(
        filter = unbox("item"),
        values = "Personer")
    ),
    list(
      code = unbox("Tid"),
      selection = list(
        filter = unbox("item"),
        values = c("2020", "2028", "2036"))
    )
  ),
  response = list(format = unbox("json-stat"))
)

q <- toJSON(q)

r <- POST("http://data.ssb.no/api/v0/no/table/10213", body = q)

folk <- content(r, as = "text") %>%
  fromJSONstat(use_factors = TRUE) %>%
  getElement(1) %>%
  mutate(Tid = år %>% as.character() %>% as.integer()) %>%
  select(Fylke = region, Folketall = value, Tid)
