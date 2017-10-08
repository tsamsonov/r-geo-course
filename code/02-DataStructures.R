# вектор из строк — цвета некоторых веток Московского метро
colors <- c("Красная", "Зеленая", "Синяя", "Коричневая", "Оранжевая")
colors
# вектор из чисел — длина веток в километрах (в той же последовательности)
lengths <- c(28, 40, 45, 19, 38)
lengths
# вектор из булевых переменных — наличие  открытых наземных участков (в той же последовательности)
opens <- c(FALSE, TRUE, TRUE, FALSE, FALSE)
opens
# Вектор из 5 элементов, который предполагается заполнить целыми числами
intvalues <- vector(mode = "integer", length = 5)
intvalues # по умолчанию заполнен нулями

# Вектор из 10 элементов, который предполагается заполнить символьными данными (строками)
charvalues <- vector("character", 10)
charvalues # по умолчанию заполнен пустыми строками
index <- 1:5 # эквивалентно c(1,2,3,4,5)
index
index <- 2:4 # эквивалентно c(2,3,4)
index
seq(from = 1, by = 2, length.out = 10) # 10 нечетных чисел, начиная с единицы
seq(from = 2, to = 20, by = 3) # от 2 до 20 с шагом 3 (сколько поместится)
seq(length.out = 10, to = 2, by = -2) # убывающая последовательность из 10 четных чисел с последним элементом, равным 2
seq(from = as.Date('2016/09/01'), by = 1, length.out = 7) # Даты первой недели учебного 2016/2017 года

seq(from = Sys.Date(), by = 7, length.out = 5) # Пять дат через неделю, начиная с сегодняшнего дня
colors[1] # первый элемент вектора
colors[3] # третий элемент
length(colors)
n <- length(colors)
colors[n]
lengths[1:4]
m <- 1
n <- 4
index <- m:n
lengths[index]
index <- c(1, 3, 4) # хотим извлечь 1, 3 и 4 элемент списка
lengths[index]

index <- c(5, 1, 4, 2) # индексы могут располагаться в произвольном порядке
lengths[index]
min(lengths) # минимум
max(lengths) # максимум
range(lengths) # размах вариации = максимум - минимум
mean(lengths) # среднее арифметическое
median(lengths) # медиана
var(lengths) # дисперсия (по английски - вариация, variation)
sd(lengths) # среднеквадратическое отклонение (standard deviation)
sum(lengths) # сумма
lengths * 1000 # преобразуем длины линий в метры
sqrt(lengths) # квадратный корень из длины каждого элемента

stations <- c(20, 21, 22, 12, 24) # количество станций

dens <- stations / lengths # плотность станций по веткам метро = кол-во станций / длина 
dens
lengths2 <- sort(lengths) # сортировка по возрастанию значений
lengths2 # отсортированный вектор
lengths # сравним с исходным

lengths2 <- sort(lengths, decreasing = TRUE) # сортировка по убыванию значений. Нужно задать параметр decreasing
lengths2 # отсортированный вектор
lengths # сравним с исходным
l <- max(lengths) # находим максимальное значение
idx <- match(l, lengths) # находим индекс элемента, равного l, в списке lengths
color <- colors[idx] # извлекаем цвет ветки метро
color
s <- paste(color, "ветка Московского метро — самая длинная. Ее протяженность составляет", l, "км")
s
colors[match(max(dens),dens)]
v <- 1:12  # создадим вектор из натуральных чисел от 1 до 12
m <- matrix(v, nrow = 3, ncol = 4)
m
m <- matrix(v, nrow = 3, ncol = 4, byrow = TRUE)
m
m[2,4]  # 2 строка, 4 толбец
m[3,1]  # 3 строка, 1 столбец
m[2,]  # 2 строка
m[,3]  # 3 cтолбец
log(m)  # натуральный логарифм ото всех элементов
sum(m)  # сумма всех элементов матрицы
median(m) # медиана
sort(m)
t(m)  # транспонированная матрица
m2<-matrix(-3:3,nrow = 3, ncol = 3)
m2
det(m2) # определитель матрицы
det(m)  # ошибка! определитель вычисляется только для квадратных матриц
m2 %*% m
m %*% m2  # ошибка!
which(m == 8, arr.ind = TRUE)
indexes <- which(m == 8, arr.ind = TRUE)
row <- indexes[1,1]
col <- indexes[1,2]
m[row,col]
lengths <- c(28, 40, 45, 19, 38)
stations <- c(20, 21, 22, 12, 24)
cbind(lengths, stations)  # соединим вектора в качестве столбцов
rbind(lengths, stations)  # соединим вектора в качестве строк
mm <- cbind(lengths, stations)
mm[,2]/mm[,1]  # количество станций на 1 км пути
dens <- mm[,2]/mm[,1]
mm<-cbind(mm, dens)
mm
colors <- c("Красная", "Зеленая", "Синяя", "Коричневая", "Оранжевая")
mm2<-cbind(mm,colors)
mm2  # обратите внимание на то, что вокруг чисел добавились кавычки
mm2[,2]/mm2[,1]
t<-data.frame(colors,lengths,stations)
t  # как мы видим, уже никаких кавычек вокруг чисел
t<-cbind(t, dens)
t
t[2,2]
t[,3]
t[4,]

t$lengths
t$stations
max(t$stations)
t$lengths / t$stations
colnames(t)
row<-data.frame("Фиолетовая", 40.5, 22, 22/45)
colnames(row) <- colnames(t)
t<-rbind(t,row)
colnames(t)<-c("Цвет","Длина","Станции","Плотность")
colnames(t)
t$Длина
t
d <- "Этт фрейм данных содержит данные по 6 линиям Московского метро"
s <- summary(t)  # summary() выдает обобщающую статистику вектору, матрице или фрейму данных
metrolist <- list(d,t,s)
metrolist
metrolist <- list(desc = d, table = t, summary = s)
metrolist
metrolist$summary
metrolist$summary[,3]
metrolist[[1]]
metrolist[["desc"]]
