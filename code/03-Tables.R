tab <- read.table("oxr_vod.csv",
                  sep = ';',
                  dec = ',',
                  header = TRUE,
                  encoding = 'UTF-8')
str(tab) # Посмотрим на структуру таблицы
tab <- read.csv2("oxr_vod.csv", encoding = 'UTF-8')
str(tab) # Посмотрим на структуру таблицы
library(readr)
tab <- as.data.frame(read_csv2("oxr_vod.csv"))
str(tab) # Посмотрим на структуру таблицы
library(openxlsx) # Подключаем библиотеку
sewage <- read.xlsx("sewage.xlsx", 1) # Читаем таблицу из первого листа
str(sewage) # Посмотрим на структуру таблицы
library(readxl)
sewage <- as.data.frame(read_excel("sewage.xlsx", 1))
str(sewage)
tab2 <- read.csv2("SatinoLanduse.csv", dec = '.')
str(tab2) # посмотрим, какова структура данных
tab2 <- read.csv2("SatinoLanduse.csv", dec = '.', stringsAsFactors = FALSE)
str(tab2) # посмотрим, какова структура данных
tab2 <- as.data.frame(read_csv2("SatinoLanduse.csv"))
str(tab2) # посмотрим, какова структура данных
classes <- c("integer", "character", "character", "character", "numeric", "numeric")
tab2 <- read.csv2("SatinoLanduse.csv", 
                 dec = '.', 
                 stringsAsFactors = FALSE, 
                 colClasses = classes)
print(tab)
head(tab)
tail(tab)
## View(tab)
## View(head(sewage, 3))
# Просмотрим текущие названия
colnames(sewage)
colnames(tab)

# Заменим их на новые
colnames(sewage) <- c("Region", "Year05", "Year10", "Year11", "Year12", "Year13")
colnames(tab) <- c("Year", "Total", "Baltic", "Black", "Azov", "Caspian", "Kara", "White", "Other")

# Проверим результат
colnames(sewage)
colnames(tab)
a <- head(sewage)

# Один столбец - результат зависит от запятой
a$Year05      # столбец в виде вектора
a[, "Year05"] # столбец в виде вектора
a[, 2]        # столбец в виде вектора

a["Year05"] # столбец в виде фрейма данных
a[2]        # столбец в виде фрейма данных

# Несколько столбцов - всегда фрейм данных
a[, c(1, 4)]              # столбцы в виде фрейма данных
a[, c("Region", "Year11")]# столбцы в виде фрейма данных
a[c("Region", "Year11")]  # столбцы в виде фрейма данных
a[c(1, 4)]                # столбцы в виде фрейма данных

# Создадим новый фрейм данных из трех необходимых столбцов:
caspian <- tab[c("Year", "Total", "Caspian")]
str(caspian)
cleaned <- tab[c(-2, -9)]
str(cleaned)
cleaned$Azov <- NULL
str(cleaned)
caspian$CaspianRatio <- round(caspian$Caspian / caspian$Total, 3)
## View(caspian)
years <- sewage[c(-1, -2)] # оставим данные с 2010 по 2013 гг

colSums(years)  # сколько всего было сброшено в каждом регионе за эти года
rowMeans(years) # сколько было сброшено в среднем за каждый год
tab[c(5,2,4), ]
indexes<-order(tab$Caspian)
head(tab[indexes, ])
head(tab[order(tab$Caspian), ])
condition <- tab$Caspian > 10
condition  # посмотрим что получилось
tab[condition, ] # используем его для фильтрации строк таблицы:
tab[tab$Caspian > 10, ]
# Первый параметр - искомое выражение, второй параметр - где искть
rows <- grep("федеральный округ",sewage$Region)
rows  # посмотрим, какие элементы столбца Region ему соответствуют
okruga <- sewage[rows,] # отфильтруем найденные строки
## View(okruga)
rows2 <- grepl("федеральный округ", sewage$Region)
rows2 # вот так выглядит результат grepl

neokruga <- sewage[!rows2, ]
## View(neokruga)
rows2 <- grepl("федеральный|числе|Российская|за|ѕ", sewage$Region)
rows2
neokruga <- sewage[!rows2, ] # обратите внимание на восклицательный знак перед rows2
## View(neokruga)
max(sewage$Year12)
max(sewage$Year12, na.rm = TRUE)
filter<-complete.cases(sewage)
filter  # посмотрим что получилось. Там где видим FALSE - есть пропуски в строках

sewage.complete <- sewage[filter, ] # отфильтруем полные строки
## View(sewage.complete)
tab <- read.csv2("SatinoLanduse.csv", encoding = 'UTF-8')
str(tab) # посмотрим, какова структура данных
## View(tab)
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
library(dplyr)

tab <- read.csv2("oxr_vod.csv")
colnames(tab) <- c("Year", "Total", "Baltic", "Black", "Azov", "Caspian", "Kara", "White", "Other")

# Выбор переменных Year, Total, Caspian
caspian <- select(tab, Year, Total, Caspian)
head(caspian)

# Вычисление нового столбца caspianRatio
caspian <- mutate(caspian, caspianRatio = round(Caspian / Total, 3))
head(caspian)

# Фильтрация по значению caspianRatio
caspian <- filter(caspian, caspianRatio > 0.445)
head(caspian)

# Сортировка по значению caspianRatio
caspian <- arrange(caspian, caspianRatio)
head(caspian)

# Агрегирование данных
stats <- summarise(caspian, total.sum = sum(Total), mean.ratio = mean(caspianRatio))
print(stats)
result <- tab %>% 
          select(Year, Total, Caspian) %>% 
          mutate(caspianRatio = round(Caspian / Total, 3)) %>% 
          filter(caspianRatio > 0.445) %>%
          arrange(caspianRatio)
head(result)
result <- arrange(
            filter(
              mutate(
                select(tab, Year, Total, Caspian),
                caspianRatio = round(Caspian / Total, 3)
              ),
              caspianRatio > 0.445
            ),
            caspianRatio
          )

