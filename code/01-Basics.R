2 + 3
2 - 3
2 * 3
2.5 + 3.1
2 ^ 3
2 ** 3
5 / 3
5 / 2.5
5 %/% 3
5 %% 3
5%/%3
5 %/% 3
a <- 5
b <- 3
a
b
a + b
a - b
a / b
a %/% b
a %% b
b <- 4
a + b
a - b
a / b
a %/% b
a %% b
c <- b
d <- a+c
c
d
e <- d + 2.5
e
f <- -2
f
f <- -e
f
c %% 2
d %% 2
sqrt(a)
sin(a)
tan(1.5)
abs(a + b - 2.5)
sin(sqrt(a))
sqrt(sin(a) + 2)
b <- sin(sqrt(a))
b
b <- sin(a)
b
b <- abs(b)
b
s <- "В историю трудно войти, но легко вляпаться (М.Жванецкий)"
s
nchar(s)
s1 <- "В историю трудно войти,"
s2 <- "но легко вляпаться"
s3 <- "(М.Жванецкий)"
s1
s2
s3
s <- paste(s1, s2)
s
s <- paste(s1, s2, s3)
s
year <- 1950
pop <- 1850
s1 <- "Максимальная численность населения в Детройте пришлась на"
s2 <- "год и составила"
s3 <- "тыс. чел"
s <- paste(s1, year, s2, pop, s3)
s
birth <- as.Date('1986/02/18')
birth

current <- Sys.Date()
current
livedays <- current - birth
livedays
current + 40
a <- 1
b <- 2
a == b
a != b
a > b
a < b
c<-3
(b>a) && (c>b)
(a>b) && (c>b)
(a>b) || (c>b)
!(a>b)
class(1)
class(0.5)
class(1 + 2i)
class("sample")
class(TRUE)
class(as.Date('1986-02-18'))
k <- 1
print(k)
class(k)

l <- as(k, "integer")
print(l)
class(l)

m <- as(l, "character")
print(m)
class(m)

n <- as(m, "numeric")
print(n)
class(n)
k <- 1
l <- as.integer(k)
print(l)
class(l)

m <- as.character(l)
print(m)
class(m)

n <- as.numeric(m)
print(n)
class(n)

d <- as.Date('1986-02-18')
print(d)
class(d)
as.integer(2.7)
a <- 2.5
b <- as.character(a)
b + 2
nchar(b)
## a <- readline()
a
a <- 1024
a
print(a)

b <- "Fourty winks in progress"
b
print(b)

print(paste("2 в степени 10 равно", 2^10))

print(paste("Сегодняшняя дата - ", Sys.Date()))
cat(a)
cat(b)

cat("2 в степени 10 равно", 2^10)

cat("Сегодняшнаяя дата -", Sys.Date())
