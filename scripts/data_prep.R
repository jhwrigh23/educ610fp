library(here)
library(rio)
library(tidyverse)
library(janitor)
library(dplyr)

b <- read_csv("https://github.com/datalorax/ach-gap-variability/raw/master/data/achievement-gaps-geocoded-long.csv")

lat_lon <- b %>%
  select(state,
         year,
         distid = district_id,
         schlid = school_id,
         lat, lon) %>%
  filter(state == "OR",
         year == 1718) %>%
  mutate(schlid = parse_number(schlid))

lat_lon <- lat_lon %>%
  distinct(distid, schlid, lat, lon)

files <- list.files(here::here("data"),
                    full.names = TRUE)
files

d <- read_csv(files[1]) %>%
  clean_names()

# d %>% this is unique
# count(ssid) %>%
# filter(n > 1)

d <- left_join(d, lat_lon)

d %>%
  count(is.na(lat)) %>%
  mutate(prop = n/sum(n))
# 0.0889 percent missing

write_csv(d, here::here("data", "final_data.csv"))