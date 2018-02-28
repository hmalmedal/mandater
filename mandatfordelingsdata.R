library(dplyr)
library(readr)
library(stringr)

source("areal.R")
source("folkemengde.R")

arealfolk <- inner_join(folk, areal, by = "Valgdistrikt") %>%
  arrange(Tid, Valgdistrikt)

source("saintelague.R")
pre2004 <- c(8, 15, 16, 8, 7, 7, 8, 6, 4, 5, 11, 17, 5, 10, 10, 6, 12, 6, 4) %>%
  as.integer()

mandat_col_types <- cols(
  Valgdistrikt = col_factor(v),
  Folketall = col_integer(),
  Tid = col_integer(),
  Areal = col_integer()
)

mandatfordelingsdata <- read_csv("mandatfordelingsdata.csv",
                                 col_types = mandat_col_types) %>%
  bind_rows(arealfolk) %>%
  group_by(Tid) %>%
  mutate(Mandater = saintelague(Folketall + 1.8 * Areal, 169)) %>%
  ungroup() %>%
  mutate(Endring = diff(c(pre2004, Mandater), lag = 19))
