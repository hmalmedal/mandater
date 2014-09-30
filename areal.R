library(httr)
library(dplyr, warn.conflicts = FALSE)
areal <- content(GET("http://data.ssb.no/api/v0/dataset/85430.csv?lang=no"),
                 type = "text/csv", sep = ";", dec = ",")
names(areal)[5] <- "areal"
areal <- areal %>%
  mutate(fylkesnr = substr(region, 1, 2)) %>%
  group_by(fylkesnr) %>%
  summarise(areal = round(sum(areal)))
