library(here)
library(rio)
library(tidyverse)
library(janitor)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)
library(ggmap)
library(RColorBrewer)
library(mapproj)
library(shadowtext)
library(stringr)
library(viridis)

files <- list.files(here::here("data"),
                    full.names = TRUE)
files

d <- read_csv(files[1]) %>%
  clean_names()

ggplot(d, aes(rit)) +
  geom_histogram(bins = 12)

ggplot(d, aes(disability_code)) +
  geom_histogram(bins = 20)

states <- map_data("state") %>%
  rename(name = region) %>%
  select(-subregion, -group) %>%
  filter(name == "oregon")

counties <- map_data("county")
or_county <- counties %>%
  filter(region == "oregon")

or_base <- ggplot(data = states) +
  geom_polygon(aes(long, lat),
               fill = "#154937",
               color = "#55565B",
               size = 2) +
  geom_bin2d(data = d, aes(lon, lat),
             binwidth = .08) +
  scale_fill_viridis_c(option = "plasma",
                       direction = -1) +
  coord_quickmap()

or_base +
  theme_void() +
  geom_polygon(data = or_county,
               aes(long, lat,
                   group = group),
               fill = NA,
               color = "yellow")
