library(openxlsx)

# col.classes<-c("character",rep("numeric",8))
t <- read.xlsx("IncomeConsumption.xlsx", 1)
filter <- grep("федеральный округ", t$Регион)
okr <- t[filter, ]

names <- sub("федеральный округ", "", okr$Регион)

filter<-grepl("федеральный округ|Федерация|числе",t$Регион)
sub <- t[!filter, ]
for (i in 1:10) print(i)
for (i in 1:10){
  a <- factorial(i) # факториал i
  b <- exp(i) # e в степени i
  print(a/b) # факториал растет быстрее экспоненты
}
i <- 0
while(i < 10) {
  i <- i+1
  print(i)
}
# Пакетное рисование графиков
for(var in colnames(okr)[-1]){
  par(mar = c(5,9,4,2))
  barplot(okr[,var], 
          names.arg = names, 
          horiz = TRUE, 
          las = 1, 
          main = var,
          col = "steelblue")
}
# Пакетное рисование графиков
par(mfrow = c(1,2))
options(scipen = 999) # запрещаем использовать экспоненциальную форму записи больших чисел

for(var in colnames(okr)[-1]){
  par(mar = c(5,9,4,3)) # устанавливаем поля для столбчатой диаграммы
  barplot(okr[,var], 
          names.arg = names, 
          horiz = TRUE, 
          las = 1, 
          main = var, 
          xlab = "По федеральным округам",
          col = "steelblue")
  par(mar = c(5,3,4,1)) # устанавливаем поля для гистограммы
  hist(sub[,var], breaks = 12, col="green", main = var, xlab = "По субъектам")
}
for (i in 1:10){
  a <- factorial(i) # факториал i
  b <- exp(i) # e в степени i
  ratio <- a/b # вычисляем отношение экспоненты и факториала
  
  if (ratio < 1){ # если экспонента больше, то...
    cat(i,'! < exp(', i, ')\n', sep = '')
  } else { # в противном случае
    cat(i,'! > exp(', i, ')\n', sep = '')
  }
}
# Пакетное чтение данных
library(foreign) # для чтения dbf необходима библиотека foreign

files <- list.files("dbf") # прочитаем список файлов в директории dbf

files <- files[grep(".dbf", files, fixed = TRUE)] # отфильтруем файлы с расширением .dbf

names <- sub(".dbf","",files) # получим названия месяцев, избавившись от расширений

i <- 1 # Создадим дополнительно переменную цикла, чтобы выбирать i-е название месяца

for (file in files){ # пройдемся по всем файлам
  
  temp <- read.dbf(paste("dbf/", file, sep='')) # прочитаем текущий файл
  
  tmean <- mean(temp$Temp) # вычислим среднюю температуру из столбца Temp
  
  hist.col <- "white" # иницилизируем переменную цвета за пределами условия 
  
  # Проверим наше условие
  if (tmean < 0){ 
    hist.col <- "steelblue"
  } else if (tmean < 10){
    hist.col <- "yellow"
  } else {
    hist.col <- "orange"
  }
  
  # Построим гистограмму
  hist(temp$Temp, 
       col = hist.col, 
       main = names[i]) # Вот здесь нам нужна дополнительная переменная цикла
  
  # Нанесем линию среднего значения
  abline(v = tmean, 
         lwd = 2, 
         col = "red") 
  
  # Подпишем среднюю температуру
  text(tmean, 
       1000, 
       labels = round(tmean,1), 
       pos = 4, 
       col = "red")
  
  i <- i + 1 # Не забудем сделать инкремент переменной цикла
}

# Создадим функцию, возвращающую цвет в зависимости от температуры
selectColor <- function(value){ 
  hist.col <- "white"
  if (tmean < 0){
    hist.col <- "steelblue"
  } else if (tmean < 10){
    hist.col <- "yellow"
  } else {
    hist.col <- "orange"
  }
  return(hist.col)
}

i <- 1
par(mfrow = c(2,2))
for (file in files){
  temp <-  read.dbf(file)
  tmean <-  mean(temp$Temp)
  
  # выберем цвет с помощью нашей функции
  hist.col <- selectColor(tmean)
  
  # построим гистограмму
  hist(temp$Temp, 
       col = hist.col, 
       main = names[i])
  
  # добавим линию среднего
  abline(v = tmean, 
         lwd = 2, 
         col = "red")
  # подпишем среднее
  text(tmean, 
       1000, 
       labels = round(tmean,1), 
       pos = 4, 
       col = "red")
  i <- i+1
}
selectColor2 <- function(value, ncolors){ # передаем в качестве дополнительного параметра количество цветов
  hist.col <- "white"
  # генерируем ncolors цветов из соответствующей палитры
  if (tmean < 0){
    hist.col <- colorRampPalette(c("darkslateblue", "steelblue1"))(ncolors)  
  } else if (tmean < 10){
    hist.col <- colorRampPalette(c("steelblue1", "yellow"))(ncolors)
  } else {
    hist.col <- colorRampPalette(c("yellow", "red"))(ncolors)
  }
  return(hist.col)
}

i <- 1

par(mfrow = c(2,2))

ncells <- 25 # установим фиксированное количество столбцов гистограммы

for (file in files){
  temp <- read.dbf(file)
  tmean <- mean(temp$Temp)
  
  # получим для раскраски требуемое количество цветов
  hist.col <- selectColor2(tmean, ncells)
  
  # построим гистограмму
  hist(temp$Temp, 
       col = hist.col, 
       main = names[i], 
       breaks = ncells)
  
  # добавим линию среднего
  abline(v = tmean, 
         lwd = 2, 
         col = "red")
  
  # подпишем среднее
  text(tmean, 1000, 
       labels = round(tmean,1), 
       pos = 4, 
       col = "red")
  
  i <- i+1
}
