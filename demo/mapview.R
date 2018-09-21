library(sf)
library(mapview)
setwd('data')

reg = st_read('Regions.shp')
map = mapview(reg)
map
mapview::mapshot(map, file = 'map.png')
