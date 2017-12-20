library(sf)
library(sp)
library(rgdal)
library(spdep)  # пакет spdep содержит инструменты анализа ПА
library(lattice)
library(RANN)
library(RColorBrewer)
library(xlsx)

reg.sf <- st_read('Regions.gpkg')
reg <- as(reg.sf, 'Spatial') # пакет spdep пока что требует объекты класса sp

par(mar = c(1,1,1,1))
plot(reg, border = "gray50")
polynei <- poly2nb(reg) # Соседство по правилу ферзя
polynei  # посмотрим сводную информацию
class(polynei)  # проверим тип объекта
coords <- coordinates(reg)

# Теперь рисуем граф:
plot(reg, border = "gray50")
plot(polynei, coords, pch = 19, cex = 0.5, add = TRUE)
title(main="Соседи по смежности (правило ферзя)")
polynei<-poly2nb(reg, queen=FALSE) # Соседство по правилу ладьи

plot(reg, border="grey70")
plot(polynei, coords, pch = 19, cex = 0.5, add = TRUE)
title(main="Соседи по смежности (правило ладьи)")
plot(reg, border="grey70")
trinei<-tri2nb(coords)
plot(trinei, coords, pch = 19, cex = 0.5, add = TRUE)
title(main="Соседи по триангуляции Делоне")
plot(reg, border="grey70")
soinei<-graph2nb(soi.graph(tri2nb(coords), coords))
plot(soinei, coords, pch = 19, cex = 0.5, add = TRUE)
title(main="Соседи по сфере влияния")
plot(reg, border="grey70")
gabnei<-graph2nb(gabrielneigh(coords))
plot(gabnei, coords, pch = 19, cex = 0.5, add = TRUE)
title(main="Соседи по графу Гэбриела")
plot(reg, border="grey70")
relnei<-graph2nb(relativeneigh(coords))
plot(relnei, coords, pch = 19, cex = 0.5, add = TRUE)
title(main="Относительные соседи по графу")
par(mfrow = c(2,2))
for (i in 1:4){
  knearnei<-knn2nb(knearneigh(coords, k = i))
  
  plot(reg, border="grey70")
  plot(knearnei, coords, pch = 19, cex = 0.5, add = TRUE)
  title(main = paste("Ближайшие соседи (k =", i, ")", sep = ''))
}
par(mfrow = c(2,2))
for (d in 3:6){
  dnearnei <- dnearneigh(coords, d1 = 0, d2 = d)
  
  plot(reg, border="grey70")
  plot(dnearnei, coords, pch = 19, cex = 0.5, add = TRUE)
  title(main = paste("Ближайшие соседи (d <=", d, ")", sep = ''))
}
polynei<-poly2nb(reg)
Wbin<-nb2listw(polynei,style="B")
Wbin  # посмотрим, что за объект получается на выходе (listw)
Wbin$neighbours
Wbin$weights
M<-listw2mat(Wbin)
levelplot(M, main="Матрица весов (бинарная)")
Wstand<-nb2listw(polynei, style = "W")
M<-listw2mat(Wstand)

ramp <- colorRampPalette(c("white","red"))
levels <- 1/1:10  # шкала 1, 0.5, 0.33, 0.25 ... 0.1
levelplot(M, 
          main="Матрица весов (нормированная)", 
          at = levels, 
          col.regions=ramp(10))
# Ближайшие соседи (k = 1)
knearnei<-knn2nb(knearneigh(coords,k=1))

Wstand<-nb2listw(knearnei, style = "B")
M<-listw2mat(Wstand)
levelplot(M, 
          main="Матрица весов (нормированная)", 
          at = levels, 
          col.regions=ramp(10))
# Чтение базовых пространственных данных
mun.sf <- st_read("Kirov.gpkg")

mun <- as(mun.sf, 'Spatial')

# Чтение таблицы со статистикой
classes <- c("integer", "character", rep("numeric", 10))
tab <- read.xlsx2("Kirov.xlsx",1, colClasses = classes)

# Соединение таблиц
mun@data <- merge(mun@data, tab, by.x="OBJECTID", by.y="N")

# Построение серии карт
months <- names(mun)[22:31] # выбираем названия столбцов с месяцами
ramp <- colorRampPalette(c("white", "orange", "red"))
levels <- seq(0,10000,1000)
nclasses <- length(levels)-1
spplot(mun, months, at = levels, col.regions = ramp(nclasses))
# Определение соседства (правило ферзя)
nei<-poly2nb(mun)

# Визиуализация графа соседства
coords <- coordinates(mun)
plot(mun, border="darkgray")
plot(nei, coords, pch = 19, cex = 0.5, add = TRUE)
title(main="Соседи по смежности (правило ферзя)")

# Вычисление весов (нормированная матрица)
W <- nb2listw(nei)

# Визуализация матрицы весов
M<-listw2mat(W)

ramp2 <- colorRampPalette(c("white","red"))
levels2 <- 1/1:10 # шкала 1, 0.5, 0.33, 0.25 ... 0.1
levelplot(M, 
          main="Матрица весов (нормированная)", 
          at = levels2, 
          col.regions=ramp2(10))
# Вычисление индекса (тест) Морана
moran.test(mun$Февраль, W)
sim<-moran.mc(mun$Февраль, listw = W, nsim = 10000)
sim

# Построим гистограмму по вычисленным индексам:
hist(sim$res,
     freq=TRUE,
     breaks=20, 
     xlim = c(-1,1),
     main = "Перестановочный тест Морана", 
     xlab = "Случайный индекс Морана",
     ylab = "Частота появления",
     col = "steelblue")

# Нанесем фактическое значение
abline(v = sim$statistic, col = "red")
moran.plot(mun$Февраль, W)
model <- spautolm(mun$Февраль ~ 1, listw=W)
model
mun$fitted <- fitted(model)

# Извлекаем остатки ε и записываем в таблицу
mun$residuals <- residuals(model)

# Сравниваем исходные данные, модельные и остатки
spplot(mun, 
       zcol=c("Февраль","fitted", "residuals"),
       names.attr = c("Фактические значения", "Модель", "Остатки"),
       at = levels, 
       col.regions = ramp(nclasses))
