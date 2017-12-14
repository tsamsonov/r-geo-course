library(sp)
library(sf)
library(raster)
library(classInt)

# ЛОКАЛЬНЫЕ ОПЕРАЦИИ
# Вычисление толщины покровного оледенения

# Чтение данных
bed <- raster('etopo1_bed.tif')
ice <- raster('etopo1_ice.tif')
countries <- st_read('countries.gpkg')
borders <- countries %>% st_geometry()

# отображение данных
classes <- classIntervals(values(bed), 20)
brks <- classes$brks
nclass <- length(brks) - 1

plot(bed, 
     breaks = brks, 
     col = gray.colors(nclass),
     main = 'ETOPO Bedrock',
     legend = F)
plot(ice, 
     breaks = brks, 
     col = gray.colors(nclass),
     main = 'ETOPO Ice surface',
     legend = F)

# вычисление разности
ice.depth <- ice - bed
plot(ice.depth, 
     col = cm.colors(255),
     main = 'Мощность покровного оледенения')
plot(borders, 
     border = 'black', 
     lwd = 0.5, 
     add = TRUE)

# сделаем пустыми все ячейки, в которых толщина льда равна нулю
ice.depth[ice.depth == 0] <- NA

plot(ice.depth, 
     col = cm.colors(255), 
     main = 'Мощность покровного оледенения')
plot(borders, 
     border = 'black', 
     lwd = 0.5, 
     add = TRUE)
# ФОКАЛЬНЫЕ ОПЕРАЦИИ

# Вырежем кусок из ЦМР
dem <- crop(ice, extent(-120, -75, 10, 40))
spplot(dem)

# Среднее
wgt <- matrix(c(1, 1, 1,
                1, 1, 1,
                1, 1, 1) / 9, 
              nrow = 3)
# на самом деле проще написать так:
# wgt <- matrix(1/9, 3, 3), но полная форма записана для наглядности

# выполним обработку ЦМР с помощью фокального фильтра
filtered <- focal(dem, w = wgt)
spplot(stack(dem, filtered),
       names.attr=c('Исходный рельеф', 'Сглаживание средним'))
# Гауссово (параметр 0.5 - это стандартное отклонение в единицах измерения растра)
wgt <- focalWeight(dem, 0.5, "Gauss")
filtered <- focal(dem, wgt)
spplot(stack(dem, filtered),
       names.attr=c('Исходный рельеф', 'Гауссово сглаживание'))
# Матрица Собеля:
wgt <- matrix(c(1, 2, 1,
                0, 0, 0,
               -1,-2,-1) / 4, 
              nrow=3)
filtered <- focal(dem, wgt)

# Это поверхность производных:
plot(filtered,
     col = gray.colors(128),
     main = 'Производная поверхности')

# Отберем все ячейки, обладающие высокими значениями производных
faults <- (filtered < -1500) | (filtered > 1500)
faults[faults == 0] <- NA

# Визуализируем результат
plot(dem, 
     col = rev(rainbow(20)),
     main = 'Уступы континентального склона',
     legend = FALSE)
plot(faults,
     col = 'black',
     legend = FALSE,
     add = TRUE)

# Морфометрия рельефа — фиксированное соседство
dem <- raster('dem_fergana.tif')
spplot(dem)

# углы наклона
slope <- terrain(dem, opt = 'slope', unit = 'degrees')
spplot(slope, 
       col.regions = heat.colors(20),
       names.attr=c('Углы наклона'))

# экспозиция
aspect <- terrain(dem, opt = 'aspect', unit = 'degrees')
spplot(aspect, 
       col.regions = rainbow(20),
       names.attr=c('Экспозиции склона'))
# отмывка
slope2 <- terrain(dem * 20, opt = 'slope')
aspect2 <- terrain(dem * 20, opt = 'aspect')
                 
# параметры angle и direction функции hillShade определяют азимут и высоту источника освещения:
hill <- hillShade(slope2, aspect2, angle = 45, direction = 315)
plot(hill, 
     col = gray.colors(128),
     main = 'Отмывка рельефа')
# Определение Евклидовых расстояний — расширенное соседство

# Чтение данных
roads <- st_read("roads.gpkg") # Дороги
poi <- st_read("poi_point.gpkg") # Точки интереса
rayons <- st_read("boundary_polygon.gpkg") # Границы районов
stations <- st_read("metro_stations.gpkg") # Станции метро
water <- st_read("water_polygon.gpkg") # Водные объекты

# Создаем пустой растр с охватом, равным охвату станции
r <-  raster(extent(stations), nrows = 200, ncols = 200)

# Конвертируем ячейки в точки
cells <- r %>% as("SpatialPoints") %>% st_as_sf() %>% st_set_crs(st_crs(stations))

# Вычисляем расстояния
d <- st_distance(stations, cells)

# Находим минимальное расстояние для каждой точки и заполняем 
# полученными значениями текущее содержимое растра
r[] = apply(d, 2, min)

# Визуализируем результат
plot(r, 
     col = rev(heat.colors(100)),
      main = 'Расстояние до ближайшей станции метро')
contour(r, 
        lwd = 0.5, 
        add= TRUE)
plot(water, 
     col = 'blue', 
     border = 'darkblue', 
     add = TRUE)
plot(roads, 
     lwd = 0.2, 
     col = 'black', 
     add = TRUE)
plot(stations, 
     pch = 20, 
     col = 'black', 
     add = TRUE)
