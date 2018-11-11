library(sf)
library(tmap)
library(dplyr)
library(mapview)
library(rnaturalearth)

countries = ne_countries() %>% 
  st_as_sf() %>% 
  filter(continent == 'Europe')

countries_conic = st_transform(countries, 
                               "+proj=eqdc +lat_0=0 +lon_0=15 +lat_1=35 +lat_2=60 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

box = countries_conic %>% 
  filter(admin != 'Russia') %>% 
  st_bbox()

tm_shape(countries_conic,
         bbox = box) + 
  tm_borders() +
  tm_bubbles('pop_est', 
             col = 'red',
             alpha = 0.5)
