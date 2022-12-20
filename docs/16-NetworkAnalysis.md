# Анализ сетей и траекторий {#network}



В данной лекции рассматриваются задачи 


## Анализ сетей

### Загрузка данных


```r
library(sf)
library(tidyverse)
library(classInt)
library(osrm) # Использование онлайн-сервиса маршрутизации OSRM
library(sfnetworks)
library(tidygraph)

# Чтение данных

db = 'data/moscow.gpkg'
roads = read_sf(db, "roads") # Дороги
poi = read_sf(db, "poi") # Точки интереса
rayons = read_sf(db, "districts") # Границы районов
stations = read_sf(db, "metro_stations") # Станции метро
water = read_sf(db, "water") # Водные объекты

# Прочитаем текущие параметры компоновки
def = par(no.readonly = TRUE)

# Уберем поля, чтобы карта занимала весь экран
par(mar = c(0,0,0,0))

# Получим ограничивающий прямоугольник слоя дорог в качестве общего охвата карты
frame = roads |>  
  st_bbox() |>
  st_as_sfc() |> 
  st_geometry()

poi.food = poi |>  
    select(NAME, AMENITY) |> 
    filter(AMENITY %in% c("restaurant", "bar", "cafe", "pub", "fast_food"))

## ОБЗОР ИСХОДНЫХ ДАННЫХ -------------------------------------

# Визуализируем входные данные
plot(frame)
plot(water |>  st_geometry(), 
     col = "lightskyblue1",
     border = "lightskyblue3",
     add = TRUE)
plot(roads |>  st_geometry(),
     col = "gray70", 
     add = TRUE)
plot(poi |>  st_geometry(), 
     col = "deepskyblue4", 
     pch = 20, 
     cex = 0.2, 
     add = TRUE)
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-1-1.png" width="100%" />


```r
plotBasemap = function(add = FALSE){
  
  plot(frame, add = add)

  plot(water |>  st_geometry(), 
       col = "lightskyblue1",
       border = "lightskyblue3",
       add = TRUE)
  
  plot(roads |>  st_geometry(),
       col = "gray70",
       add = TRUE)
  
  plot(poi.food |>  st_geometry(), 
       col = "deepskyblue4", 
       pch = 20, 
       cex = 0.3, 
       add = TRUE)
  plot(stations |>  st_geometry(), 
       col = "slategray4", 
       pch = 20, 
       cex = 2, 
       add = TRUE)
  text(stations |>  st_centroid() %>% st_coordinates(),
       labels = "M",
       col = "white",
       cex = 0.4)
}
```

### Онлайн-анализ через сервис OSRM

#### Анализ зон транспортной доступности  {#transport_zones}

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
psel = poi |>  
  filter(NAME == "Центральный детский магазин" & SHOP == "toys")

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

plot(service_area_utm |> st_geometry(),
     col = adjustcolor("violetred3", alpha.f = 0.2),
     border = "violetred3",
     add = TRUE)

plot(selected_poi |> st_geometry(), 
     col = "violetred3", 
     pch = 20, 
     cex = 0.5, 
     add = TRUE)

plot(psel |> st_geometry(), 
     col = "violetred4", 
     pch = 20, 
     cex = 4, 
     add = TRUE)
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-3-1.png" width="100%" />

Итак, в данном разделе мы научились строить зоны транспортной доступности в виде полигонов, ограниченных изохроной времени движения.

#### Построение маршрутов и матриц времени движения {#routes}

В этом разделе модуля пространственного анализа мы посмотрим, каким образом можно построить оптимальный маршрут между двумя точками, а также получить матрицу времени движения между точками (на примере станций метро). Для решения этих задач используем следующие функции пакета osrm:

* `osrmRoute(src, dest)` --- строит оптимальный маршрут между точками `src` и `dest`
* `osrmTable(loc)` --- строит матрицу времени движения между всеми парами точек в `loc`

Так же, как и в предыдущем разделе, нам понадобятся преобразования координат. Построим оптимальный маршрут между книжным магазином "Молодая Гвардия" на Полянке и чебуречной "Дружба" на метро Сухаревская:


```r

## ПОСТРОЕНИЕ МАРШРУТОВ -------------------------------------

# Выбираем и проецируем начальную точку
origin = poi |> filter(NAME == 'Молодая Гвардия')
origin_wgs = st_transform(origin, WGS84)
  
# Выбираем и проецируем конечную точку
destination = poi |>  filter(NAME == 'Чебуречная "Дружба"')
destination_wgs = st_transform(destination, WGS84)

# Строим маршрут
route = osrmRoute(origin_wgs, 
                  destination_wgs, 
                  overview = "full", # запретить генерализацию линий
                  returnclass = 'sf') # вернуть результат в виде объекта класса Spatial

# Преобразуем результат обратно в UTM
route.utm = st_transform(route, UTM)

# Визуализируем результат:
plotBasemap()

plot(route.utm |> st_geometry(),
     lwd = 3,
     col = "orange",
     add = TRUE)

plot(origin |> st_geometry(), 
     col = "tomato3", 
     pch = 20, 
     cex = 3, 
     add = TRUE)
text(origin |> st_coordinates(),
     labels = "O",
     col = "tomato4",
     cex = 0.5)

plot(destination |> st_geometry(), 
     col = "tomato", 
     pch = 20, 
     cex = 4, 
     add = TRUE)
text(destination |> st_coordinates(),
     labels = "D",
     col = "tomato4",
     cex = 0.7)
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-4-1.png" width="100%" />

### Оффлайн-анализ через sfnetworks

#### Подготовка данных

Пакет `sfnetworks` использует методы пакетов `tidygraph` и `igraph` для анализа сетевых данных. Если OSRM содержит только базовые функции сетевого анализа, то sfnetworks позволяет выполнять достаточно сложные теоретические расчеты на географических сетях. Рассмотрим их на примере имеющегося у нас датасета по центру Москвы.

Чтобы граф построился корректно, необходимо продублировать линии, не являющиеся односторонними, а также округлить координаты. Первая операция нужна для того чтобы разрешить проеезд по двусторонним ребрам в обе стороны. Вторая операция важна для того чтобы устранить ошибки пристыковки линий, из-за которых они могут быть не распознаны как топологически связанные.


```r
lines = roads |> 
  st_cast('LINESTRING')

twoway = lines |> 
  filter(is.na(ONEWAY) | ONEWAY != 'yes') |> 
  st_reverse() |> 
  bind_rows(lines)


net = twoway |> 
  st_geometry() |>
  lapply(function(x) round(x, 0)) |>
  st_sfc(crs = st_crs(roads)) |>
  as_sfnetwork()

net
## # A sfnetwork with 2133 nodes and 2825 edges
## #
## # CRS:  WGS 84 / UTM zone 37N 
## #
## # A directed multigraph with 223 components with spatially explicit edges
## #
## # Node Data:     2,133 × 1 (active)
## # Geometry type: POINT
## # Dimension:     XY
## # Bounding box:  xmin: 410947 ymin: 6176676 xmax: 415891 ymax: 6181910
##                  x
##        <POINT [m]>
## 1 (410948 6177750)
## 2 (410947 6177750)
## 3 (411054 6177640)
## 4 (410947 6177557)
## 5 (410978 6179110)
## 6 (410947 6179112)
## # … with 2,127 more rows
## #
## # Edge Data:     2,825 × 3
## # Geometry type: LINESTRING
## # Dimension:     XY
## # Bounding box:  xmin: 410947 ymin: 6176676 xmax: 415891 ymax: 6181910
##    from    to                                                                  x
##   <int> <int>                                                   <LINESTRING [m]>
## 1     1     2                                   (410948 6177750, 410947 6177750)
## 2     3     4 (411054 6177640, 411046 6177634, 411011 6177606, 410957 6177564, …
## 3     5     6                   (410978 6179110, 410948 6179112, 410947 6179112)
## # … with 2,822 more rows
```

Визуализировать граф можно как посредством стандартной функции `plot`, так и с помощью функции `autoplot`, которая задействует функциональность `ggplot2`:


```r
plot(net)
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-6-1.png" width="100%" />

```r
autoplot(net)
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-6-2.png" width="100%" />

Для того чтобы работать с компонентами графа (ребрами и вершинами), необходимо их _активировать_. 


```r
net |> 
  activate("edges")
## # A sfnetwork with 2133 nodes and 2825 edges
## #
## # CRS:  WGS 84 / UTM zone 37N 
## #
## # A directed multigraph with 223 components with spatially explicit edges
## #
## # Edge Data:     2,825 × 3 (active)
## # Geometry type: LINESTRING
## # Dimension:     XY
## # Bounding box:  xmin: 410947 ymin: 6176676 xmax: 415891 ymax: 6181910
##    from    to                                                                  x
##   <int> <int>                                                   <LINESTRING [m]>
## 1     1     2                                   (410948 6177750, 410947 6177750)
## 2     3     4 (411054 6177640, 411046 6177634, 411011 6177606, 410957 6177564, …
## 3     5     6                   (410978 6179110, 410948 6179112, 410947 6179112)
## 4     7     8                   (410947 6179209, 411033 6179201, 411040 6179200)
## 5     9    10 (411022 6181910, 411004 6181900, 410992 6181894, 410988 6181892, …
## 6    11    12                   (410947 6179043, 410959 6179044, 410962 6179044)
## # … with 2,819 more rows
## #
## # Node Data:     2,133 × 1
## # Geometry type: POINT
## # Dimension:     XY
## # Bounding box:  xmin: 410947 ymin: 6176676 xmax: 415891 ymax: 6181910
##                  x
##        <POINT [m]>
## 1 (410948 6177750)
## 2 (410947 6177750)
## 3 (411054 6177640)
## # … with 2,130 more rows

net |> 
  activate("nodes")
## # A sfnetwork with 2133 nodes and 2825 edges
## #
## # CRS:  WGS 84 / UTM zone 37N 
## #
## # A directed multigraph with 223 components with spatially explicit edges
## #
## # Node Data:     2,133 × 1 (active)
## # Geometry type: POINT
## # Dimension:     XY
## # Bounding box:  xmin: 410947 ymin: 6176676 xmax: 415891 ymax: 6181910
##                  x
##        <POINT [m]>
## 1 (410948 6177750)
## 2 (410947 6177750)
## 3 (411054 6177640)
## 4 (410947 6177557)
## 5 (410978 6179110)
## 6 (410947 6179112)
## # … with 2,127 more rows
## #
## # Edge Data:     2,825 × 3
## # Geometry type: LINESTRING
## # Dimension:     XY
## # Bounding box:  xmin: 410947 ymin: 6176676 xmax: 415891 ymax: 6181910
##    from    to                                                                  x
##   <int> <int>                                                   <LINESTRING [m]>
## 1     1     2                                   (410948 6177750, 410947 6177750)
## 2     3     4 (411054 6177640, 411046 6177634, 411011 6177606, 410957 6177564, …
## 3     5     6                   (410978 6179110, 410948 6179112, 410947 6179112)
## # … with 2,822 more rows
```

В частности, для выполнения анализа необходимо вычислить веса всех ребер графа. Обычно вес зависит от времени передвижения, но за неимением такой информации можно использовать и длину:


```r
net = net |> 
  activate("edges") |> 
  mutate(weight = edge_length())
```

#### Вычисление центральности


```r
net = net |> 
  activate("edges") |> 
  mutate(bc = centrality_edge_betweenness())

ggplot() +
  geom_sf(data = st_as_sf(net, "edges"), aes(col = bc, linewidth = bc)) +
  scale_color_viridis_c() +
  ggtitle("Центральность по промежуточности")
```

<img src="16-NetworkAnalysis_files/figure-html/unnamed-chunk-9-1.png" width="100%" />


## Краткий обзор {#temporal_review}

Для просмотра презентации щелкните на ней один раз левой кнопкой мыши и листайте, используя кнопки на клавиатуре:
<iframe src="https://tsamsonov.github.io/r-geo-course-slides/16_Networks.html#1" width="100%" height="390px" data-external="1"></iframe>

> Презентацию можно открыть в отдельном окне или вкладке браузере. Для этого щелкните по ней правой кнопкой мыши и выберите соответствующую команду.

## Контрольные вопросы и упражнения {#qtasks_network_analysis}

### Вопросы {#questions_network_analysis}

### Упражнения {#tasks_network_analysis}

----
_Самсонов Т.Е._ **Визуализация и анализ географических данных на языке R.** М.: Географический факультет МГУ, 2022. DOI: [10.5281/zenodo.901911](https://doi.org/10.5281/zenodo.901911)
----
