library(sf)
p <- rbind(c(3.2,4), c(3,4.6), c(3.8,4.4), c(3.5,3.8), c(3.4,3.6), c(3.9,4.5))
mp <- st_multipoint(p)

s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
ls <- st_linestring(s1)

s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
s3 <- rbind(c(0,4.4), c(0.6,5))
mls <- st_multilinestring(list(s1,s2,s3))

p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
pol <- st_polygon(list(p1, p2))
p3 <- rbind(c(3,0), c(4,0), c(4,1), c(3,1), c(3,0))
p4 <- rbind(c(3.3,0.3), c(3.8,0.3), c(3.8,0.8), c(3.3,0.8), c(3.3,0.3))[5:1,]
p5 <- rbind(c(3,3), c(4,2), c(4,3), c(3,3))
mpol <- st_multipolygon(list(list(p1,p2), list(p3,p4), list(p5)))

gc <- st_geometrycollection(list(mp, mpol, ls))
par(mfrow = c(2,3))
plot(mp, cex = 5, pch = 20, main = 'MULTIPOINT', cex.main=3)
plot(ls, lwd = 3, main = 'LINESTRING', cex.main=3)
plot(mls, lwd = 3, main = 'MULTILINESTRING', cex.main=3)
plot(pol, lwd = 3, col = 'grey', main = 'POLYGON', cex.main=3)
plot(mpol, lwd = 3, col = 'grey', main = 'MULTIPOLYGON', cex.main=3)
plot(gc, lwd = 3, col = 'grey', border = 'black', main = 'GEOMETRYCOLLECTION', cex.main=3)
par(mfrow = c(1,1))
cat(st_as_text(mp))
cat(st_as_text(ls))
cat(st_as_text(mls))
cat(st_as_text(pol))
cat(st_as_text(mpol))
cat(st_as_text(gc))
cat(st_as_binary(ls))
cat(st_crs(4326)[['proj4string']])
cat(st_crs(3857)[['proj4string']])
cat(st_crs(54027)[['proj4string']])
cat(st_crs(32637)[['proj4string']])
library(sf)
methods(class = "sf") # Посмотрим, какие методы доступных для объектов класса sf
countries <- st_read('ne/countries.gpkg')
class(countries)
head(countries[tail(colnames(countries))])
outlines <- st_geometry(countries)
class(outlines)
head(outlines)
class(outlines[[8]])
outlines[[8]][[1]]
plot(countries)
plot(outlines, col = 'red')
plot(countries['sovereignt'], key.pos = NULL) # Здесь легенда не нужна
plot(countries['gdp_md_est'], graticule = TRUE, axes = TRUE)
oceans <- st_read('ne/oceans.gpkg')
rivers <- st_read('ne/rivers.gpkg')
lakes <- st_read('ne/lakes.gpkg')

plot(countries %>% st_geometry, lwd = 0.5, border = 'gray')
plot(oceans %>% st_geometry, col = 'steelblue1', border = 'steelblue', add = TRUE)
plot(lakes %>% st_geometry, col = 'steelblue1', border = 'steelblue', add = TRUE)
plot(rivers %>% st_geometry, col = 'steelblue', add = TRUE)
st_crs(countries)    # Координатная система
st_crs(3857) # Проекция Меркатора для карт мира
st_crs(54030) # Проекция Робинсона для карт мира

# Проекция UTM, зона 37.
st_crs('+proj=utm +zone=37 +datum=WGS84 +units=m')
st_crs(countries) <- NA
st_crs(countries) 

st_crs(countries) <- st_crs(4326)
st_crs(countries)
# Проекция Меркатора
countries.merc <- st_transform(countries, 3857)

plot(st_geometry(countries.merc), 
     col = 'lightgray',
     lwd = 0.5,
     graticule = TRUE, 
     axes = TRUE)
# Проекция Робинсона (используем dplyr)
countries.rob <- countries %>% st_transform(54030)
plot(st_geometry(countries.rob), 
     col = 'lightgray',
     lwd = 0.5,
     graticule = TRUE, 
     axes = TRUE)
# Зарубежная Европа в Конической равнопромежуточной проекции. 
# Задаем только необходимые параметры проекции
europe.conic <- countries %>% 
  dplyr::filter(continent == 'Europe' & sovereignt != 'Russia') %>% 
  st_transform('+proj=eqdc +lon_0=10 +lat_1=30 +lat_2=60 +datum=WGS84 +units=m')

plot(st_geometry(europe.conic), 
     col = 'lightgray',
     lwd = 0.5,
     graticule = TRUE, 
     axes = TRUE)
library(dplyr)

italy <- countries %>% filter(sovereignt == 'Italy')
plot(st_geometry(italy))
largest <- countries %>% select(pop_est) %>% filter(pop_est > 100000000)
plot(outlines, col = 'lightgrey')
plot(largest, col = 'red', add = TRUE)
continents <- countries %>% 
  group_by(continent) %>% 
  summarise(gdp = sum(gdp_md_est))
plot(continents['gdp'])
def <- par(no.readonly = TRUE)

par(mfrow=c(2,4))
par(mar = c(2,1,5,1))

a <- list(
  c(0,0,0,20,20,20,20,0,0,0),
  c(0,0,0,20,20,20,20,0,0,0),
  c(0,0,0,20,20,20,20,0,0,0),
  c(0,0,0,20,20,20,20,0,0,0),
  c(0,0,0,20,20,20,20,0,0,0),
  c(0,5,0,15,10,15,10,5,0,5),
  c(0,0,0,20,20,20,20,0,0,0),
  c(2,5,2,15,12,15,12,5,2,5)
)
  
b <- list(
  c(30,0,30,20,50,20,50,0,30,0),
  c(10,10,10,30,30,30,30,10,10,10),
  c(0,0,0,20,20,20,20,0,0,0),
  c(20,5,20,15,30,15,30,5,20,5),
  c(10,5,10,15,20,15,20,5,10,5),
  c(0,0,0,20,20,20,20,0,0,0),
  c(8,5,8,15,18,15,18,5,8,5),
  c(0,0,0,20,20,20,20,0,0,0)
)

labels <- c(
  'Не пересекается \n(A disjoint B)',
  'Перекрывает \n(A overlaps B)',
  'Совпадает \n(A equals B)',
  'Касается \n(A touches B)',
  'Покрывает \n(A covers B)',
  'Покрыт \n(A covered by B)',
  'Содержит \n(A сontains B)',
  'Содержится \n(A within B)'
)

ashift <- c(0, -5, -5, 0, -5, 0, -6, 0)
bshift <- c(0, 5, 5, 0, 0, 5, 0, 6)

ncases <- length(b)

for (i in 1:ncases) {
  aline <- st_linestring(matrix(a[[i]], ncol = 2, byrow = TRUE))
  bline <- st_linestring(matrix(b[[i]], ncol = 2, byrow = TRUE))
  
  apol <- st_cast(aline, 'POLYGON')
  bpol <- st_cast(bline, 'POLYGON')
  
  ac <- st_centroid(apol)
  bc <- st_centroid(bpol)
  
  geom <- st_sfc(list(apol, bpol))
  
  poly <- st_intersection(apol, bpol)
  line <- st_intersection(bline, aline)
  
  plot(geom, main = labels[i])
  plot(poly, col = 'lightgrey', add = TRUE)
  plot(line, lwd = 4, col = 'blue', add = TRUE)
  text(c(ac[1] + ashift[i], bc[1] + bshift[i]), c(ac[2], bc[2]), labels = c('A', 'B'), cex = 2)
}

par(def)
cities <- st_read('ne/cities.gpkg')
city.pts <- st_geometry(cities)

# Наносим исходную конфигурацию
plot(outlines, lwd = 0.5)
plot(cities, col = 'black', pch = 20, cex = 0.5, add = TRUE)

# Отбираем точки внутри стран с максимальным ВВП
sel <- cities[largest, ]

# Смотрим что получилось
plot(outlines, lwd = 0.5)
plot(largest, col = 'gray', add = TRUE)
plot(sel, pch = 20, col = 'black', add = TRUE)
cz <- countries %>% filter(sovereignt == 'Czechia')
neighbors <- countries[cz, op = st_touches]

plot(st_geometry(neighbors), col = 'lightgray', lwd = 0.5)
plot(cz, col = 'darkgray', add = TRUE)

st_point(c(0, 2)) # XY POINT
st_point(c(0, 2, -1)) # XYZ POINT
st_point(c(0, 2, 5), dim = 'XYM') # XYM POINT
st_point(c(0, 2, -1, 5)) # XYZM POINT
coords <- matrix(c(
  0, 2,
  1, 3,
  3, 1,
  5, 0
), ncol = 2, byrow = TRUE)

mp <- st_multipoint(coords) # XY MULTIPOINT
print(mp)

ls <- st_linestring(coords) # XY LINESTRING
print(ls)

plot(ls)
plot(mp, col = 'red', pch = 19, add = TRUE)
coords <- matrix(c( # Координаты главного полигона
  1, 0,
  0, 2,
  2, 3,
  4, 2,
  3, 0.5,
  1, 0
), ncol = 2, byrow = TRUE)

pol <- st_polygon(list(coords)) # Простой полигон
print(pol)

plot(pol, col = 'lightblue')

hole <- matrix(c( # Координаты дыры
  2, 1,
  3, 1.5,
  3, 2,
  2, 2,
  1.5, 1.5,
  2, 1
), ncol = 2, byrow = TRUE)

pol2 <- st_polygon(list(coords, hole)) # Полигон с дырой
print(pol2)

plot(pol2, col = 'lightblue')
coords1 <- matrix(c(
  0.5, 0,
  0, 1,
  1, 1.5,
  2, 1,
  1.5, 0.25,
  0.5, 0
), ncol = 2, byrow = TRUE)

coords2 <- matrix(c(
  3, 1,
  2.5, 2,
  3.5, 2.5,
  4, 2,
  4, 1.25,
  3, 1
), ncol = 2, byrow = TRUE)

mpol <- st_multipolygon(list(list(coords1), list(coords2)))

print(mpol)

plot(pol, col = 'grey') # Обычный полигон (серый)
plot(mpol, col = 'pink', add = TRUE) # Мультиполигон (розовый)

coords4 <- matrix(c(
  2.2, 1.2,
  2.8, 1.5,
  2.8, 1.8,
  2.2, 1.8,
  2.0, 1.6,
  2.2, 1.2
), ncol = 2, byrow = TRUE)

island <- st_polygon(list(coords4))

mpol2 <- st_multipolygon(list(pol2, island))

print(mpol2)

plot(mpol2, col = 'darkolivegreen4')
coords1 <- matrix(c(
  -3, 0,
  -1, 2,
  0, 2
), ncol = 2, byrow = TRUE)

coords2 <- matrix(c(
  4, 2,
  5, 3,
  6, 5
), ncol = 2, byrow = TRUE)

mline <- st_multilinestring(list(coords1, coords2))
print(mline)

plot(mline, lwd = 3, col = 'blue')
plot(pol2, col = 'lightblue', add = TRUE)
col <- st_geometrycollection(list(ls, mp, mline, pol2))
print(col)
plot(col)
moscow.sfg <- st_point(c(37.615, 55.752))
irkutsk.sfg <- st_point(c(104.296, 52.298))
petro.sfg <- st_point(c(158.651, 53.044))

cities.sfc <- st_sfc(moscow.sfg, irkutsk.sfg, petro.sfg)
print(cities.sfc)
st_crs(cities.sfc) <- st_crs(4326) # WGS84
print(cities.sfc)
plot(cities.sfc, pch = 19)
countries %>% filter(sovereignt == 'Russia') %>% st_geometry() %>% plot(add = TRUE)
city.attr <- data.frame(
  name = c('Москва', 'Иркутск', 'Петропавловск-Камчатский'),
  established = c(1147, 1661, 1740),
  population = c(12500, 620, 180)
)

cites.sf <- st_sf(city.attr, geometry = cities.sfc)
print(cites.sf)
italy.borders <- st_cast(italy, 'MULTILINESTRING')
class(st_geometry(italy.borders))

italy.regions <- st_cast(italy.borders, 'MULTIPOLYGON')
class(st_geometry(italy.regions))

italy.points <- st_cast(italy.borders, 'POINT')
class(st_geometry(italy.points))

plot(st_geometry(italy.regions), lwd = 0.5)
plot(italy.points, pch = 20, add = TRUE)
# Создадим три линии
coords1 = rbind(c(0, 0), c(0, 6))
line1 <- st_linestring(coords1)

coords2 = rbind(c(-1,1), c(5,1))
line2 = st_linestring(coords2)

coords3 = rbind(c(-1,5), c(4,0))
line3 = st_linestring(coords3)

# Создадим мультилинию
mls <- st_multilinestring(list(line1, line2, line3))
plot(mls)

# Посмотрим на ее точки
points <- st_cast(mls, 'MULTIPOINT')
plot(points, pch = 20, add = TRUE)
st_polygonize(mls)
mls2 <- st_node(mls)
poly2 <- st_polygonize(mls2)
points2 <- st_cast(mls2, 'MULTIPOINT')

plot(mls2)
plot(poly2, col = 'grey', add = TRUE)
plot(points2, pch = 20, add = TRUE)
st_bbox(italy)   # Координаты органичивающего прямоугольника
st_area(italy)   # Площадь
st_length(italy) # Периметр
box <- st_as_sfc(st_bbox(italy)) # Ограничивающий прямоугольник

plot(italy %>% st_geometry(), 
     col = 'lightgrey')
plot(box, 
     border = 'red', 
     add = TRUE)
## st_write(cites.sf, 'mycities.shp') # Шейп-файл
library(raster)

dem <- raster('world/gebco.tif') # Цифровая модель рельефа
class(dem)

img <- stack('world/BlueMarbleJuly.tif') # Цветной космический снимок (RGB)
class(img)
class(img[[1]])
ch1 <- raster('world/BlueMarbleJuly.tif', 1)
ch2 <- raster('world/BlueMarbleJuly.tif', 2)
ch3 <- raster('world/BlueMarbleJuly.tif', 3)

img <- stack(ch1, ch2, ch3)
par(mfrow = c(1,1))
plot(dem)
brks <- c(-12000, 0, 200, 500, 1000, 2000, 4000, 8000)
clrs <- c(
  "steelblue4",
  "darkseagreen",
  "lightgoldenrod1",
  "darkgoldenrod1",
  "darkorange",
  "coral2",
  "firebrick3")

plot(dem, breaks = brks, col = clrs)

plot(ch1, col = colorRampPalette(c("black", "white"))(255))

plot(ch1, col = rainbow(10))
plotRGB(img)
par(mfrow = c(3,2))
plotRGB(img, 1, 2, 3)
plotRGB(img, 1, 3, 2)
plotRGB(img, 2, 1, 3)
plotRGB(img, 2, 3, 1)
plotRGB(img, 3, 1, 2)
plotRGB(img, 3, 2, 1)
par(mfrow = c(1,1))
plotRGB(img)
plot(outlines, border = "white", lwd = 0.5, add = TRUE)
crs(dem) # читаем систему координат
crs(dem) <- NA # очищаем систему координат
crs(dem)
crs(dem) <- st_crs(4326)[[2]] # создаем систему координат
crs(dem)
# Проекция Меркатора:
img.merc <- projectRaster(img, crs = st_crs(3857)[[2]])
plotRGB(img.merc)
plot(st_geometry(countries.merc), 
     border = rgb(1,1,1,0.2), lwd = 0.5, add = TRUE)
# Проекция Робинсона:
img.merc <- projectRaster(img, crs = st_crs(54030)[[2]])
plotRGB(img.merc)
plot(st_geometry(countries.rob), 
     border = rgb(1,1,1,0.2), lwd = 0.5, add = TRUE)
below.zero <- dem < 0
plot(below.zero)

highlands <- dem > 100 & dem < 500
plot(highlands)

mountains <- dem > 1000
plot(mountains)
bed <- raster('world/etopo1_bed.tif')
ice <- raster('world/etopo1_ice.tif')

ice.depth <- ice - bed

plot(ice.depth, col = cm.colors(255))
plot(outlines, border = 'black', lwd = 0.5, add = TRUE)
values(ice.depth)[values(ice.depth) <= 0] <- NA

plot(ice.depth, col = cm.colors(255))
plot(outlines, border = 'black', lwd = 0.5, add = TRUE)
## writeRaster(ice.depth, 'world/ice_depth.tif')
