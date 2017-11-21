library(sf)
library(openxlsx) # Чтение файлов Excel
library(lattice) # Пакет lattice используется для построения серий карт/графиков
library(classInt) # Пакет classInt реализует методы классификации данных
library(RColorBrewer) # Цветовые шкалы

library(sp) # Пакет sp нужен для поддержки классов Spatial, необходимых для создания карт средствами lattice

# Читаем шейп-файл с границами регионов
reg <- read_sf("Regions.gpkg")
## View(reg)
# читаем таблицу со статистикой
tab <- read.xlsx("Regions.xlsx")
## View(tab)
# сразу разделим численность населения на миллион, 
# чтобы не иметь дело с большими числами:
tab[3:11] <- tab[3:11] / 1000000
head(tab)
reg <- merge(reg, tab, by.x="TARGET_FID", by.y="FID")
## View(reg)
# Запишем число классов в переменную
nclasses <- 5

# Подготовим цветовую шкалу от бледно-розового к красному
ramp <- colorRampPalette(c("mistyrose", "red"))

intervals <- classIntervals(reg$X2015, n = nclasses, style = "equal")

# извлечь полученные границы можно через $brks
intervals$brks

plot(intervals, pal = ramp(nclasses), cex=0.5, main = "Равные интервалы MIN/MAX")
intervals <- classIntervals(reg$X2015, n = nclasses, style = "pretty")
intervals$brks
plot(intervals, pal = ramp(nclasses), cex=0.5, main = "Округленные равные интервалы")
intervals <- classIntervals(reg$X2015, n = nclasses, style = "quantile")
intervals$brks
plot(intervals, pal = ramp(nclasses), cex=0.5, main = "Квантили (равноколичественные)")
intervals <- classIntervals(reg$X2015, n = nclasses, style = "jenks")
intervals$brks
plot(intervals, pal = ramp(nclasses), cex=0.5, main = "Естественные интервалы")
data <- as.vector(as.matrix(tab[3:11]))

# Воспользуемся еще раз методом естественных интервалов:
intervals <- classIntervals(data, n = nclasses, style = "jenks")
intervals$brks

plot(intervals, pal = ramp(nclasses), cex=0.5, main = "Естественные интервалы")
spreg <- as(reg, 'Spatial')
spplot(spreg, 
       zcol = c("X1959", "X1979", "X2002", "X2014"), 
       at = intervals$brks, 
       col.regions = ramp(nclasses)
)
names <- list(at = intervals$brks, 
             labels = intervals$brks, 
             cex = 1.0
)

# Теперь создадим параметры легенды в виде списка. Параметр labels отвечает за подписи, а width — за ширину
legend <- list(labels = names, width=3.0)

# наконец, созданную легенду можно подставить в параметр colorkey=
spplot(spreg, 
       zcol = c("X1959", "X1979", "X2002", "X2014"), 
       at = intervals$brks, 
       col.regions = ramp(nclasses),
       colorkey = legend
)
breaks <-c(0,1,2.5,5,10,15)

nclasses <- length(breaks) - 1

intervals <- classIntervals(data, nclasses, style = "fixed", fixedBreaks=breaks)

plot(intervals, pal = ramp(nclasses), cex=0.5, main = "Пользовательские интервалы")

names <- list(at = intervals$brks, 
             labels = intervals$brks, 
             cex = 1.0
)

legend <- list(labels = names, width=3.0)

spplot(spreg, 
       zcol = c("X1959", "X1979", "X2002", "X2014"),
       names.attr = c("1959", "1979", "2002", "2014"),
       at = intervals$brks, 
       col.regions = ramp(nclasses),
       colorkey = legend
)
# Центроиды полигонов извлекаются так:
centers <- st_centroid(reg)
head(centers)
plot(reg %>% st_geometry())
plot(centers %>% st_geometry(), pch = 20, add = TRUE)
# Шкалу классификации картодиаграмм определим вручную
fixed.breaks <- c(0, 500, 1000, 2000, 5000, 10000, 15000)

# подсчитаем количество граничных значений
nbreaks <- length(fixed.breaks)

# подсчитаем количество классов
nclasses <- nbreaks-1

# подготовим вектор для размеров диаграмм
size.classes <- vector(mode = 'numeric', length = nclasses)

# Зададим диаметр первого класса
size.classes[1] <- 2 

# Построим остальные размеры по принципу увеличения в 1.3 раза
for(i in 2:nclasses){
  size.classes[i] <- 1.3 * size.classes[i-1]
}

# Посмотрим, что получилось:
plot(1:nclasses, 
     rep(0, nclasses), 
     pch = 20, 
     cex = size.classes)
# Классифицируем каждый показатель:
size1 <- cut(centers$PopUrban, 
             breaks = fixed.breaks, 
             labels = size.classes,
             include.lowest = TRUE)
size2 <- cut(centers$PopRural, 
             breaks = fixed.breaks, 
             labels = size.classes,
             include.lowest = TRUE)
size <- as.numeric(c(as.character(size1), 
                     as.character(size2)))

columns <- c("PopUrban", "PopRural")

# диаграммы будут зеленого полупрозрачного цвета
diag.color <- adjustcolor("green4", alpha.f = 0.5) 

# Пробуем строить карту
spcenters <- centers %>% as('Spatial')
spplot(spcenters, 
       zcol = columns,
       cuts = fixed.breaks, # для точечного символа границы классов указываются в параметре cuts
       cex = size, # каждая диаграмма будет иметь свой размер
       pch = 20,   # наличие pch означает, что визуализация будет производиться с помощью точечных символов
       col.regions = diag.color, # устанавливаем красный полупрозрачный цвет
       names.attr = c("Городское", "Сельское"),
       main = list("Население", cex = 2.0, just="centre"),
       as.table = TRUE     # осуществлять прорисовку карт сверху вниз, слева направо
)
# Сформируем список параметров значков, включая тип символа, цвет и размеры:
legend.points <- list(pch = 20, 
                      col = diag.color, 
                      cex = size.classes)
# сделаем отдельные вектора для левых и правых границ интервалов:
low <- fixed.breaks[1:nbreaks-1]
high <- fixed.breaks[2:nbreaks]

# вставим вектора друг а друга. Метки должны быть оформлены как список,
# поэтому дополнительно оборачиваем результат вставки в list():
labels = list(paste(low, " — ", high))

# Наконец, сформируем параметры легенды:
legend <- list(points = legend.points, # символы
               text = labels,          # подписи
               columns = 1,            # количество столбцов
               between = 0,            # расстояние между строками
               reverse.rows = TRUE,    # сортировка элементов
               padding.text = 10.0,    # отступ подписи от символа
               title = "Тыс.чел",      # заголовок
               cex.title = 1.3         # масштаб шрифта заголовка
          )
# Построим карту
spplot(spcenters, 
       zcol = columns,
       cuts = fixed.breaks,
       cex = size,
       pch = 20,
       col.regions = diag.color,
       key.space="right",   # местоположение легенды
       key = legend,       # легенда
       names.attr = c("Городское", "Сельское"),
       main = list("Население", cex = 2.0, just="centre"),
       par.settings = list(strip.background = list(col = "lightgrey")), # меняем цвет шапки каждой фасеты на серый
       par.strip.text = list(cex = 0.9), # уменьшаем размер шрифта в каждой фасете
       as.table = TRUE     # осуществлять прорисовку карт сверху вниз, слева направо
)
# Читаем исходные данные
splakes <- st_read("Lakes.gpkg") %>% as('Spatial')
sprivers <- st_read("Rivers.gpkg") %>% as('Spatial')
spcities <- st_read("Cities.gpkg") %>% as('Spatial')

# Настройки отображения городов
layout.cities <- list("sp.points", 
                      spcities, 
                      pch = 19, 
                      cex = 0.75, 
                      col = "black")

# Настройки отображения рек
layout.rivers <- list("sp.lines", 
                      sprivers, 
                      col = "steelblue3", 
                      lwd = 1, 
                      first = TRUE)

# Собираем в один список для передачи в spplot()
layout <- list(layout.rivers, layout.cities)
# Границы регионов 
layout.reg <- list("sp.polygons", 
                   spreg,
                   lwd = 0.5,
                   col = "slategrey", 
                   first = TRUE)

# Озера
layout.lakes <- list("sp.polygons", 
                     splakes,
                     col = "steelblue3",
                     fill = "lightblue1", 
                     lwd = 0.5, 
                     first = TRUE)

# Подписи городов
layout.text <- list("sp.text", 
                    coordinates(spcities), 
                    spcities$name_2, 
                    cex = 0.75, 
                    pos = 2)

layout <- list(layout.reg, 
               layout.rivers, 
               layout.lakes, 
               layout.cities,
               layout.text)
# Вычислим экстент регионов
extent <- st_bbox(reg)

# Построим карту
spplot(spcenters, 
       zcol = columns,
       cuts = fixed.breaks,
       cex = size,
       pch = 20,
       col.regions = diag.color,
       xlim = c(extent[1], extent[3]),
       ylim = c(extent[2], extent[4]),
       key.space="right",   # местоположение легенды
       sp.layout = layout, # дополнительные слои
       key = legend,       # легенда
       names.attr = c("Городское", "Сельское"),
       main = list("Население", cex = 2.0, just="centre"),
       par.settings = list(strip.background = list(col = "lightgrey")),
       par.strip.text = list(cex = 0.9), 
       as.table = TRUE     # осуществлять прорисовку карт сверху вниз, слева направо
)
library(raster)
# Прочитаем растровый файл
temp <- raster("tmean_1.tif")

# Проверим, какой он имеет класс:
class(temp)

# попробуем вывести растр на экран:
plot(temp)
temp <- temp/10
plot(temp)
# создадим цветовую палитру в синих тонах
pal <- colorRampPalette(c("dodgerblue4","dodgerblue1"))

# вычислим минимум и маскимум температуры
min <- cellStats(temp, "min")
max <- cellStats(temp, "max")

# определим ширину интервала температур равной 2.5 градусам
step <- 2.5

# вычислим границы равных интервалов, используя функцию fullseq() из пакета scales
library(scales)
levels <- fullseq(c(min, max), step)

# определим количество полученных интервалов
nclasses <- length(levels)-1

# визуализируем данные
plot(temp, 
     breaks = levels, # в breaks подставляем границы интервалов
     col = pal(nclasses))
# визуализируем данные
plot(temp, 
     breaks = levels, # в breaks подставляем границы интервалов
     col = pal(nclasses))
plot(spreg, 
     border = "black", 
     add = TRUE, 
     lwd = 0.3)
plot(sprivers, 
     col = "midnightblue", 
     add = TRUE, 
     lwd = 1)
plot(splakes, 
     col = "steelblue1", 
     add = TRUE, 
     lwd = 0.5)
plot(spcities, 
     add = TRUE, 
     pch = 20)

pts <- coordinates(spcities)
text(pts[,1], pts[,2], 
     labels = spcities$name_2, 
     cex = 0.8, pos = 3)
grid(col="grey20")
colors <- c("dodgerblue4","white","orange","firebrick")
pal <- colorRampPalette(colors)

# Можно, кстати, визуализировать полученные цвета как пиксельное изображение:
ncolors <- length(colors)
image(x = 1:ncolors,
      y = 1,
      z = as.matrix(1:ncolors),
      col = colors)
# Примем условно, что минимум и максимум содержатся в первом файле
min <- cellStats(temp, "min")
max <- cellStats(temp, "max")

# Создадим список для растров, чтобы прочитать их единожды и далее использовать во всех циклах
rasters <- vector(mode = "list", length = 12)

# Запишем первый растр в список
rasters[[1]] = temp

# Пройдемся по остальным файлам и сравним их минимумы и максимумы с текущим
for (i in 2:12){
  # сформируем имя файла
  file <- paste("tmean_", i, ".tif", sep="")
  
  # прочитаем файл
  temp <- raster(file)/10
  
  # Запишем текущий растр в список
  rasters[[i]] <- temp
  
  # вычислим текущий минимум и максимум
  vmin <- cellStats(temp, "min")
  vmax <- cellStats(temp, "max")
  
  # выясним, не меньше ли текущее значение, чем тот минимум, что мы храним
  if(vmin < min){
    min <- vmin # если да, то заменим минимум на текущее значение
  }
  
  # аналогично для максимума
  if(vmax > max){
    max <- vmax
  }
}

cat("Минимальная температура - ", min)
cat("Максимальная температура - ", max)

# Если предположить, что температуры будут визуализироваться
# с шагом 2.5 градуса, то шкалу сечения можно посчитать автоматически

# Рассчитаем границы классов, покрывающие диапазон данных, 
# используя удобную функцию fullseq() из пакета scales
levels <- fullseq(c(min, max), step)

# Количество интервалов в шкале равно количеству граничных значений -1
nclasses <- length(levels)-1

# Выведем теперь данные на экран
plot(temp, 
     breaks = levels, 
     col = pal(nclasses))

# легенду можно сделать и покрасивее. За ширину шкалы отвечает параметр
# legend.width, а за ее растяжение по высоте — legend.shrink.
# Если legend.shrink = 1, то легенда будет по высоте такой же как и карта:

plot(temp, 
     breaks = levels, 
     col = pal(nclasses), 
     legend.shrink = 1, 
     legend.width = 1.5)

# вы также можете более тонко настроить параметры легенды растрового слоя, используя
# аргументы legend.args и axis.args. Оба параметра являются списками

# legend.args  отвечает за заголовок легенды,
# axis.args отвечает за шкалу подписей.

legendargs <- list(text='°С', 
                   side=3, 
                   font=2, 
                   line=0.3, 
                   cex=0.8)

axisargs <- list(cex.axis=0.7)

# сделаем поля поуже:
par(mar=c(6,3,5,1)+0.1)
# и по 2 графика на строку
par(mfrow = c(1,2))

months<-c("Январь","Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь")

for (i in 1:12){
  plot(rasters[[i]], 
       breaks = levels, 
       col = pal(nclasses), 
       legend.mar = 4.5, 
       legend.shrink = 1, 
       legend.width = 1.5, 
       legend.args = legendargs, 
       axis.args = axisargs,
       main = months[i]
  )
  
  plot(spreg, 
     border = "black", 
     add = TRUE, 
     lwd = 0.3)
  plot(sprivers, 
       col = "midnightblue", 
       add = TRUE, 
       lwd = 1)
  plot(splakes, 
       col = "steelblue1", 
       add = TRUE, 
       lwd = 0.5)
  plot(spcities, 
       add = TRUE, 
       pch = 20)
  
  pts <- coordinates(spcities)
  text(pts[,1], pts[,2], 
       labels = spcities$name_2, 
       cex = 0.8, pos = 3)
  grid(col="grey20")
}
## png("October.png", width = 500, height = 500)
## plot(rasters[[10]],
##      breaks = levels,
##      col = pal(nclasses),
##      legend.mar = 4.5,
##      legend.shrink = 1,
##      legend.width = 1.5,
##      legend.args = legendargs,
##      axis.args = axisargs,
##      main = months[10]
## )
## dev.off() # Важно: завершаем рисование в файл
## png("Allmonths.png", width = 40, height = 30, units = "cm", res = 300)
## par(mar=c(5,4,5,6))
## par(mfrow = c(3,4))
## for (i in 1:12){
##   plot(rasters[[i]],
##        breaks = levels,
##        col = pal(nclasses),
##        legend.mar = 4.5,
##        legend.shrink = 1,
##        legend.width = 1.5,
##        legend.args = legendargs,
##        axis.args = axisargs,
##        main = months[i]
##   )
## }
## dev.off() # Важно: завершаем рисование в файл
## # по умолчанию ширина и высота задаются в дюймах
## CairoPDF("Results.pdf", width = 10, height = 10)
## par(mfrow=c(2,2))
## par(mar=c(5,4,5,6))
## 
## for(i in 1:12){
##   plot(rasters[[i]],
##        breaks = levels,
##        col=pal(nclasses),
##        legend.mar=4.5,
##        legend.shrink = 1,
##        legend.width = 1.5,
##        legend.args = legendargs,
##        axis.args = axisargs,
##        axes = FALSE
##   )
## 
##   # Далее повторим инструкции по выводу остальных слоев и подписей:
##   plot(spreg, border="black", add=TRUE, lwd=0.3)
##   plot(sprivers, col="midnightblue", add=TRUE, lwd=1)
##   plot(splakes, col="steelblue1", add=TRUE, lwd=0.5)
##   plot(spcities, add=TRUE, pch=20)
##   text(pts[,1], pts[,2], labels = cities$name_2, cex = 0.8, pos = 3)
## 
##   # Сделаем шаг по оси X равным 5 градусов, а по Y — 4 градуса
##   xseq = seq(30,55,by=5)
##   yseq = seq(46,60,by=4)
## 
##   # Сформируем подписи координат, включающие значок градуса:
##   xlabels <- paste(xseq, "°", sep="")
##   ylabels <- paste(yseq, "°", sep="")
## 
##   # Выведем на экран ось X и Y
##   axis(1, at = xseq, labels = xlabels)
##   axis(2, at = yseq, labels = ylabels)
## 
##   # Нанесем сетку вручную, используя функцию abline():
## 
##   abline(h=yseq, lty=3, col="grey20")
##   abline(v=xseq, lty=3, col="grey20")
## 
##   # Нанесем заголовок карты
##   title(main=months[i], sub="Среднемесячная температура")
## 
##   # Нанесем
##   box("plot", lwd=2)
## }
## dev.off() # Важно: завершаем рисование в файл
