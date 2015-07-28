library(dplyr)
library(rjstat)
areal <- fromJSONstat("http://data.ssb.no/api/v0/dataset/85430.json?lang=no",
                      naming = "id") %>%
  getElement(1) %>%
  tbl_df() %>%
  mutate(fylkesnr = substr(Region, 1, 2)) %>%
  group_by(fylkesnr) %>%
  summarise(areal = round(sum(value)))
