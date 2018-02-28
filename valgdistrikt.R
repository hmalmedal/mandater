library(readr)

v <- c("Østfold", "Akershus", "Oslo", "Hedmark", "Oppland", "Buskerud",
       "Vestfold", "Telemark", "Aust-Agder", "Vest-Agder", "Rogaland",
       "Hordaland", "Sogn og Fjordane", "Møre og Romsdal", "Sør-Trøndelag",
       "Nord-Trøndelag", "Nordland", "Troms", "Finnmark")

Encoding(v) <- "UTF-8"

col_types <- cols(
  Kommunenummer = col_character(),
  Kommunenavn = col_character(),
  Valgdistrikt = col_factor(v)
)

valgdistrikt <- read_csv("valgdistrikt.csv", col_types = col_types)
