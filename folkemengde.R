library(httr)
library(dplyr, warn.conflicts = F)
folk <- content(GET("http://data.ssb.no/api/v0/dataset/85436.csv?lang=no"),
                type = "text/csv", sep = ";", dec = ",")
names(folk)[6] <- "folkemengde"
folk <- folk %>%
  filter(tid %in% c(2020, 2028, 2036), folkemengde > 0) %>%
  group_by(region, tid) %>%
  summarise(folkemengde = sum(folkemengde))
