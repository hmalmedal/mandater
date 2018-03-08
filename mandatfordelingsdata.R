library(dplyr)
library(forcats)
library(readr)
library(stringr)

source("areal.R")
source("folkemengde.R")

arealfolk <- inner_join(folk, areal, by = "Valgdistrikt") %>%
  arrange(Tid, Valgdistrikt)

source("saintelague.R")
pre2004 <- read_csv("pre2004.csv", col_types = "ci") %>%
  mutate_at(vars(Valgdistrikt), funs(as_factor)) %>%
  mutate(Tid = integer(19))

mandatfordelingsdata <- read_csv("mandatfordelingsdata.csv",
                                 col_types = "ciii") %>%
  mutate_at(vars(Valgdistrikt), funs(as_factor)) %>%
  bind_rows(arealfolk) %>%
  group_by(Tid) %>%
  mutate(Mandater = saintelague(Folketall + 1.8 * Areal, 169)) %>%
  ungroup() %>%
  bind_rows(pre2004) %>%
  arrange(Tid, Valgdistrikt) %>%
  group_by(Valgdistrikt) %>%
  mutate(Endring = Mandater - lag(Mandater)) %>%
  ungroup() %>%
  filter(Tid > 0)
