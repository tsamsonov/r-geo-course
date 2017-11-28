library(sf)
library(dplyr)
library(classInt)
library(osrm) # Использование онлайн-сервиса маршрутизации OSRM
library(cartography) # Удобное построение тематических карт средствами plot()

setwd("/Volumes/Data/GitHub/r-geo-course/data")

# Чтение данных
roads <- st_read("roads.gpkg") # Дороги
poi <- st_read("poi_point.gpkg") # Точки интереса
rayons <- st_read("boundary_polygon.gpkg") # Границы районов
stations <- st_read("metro_stations.gpkg") # Станции метро
water <- st_read("water_polygon.gpkg") # Водные объекты

# Прочитаем текущие параметры компоновки
def <- par(no.readonly = TRUE)

# Уберем поля, чтобы карта занимала весь экран
par(mar = c(0,0,0,0))

# Получим ограничивающий прямоугольник слоя дорог в качестве общего охвата карты
frame <- roads %>% st_bbox() %>% st_as_sfc() %>% st_geometry()

## ОБЗОР ИСХОДНЫХ ДАННЫХ -------------------------------------

# Визуализируем входные данные
plot(frame)
plot(water %>% st_geometry(), 
     col = "lightskyblue1",
     border = "lightskyblue3",
     add = TRUE)
plot(roads %>% st_geometry(),
     col = "gray70", 
     add = TRUE)
plot(poi %>% st_geometry(), 
     col = "deepskyblue4", 
     pch = 20, 
     cex = 0.2, 
     add = TRUE)
## View(poi)
stats <- data.frame(table(poi$AMENITY))
## View(stats)
poi.food <- poi %>% 
            select(NAME, AMENITY) %>% 
            filter(AMENITY %in% c("restaurant", "bar", "cafe", "pub", "fast_food"))
head(poi.food)

## АНАЛИЗ РАССТОЯНИЙ -------------------------------------

dist.matrix <- st_distance(roads, poi.food)

# посмотрим, как выглядит результат на примере первых пяти объектов
print(dist.matrix[1:5,1:5])
ids <- apply(dist.matrix, 2, function(X) order(X)[1])
count.stats <- as.data.frame(table(ids))
roads <- roads %>% mutate(id = row.names(.))
roads.poi <- merge(roads, 
                   count.stats, 
                   by.x = 'id', 
                   by.y = 'ids', 
                   all.x = T)
# Статистика по улицам в табличном представлении (первые 10)
roads.poi %>% 
  select(NAME, Freq) %>% 
  arrange(desc(Freq)) %>% 
  head(10)
# Получим границы классов
nclasses <- 4
class.breaks <- classIntervals(roads.poi$Freq, 
                               n = nclasses, 
                               style = "jenks")
# Извлечем граничные интервалы
borders <- class.breaks$brks

# Названия классов — они же толщины линия от 1 до 4
line.widths <- 1:nclasses

# Перекодируем столбец количества присоединенных пунктов в классы
sizes <- cut(roads.poi$Freq, 
             breaks = borders, 
             labels = line.widths)
base.colors <- c("mistyrose", "red")
ramp <- colorRampPalette(base.colors)
colors <- findColours(class.breaks, base.colors)

plot(frame)

plot(water %>% st_geometry(), 
     col = "lightskyblue1",
     border = "lightskyblue3",
     add = TRUE)

plot(roads %>% st_geometry(),
     col = "gray70",
     add = TRUE)

plot(roads.poi %>% st_geometry(),
     lwd = sizes, 
     col = colors,
     add = TRUE)

plot(poi.food %>% st_geometry(), 
     col = "deepskyblue4", 
     pch = 20, 
     cex = 0.2, 
     add = TRUE)

# Функция legendGradLines из пакета cartography позволяет строить
# легенду для карт линий градуированных размеров:
legendGradLines(title.txt = "Пункты питания", 
                pos = "left",
                title.cex = 0.8,
                values.cex = 0.6, 
                breaks = borders,
                lwd = line.widths,
                col = "red")

## АНАЛИЗ ВЗАИМНОГО ПОЛОЖЕНИЯ -------------------------------------

poi.food <- poi.food %>% mutate(count = 1)
rayons.poi <- aggregate(poi.food['count'], rayons, sum)
# Преобразуем результат в относительный показатель
# (единиц на кв.км. площади) и запишем в таблицу районов:
rayons.poi$density <- 1000000 * rayons.poi$count / st_area(rayons.poi)
# Настроим параметры отображения
choro.pal <- colorRampPalette(c("lightgoldenrodyellow", "orangered"))

intervals <- classIntervals(rayons.poi$density, 
                            n = 5, 
                            style = "quantile")
choroLayer(rayons.poi, # Исходный слой типа SpatialPolygonsDataFrame
           var = "density", # Картографируемая переменная (столбец) 
           breaks = intervals$brks, # Границы интервалов
           col = choro.pal(5), # Цвета для соответствующих интервалов
           legend.pos = "n") # Легенду мы нарисуем позднее, поверх всех слоев
plot(water %>% st_geometry(), 
     col = "lightskyblue1",
     border = "lightskyblue3",
     add = TRUE)
plot(roads %>% st_geometry(),
     col = "gray50",
     add = TRUE)
plot(poi.food %>% st_geometry(), 
     col = "deepskyblue4", 
     pch = 20, 
     cex = 0.5, 
     add = TRUE)
plot(rayons %>% st_geometry(),
     border = "black",
     lwd = 3,
     add = TRUE)
text(rayons %>% st_centroid() %>% st_coordinates(),
     labels = gsub(' ', '\n', rayons$NAME),
     font = 2,
     cex = 0.6)

# Рисуем легенду
legendChoro(breaks = intervals$brks, 
            col = choro.pal(5),
            pos = "topleft",
            frame = FALSE, 
            title.txt = "Заведений на 1 кв.км")

## АНАЛИЗ АБСОЛЮТНЫХ ЗОН ОКРУЖЕНИЯ -------------------------------------

# Функция отвечает за рисование базовой карты
plotBasemap <- function(){
  
  plot(frame)

  plot(water %>% st_geometry(), 
       col = "lightskyblue1",
       border = "lightskyblue3",
       add = TRUE)
  
  plot(roads %>% st_geometry(),
       col = "gray70",
       add = TRUE)
  
  plot(poi.food %>% st_geometry(), 
       col = "deepskyblue4", 
       pch = 20, 
       cex = 0.3, 
       add = TRUE)
  plot(stations %>% st_geometry(), 
       col = "slategray4", 
       pch = 20, 
       cex = 2, 
       add = TRUE)
  text(stations %>% st_centroid() %>% st_coordinates(),
       labels = "M",
       col = "white",
       cex = 0.4)
}
# Выберем станцию метро и построим буферную зону
krop <- stations %>% filter(NAME == "Кропоткинская")
zone <- st_buffer(krop, dist = 300)

# Применим разработанную функцию для отбора точек
selected.poi <- poi.food[zone, ]

# Применим разработанную функцию для рисования картографической основы
plotBasemap()

# Визуализируем результаты анализа
plot(krop %>% st_geometry(), 
     col = "red", 
     pch = 20, 
     cex = 4, 
     add = TRUE)

text(krop %>% st_coordinates(),
     labels = "M",
     col = "white",
     cex = 0.7,
     add = TRUE)

plot(zone %>% st_geometry(),
     col = adjustcolor("sienna3", alpha.f = 0.5),
     border = "sienna3",
     add = TRUE)

plot(selected.poi %>% st_geometry(), 
     col = "sienna4", 
     pch = 20, 
     cex = 0.5, 
     add = TRUE)
## # Найденные объекты в табличном представлении:
## View(selected.poi)
river <- water %>% filter(NAME == "Москва")
zone <- st_buffer(river, dist = 100)

selected.poi <- poi.food[zone, ]

plotBasemap()

plot(zone %>% st_geometry(),
     col = adjustcolor("orange", alpha.f = 0.5),
     border = "orange",
     add = TRUE)

plot(river %>% st_geometry(), 
     col = adjustcolor("deepskyblue", alpha.f = 0.5), 
     border = F,
     add = TRUE)

plot(selected.poi %>% st_geometry(), 
     col = "firebrick1", 
     pch = 20, 
     cex = 0.5, 
     add = TRUE)
## # Найденные объекты в табличном представлении:
## View(selected.poi)
## 
## ## АНАЛИЗ КОНКУРЕНТНЫХ ЗОН ОКРУЖЕНИЯ -------------------------------------
## 
## zones <- st_voronoi(stations)
## plot(zones)
## # Агрегруем данные по каждой зоне
## zones.poi <- aggregate(poi.food['count'], zones, sum)
## 
## # Визуализируем результат
## plotBasemap()
## 
## plot(zones %>% st_geometry(),
##      col = adjustcolor("white", alpha.f = 0.5),
##      add = TRUE)
## 
## propSymbolsLayer(zones.poi,
##            var = "count",
##            symbols = "circle",
##            col = adjustcolor("turquoise3", alpha.f = 0.5),
##            border = F,
##            legend.title.txt = "Заведений питания")
## 
## text(zones %>% st_coordinates(),
##      labels = zones$count,
##      col = "turquoise4",
##      cex = log(zones$counts)/4)

## АНАЛИЗ ЗОН ТРАНСПОРТНОЙ ДОСТУПНОСТИ -------------------------------------

# Инициализируем систему координат WGS84, используемую в OSRM
WGS84 <- st_crs(4326)

# Извлечем информацию о системе координат исходных точек
UTM <- st_crs(poi)

# Выберем целевой объект
psel <- poi %>% filter(NAME == "Центральный детский магазин" & SHOP == "toys")

# Преобразуем координаты точки в WGS84
psel.wgs <- st_transform(psel, WGS84)

# Получаем 5-минутную зону транспортной доступности
# с помощью пакета osrm
service.area <- osrmIsochrone(psel.wgs %>% st_coordinates() %>% as.vector(), breaks = 5)

# Преобразуем зону обратно в UTM для дальнейших операций
service.area.utm <- st_transform(st_as_sf(service.area), UTM)

# Отбираем точки
selected.poi <- poi.food[service.area.utm, ]

# Визуализируем результат
plotBasemap()

plot(service.area.utm %>% st_geometry(),
     col = adjustcolor("violetred3", alpha.f = 0.2),
     border = "violetred3",
     add = TRUE)

plot(selected.poi  %>% st_geometry(), 
     col = "violetred3", 
     pch = 20, 
     cex = 0.5, 
     add = TRUE)

plot(psel %>% st_geometry(), 
     col = "violetred4", 
     pch = 20, 
     cex = 4, 
     add = TRUE)

## ПОСТРОЕНИЕ МАРШРУТОВ -------------------------------------

# Выбираем и проецируем начальную точку
origin <- poi %>% filter(NAME == 'Молодая Гвардия')
origin.wgs <- st_transform(origin, WGS84)
  
# Выбираем и проецируем конечную точку
destination <- poi %>% filter(NAME == 'Чебуречная "Дружба"')
destination.wgs <- st_transform(destination, WGS84)

# Строим маршрут
route <- osrmRoute(origin.wgs %>% as('Spatial'), 
                   destination.wgs %>% as('Spatial'), 
                   overview = "full", # запретить генерализацию линий
                   sp = TRUE) # вернуть результат в виде объекта класса Spatial

# Преобразуем результат обратно в UTM
route.utm <- st_transform(route %>% st_as_sf(), UTM)

# Визуализируем результат:
plotBasemap()

plot(route.utm %>% st_geometry(),
     lwd = 3,
     col = "orange",
     add = TRUE)

plot(origin %>% st_geometry(), 
     col = "tomato3", 
     pch = 20, 
     cex = 3, 
     add = TRUE)
text(origin %>% st_coordinates(),
     labels = "O",
     col = "tomato4",
     cex = 0.5)

plot(destination %>% st_geometry(), 
     col = "tomato", 
     pch = 20, 
     cex = 4, 
     add = TRUE)
text(destination %>% st_coordinates(),
     labels = "D",
     col = "tomato4",
     cex = 0.7)

