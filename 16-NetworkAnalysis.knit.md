# Анализ сетей и траекторий {#network}



## Загрузка данных


```r
library(sf)
library(tidyverse)
library(classInt)
library(osrm) # Использование онлайн-сервиса маршрутизации OSRM
library(cartography) # Удобное построение тематических карт средствами plot()

# Чтение данных
roads = st_read("data/roads.gpkg") # Дороги
poi = st_read("data/poi_point.gpkg") # Точки интереса
rayons = st_read("data/boundary_polygon.gpkg") # Границы районов
stations = st_read("data/metro_stations.gpkg") # Станции метро
water = st_read("data/water_polygon.gpkg") # Водные объекты

# Прочитаем текущие параметры компоновки
def = par(no.readonly = TRUE)

# Уберем поля, чтобы карта занимала весь экран
par(mar = c(0,0,0,0))

# Получим ограничивающий прямоугольник слоя дорог в качестве общего охвата карты
frame = roads %>% st_bbox() %>% st_as_sfc() %>% st_geometry()

poi.food = poi %>% 
            dplyr::select(NAME, AMENITY) %>% 
            dplyr::filter(AMENITY %in% c("restaurant", "bar", "cafe", "pub", "fast_food"))

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
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-1-1.png" width="100%" />


```r
plotBasemap = function(add = FALSE){
  
  plot(frame, add = add)

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
```


## Анализ зон транспортной доступности  {#transport_zones}

Зоны транспортной доступности представляют из себя зоны окружения объектов, построенные не по евклидову расстоянию, а по расстоянию или времени движения по дорожной сети. В задачах логистики и геомаркетинга зоны транспортной доступности часто называют _зонами обслуживания_ (service area), поскольку используются для определения территории, которую может покрыть объект, предоставляющий некоторые услуги. Например, для пожарного депо зона 10-минутной доступности показывает территорию города, в любую точку которой пожарная машина может доехать __из__ данного депо в течение 10 минут. И наоборот, для торгового центра зона 10-минутной доступности показывает территорию города, __из__ любой точки которой можно добраться до ТЦ в течение 10 минут. Очевидно, что продолжительность прямого и обратного маршрута неодинакова, на нее может оказывать влияние схема движения, приоритет дорог и так далее.

Задача, которую мы решим в данном разделе, звучит так: определить все заведения питания, находящиеся в 7 минутах езды от Центрального детского магазина. Для построения зоны доступности мы будем использовать пакет [osrm](https://cran.r-project.org/web/packages/osrm/index.html), предоставляющий интерфейс __R__ к онлайн-библиотеке маршрутизации [OSRM](http://project-osrm.org), работающей на основе данных OSM. Для построения зоны доступности (изохроны) нам понадобится функция `osrmIsochrone()` из данного пакета.

> Внимание: для выполнения этого раздела модуля необходимо подключение к Интернету

Поскольку данные, используемые в настоящем модуле, предварительно были конвертированы в проекцию [UTM](https://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system) и хранятся в метрах, а OSRM решает все задачи в географических координатах (широте и долготе относительно эллипсоида [WGS84](https://en.wikipedia.org/wiki/World_Geodetic_System)), нам необходимо научиться работать с проекциями данных и преобразовывать системы координат между собой.


```r

## АНАЛИЗ ЗОН ТРАНСПОРТНОЙ ДОСТУПНОСТИ -------------------------------------

# Инициализируем систему координат WGS84, используемую в OSRM
WGS84 = st_crs(4326)

# Извлечем информацию о системе координат исходных точек
UTM = st_crs(poi)

# Выберем целевой объект
psel = poi %>% dplyr::filter(NAME == "Центральный детский магазин" & SHOP == "toys")

# Преобразуем координаты точки в WGS84
psel.wgs = st_transform(psel, WGS84)

# Получаем 5-минутную зону транспортной доступности
# с помощью пакета osrm
service_area = osrmIsochrone(psel.wgs, breaks = 3)

# Преобразуем зону обратно в UTM для дальнейших операций
service_area_utm = st_transform(st_as_sf(service_area), UTM)

# Отбираем точки
selected_poi = poi.food[service_area_utm, ]

# Визуализируем результат
plotBasemap()

plot(service_area_utm %>% st_geometry(),
     col = adjustcolor("violetred3", alpha.f = 0.2),
     border = "violetred3",
     add = TRUE)

plot(selected_poi  %>% st_geometry(), 
     col = "violetred3", 
     pch = 20, 
     cex = 0.5, 
     add = TRUE)

plot(psel %>% st_geometry(), 
     col = "violetred4", 
     pch = 20, 
     cex = 4, 
     add = TRUE)
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-3-1.png" width="100%" />

Итак, в данном разделе мы научились строить зоны транспортной доступности в виде полигонов, ограниченных изохроной времени движения.

## Построение маршрутов и матриц времени движения {#routes}

В этом разделе модуля пространственного анализа мы посмотрим, каким образом можно построить оптимальный маршрут между двумя точками, а также получить матрицу времени движения между точками (на примере станций метро). Для решения этих задач используем следующие функции пакета osrm:

* `osrmRoute(src, dest)` --- строит оптимальный маршрут между точками `src` и `dest`
* `osrmTable(loc)` --- строит матрицу времени движения между всеми парами точек в `loc`

Так же, как и в предыдущем разделе, нам понадобятся преобразования координат. Построим оптимальный маршрут между книжным магазином "Молодая Гвардия" на Полянке и чебуречной "Дружба" на метро Сухаревская:


