library(dplyr)
library(rjstat)
folk <- fromJSONstat("http://data.ssb.no/api/v0/dataset/85436.json?lang=no",
                     use_factors = TRUE) %>%
  getElement(1) %>%
  tbl_df() %>%
  filter(tid %in% c(2020, 2028, 2036), value > 0) %>%
  group_by(region, tid) %>%
  summarise(folkemengde = sum(value))
