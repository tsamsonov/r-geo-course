library(openxlsx)
setwd("/Volumes/Data/GitHub/r-geo-course/data")
tab <- read.table("oxr_vod.csv",
                  sep = ';',
                  dec = ',',
                  header = TRUE,
                  encoding = 'UTF-8')
## View(tab)
tab2<-read.csv2("oxr_vod.csv", encoding = 'UTF-8')
## View(tab2)
tab[c(5,2,4), ]
indexes<-order(tab$Каспийское)
head(tab[indexes, ])
head(tab[order(tab$Каспийское), ])
condition <- tab$Каспийское > 10
condition  # посмотрим что получилось
tab[condition, ] # используем его для фильтрации строк таблицы:
tab[tab$Каспийское > 10, ]
caspian <- data.frame(tab$Год, tab$Всего, tab$Каспийское)
colnames(caspian)<-c("Year", "Total", "Caspian")
ratio <- caspian$Caspian / caspian$Total
ratio
ratio <- round(ratio, digits = 3)
ratio
caspian$CaspianRatio <- ratio
## View(caspian)
head(caspian[2])  # второй столбец (фактически — таблица из одного столбца)
head(caspian[c(1,4)])  # первый и четвертый столбец
caspian[,2]
sewage<-read.xlsx("sewage.xlsx",1) # Читаем таблицу из первого листа
## View(sewage)
colnames(sewage) <- c("Region", "Year05", "Year10", "Year11", "Year12", "Year13")
## View(sewage)
max(sewage$Year12)
max(sewage$Year13, na.rm = TRUE)
filter<-complete.cases(sewage)
filter  # посмотрим что получилось. Там где видим FALSE - есть пропуски в строках

sewage.complete <- sewage[filter, ] # отфильтруем полные строки
## View(sewage.complete)
# Первый параметр - искомое выражение, второй параметр - где искть
rows <- grep("федеральный округ",sewage$Region)
rows  # посмотрим, какие элементы столбца Region ему соответствуют
okruga <- sewage[rows,] # отфильтруем найденные строки
## View(okruga)
rows2 <- grepl("федеральный округ",sewage$Region)
rows2 # вот так выглядит результат grepl

neokruga <- sewage[!rows2,]
## View(neokruga)
rows2 <- grepl("федеральный|числе|Российская|за|ѕ",sewage$Region)
rows2
neokruga <- sewage[!rows2,] # обратите внимание на восклицательный знак перед rows2
## View(neokruga)
tab <- read.csv2("SatinoLanduse.csv", encoding = 'UTF-8')
str(tab) # посмотрим, какова структура данных
## View(tab)
s <- "5456.788"
s + 1
n <- as(s, "numeric")
n + 1
s <- as(n, "character")
s
nchar(s)
as.numeric(s) # то же самое, что и as(s, "numeric")
tab$Comment <- as.character(tab$Comment)
str(tab)
as.numeric(tab$Perimeter)
levels(tab$Perimeter)[1:10]
tab$Perimeter <- as.numeric(as.character(tab$Perimeter))
str(tab)

# Теперь попробуем преобразовать столбец Area
temp <- as.numeric(as.character(tab$Area))
temp[1:10]
tab[is.na(temp), "Area"]
tab$Area <- gsub(',', '.', tab$Area) # заменим запятые на точки
tab$Area <- as.numeric(as.character(tab$Area)) # Теперь можно преобразовать в числа
str(tab)
levels(tab$Type)
levels(tab$Administration)
filter <- grep("Совьяковская", tab$Administration) # Найдем все записи
tab[filter, "Administration"] <- "Совьяковская сельская администрация" # Заменим их одним значением
tab$Administration <- droplevels(tab$Administration) # Удаляем неиспользуемые уровни
levels(tab$Administration)
filter <- nchar(as.vector(tab$Administration)) == 0 # TRUE если длина равна 0
# Пробуем заменить:
tab[filter, "Administration"] <- "Прочее"
tab$Administration <- as.character(tab$Administration)
tab[filter, "Administration"] <- "Прочее"
tab$Administration <- as.factor(tab$Administration)
levels(tab$Administration)
summary(tab)
write.csv2(okruga, "okruga.csv", fileEncoding = 'UTF-8') # Сохраним первую таблицу в CSV в кодировке Unicode
write.xlsx(neokruga, "neokruga.xlsx") # Сохраним вторую таблицу в XLSX без названий строк

# Проверим, все ли в порядке с сохраненными таблицами:

okruga.saved <- read.csv2("okruga.csv", encoding = 'UTF-8')
head(okruga.saved)

neokruga.saved <- read.xlsx("neokruga.xlsx",1)
head(neokruga.saved)
