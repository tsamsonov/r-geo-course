library(sf)
library(dplyr)
library(raster)
library(RColorBrewer)

setwd('/Volumes/Data/GitHub/r-geo-course/data/')

cities <- st_read('world/cities.gpkg')


countries <- st_read('world/countries.gpkg')
class(countries)
print(countries[70:72], n = 5)

methods(class = 'sf')

plot(countries)
plot(countries['SOVEREIGNT'])

plot(countries['MAPCOLOR9'],
     col = brewer.pal(9,'Set1'))

borders <- st_geometry(countries)
head(borders)
attributes(borders)
class(borders)
plot(borders)

bahamas <- countries %>% filter(SOVEREIGNT == 'The Bahamas')
b <- bahamas %>% st_geometry()
class(b)

st_as_text(b)
b[[1]][[1]] 
st_as_binary(b)

france <- countries %>% filter(SOVEREIGNT == 'France')
f <- france %>% st_geometry()
class(f)
st_as_text(f)
plot(f)



plot(f[[1]]) # Реюньон

plot(f[[2]]) # Остатки

plot(st_polygon(f[[2]][[1]])) # Остатки
plot(st_polygon(f[[2]][[2]])) # Остатки
plot(st_polygon(f[[2]][[3]])) # Остатки


afr <- countries %>% filter(CONTINENT == 'Africa')
plot(afr %>% st_geometry())
  
st_write(afr, 'data/afrika.gpkg')
st_read('data/afrika.gpkg')

# PROJECTIONS
st_crs(countries)
mercator.countries <- st_transform(countries, 3857)
plot(mercator.countries %>% st_geometry(), graticule = TRUE, axes = TRUE)

robinson.countries <- countries %>% st_transform(54030)
robinson.cities <- cities %>% st_transform(54030)
large.cities <- robinson.cities %>% filter(POP2015 > 10000)

g = st_graticule(robinson.countries,
                 lat = seq(-90,  090, 30),
                 lon = seq(-180, 180, 30))

plot(robinson.countries %>% st_geometry(), 
     graticule = g,
     xlim = st_bbox(robinson.countries)[c(1,3)], 
     ylim = st_bbox(robinson.countries)[c(2,4)],
     xaxs = "i", yaxs = "i",
     axes = TRUE)

plot(robinson.cities %>% st_geometry(), add = TRUE,
     pch = 19, cex = 0.5, col = 'black')

plot(large.cities %>% st_geometry(), add = TRUE,
     pch = 19, col = 'red')

### Растры

ne <- raster('world/gebco01.tif')
plot(ne)

pal <- colorRampPalette(c("dodgerblue4","dodgerblue1", "white", "green", "yellow", "orange", "firebrick"))

breaks <- c(-12000, -6000, -4000, -2000, -1000, 0, 500, 1000, 2000, 3000, 5000, 8000)

nclasses <- length(breaks)-1

plot(ne,
     breaks = breaks,
     col = pal(nclasses))

plot(borders, add = TRUE)
