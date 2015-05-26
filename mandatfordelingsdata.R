library(dplyr, warn.conflicts = FALSE)
library(readr)

mandatfordelingsdata <- read_csv("mandatfordelingsdata.csv")

source("areal.R")
source("folkemengde.R")

fylker <- unique(mandatfordelingsdata$Fylke)

areal <- areal %>%
  mutate(fylkesnr = factor(fylkesnr,
                           levels = unique(fylkesnr),
                           labels = fylker)) %>%
  select(Fylke = fylkesnr, Areal = areal)

folk <- ungroup(folk) %>%
  mutate(region = factor(region,
                         levels = unique(region),
                         labels = fylker)) %>%
  select(Fylke = region, Folketall = folkemengde, Tid = tid)

arealfolk <- inner_join(folk, areal, by = "Fylke")

source("saintelague.R")
pre2004 <- c(8, 15, 16, 8, 7, 7, 8, 6, 4, 5, 11, 17, 5, 10, 10, 6, 12, 6, 4)
mandatfordelingsdata <- mandatfordelingsdata %>%
  mutate(Fylke = factor(Fylke, levels = fylker)) %>%
  rbind(arealfolk) %>%
  arrange(Tid, Fylke) %>%
  group_by(Tid) %>%
  mutate(Mandater = saintelague(169, Folketall + 1.8 * Areal)) %>%
  ungroup() %>%
  mutate(Endring = diff(c(pre2004, Mandater), lag = 19))
