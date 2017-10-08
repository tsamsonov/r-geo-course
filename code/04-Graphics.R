library(readxl)

# Прочтем таблицу по экспорту/импорту продукции в регионах России 
types <- c("text", rep("numeric", 12))
tab <- as.data.frame(read_excel("ExpImp.xlsx", 1, col_types = types))
str(tab)
# Выгрузим данные по федеральным округам в отдельную таблицу
filter <- grep("федеральный округ", tab$Регион)
okr <- tab[filter, ]

# Отсортируем данные по федеральным округам в алфавитном порядке:
okr <- okr[order(okr$Регион), ]
## View(okr)
# Выгрузим данные по субъектам в отдельную таблицу
filter <- grepl("федеральный округ|Федерация|числе",tab$Регион)
sub <- tab[!filter, ]
## View(sub)
barplot(okr$ХимЭкспорт)

# Или даже просто вектор натуральных чисел от -5 до 5:
barplot(-5:5)

# Если у каждого столбика есть название, 
# нужно передать вектор названий в аргумент names.arg = 
barplot(okr$ХимЭкспорт, names.arg = okr$Регион)

# при наличии длинных подписей удобнее столбчатую диаграмму разместить горизонтально, используя параметр horiz = TRUE.
barplot(okr$ХимЭкспорт, names.arg = okr$Регион, horiz=TRUE)
barplot(okr$ХимЭкспорт, names.arg = okr$Регион, horiz=TRUE, las = 1)
names <- sub("федеральный округ", "", okr$Регион) # "" - означает пустая строка
barplot(okr$ХимЭкспорт, names.arg = names, horiz = TRUE, las = 1)
# mar=c(bottom, left, top, right)
# The default is c(5, 4, 4, 2) + 0.1.
margins.default <- par("mar") # запишем текущее значение, чтобы восстановить его потом
par(mar = c(5, 10, 4, 2)) # увеличим поле left до 10 условных единиц
barplot(okr$ХимЭкспорт, names.arg = names, horiz=TRUE, las = 1)
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1)

# Чтобы увеличить диапазон оси X, можно использовать параметр xlim = c(min, max):
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0,12000))
par(mar = c(5, 5, 5, 5)) # установим поля

pie(okr$ХимЭкспорт)

# вместо номеров можно использовать подписи секторов, добавив второй параметр:
pie(okr$ХимЭкспорт, names)

# в каждую метку можно добавить процент данного округа в общей массе. Для этого его нужно сначала посчитать:
percentage <- 100 * okr$ХимЭкспорт / sum(okr$ХимЭкспорт)

# и округлить до 1 знака после запятой:
percentage <- round(percentage, digits = 1)

names2<-paste(names, " (", percentage, "%)", sep = "")

# Используем для аннотирования круговых секторов:
pie(okr$ХимЭкспорт, names2)

# Добавить заголовок можно также с помощью параметра main =
pie(okr$ХимЭкспорт, names2, main = "Доля федеральных округов в экспорте продукции химической промышленности")
pie(okr$ХимЭкспорт, names2, main = "Доля федеральных округов в экспорте \n продукции химической промышленности")
pie(okr$ХимЭкспорт, 
    names2, 
    main = "Доля федеральных округов в экспорте \n продукции химической промышленности", 
    clockwise = TRUE)
hist(sub$ПродЭкспорт)
# Карманы будут от 0 до 3000 через 100. Заодно добавим цвет:
hist(sub$ПродЭкспорт, breaks = seq(0,3000,100), col="olivedrab3")
hist(sub$ПродЭкспорт[sub$ПродЭкспорт < 300], col = "olivedrab3", breaks = seq(0, 300, 20))
hist(log(sub$ПродЭкспорт), col = "olivedrab3")
par(mar=c(4,4,3,2))
# Диаграмма рассеяния по экспорту и импорту:
plot(sub$МетЭкспорт, 
     sub$МетИмпорт,
     col="red", 
     xlab="Экспорт, млн. долл. США", 
     ylab = "Импорт, млн. долл. США", 
     main = "Экспорт/импорт металлов и изделий из них по субъектам РФ")
plot(sub$МетЭкспорт, 
     sub$МетИмпорт, 
     col="red", 
     xlab="Экспорт, млн. долл. США", 
     ylab = "Импорт, млн. долл. США", 
     main = "Экспорт/импорт металлов и изделий из них по субъектам РФ", 
     asp = 1)
plot(sub$МетЭкспорт, 
     sub$МетИмпорт, 
     col="red", 
     xlab="Экспорт, млн. долл. США", 
     ylab = "Импорт, млн. долл. США", 
     main = "Экспорт/импорт металлов и изделий из них по субъектам РФ", 
     asp = 1,
     pch = 2, 
     cex = 0.5)
plot(sub$МетЭкспорт, 
     sub$МетИмпорт, 
     col="red", 
     xlab="Экспорт, млн. долл. США", 
     ylab = "Импорт, млн. долл. США", 
     main = "Экспорт/импорт металлов и изделий из них по субъектам РФ", 
     asp = 1,
     pch = 20, 
     cex = 1.2)
tab <- read.csv2("oxr_vod.csv", encoding = 'UTF-8')
plot(tab$Год, tab$Каспийское, pch=20) # для начала нанесем точки
lines(tab$Год, tab$Каспийское) # теперь нанесем линии
plot(tab$Год, tab$Карское,pch=20)
plot(tab$Год, tab$Каспийское, type="p")
plot(tab$Год, tab$Каспийское, type="l")
plot(tab$Год, tab$Каспийское, type="b")
plot(tab$Год, tab$Каспийское, type="c")
plot(tab$Год, tab$Каспийское, type="o")
plot(tab$Год, tab$Каспийское, type="h")
plot(tab$Год, tab$Каспийское, type="s")
plot(tab$Год, tab$Каспийское, type="l", lwd = 2, lty = 1)
plot(tab$Год, tab$Каспийское, type="l", lwd = 3, lty = 2)
plot(tab$Год, tab$Каспийское, type="l", lwd = 1, lty = 3)
plot(tab$Год, 
     tab$Каспийское, 
     pch=20, 
     type="o", 
     ylim = c(0,12), 
     col="red3")

# Добавим теперь на существующий график новый ряд данных, используя функции points() и lines():
points(tab$Год, tab$Карское, pch=20, col="forestgreen")
lines(tab$Год, tab$Карское, pch=20, col="forestgreen")
xrange = range(tab$Год) # вычислим диапазон по оси X
yrange = range(tab$Каспийское, tab$Карское, tab$Азовское) # вычислим диапазон по оси Y

# Построим пустой график, охватывающий полный диапазон данных, и имеющий все необходимые сопроводительные элементы
plot(xrange,
     yrange,
     main="Объем сброса загрязненных сточных вод", 
     xlab="Год", 
     ylab="млрд.куб.м",
     type = "n") # n означает, что ряд данных рисоваться не будет

# Теперь добавим на график ряды данных
points(tab$Год, tab$Каспийское, pch=20, col="red3")
lines(tab$Год, tab$Каспийское, pch=20, col="red3")

points(tab$Год, tab$Карское, pch=20, col="forestgreen")
lines(tab$Год, tab$Карское, pch=20, col="forestgreen")

points(tab$Год, tab$Азовское, pch=20, col="steelblue")
lines(tab$Год, tab$Азовское, pch=20, col="steelblue")
plot(okr$МетЭкспорт, 
     okr$МетИмпорт, 
     col=rgb(1,0,0,0.5), 
     xlab="Экспорт, млн. долл. США", 
     ylab = "Импорт, млн. долл. США", 
     main = "Экспорт/импорт металлов и изделий из них по ФО РФ (2013 г.)", 
     asp = 1,
     pch = 20, 
     cex = 2+log(sub$МетИмпорт/sub$МетЭкспорт)) # размер кружка зависит от соотношения импорта и экспорта
head(colors())
par(mar = c(5, 10, 4, 2)) # увеличим поле left до 10 условных единиц
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0,12000), 
        col = "steelblue")
violet = rgb(0.4, 0, 0.6)
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0,12000), 
        col = violet)
violet.transp = adjustcolor(violet, alpha = 0.5)
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0,12000), 
        col = violet.transp)

green.transp = rgb(0, 1, 0, 0.5) # появился четвертый параметр
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0,12000), 
        col = green.transp)
colors <- c("red", "green", "blue", "orange", "yellow", "pink", "white","black")

barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0,12000), 
        col = colors)
colors <- rep("gray", 8) # сделаем 8 серых цветов
colors[2] <- "red"
colors[7] <- "red"
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0,12000), 
        col = colors)
colors<-c("gray","steelblue")
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz =TRUE, 
        las = 1, 
        xlim = c(0, 12000), 
        col = colors)
# задаем 2 опорных цвета: черный  белый
palet<-colorRampPalette(c("black","white")) 

# и автоматически генерируем 8 цветов между ними:
colors<-palet(8)

# используем их для отображения:
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz = TRUE, 
        las = 1, 
        xlim = c(0, 12000), 
        col= colors)

# вы можете включить в палитру произвольное количество цветов:
palet<-colorRampPalette(c("steelblue","white","purple4")) 
colors<-palet(8)
barplot(okr$ХимЭкспорт, 
        names.arg = names, 
        main = "Экспорт продукции химической промышленности", 
        xlab = "млн долл. США", 
        horiz=TRUE, 
        las = 1, 
        xlim = c(0, 12000), 
        col= colors)
pie(okr$ХимЭкспорт, names2, main = "Доля федеральных округов в экспорте \n продукции химической промышленности", col=rainbow(length(names2)))
pie(okr$ХимЭкспорт, names2, main = "Доля федеральных округов в экспорте \n продукции химической промышленности", col=sample(colors(),5))
library(RColorBrewer) # Откроем библиотеку RColorBrewer:
display.brewer.all() # Посмотрим, какие в ней имеются палитры
# выберем цвета из палитры Set2 по количеству секторов в круге:
colors <- brewer.pal(length(names2),"Set1")

# И используем их при визуализации
par(mar = c(5, 5, 5, 5)) # установим поля
pie(okr$ХимЭкспорт, names2, main = "Доля федеральных округов в экспорте \n продукции химической промышленности", col=colors)

# Попробуем палитру Accent:
pie(okr$ХимЭкспорт, names2, main = "Доля федеральных округов в экспорте \n продукции химической промышленности", col=brewer.pal(length(names2),"Accent"))
plot(tab$Год, 
     tab$Каспийское, 
     pch=20, 
     type="o", 
     ylim = c(0,12), 
     col="red3", 
     main="Объем сброса загрязненных сточных вод", 
     xlab="Год", 
     ylab="млрд.куб.м",
     cex.axis=0.8, 
     cex.lab=0.7, 
     cex.main=0.9, 
     cex = 0.8)

points(tab$Год, tab$Карское, pch=20, col="forestgreen",cex = 0.8)
lines(tab$Год, tab$Карское, pch=20, col="forestgreen")

points(tab$Год, tab$Азовское, pch=20, col="steelblue",cex = 0.8)
lines(tab$Год, tab$Азовское, pch=20, col="steelblue")
plot(tab$Год, 
     tab$Каспийское, 
     pch=20, 
     type="o", 
     ylim = c(0,12), 
     col="red3", 
     main="Объем сброса загрязненных сточных вод", 
     xlab="Год", 
     ylab="млрд.куб.м",
     cex.axis=0.8, 
     cex.lab=0.7, 
     cex.main=0.9, 
     col.lab = "grey50", 
     fg = "grey40")
points(tab$Год, tab$Карское, pch=20, col="forestgreen")
lines(tab$Год, tab$Карское, pch=20, col="forestgreen")
points(tab$Год, tab$Азовское, pch=20, col="steelblue")
lines(tab$Год, tab$Азовское, pch=20, col="steelblue")
plot(tab$Год, 
     tab$Каспийское,
     type = "l",
     axes = FALSE)

axis(side = 1, 
     at = seq(min(tab$Год), max(tab$Год), 1),
     tck = -0.02,
     labels = FALSE) # разметим ось X через 1 год, но рисовать подписи не будем

axis(side = 1, 
     at = seq(min(tab$Год), max(tab$Год), 3), # а подписи расставим через 3 года
     tck = 0) # но рисовать метки не будем

# разметим ось Y через 1 млрд куб. м., округлив предварительно минимальное и максимальное значение до ближайшего целого снизу и сверху соответственно
axis(side = 2, 
     at = seq(floor(min(tab$Каспийское)), ceiling(max(tab$Каспийское)), 1),
     tck = -0.02) 

box() # добавим рамку для красоты
plot(tab$Год, 
     tab$Каспийское,
     type = "l",
     col = "red")
grid()
plot(tab$Год, 
     tab$Каспийское,
    type = "l",
    col = "red")
grid(10, 5)
plot(tab$Год, 
     tab$Каспийское, 
     type="n") # режим 'n' позволяет ничего не рисовать, но заложить поле графика в соответствии с данными, указанными в параметрах x и y

# Вычисляем линии сетки
xlines <- seq(min(tab$Год), max(tab$Год), 1)
ylines <- seq(ceiling(min(tab$Каспийское)),
              floor(max(tab$Каспийское)), 1)

# Рисуем линии сетки
abline(h = ylines, v = xlines, col = "lightgray")

# Рисуем график
lines(tab$Год, 
     tab$Каспийское, 
     col="red3")
points(tab$Год, 
     tab$Каспийское,
     pch = 20,
     col="red3")

# Выделяем значение 10 по оси Y:
abline(h = 10, col = "blue", lwd = 2)

# Рисуем дополнительно рамку, т.к. сетку координат мы рисовали после графика
box()
## text(tab$Год,
##      tab$Каспийское,
##      labels = tab$Каспийское,
##      cex = 0.75,
##      pos = 3)
par(mar = margins.default)

# Найдем ограничивающий прямоугольник вокруг всех рядов данных
xrange = range(tab$Год)
yrange = range(tab$Каспийское, tab$Карское, tab$Азовское)

# Построим пустой график с разметкой осей и всеми заголовками
plot(xrange, 
     yrange, 
     type="n", 
     main="Объем сброса загрязненных сточных вод", 
     xlab="Год", 
     ylab="млрд.куб.м",
     cex.axis=0.8, 
     cex.lab=0.7, 
     cex.main=0.9, 
     col.lab = "grey50", 
     fg = "grey40")

# Добавим на график сетку координат
grid()

# Добавим на график данные
points(tab$Год, tab$Каспийское, pch=20, col="red3")
lines(tab$Год, tab$Каспийское, pch=20, col="red3")

points(tab$Год, tab$Карское, pch=20, col="forestgreen")
lines(tab$Год, tab$Карское, pch=20, col="forestgreen")

points(tab$Год, tab$Азовское, pch=20, col="steelblue")
lines(tab$Год, tab$Азовское, pch=20, col="steelblue")

# Определим положение, названия и цвета:
main <- "Море"
location <- "topright"
labels <- c("Каспийское", "Карское", "Азовское")
colors <- c("red3", "forestgreen", "steelblue")

# Если цвет передать в параметр fill, то по умолчанию
# нарисуются цветовые плашки:
legend(location, labels, title = main, fill=colors)
## pts <- c(20, 20, 20) # каждый элемент показывается точкой типа 20
## lns <- c(1, 1, 1) # каждый элемент показывается линией толщиной 1
## 
## # теперь посмотрим на легенду (она нарисуется поверх старой)
## legend(location, labels, title = main, col = colors, pch = pts, lwd = lns)
