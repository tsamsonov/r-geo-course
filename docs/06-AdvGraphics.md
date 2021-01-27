# Продвинутая графика {#advgraphics}



## Предварительные требования {#advgraphics_prerequisites}

Для работы по теме текущей лекции вам понадобятся пакеты __ggplot2__, __dplyr__ и __tidyr__ из __tidyverse__. Помимо этого, мы будем работать напрямую с данными [__Евростата__](https://ec.europa.eu/eurostat/web/main/home), NASA [__POWER__](https://power.larc.nasa.gov/) и USDA NRCS [__Soil Data Access__](https://sdmdataaccess.nrcs.usda.gov/) к которым можно обращаться напрямую с использованием пакетов [`eurostat`](https://ropengov.github.io/eurostat/), [`nasapower`](https://docs.ropensci.org/nasapower/) и [`soildb`](http://ncss-tech.github.io/soilDB/docs/):

```r
library(dplyr)
library(tidyr)
library(ggplot2)
library(eurostat)
library(nasapower)
library(soilDB)
```

> Пакет soilDB лучше устанавливать из консоли командой `install.packages('soilDB', dependencies = TRUE)`. Указание параметра `dependencies = TRUE` обеспечит установку других пакетов, от которых он зависит.

В настоящей главе мы кратко познакомимся с системой [__ggplot2__](https://ggplot2.tidyverse.org/). __gg__ расшифровывается как _grammar of graphics_. Под этим понимается определенная (какая — мы узнаем далее) система правил, позволяющих описывать и строить графики. ggplot довольно сильно отличается от стандартной графической подсистемы R. Прежде всего — модульным подходом к построению изображений. В ggplot вы собираете графики «по кирпичикам», отдельно определяя источник данных, способы изображения, параметры системы координат и т.д. -- путем вызова и _сложения_ результатов соответствующих функций. 

При построении элементарных графиков __ggplot__ может показаться (и по факту так и есть) сложнее, чем стандартная графическая подсистема. Однако при усложнении требований к внешнему виду и информационному насыщению графика сложность ggplot оказывается преимуществом, и с ее помощью _относительно просто_ можно получать элегантные и информативные визуализации, на создание которых с помощью стандартной подсистемы пришлось бы затратить невероятные усилия! В этой главе мы кратко познакомимся с ggplot, а далее на протяжении курса будем регулярно ее использовать, осваивая новые возможности.

## Загрузка данных Евростата {#advgraphics_eurostat}

Таблицы данных Евростата имеют уникальные коды, по которым их можно загружать, используя API (Application programming interface). В этой лекции мы будем работать с данными о крупнейших международных партнерах Евросоюза по импорту и экспорту основных видов товаров. Например, [таблица данных по продуктам питания, напиткам и табаку](https://ec.europa.eu/eurostat/databrowser/view/tet00034/default/table?lang=en) имеет код __tet00034__:

<img src="images/eurostat.png" width="100%" />


Для чтения таблиц по кодам в пакете eurostat имеется функция `get_eurostat()`. Чтобы год измерения получить в виде числа, а не объекта типа `Date`, используем второй параметр `time_format = num`. Для перехода от кодов продукции и стран к их полным наименованиям, дополнительно вызовем функцию `label_eurostat()` из того же пакета:

```r
tables = c('tet00034', 'tet00033', 'tet00032', 'tet00031','tet00030', 'tet00029')

trades = lapply(tables, function(X) { # прочтем несколько таблиц в список
  get_eurostat(X) %>% label_eurostat()
}) %>% 
  bind_rows() %>% # объединим прочитанные таблицы в одну
  select(-geo) %>% # убираем столбец с территорией торговли, т.к. там только Евросоюз
  dplyr::filter(stringr::str_detect(indic_et, 'Exports in|Imports in')) %>% # оставим только экспорт и импорт
  pivot_wider(names_from = indic_et, values_from = values) %>%  # вынесем данные по экспорту и импорту в отдельные переменные
  rename(export = `Exports in million of ECU/EURO`, # дадим им краткие названия
         import = `Imports in million of ECU/EURO`) %>% 
  mutate(partner = as.factor(partner))

trades # посмотрим, что получилось
## # A tibble: 720 x 5
##    sitc06                   partner                time        export import
##    <chr>                    <fct>                  <date>       <dbl>  <dbl>
##  1 Food, drinks and tobacco Argentina              2008-01-01    81.3  7334 
##  2 Food, drinks and tobacco Brazil                 2008-01-01   600.   9639.
##  3 Food, drinks and tobacco Canada                 2008-01-01  1950.   1458.
##  4 Food, drinks and tobacco Switzerland            2008-01-01  5000.   2727.
##  5 Food, drinks and tobacco China except Hong Kong 2008-01-01  1322.   3567.
##  6 Food, drinks and tobacco Japan                  2008-01-01  3964.    119.
##  7 Food, drinks and tobacco Norway                 2008-01-01  2416.   3012.
##  8 Food, drinks and tobacco Russia                 2008-01-01  7567.    855.
##  9 Food, drinks and tobacco Turkey                 2008-01-01  1175    3160.
## 10 Food, drinks and tobacco United States          2008-01-01 10021.   6030.
## # … with 710 more rows
```

## Загрузка данных NASA POWER {#advgraphics_nasapower}

NASA [__POWER__](https://power.larc.nasa.gov/) — это проект _NASA_, предоставляющий метеорологические, климатические и энергетические данные для целей исследования возобновляемых источников энергии, энергетической эффективности зданий и сельскохозяйственных приложений. Доступ к этим данным, как и Евростату, можно получить через программный интерфейса (API), используя пакет [__nasapower__](https://docs.ropensci.org/nasapower/). 

В основе выгрузки данных лежат реанализы с разрешением $0.5^\circ$ Выгрузим данные по температуре, относительной влажности и осадкам в Екатеринбурге ($60.59~в.д.$, $56.84~с.ш.$) за период с 1 по 30 апреля 1995 года:


```r
daily_single_ag <- get_power(
  community = "AG",
  lonlat = c(60.59, 56.84),
  pars = c("RH2M", "T2M", "PRECTOT"),
  dates = c("1995-04-01", "1995-04-30"),
  temporal_average = "DAILY"
)

daily_single_ag # посмотрим, что получилось
## NASA/POWER SRB/FLASHFlux/MERRA2/GEOS 5.12.4 (FP-IT) 0.5 x 0.5 Degree Daily Averaged Data  
##  Dates (month/day/year): 04/01/1995 through 04/30/1995  
##  Location: Latitude  56.84   Longitude 60.59  
##  Elevation from MERRA-2: Average for 1/2x1/2 degree lat/lon region = 279.98 meters   Site = na  
##  Climate zone: na (reference Briggs et al: http://www.energycodes.gov)  
##  Value for missing model data cannot be computed or out of model availability range: NA  
##  
##  Parameters: 
##  PRECTOT MERRA2 1/2x1/2 Precipitation (mm day-1) ;
##  T2M MERRA2 1/2x1/2 Temperature at 2 Meters (C) ;
##  RH2M MERRA2 1/2x1/2 Relative Humidity at 2 Meters (%)  
##  
## # A tibble: 30 x 10
##      LON   LAT  YEAR    MM    DD   DOY YYYYMMDD    RH2M   T2M PRECTOT
##    <dbl> <dbl> <dbl> <int> <int> <int> <date>     <dbl> <dbl>   <dbl>
##  1  60.6  56.8  1995     4     1    91 1995-04-01  77.1  6.29    0   
##  2  60.6  56.8  1995     4     2    92 1995-04-02  78.4  8.13    0   
##  3  60.6  56.8  1995     4     3    93 1995-04-03  75.1  8.35    0.03
##  4  60.6  56.8  1995     4     4    94 1995-04-04  78.1  7.92    2.35
##  5  60.6  56.8  1995     4     5    95 1995-04-05  89.4  5.64    3.99
##  6  60.6  56.8  1995     4     6    96 1995-04-06  89.0  6.29    1.26
##  7  60.6  56.8  1995     4     7    97 1995-04-07  82.5  3.58    1.14
##  8  60.6  56.8  1995     4     8    98 1995-04-08  75.1  2.6     1.47
##  9  60.6  56.8  1995     4     9    99 1995-04-09  77.1  3.88    1.76
## 10  60.6  56.8  1995     4    10   100 1995-04-10  72.6  4.96    0   
## # … with 20 more rows
```

Аналогичным путем можно выгрузить данные, осредненные по годам. Например, можно получить данные по суммарной и прямой солнечной радиации ($кВт/ч/м^2/день$) для той же точки с 1995 по 2015 год:


```r
interannual_sse <- get_power(
  community = "SSE",
  lonlat = c(60.59, 56.84),
  dates = 1995:2015,
  temporal_average = "INTERANNUAL",
  pars = c("CLRSKY_SFC_SW_DWN",
           "ALLSKY_SFC_SW_DWN")
)
interannual_sse # посмотрим, что получилось
## NASA/POWER SRB/FLASHFlux/MERRA2/GEOS 5.12.4 (FP-IT) 0.5 x 0.5 Degree Interannual Averages/Sums  
##  Dates (month/day/year): 01/01/1995 through 12/31/1996  
##  Location: Latitude  56.84   Longitude 60.59  
##  Elevation from MERRA-2: Average for 1/2x1/2 degree lat/lon region = 279.98 meters   Site = na  
##  Climate zone: na (reference Briggs et al: http://www.energycodes.gov)  
##  Value for missing model data cannot be computed or out of model availability range: NA  
##  
##  Parameters: 
##  ALLSKY_SFC_SW_DWN SRB/FLASHFlux 1/2x1/2 All Sky Insolation Incident on a Horizontal Surface (kW-hr/m^2/day) ;
##  CLRSKY_SFC_SW_DWN SRB/FLASHFlux 1/2x1/2 Clear Sky Insolation Incident on a Horizontal Surface (kW-hr/m^2/day)  
##  
## # A tibble: 4 x 17
##     LON   LAT PARAMETER  YEAR   JAN   FEB   MAR   APR   MAY   JUN   JUL   AUG
##   <dbl> <dbl> <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1  60.6  56.8 CLRSKY_S…  1995  0.91  2.07  3.93  5.93  7.27  7.98  7.54  6.13
## 2  60.6  56.8 CLRSKY_S…  1996  0.94  2.12  4.02  6.24  7.37  7.93  7.42  6.23
## 3  60.6  56.8 ALLSKY_S…  1995  0.68  1.41  2.8   4.75  5.42  6.04  5.78  4.13
## 4  60.6  56.8 ALLSKY_S…  1996  0.76  1.57  3.39  4.82  5.3   6.2   5.58  4.5 
## # … with 5 more variables: SEP <dbl>, OCT <dbl>, NOV <dbl>, DEC <dbl>,
## #   ANN <dbl>
```
## Загрузка данных Soil Data Access {#advgraphics_soildb}

__Soil Data Access__ — это онлайн-сервис департамента сельского хозяйства США, который позволяет получать подробные данные о почвенных ресурсах этой страны. Наиболее часто запрашиваются данные по так называемым почвенным [_сериям_](https://en.wikipedia.org/wiki/Soil_series) — группам почвенных профилей, обладающих схожими характеристиками и, таким образом, идентичными с точки зрения сельскохозяйственного использования. Как правило, серии именуются по названию населенного пункта, рядом с которым впервые были найдены подобные почвы. 

Например, серия _Cecil_ имеет следующее покрытие и обеспеченность разрезами в базе данных SDA при запросе на сайте [Series Extent Explorer](https://casoilresource.lawr.ucdavis.edu/see/#cecil):

![Plot title. ](06-AdvGraphics_insertimage_1.png)
Для запросов данных по почвенным сериям достаточно вызвать функцию `fetchOSD` и передать ей имя одной или более серий:

```r
soils = c('wilkes',  'chewacla', 'congaree')
series = fetchOSD(soils, extended = TRUE)
```

Результирющий объект представляет собой список со множеством таблиц, которые характеризуют как почвенную серию в целом, так и отдельные ее разрезы:

```r
str(series)
## List of 13
##  $ SPC             :Formal class 'SoilProfileCollection' [package "aqp"] with 9 slots
##   .. ..@ idcol       : chr "id"
##   .. ..@ hzidcol     : chr "hzID"
##   .. ..@ depthcols   : chr [1:2] "top" "bottom"
##   .. ..@ metadata    :List of 8
##   .. .. ..$ aqp_df_class    : chr "data.frame"
##   .. .. ..$ aqp_group_by    : chr ""
##   .. .. ..$ aqp_hzdesgn     : chr "hzname"
##   .. .. ..$ aqp_hztexcl     : chr "texture_class"
##   .. .. ..$ depth_units     : chr "cm"
##   .. .. ..$ stringsAsFactors: logi FALSE
##   .. .. ..$ original.order  : int [1:22] 1 2 3 4 5 6 7 8 9 10 ...
##   .. .. ..$ origin          : chr "OSD via Soilweb / fetchOSD"
##   .. ..@ horizons    :'data.frame':	22 obs. of  19 variables:
##   .. .. ..$ id           : chr [1:22] "CHEWACLA" "CHEWACLA" "CHEWACLA" "CHEWACLA" ...
##   .. .. ..$ top          : int [1:22] 0 10 36 66 97 119 152 0 20 46 ...
##   .. .. ..$ bottom       : int [1:22] 10 36 66 97 119 152 203 20 46 56 ...
##   .. .. ..$ hzname       : chr [1:22] "Ap" "Bw1" "Bw2" "Bw3" ...
##   .. .. ..$ soil_color   : chr [1:22] "#7E5A3BFF" "#7A5C37FF" "#7A5C37FF" "#7E5A3BFF" ...
##   .. .. ..$ hue          : chr [1:22] "7.5YR" "10YR" "10YR" "7.5YR" ...
##   .. .. ..$ value        : int [1:22] 4 4 4 4 5 5 4 4 4 3 ...
##   .. .. ..$ chroma       : int [1:22] 4 4 4 4 8 1 4 4 3 3 ...
##   .. .. ..$ dry_hue      : chr [1:22] "7.5YR" "10YR" "10YR" "7.5YR" ...
##   .. .. ..$ dry_value    : int [1:22] 6 6 6 6 6 6 6 6 6 5 ...
##   .. .. ..$ dry_chroma   : int [1:22] 4 4 4 4 7 1 4 4 3 3 ...
##   .. .. ..$ texture_class: Ord.factor w/ 21 levels "coarse sand"<..: 13 18 17 13 17 17 13 13 13 NA ...
##   .. .. ..$ cf_class     : logi [1:22] NA NA NA NA NA NA ...
##   .. .. ..$ pH           : logi [1:22] NA NA NA NA NA NA ...
##   .. .. ..$ pH_class     : Ord.factor w/ 12 levels "ultra acid"<"extremely acid"<..: 3 3 3 3 3 3 3 4 NA NA ...
##   .. .. ..$ distinctness : chr [1:22] "clear" "gradual" "gradual" "gradual" ...
##   .. .. ..$ topography   : chr [1:22] "smooth" "wavy" "wavy" "wavy" ...
##   .. .. ..$ narrative    : chr [1:22] "Ap--0 to 4 inches; brown (7.5YR 4/4) loam; weak medium granular structure; friable; common very fine, fine, and"| __truncated__ "Bw1--4 to 14 inches; dark yellowish brown (10YR 4/4) silty clay loam; weak medium subangular blocky structure; "| __truncated__ "Bw2--14 to 26 inches; dark yellowish brown (10YR 4/4) clay loam; weak medium subangular blocky structure; friab"| __truncated__ "Bw3--26 to 38 inches; brown (7.5YR 4/4) loam; weak medium subangular blocky structure; friable; common fine roo"| __truncated__ ...
##   .. .. ..$ hzID         : chr [1:22] "1" "2" "3" "4" ...
##   .. ..@ site        :'data.frame':	3 obs. of  33 variables:
##   .. .. ..$ id                     : chr [1:3] "CHEWACLA" "CONGAREE" "WILKES"
##   .. .. ..$ soiltaxclasslastupdated: chr [1:3] "2010-02-11 00:00:00+00" "2002-07-18 00:00:00+00" "1997-06-06 00:00:00+00"
##   .. .. ..$ mlraoffice             : int [1:3] 3 3 3
##   .. .. ..$ series_status          : chr [1:3] "established" "established" "established"
##   .. .. ..$ family                 : chr [1:3] "fine-loamy, mixed, active, thermic fluvaquentic dystrudepts" "fine-loamy, mixed, active, nonacid, thermic oxyaquic udifluvents" "loamy, mixed, active, thermic, shallow typic hapludalfs"
##   .. .. ..$ soilorder              : chr [1:3] "inceptisols" "entisols" "alfisols"
##   .. .. ..$ suborder               : chr [1:3] "udepts" "fluvents" "udalfs"
##   .. .. ..$ greatgroup             : chr [1:3] "dystrudepts" "udifluvents" "hapludalfs"
##   .. .. ..$ subgroup               : chr [1:3] "fluvaquentic dystrudepts" "oxyaquic udifluvents" "typic hapludalfs"
##   .. .. ..$ tax_partsize           : chr [1:3] "fine-loamy" "fine-loamy" "loamy"
##   .. .. ..$ tax_partsizemod        : logi [1:3] NA NA NA
##   .. .. ..$ tax_ceactcl            : chr [1:3] "active" "active" "active"
##   .. .. ..$ tax_reaction           : chr [1:3] NA "nonacid" NA
##   .. .. ..$ tax_tempcl             : chr [1:3] "thermic" "thermic" "thermic"
##   .. .. ..$ originyear             : logi [1:3] NA NA NA
##   .. .. ..$ establishedyear        : int [1:3] 1937 1904 1916
##   .. .. ..$ descriptiondateinitial : chr [1:3] "2010-02-11 00:00:00+00" "2002-07-18 00:00:00+00" "2007-09-06 00:00:00+00"
##   .. .. ..$ descriptiondateupdated : chr [1:3] "2010-02-11 00:00:00+00" "2002-07-18 00:00:00+00" "2007-09-06 00:00:00+00"
##   .. .. ..$ benchmarksoilflag      : int [1:3] 1 0 0
##   .. .. ..$ statsgoflag            : int [1:3] 1 1 1
##   .. .. ..$ objwlupdated           : chr [1:3] "2012-08-01 14:06:37+00" "2012-08-01 14:06:37+00" "2012-08-01 14:06:37+00"
##   .. .. ..$ recwlupdated           : chr [1:3] "2012-08-01 14:06:37+00" "2012-08-01 14:06:37+00" "2012-08-01 14:06:37+00"
##   .. .. ..$ typelocstareaiidref    : int [1:3] 6691 6706 6691
##   .. .. ..$ typelocstareatypeiidref: int [1:3] 3 3 3
##   .. .. ..$ soilseriesiid          : int [1:3] 24628 1057 23800
##   .. .. ..$ soilseriesdbiidref     : int [1:3] 122 122 122
##   .. .. ..$ grpiidref              : int [1:3] 15801 15801 15801
##   .. .. ..$ tax_minclass           : chr [1:3] "mixed" "mixed" "mixed"
##   .. .. ..$ subgroup_mod           : chr [1:3] "fluvaquentic" "oxyaquic" "typic"
##   .. .. ..$ greatgroup_mod         : chr [1:3] "dystr" "udi" "hapl"
##   .. .. ..$ drainagecl             : chr [1:3] "somewhat poorly" "well" "well"
##   .. .. ..$ ac                     : int [1:3] 1259224 216875 617848
##   .. .. ..$ n_polygons             : int [1:3] 40647 10387 34748
##   .. ..@ sp          :Formal class 'SpatialPoints' [package "sp"] with 3 slots
##   .. .. .. ..@ coords     : num [1, 1] 0
##   .. .. .. ..@ bbox       : logi [1, 1] NA
##   .. .. .. ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slot
##   .. .. .. .. .. ..@ projargs: chr NA
##   .. ..@ diagnostic  :'data.frame':	0 obs. of  0 variables
##   .. ..@ restrictions:'data.frame':	0 obs. of  0 variables
##  $ competing       :'data.frame':	1 obs. of  3 variables:
##   ..$ series   : chr "CHEWACLA"
##   ..$ competing: chr "OAKBORO"
##   ..$ family   : chr "fine-loamy, mixed, active, thermic fluvaquentic dystrudepts"
##  $ geomcomp        :'data.frame':	3 obs. of  9 variables:
##   ..$ series         : chr [1:3] "CHEWACLA" "CONGAREE" "WILKES"
##   ..$ Interfluve     : num [1:3] 1 0 0.182
##   ..$ Crest          : num [1:3] 0 0 0.0267
##   ..$ Head Slope     : int [1:3] 0 0 0
##   ..$ Nose Slope     : int [1:3] 0 0 0
##   ..$ Side Slope     : num [1:3] 0 0 0.791
##   ..$ Base Slope     : int [1:3] 0 1 0
##   ..$ n              : int [1:3] 3 1 187
##   ..$ shannon_entropy: num [1:3] 0 0 0.368
##  $ hillpos         :'data.frame':	3 obs. of  8 variables:
##   ..$ series         : chr [1:3] "CHEWACLA" "CONGAREE" "WILKES"
##   ..$ Toeslope       : num [1:3] 0.963 0.786 0
##   ..$ Footslope      : num [1:3] 0.0366 0.2143 0
##   ..$ Backslope      : num [1:3] 0 0 0.636
##   ..$ Shoulder       : num [1:3] 0 0 0.227
##   ..$ Summit         : num [1:3] 0 0 0.138
##   ..$ n              : int [1:3] 82 14 247
##   ..$ shannon_entropy: num [1:3] 0.0975 0.3228 0.5577
##  $ mtnpos          : logi FALSE
##  $ terrace         :'data.frame':	2 obs. of  5 variables:
##   ..$ series         : chr [1:2] "CHEWACLA" "CONGAREE"
##   ..$ Tread          : num [1:2] 0.979 1
##   ..$ Riser          : num [1:2] 0.0213 0
##   ..$ n              : int [1:2] 94 36
##   ..$ shannon_entropy: num [1:2] 0.064 0
##  $ flats           :'data.frame':	2 obs. of  7 variables:
##   ..$ series         : chr [1:2] "CHEWACLA" "CONGAREE"
##   ..$ Dip            : num [1:2] 0.1569 0.0667
##   ..$ Talf           : num [1:2] 0.843 0.867
##   ..$ Flat           : int [1:2] 0 0
##   ..$ Rise           : num [1:2] 0 0.0667
##   ..$ n              : int [1:2] 51 15
##   ..$ shannon_entropy: num [1:2] 0.27 0.301
##  $ pmkind          :'data.frame':	6 obs. of  5 variables:
##   ..$ series: chr [1:6] "CHEWACLA" "CHEWACLA" "CONGAREE" "CONGAREE" ...
##   ..$ pmkind: chr [1:6] "Alluvium" "Residuum" "Alluvium" "Fluviomarine deposits" ...
##   ..$ n     : int [1:6] 207 1 72 13 1 264
##   ..$ total : int [1:6] 208 208 86 86 86 264
##   ..$ P     : num [1:6] 0.9952 0.0048 0.8372 0.1512 0.0116 ...
##  $ pmorigin        :'data.frame':	24 obs. of  5 variables:
##   ..$ series  : chr [1:24] "CHEWACLA" "CHEWACLA" "CHEWACLA" "CHEWACLA" ...
##   ..$ pmorigin: chr [1:24] "Igneous and metamorphic rock" "Sedimentary rock" "Granite and gneiss" "Mixed" ...
##   ..$ n       : int [1:24] 29 11 2 2 1 1 1 1 1 1 ...
##   ..$ total   : int [1:24] 51 51 51 51 51 51 51 51 51 51 ...
##   ..$ P       : num [1:24] 0.5686 0.2157 0.0392 0.0392 0.0196 ...
##  $ mlra            :'data.frame':	19 obs. of  4 variables:
##   ..$ series    : chr [1:19] "CHEWACLA" "CHEWACLA" "CHEWACLA" "CHEWACLA" ...
##   ..$ mlra      : chr [1:19] "129" "135A" "136" "133A" ...
##   ..$ area_ac   : int [1:19] 6166 3878 929362 128376 78429 59646 29004 13530 10366 2128 ...
##   ..$ membership: num [1:19] 0.005 0.003 0.738 0.102 0.062 0.047 0.023 0.011 0.008 0.01 ...
##  $ climate.annual  :'data.frame':	24 obs. of  12 variables:
##   ..$ series     : chr [1:24] "CHEWACLA" "CHEWACLA" "CHEWACLA" "CHEWACLA" ...
##   ..$ climate_var: chr [1:24] "Elevation (m)" "Effective Precipitation (mm)" "Frost-Free Days" "Mean Annual Air Temperature (degrees C)" ...
##   ..$ minimum    : num [1:24] 0 128.8 177 11.3 986 ...
##   ..$ q01        : num [1:24] 7 216.4 188 12.9 1069 ...
##   ..$ q05        : num [1:24] 34 247.4 196 13.5 1093 ...
##   ..$ q25        : num [1:24] 125 312.2 208 14.9 1136 ...
##   ..$ q50        : num [1:24] 192 349.8 218 15.7 1178 ...
##   ..$ q75        : num [1:24] 248 441.2 227 16.4 1276 ...
##   ..$ q95        : num [1:24] 348 568.8 235 17.3 1392 ...
##   ..$ q99        : num [1:24] 480 740.8 243 17.8 1575 ...
##   ..$ maximum    : num [1:24] 919 1382.8 300 19.7 2202 ...
##   ..$ n          : int [1:24] 32689 32689 32689 32689 32689 32689 32689 32689 8392 8392 ...
##  $ climate.monthly :'data.frame':	72 obs. of  14 variables:
##   ..$ series     : chr [1:72] "CHEWACLA" "CHEWACLA" "CHEWACLA" "CHEWACLA" ...
##   ..$ climate_var: chr [1:72] "ppt1" "ppt2" "ppt3" "ppt4" ...
##   ..$ minimum    : num [1:72] 61 64 81 63 60 78 83 74 68 53 ...
##   ..$ q01        : num [1:72] 74 71 92 71 69 83 92 85 81 72 ...
##   ..$ q05        : num [1:72] 82 73 98 75 72 89 100 89 86 76 ...
##   ..$ q25        : num [1:72] 93 83 105 83 81 96 108 96 91 82 ...
##   ..$ q50        : num [1:72] 105 107 120 88 92 101 116 102 98 86 ...
##   ..$ q75        : num [1:72] 115 121 128 95 101 106 123 110 105 91 ...
##   ..$ q95        : num [1:72] 131 135 137 111 111 117 133 129 118 100 ...
##   ..$ q99        : num [1:72] 149 144 147 122 125 133 143 142 137 109 ...
##   ..$ maximum    : num [1:72] 248 227 239 150 167 198 220 207 192 158 ...
##   ..$ n          : int [1:72] 32689 32689 32689 32689 32689 32689 32689 32689 32689 32689 ...
##   ..$ month      : Factor w/ 12 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ variable   : Factor w/ 2 levels "Potential ET (mm)",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ soilweb.metadata:'data.frame':	19 obs. of  2 variables:
##   ..$ product    : chr [1:19] "block diagram archive" "component pedons" "KSSL snapshot" "MLRA membership" ...
##   ..$ last_update: chr [1:19] "2019-12-17" "2020-12-08" "2020-03-13" "2020-07-14" ...
```


## Базовый шаблон ggplot {#advgraphics_template}

Для начала посмотрим, как можно показать суммарный экспорт по годам:

```r
trades_total = trades %>% 
  group_by(time) %>% 
  summarise(export = sum(export),
            import = sum(import))
  
ggplot(data = trades_total) +
  geom_point(mapping = aes(x = time, y = export))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-8-1.png" width="100%" />

Базовый (минимально необходимый) шаблон построения графика через __ggplot__ выглядит следующим образом:

```r
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
```
где:

- `DATA` --- источник данных (фрейм, тиббл)
- `GEOM_FUNCTION` --- функция, отвечающая за геометрический тип графика (точки, линии, гистограммы и т.д.)
- `MAPPINGS` --- перечень соответствий между переменными данных (содержащихся в `DATA`) и графическими переменными (координатами, размерами, цветами и т.д.)

## Геометрические типы и преобразования {#advgraphics_geoms}

ggplot предлагает несколько десятков различных видов геометрий для отображения данных. С их полным перечнем можно познакомиться [тут](https://ggplot2.tidyverse.org/reference/). Мы рассмотрим несколько наиболее употребительных, а геометрии, связанные со статистическими преобразованиями, оставим для следующей темы.

В первом примере мы отображали данные по экспорту за разные года, однако точечный тип не очень подходит для данного типа графика, поскольку он показывает динамику изменения. А это означает, что желательно соединить точки линиями. Для этого используем геометрию `geom_line()`:


```r
ggplot(data = trades_total) +
  geom_line(mapping = aes(x = time, y = export))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-10-1.png" width="100%" />

Поскольку в данном случае величина является агрегированной за год, более правильным может быть показ ее изменений в виде ступенчатого линейного графика, который получается через геометрию `geom_step()`:


```r
ggplot(data = trades_total) +
  geom_step(mapping = aes(x = time, y = export))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-11-1.png" width="100%" />

Можно совместить несколько геометрий, добавив их последовательно на график:

```r
ggplot(data = trades_total) +
  geom_line(mapping = aes(x = time, y = export)) +
  geom_point(mapping = aes(x = time, y = export))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-12-1.png" width="100%" />

Если у нескольких геометрий одинаковые отображения, их можно вынести в вызов функции `ggplot()` (чтобы не дублировать):

```r
ggplot(data = trades_total, mapping = aes(x = time, y = export)) +
  geom_line() +
  geom_point()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-13-1.png" width="100%" />

Наглядность линейного графика можно усилить, добавив "заливку" области с использованием `geom_area()`:

```r
ggplot(data = trades_total, mapping = aes(x = time, y = export)) +
  geom_area(alpha = 0.5) + # полигон с прозрачностью 0,5
  geom_line() +
  geom_point()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-14-1.png" width="100%" />

Для построения столбчатой диаграммы следует использовать геометрию `geom_col()`. Например, вот так выглядит структура экспорта продукции машиностроения из Евросоюза по ведущим партнерам:

```r
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment', time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export)) +
  geom_col()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-15-1.png" width="100%" />

Развернуть диаграмму можно, используя функцию `coord_flip()`:

```r
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment', time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export)) +
  geom_col() +
  coord_flip()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-16-1.png" width="100%" />

## Графические переменные и группировки {#advgraphics_aes}

Графические переменные --- это параметры, определяющие внешний вид символов. К ним относятся цвет (тон, насыщенность и светлота), размер, форма, ориентировка, внутренняя структура символа. В ggplot значения графических переменных могут быть едиными для всех измерений, а могут зависеть от величины измерений. С точки зрения управления здесь все просто: если вы хотите, чтобы какой-то графический параметр зависел от значения показателя, он должен быть указан внутри конструкции `mapping = aes(...)`. Если необходимо, чтобы этот параметр был одинаковым для всех измерений, вы должны его указать внутри `<GEOM_FUNCTION>(...)`, то есть не передавать в `mapping`.

Для управления цветом, формой и размером (толщиной) графического примитива следует использовать параметры _color_, _shape_ и _size_ соответственно. Посмотрим, как они работают внутри и за пределами функции `aes()`:


```r
# один цвет для графика (параметр за пределами aes)
ggplot(trades_total) + 
    geom_line(mapping = aes(x = time, y = export), color = 'blue')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-17-1.png" width="100%" />

```r

trade_russia = trades %>% dplyr::filter(partner == 'Russia')

ggplot(trade_russia) + # у каждой группы данных свой цвет (параметр внутри aes)
  geom_line(mapping = aes(x = time, y = export, color = sitc06))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-17-2.png" width="100%" />

```r

ggplot(trade_russia, mapping = aes(x = time, y = export, color = sitc06)) + # а теперь и с точками
  geom_line() +
  geom_point()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-17-3.png" width="100%" />

Аналогичным образом работает параметр формы значка:

```r
# один значок для графика
ggplot(trades_total) + 
    geom_point(mapping = aes(x = time, y = export), shape = 15)
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-18-1.png" width="100%" />

```r
    

ggplot(trade_russia) + # у каждой группы данных свой значок
    geom_point(mapping = aes(x = time, y = export, shape = sitc06))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-18-2.png" width="100%" />

Для изменения размера значка или линии используйте параметр `size`:

```r
# изменение размера значка и линии
ggplot(trades_total, mapping = aes(x = time, y = export)) + 
    geom_point(size = 5) +
    geom_line(size = 2)
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-19-1.png" width="100%" />

Если вы используете зависимые от значений графические переменные и при этом хотите добавить на график еще одну геометрию (c постоянными параметрами), то вам необходимо сгруппировать объекты второй геометрии по той же переменной, по которой вы осуществляете разбиение в первой геометрии. Для этого используйте параметр `group`:

```r
ggplot(trade_russia, aes(x = time, y = export)) + 
    geom_point(aes(shape = sitc06)) +
    geom_line(aes(group = sitc06))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-20-1.png" width="100%" />

Для изменения цвета столбчатых диаграмм следует использовать параметр `fill`, а цвет и толщина обводки определяются параметрами `color` и `size`:

```r
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment', time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export)) +
  geom_col(fill = 'plum4', color = 'black', size = 0.2) +
  coord_flip()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-21-1.png" width="100%" />

Цвет на столбчатых диаграммах можно использовать для отображения дополнительных переменных, например типа экспортируемой продукции. По умолчанию столбики будут образовывать стек

```r
trades %>% 
  dplyr::filter(time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export, fill = sitc06)) +
  geom_col(color = 'black', size = 0.2) +
  coord_flip()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-22-1.png" width="100%" />

Если вам важно не абсолютное количество, а процентное соотношение величин, вы можете применить вид группировки `position == 'fill`:

```r
trades %>% 
  dplyr::filter(time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export, fill = sitc06)) +
    geom_col(color = 'black', size = 0.2, position = 'fill') +
    coord_flip()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-23-1.png" width="100%" />

Еще один вид группировки — это группировка по соседству. Чтобы использовать ее, применить метод `position == 'dodge`:

```r
trade_russia %>% 
  dplyr::filter(time >= as.Date('2013-01-01')) %>% 
  ggplot(mapping = aes(x = time, y = export, fill = sitc06)) +
    geom_col(color = 'black', size = 0.2, position = 'dodge')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-24-1.png" width="100%" />

## Системы координат {#advgraphics_coords}

__ggplot__ поддерживает множество полезных преобразований координат, таких как смена осей X и Y, переход к логарифмическим координатам и использование полярной системы вместо декартовой прямоугольной. 

Смена переменных происходит благодаря уже знакомой нам функции `coord_flip()`. Рассмотрим, например, как изменилась структура экспорта/импорта по годам:

```r
trades_type = trades %>% 
  group_by(sitc06, time) %>% 
  summarise(export = sum(export),
            import = sum(import))

ggplot(trades_type) + 
    geom_point(mapping = aes(x = export, y = import, color = sitc06, size = time), alpha = 0.5)
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-25-1.png" width="100%" />

```r

ggplot(trades_type) + 
    geom_point(mapping = aes(x = export, y = import, color = sitc06, size = time), alpha = 0.5) +
    coord_flip()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-25-2.png" width="100%" />

Поскольку объемы продукции различаются _на порядки_, для различимости малых объемов целесообразно перейти к логарифмической шкале. Для этого используем `scale_log_x()` и `scale_log_y()`:

```r
ggplot(trades_type, mapping = aes(x = export, y = import, color = sitc06, size = time)) + 
  geom_point(alpha = 0.5) +
  scale_x_log10() +
  scale_y_log10()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-26-1.png" width="100%" />

Преобразование в полярную систему координат используется для того чтобы получить круговую секторную диаграмму Найтингейл (_coxcomb chart_):

```r
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment', time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export, fill = partner)) +
  geom_col() +
  coord_polar()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-27-1.png" width="100%" />
 
Разумеется, здесь тоже можно использовать преобразование шкалы по оси _Y_ (которая теперь отвечает за радиус). Применим правило квадратного корня, добавив вызов функции `scale_y_sqrt()`:

```r
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment', time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export, fill = partner)) +
  geom_col() +
  coord_polar() +
  scale_y_sqrt()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-28-1.png" width="100%" />

Чтобы построить классическую секторную диаграмму, необходимо, чтобы угол поворота соответствовал величине показателя (оси _Y_), а не названию категории (оси _X_). Для этого при вызове функции `coord_polar()` следует указать параметр `theta = 'y'`, а при вызове `geom_col()` оставить параметр `x` пустым:

```r
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment', time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = '', y = export, fill = partner), color = 'black', size = 0.2) +
  geom_col() +
  coord_polar(theta = 'y')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-29-1.png" width="100%" />

## Названия осей и легенды {#advgraphics_titles}

ggplot предоставляет ряд функций для аннотирования осей и легенды. Для этого можно использовать одну из следующих функций:

- `labs(...)` модифицирует заголовок легенды для соответствующей графической переменной, либо заголовок/подзаголовок графика
- `xlab(label)` модифицирует подпись оси X
- `ylab(label)` модифицирует подпись оси Y
- `ggtitle(label, subtitle = NULL)` модифицирует заголовок и подзаголовок графика

Создадим подписи легенд, отвечающих за цвет и размер значка на графике соотношения импорта и экспорта разных видов продукции:

```r
ggplot(trades_type) + 
  geom_point(mapping = aes(x = export, y = import, color = sitc06, size = time), alpha = 0.5) +
  labs(color = "Вид продукции", size = 'Год')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-30-1.png" width="100%" />

Добавим заголовок и подзаголовок графика:

```r
ggplot(trades_type) + 
  geom_point(mapping = aes(x = export, y = import, color = sitc06, size = time), alpha = 0.5) +
  labs(color = "Вид продукции", size = 'Год') +
  ggtitle('Соотношение импорта и экспорта в странах Евросоюза (млн долл. США)',
          subtitle = 'Данные по ключевым партнерам')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-31-1.png" width="100%" />

Изменим подписи осей:

```r
ggplot(trades_type) + 
  geom_point(mapping = aes(x = export, y = import, color = sitc06, size = time), alpha = 0.5) +
  labs(color = "Вид продукции", size = 'Год') +
  ggtitle('Соотношение импорта и экспорта в странах Евросоюза (млн долл. США)',
          subtitle = 'Данные по ключевым партнерам') +
  xlab('Экспорт') +
  ylab('Импорт')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-32-1.png" width="100%" />

## Разметка осей {#advgraphics_axes}

Первое, что вам скорее всего захочется убрать — это экспоненциальная запись чисел. На самом деле, эта запись не является параметром __ggplot__ или стандартной системы __graphics__. Количество значащих цифр, после которых число автоматически представляется в экспоненциальном виде, управляется параметром `scipen`. Мы можем задать его достаточно большим, чтобы запретить переводить любые разумные числа в экспоненциальный вид:

```r
options(scipen = 999)
ggplot(trades_type) + 
  geom_point(mapping = aes(x = export, y = import, color = sitc06, size = time), alpha = 0.5) +
  labs(color = "Вид продукции", size = 'Год') +
  ggtitle('Соотношение импорта и экспорта в странах Евросоюза (млн долл. США)',
          subtitle = 'Данные по ключевым партнерам') +
  xlab('Экспорт') +
  ylab('Импорт')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-33-1.png" width="100%" />

Для управления разметкой осей необходимо использовать функции `scale_x_continuous()`, `scale_y_continuous()`, `scale_x_log10(...)`, `scale_y_log10(...)`, `scale_x_reverse(...)`, `scale_y_reverse(...)`, `scale_x_sqrt(...)`, `scale_y_sqrt(...)`, которые, с одной стороны, указывают тип оси, а с другой стороны — позволяют управлять параметрами сетки координат и подписями.

Для изменения координат линий сетки и подписей необходимо использовать, соответственно, параметры `breaks` и `labels`:

```r
ggplot(trades_type, mapping = aes(x = export, y = import, color = sitc06, size = time)) + 
  geom_point(alpha = 0.5) +
  scale_x_log10(breaks = seq(0, 500000, 100000)) +
  scale_y_log10(breaks = seq(0, 500000, 100000))
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-34-1.png" width="100%" />

В данном случае, как раз, будет достаточно полезным параметр `labels`, поскольку метки можно сделать более компактными, поделив их на 1000 (и не забыть потом указать, что объемы теперь указаны не в миллионах, а в миллиардах долларов):

```r
brks = seq(0, 500000, 100000)
ggplot(trades_type, mapping = aes(x = export, y = import, color = sitc06, size = time)) + 
  geom_point(alpha = 0.5) +
  scale_x_log10(breaks = brks, labels = brks / 1000) +
  scale_y_log10(breaks = brks, labels = brks / 1000)
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-35-1.png" width="100%" />

Для обычной шкалы используйте функции `scale_x_continuous()` и `scale_y_continuous()`:

```r
ggplot(trades_type, mapping = aes(x = export, y = import, color = sitc06, size = time)) + 
  geom_point(alpha = 0.5) +
  scale_x_continuous(breaks = brks, labels = brks / 1000) +
  scale_y_continuous(breaks = brks, labels = brks / 1000)
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-36-1.png" width="100%" />

Для того чтобы принудительно указать диапазоны осей и графических переменных, следует использовать функции `lims(...)`, `xlim(...)` и `ylim(...)`. Например, мы можем приблизиться в левый нижний угол графика, задав диапазон 0-200000 по обеим осям:

```r
ggplot(trades_type, mapping = aes(x = export, y = import, color = sitc06, size = time)) + 
  geom_point(alpha = 0.5) +
  xlim(0, 75000) +
  ylim(0, 75000)
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-37-1.png" width="100%" />

Функция `lims()` работает еще хитрее: она позволяет применять графические переменные только к ограниченному набору значений исходных данных. Например, таким путем я могу выделить на графике продукцию машиностроения:

```r
ggplot(trades_type, mapping = aes(x = export, y = import, color = sitc06, size = time)) + 
  geom_point(alpha = 0.5) +
  lims(color = 'Machinery and transport equipment')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-38-1.png" width="100%" />

## Подписи и аннотации {#advgraphics_labels}

С точки зрения __ggplot__ текст на графике, отображающий входные данные, является одной из разновидностей геометрии. Размещается он с помощью функции `geom_text()`. Как и в случае с другими геометриями, параметры, зависящие от исходных данных, должны быть переданы внутри `mapping = aes(...)`:

```r
ggplot(data = trades_total, mapping = aes(x = time, y = export)) +
  geom_area(alpha = 0.5) + # полигон с прозрачностью 0,5
  geom_line() +
  geom_point() +
  geom_text(aes(label = floor(export / 1000))) # добавляем подписи
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-39-1.png" width="100%" />

Выравнивание подписи относительно якорной точки (снизу, сверху, справа, слева) по горизонтали и вертикали управляется параметрами `hjust` и `vjust`, а смещения по осям X (в координатах графика) — параметрами `nudge_x` и `nudge_y`:

```r
ggplot(data = trades_total, mapping = aes(x = time, y = export)) +
  geom_area(alpha = 0.5) + # полигон с прозрачностью 0,5
  geom_line() +
  geom_point() +
  geom_text(aes(label = floor(export / 1000)), 
            vjust = 0, nudge_y = 40000) # добавляем подписи
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-40-1.png" width="100%" />

Подписи с фоновой плашкой добавляются через функцию `geom_label()`, которая имеет аналогичный синтаксис:

```r
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment', time == as.Date('2017-01-01')) %>% 
  ggplot(mapping = aes(x = partner, y = export)) +
  geom_col(fill = 'plum4', color = 'black', size = 0.2) +
  coord_flip() +
  geom_label(aes(y = export / 2, label = floor(export / 1000))) # добавляем подписи
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-41-1.png" width="100%" />

__Аннотации__ представляют собой объекты, размещаемые на графике вручную, и используемые, как правило, для выделения объектов и областей. Для размещения аннотаций используется функция `annotate()`:

```r
ggplot(data = trades_total, mapping = aes(x = time, y = export)) +
  geom_area(alpha = 0.5) + # полигон с прозрачностью 0,5
  geom_line() +
  geom_point() +
  geom_text(aes(label = floor(export / 1000)), 
            vjust = 0, nudge_y = 40000) +
  annotate("text", x = as.Date('2009-01-01'), y = 550000, label = "Это провал", color = 'red')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-42-1.png" width="100%" />

Аннотировать можно не только подписями, но и регионами. Например, мы можем выделить область, которая соответствует импорту/экспорту продукции химической промышленности:

```r
ggplot(trades_type, mapping = aes(x = export, y = import, color = sitc06, size = time)) + 
  annotate("rect", xmin = 100000, xmax = 250000, ymin = 75000, ymax = 175000,  alpha = .2, color = 'black', size = 0.1) +
  geom_point(alpha = 0.5) +
  annotate("text", x = 175000, y = 190000, label = "Chemicals", color = 'coral')
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-43-1.png" width="100%" />


## Фасеты {#advgraphics_facets}

Фасеты представляют собой множество графиков, каждый из которых отображает свою переменную или набор значений. Для разбиения на фасеты используется функция facet_wrap(), которой необходимо передать переменную разбиения с _тильдой_. Например, рассмотрим изменение структуры импорта по годам:

```r
brks = c(0, 50, 100, 150, 200)
trades %>% 
  dplyr::filter(sitc06 == 'Machinery and transport equipment') %>% 
  ggplot(mapping = aes(x = partner, y = import)) +
  geom_col() +
  scale_y_continuous(breaks = brks * 1e3, labels = brks) +
  ggtitle('Импорт продукции машиностроения (мдрд долл. США)',
        subtitle = 'Данные по ключевым партнерам') +
  coord_flip() +
  facet_wrap(~time)
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-44-1.png" width="100%" />

## Темы {#advgraphics_themes}

Система __ggplot__ интересна также тем, что для нее существует множество предопределенных "тем" или скинов для оформления графиков. [Часть из них](https://ggplot2.tidyverse.org/reference/ggtheme.html) входит в состав самой библиотеки. Дополнительные темы можно установить через пакет [__ggthemes__](https://cran.r-project.org/web/packages/ggthemes/index.html). Чтобы изменить тему оформления ggplot, достаточно прибавить в конце построения графика соответствующую функцию. Например, классическая черно-белая тема получается прибавлением функции `theme_bw()`:

```r
ggplot(data = trades_total, mapping = aes(x = time, y = export)) +
  geom_area(alpha = 0.5) + # полигон с прозрачностью 0,5
  geom_line() +
  geom_point() +
  geom_text(aes(label = floor(export / 1000)), 
            vjust = 0, nudge_y = 40000) +
  theme_bw()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-45-1.png" width="100%" />

```r

ggplot(trades_type) + 
  geom_point(mapping = aes(x = export, y = import, color = sitc06, size = time), alpha = 0.5) +
  labs(color = "Вид продукции", size = 'Год') +
  ggtitle('Соотношение импорта и экспорта в странах Евросоюза (млн долл. США)',
          subtitle = 'Данные по ключевым партнерам') +
  xlab('Экспорт') +
  ylab('Импорт') +
  theme_bw()
```

<img src="06-AdvGraphics_files/figure-html/unnamed-chunk-45-2.png" width="100%" />

## Контрольные вопросы и упражнения {#questions_tasks_advgraphics}

### Вопросы {#questions_advgraphics}

1. Назовите три основных компоненты шаблона построения графика в __ggplot2__.
1. Как называются геометрии __ggplot2__, отвечающие за построение точек, линий и ступенчатых линий?
1. Как называется геометрия __ggplot2__, отвечающая за построение столбчатой диаграммы?
1. Как сделать так, чтобы графический параметр __ggplot2__ был постоянным для всех измерений?
1. Как сделать так, чтобы графический параметр __ggplot2__ зависел от значения переменной?
1. Перечислите названия параметров, отвечающих за цвет, размер, заливку и тип значка графического примитива.
1. Если вы используете зависимые от значений графические переменные и при этом хотите добавить на график еще одну геометрию с постоянными параметрами, то как это можно реализовать?
1. Перечислите названия режимов группировки столбчатых диаграмм и пути их реализации.
1. Какая функция ggplot2 позволяет поменять местами оси координат?
1. Перечислите типы шкал для осей координат, которые доступны в __ggplot2__.
1. Назовите функцию, позволяющую перейти к полярной системе координат при построении графика в __ggplot2__.
1. В чем отличие построения розы-диаграммы (_coxcomb chart_) и секторной диаграммы (_pie chart_) средствами __ggplot2__?
1. Что делает функция `labs()`?
1. Какие функции позволяют определить названия осей и заголовок графика?
1. Что делает функция `lims()`?
1. Как ограничить область построения графика заданным диапазоном значений координат?
1. Как ограничить применение графических переменных только к определенным значениям измерений?
1. Назовите геометрии, которые позволяют размещать подписи и подписи с плашками (фоном) на графиках __ggplot2__.
1. Чем отличаются аннотации от геометрии подписей в __ggplot__? Какие виды аннотаций можно создавать?
1. Каким образом можно построить фасетный график, на котором каждое изображение соответствует значению переменной? Каков синтаксис вызова соответствующей функции?
1. Как поменять стиль отображения (тему) графика __ggplot2__?
1. Как получить программный доступ к таблицам Евростата, не прибегая к закачке файлов? Какой пакет можно использовать для этого?
1. Что является уникальным идентификатором таблицы в данных Евростата и как его узнать?
1. Как преобразовать коды Евростата в загруженных таблицах в человеко-читаемые обозначения?

### Упражнения {#tasks_advgraphics}

1. Постройте линейный график хода температуры , а также столбчатую диаграмму хода суммарной солнечной радиации в Екатеринбурге на примере данных NASA POWER, загруженных в разделе [6.3](#advgraphics_nasapower).<!-- \@ref(advgraphics_nasapower). -->

    > __Подсказка__: Для построения столбчатой диаграммы вам потребуется использовать функцию `geom_col()`, поскольку высота столбика отражает не встречаемость значения, а величину переменной. Также вам потребуется преобразовать таблицу среднемесячных величин к длинной форме, где название месяца будет отдельной переменной (тип — упорядоченный фактор).

2. Загрузите [таблицу данных по импорту/экспорту продуктов питания, напитков и табака](https://ec.europa.eu/eurostat/databrowser/view/tet00034/default/table?lang=en) с портала Евростата (с использованием пакета __eurostat__). Постройте линейный график изменения _суммарных_ величин импорта и экспорта по данному показателю (у вас должно получиться 2 графика на одном изображении). Используйте _цвет_ для разделения графиков. Добавьте текстовые подписи величин импорта и экспорта. Постройте также две круговых диаграммы, показывающих соотношение ведущих импортеров и экспортеров за последний имеющийся год. Сделайте сначала это отдельными графиками, а затем одним фасетным графиком (для этого потребуется привести таблицу к длинной форме).

----
_Самсонов Т.Е._ **Визуализация и анализ географических данных на языке R.** М.: Географический факультет МГУ, 2021. DOI: [10.5281/zenodo.901911](https://doi.org/10.5281/zenodo.901911)
----
