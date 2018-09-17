# Таблицы {#tables}



## Предварительные требования {#tables_prerequisites}

Для работы по теме текущей лекции вам понадобятся пакеты из `tidyverse`, а также `writexl`. Установите их, используя следующую команду:

```r
install.packages('tidyverse')
install.packages('writexl')
```

> Внимание: установка пакетов выполняется один раз из консоли. Вызов функции `install.packages()` не должен присутствовать в ваших скриптах

## Структуры данных {#tables_datastructures}

## Чтение {#tables_reading}

Существует множество способов получить набор табличных данных в текущей сессии R. Эти способы варьируются от загрузки данных из пакета до извлечения таблиц из текстовых документов и веб-страниц. В настоящей главе мы рассмотрим наиболее распространенные способы, нацеленные на работу с готовыми таблицами. 

### Встроенные данные {#tables_reading_inner}

Пакеты R часто содержат тестовые наборы данных. Эти данные, как правило, предназначены для ознакомления с возможностями пакета. Чтобы узнать, какие данные есть в пакете, вы можете вызвать функцию `data(package = 'packagename')`, где `packagename` --- это имя интересующего вас пакета. Например, посмотрим, какие данные есть в пакете `dplyr` (произносится как _deep liar_ — 'диплáйер'), который мы далее будем использовать для манипуляций с таблицами:

```r
data(package = 'dplyr')
```
![_Данные, доступные в пакете dplyr_](images/data_dplyr.png)

На рисунке можно видеть перечень наборов данных и их краткие описания. Для загрузки набора данных передайте его название в качестве первого параметра функции `data()`. Ну-ка, что там с персонажами из _Star Wars_:

```r
data(starwars, package = 'dplyr')
starwars
##                     name height   mass    hair_color          skin_color
## 1         Luke Skywalker    172   77.0         blond                fair
## 2                  C-3PO    167   75.0          <NA>                gold
## 3                  R2-D2     96   32.0          <NA>         white, blue
## 4            Darth Vader    202  136.0          none               white
## 5            Leia Organa    150   49.0         brown               light
## 6              Owen Lars    178  120.0   brown, grey               light
## 7     Beru Whitesun lars    165   75.0         brown               light
## 8                  R5-D4     97   32.0          <NA>          white, red
## 9      Biggs Darklighter    183   84.0         black               light
## 10        Obi-Wan Kenobi    182   77.0 auburn, white                fair
## 11      Anakin Skywalker    188   84.0         blond                fair
## 12        Wilhuff Tarkin    180     NA  auburn, grey                fair
## 13             Chewbacca    228  112.0         brown             unknown
## 14              Han Solo    180   80.0         brown                fair
## 15                Greedo    173   74.0          <NA>               green
## 16 Jabba Desilijic Tiure    175 1358.0          <NA>    green-tan, brown
## 17        Wedge Antilles    170   77.0         brown                fair
## 18      Jek Tono Porkins    180  110.0         brown                fair
## 19                  Yoda     66   17.0         white               green
## 20             Palpatine    170   75.0          grey                pale
## 21             Boba Fett    183   78.2         black                fair
## 22                 IG-88    200  140.0          none               metal
## 23                 Bossk    190  113.0          none               green
## 24      Lando Calrissian    177   79.0         black                dark
## 25                 Lobot    175   79.0          none               light
## 26                Ackbar    180   83.0          none        brown mottle
## 27            Mon Mothma    150     NA        auburn                fair
## 28          Arvel Crynyd     NA     NA         brown                fair
## 29 Wicket Systri Warrick     88   20.0         brown               brown
## 30             Nien Nunb    160   68.0          none                grey
## 31          Qui-Gon Jinn    193   89.0         brown                fair
## 32           Nute Gunray    191   90.0          none       mottled green
## 33         Finis Valorum    170     NA         blond                fair
## 34         Jar Jar Binks    196   66.0          none              orange
## 35          Roos Tarpals    224   82.0          none                grey
## 36            Rugor Nass    206     NA          none               green
## 37              Ric Olié    183     NA         brown                fair
## 38                 Watto    137     NA         black          blue, grey
## 39               Sebulba    112   40.0          none           grey, red
## 40         Quarsh Panaka    183     NA         black                dark
## 41        Shmi Skywalker    163     NA         black                fair
## 42            Darth Maul    175   80.0          none                 red
## 43           Bib Fortuna    180     NA          none                pale
## 44           Ayla Secura    178   55.0          none                blue
## 45              Dud Bolt     94   45.0          none          blue, grey
## 46               Gasgano    122     NA          none         white, blue
## 47        Ben Quadinaros    163   65.0          none grey, green, yellow
## 48            Mace Windu    188   84.0          none                dark
## 49          Ki-Adi-Mundi    198   82.0         white                pale
## 50             Kit Fisto    196   87.0          none               green
## 51             Eeth Koth    171     NA         black               brown
## 52            Adi Gallia    184   50.0          none                dark
## 53           Saesee Tiin    188     NA          none                pale
## 54           Yarael Poof    264     NA          none               white
## 55              Plo Koon    188   80.0          none              orange
## 56            Mas Amedda    196     NA          none                blue
## 57          Gregar Typho    185   85.0         black                dark
## 58                 Cordé    157     NA         brown               light
## 59           Cliegg Lars    183     NA         brown                fair
## 60     Poggle the Lesser    183   80.0          none               green
## 61       Luminara Unduli    170   56.2         black              yellow
## 62         Barriss Offee    166   50.0         black              yellow
## 63                 Dormé    165     NA         brown               light
## 64                 Dooku    193   80.0         white                fair
## 65   Bail Prestor Organa    191     NA         black                 tan
## 66            Jango Fett    183   79.0         black                 tan
## 67            Zam Wesell    168   55.0        blonde fair, green, yellow
## 68       Dexter Jettster    198  102.0          none               brown
## 69               Lama Su    229   88.0          none                grey
## 70               Taun We    213     NA          none                grey
## 71            Jocasta Nu    167     NA         white                fair
## 72         Ratts Tyerell     79   15.0          none          grey, blue
## 73                R4-P17     96     NA          none         silver, red
## 74            Wat Tambor    193   48.0          none         green, grey
## 75              San Hill    191     NA          none                grey
## 76              Shaak Ti    178   57.0          none    red, blue, white
## 77              Grievous    216  159.0          none        brown, white
## 78               Tarfful    234  136.0         brown               brown
## 79       Raymus Antilles    188   79.0         brown               light
## 80             Sly Moore    178   48.0          none                pale
## 81            Tion Medon    206   80.0          none                grey
## 82                  Finn     NA     NA         black                dark
## 83                   Rey     NA     NA         brown               light
## 84           Poe Dameron     NA     NA         brown               light
## 85                   BB8     NA     NA          none                none
## 86        Captain Phasma     NA     NA       unknown             unknown
## 87         Padmé Amidala    165   45.0         brown               light
##        eye_color birth_year        gender      homeworld        species
## 1           blue       19.0          male       Tatooine          Human
## 2         yellow      112.0          <NA>       Tatooine          Droid
## 3            red       33.0          <NA>          Naboo          Droid
## 4         yellow       41.9          male       Tatooine          Human
## 5          brown       19.0        female       Alderaan          Human
## 6           blue       52.0          male       Tatooine          Human
## 7           blue       47.0        female       Tatooine          Human
## 8            red         NA          <NA>       Tatooine          Droid
## 9          brown       24.0          male       Tatooine          Human
## 10     blue-gray       57.0          male        Stewjon          Human
## 11          blue       41.9          male       Tatooine          Human
## 12          blue       64.0          male         Eriadu          Human
## 13          blue      200.0          male       Kashyyyk        Wookiee
## 14         brown       29.0          male       Corellia          Human
## 15         black       44.0          male          Rodia         Rodian
## 16        orange      600.0 hermaphrodite      Nal Hutta           Hutt
## 17         hazel       21.0          male       Corellia          Human
## 18          blue         NA          male     Bestine IV          Human
## 19         brown      896.0          male           <NA> Yoda's species
## 20        yellow       82.0          male          Naboo          Human
## 21         brown       31.5          male         Kamino          Human
## 22           red       15.0          none           <NA>          Droid
## 23           red       53.0          male      Trandosha     Trandoshan
## 24         brown       31.0          male        Socorro          Human
## 25          blue       37.0          male         Bespin          Human
## 26        orange       41.0          male       Mon Cala   Mon Calamari
## 27          blue       48.0        female      Chandrila          Human
## 28         brown         NA          male           <NA>          Human
## 29         brown        8.0          male          Endor           Ewok
## 30         black         NA          male        Sullust      Sullustan
## 31          blue       92.0          male           <NA>          Human
## 32           red         NA          male Cato Neimoidia      Neimodian
## 33          blue       91.0          male      Coruscant          Human
## 34        orange       52.0          male          Naboo         Gungan
## 35        orange         NA          male          Naboo         Gungan
## 36        orange         NA          male          Naboo         Gungan
## 37          blue         NA          male          Naboo           <NA>
## 38        yellow         NA          male       Toydaria      Toydarian
## 39        orange         NA          male      Malastare            Dug
## 40         brown       62.0          male          Naboo           <NA>
## 41         brown       72.0        female       Tatooine          Human
## 42        yellow       54.0          male       Dathomir         Zabrak
## 43          pink         NA          male         Ryloth        Twi'lek
## 44         hazel       48.0        female         Ryloth        Twi'lek
## 45        yellow         NA          male        Vulpter     Vulptereen
## 46         black         NA          male        Troiken          Xexto
## 47        orange         NA          male           Tund          Toong
## 48         brown       72.0          male     Haruun Kal          Human
## 49        yellow       92.0          male          Cerea         Cerean
## 50         black         NA          male    Glee Anselm       Nautolan
## 51         brown         NA          male       Iridonia         Zabrak
## 52          blue         NA        female      Coruscant     Tholothian
## 53        orange         NA          male        Iktotch       Iktotchi
## 54        yellow         NA          male        Quermia       Quermian
## 55         black       22.0          male          Dorin        Kel Dor
## 56          blue         NA          male       Champala       Chagrian
## 57         brown         NA          male          Naboo          Human
## 58         brown         NA        female          Naboo          Human
## 59          blue       82.0          male       Tatooine          Human
## 60        yellow         NA          male       Geonosis      Geonosian
## 61          blue       58.0        female         Mirial       Mirialan
## 62          blue       40.0        female         Mirial       Mirialan
## 63         brown         NA        female          Naboo          Human
## 64         brown      102.0          male        Serenno          Human
## 65         brown       67.0          male       Alderaan          Human
## 66         brown       66.0          male   Concord Dawn          Human
## 67        yellow         NA        female          Zolan       Clawdite
## 68        yellow         NA          male           Ojom       Besalisk
## 69         black         NA          male         Kamino       Kaminoan
## 70         black         NA        female         Kamino       Kaminoan
## 71          blue         NA        female      Coruscant          Human
## 72       unknown         NA          male    Aleen Minor         Aleena
## 73     red, blue         NA        female           <NA>           <NA>
## 74       unknown         NA          male          Skako        Skakoan
## 75          gold         NA          male     Muunilinst           Muun
## 76         black         NA        female          Shili        Togruta
## 77 green, yellow         NA          male          Kalee        Kaleesh
## 78          blue         NA          male       Kashyyyk        Wookiee
## 79         brown         NA          male       Alderaan          Human
## 80         white         NA        female         Umbara           <NA>
## 81         black         NA          male         Utapau         Pau'an
## 82          dark         NA          male           <NA>          Human
## 83         hazel         NA        female           <NA>          Human
## 84         brown         NA          male           <NA>          Human
## 85         black         NA          none           <NA>          Droid
## 86       unknown         NA        female           <NA>           <NA>
## 87         brown       46.0        female          Naboo          Human
##                                                                                                                                        films
## 1                                            Revenge of the Sith, Return of the Jedi, The Empire Strikes Back, A New Hope, The Force Awakens
## 2                     Attack of the Clones, The Phantom Menace, Revenge of the Sith, Return of the Jedi, The Empire Strikes Back, A New Hope
## 3  Attack of the Clones, The Phantom Menace, Revenge of the Sith, Return of the Jedi, The Empire Strikes Back, A New Hope, The Force Awakens
## 4                                                               Revenge of the Sith, Return of the Jedi, The Empire Strikes Back, A New Hope
## 5                                            Revenge of the Sith, Return of the Jedi, The Empire Strikes Back, A New Hope, The Force Awakens
## 6                                                                                      Attack of the Clones, Revenge of the Sith, A New Hope
## 7                                                                                      Attack of the Clones, Revenge of the Sith, A New Hope
## 8                                                                                                                                 A New Hope
## 9                                                                                                                                 A New Hope
## 10                    Attack of the Clones, The Phantom Menace, Revenge of the Sith, Return of the Jedi, The Empire Strikes Back, A New Hope
## 11                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
## 12                                                                                                           Revenge of the Sith, A New Hope
## 13                                           Revenge of the Sith, Return of the Jedi, The Empire Strikes Back, A New Hope, The Force Awakens
## 14                                                                Return of the Jedi, The Empire Strikes Back, A New Hope, The Force Awakens
## 15                                                                                                                                A New Hope
## 16                                                                                        The Phantom Menace, Return of the Jedi, A New Hope
## 17                                                                                   Return of the Jedi, The Empire Strikes Back, A New Hope
## 18                                                                                                                                A New Hope
## 19                                Attack of the Clones, The Phantom Menace, Revenge of the Sith, Return of the Jedi, The Empire Strikes Back
## 20                                Attack of the Clones, The Phantom Menace, Revenge of the Sith, Return of the Jedi, The Empire Strikes Back
## 21                                                                         Attack of the Clones, Return of the Jedi, The Empire Strikes Back
## 22                                                                                                                   The Empire Strikes Back
## 23                                                                                                                   The Empire Strikes Back
## 24                                                                                               Return of the Jedi, The Empire Strikes Back
## 25                                                                                                                   The Empire Strikes Back
## 26                                                                                                     Return of the Jedi, The Force Awakens
## 27                                                                                                                        Return of the Jedi
## 28                                                                                                                        Return of the Jedi
## 29                                                                                                                        Return of the Jedi
## 30                                                                                                                        Return of the Jedi
## 31                                                                                                                        The Phantom Menace
## 32                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
## 33                                                                                                                        The Phantom Menace
## 34                                                                                                  Attack of the Clones, The Phantom Menace
## 35                                                                                                                        The Phantom Menace
## 36                                                                                                                        The Phantom Menace
## 37                                                                                                                        The Phantom Menace
## 38                                                                                                  Attack of the Clones, The Phantom Menace
## 39                                                                                                                        The Phantom Menace
## 40                                                                                                                        The Phantom Menace
## 41                                                                                                  Attack of the Clones, The Phantom Menace
## 42                                                                                                                        The Phantom Menace
## 43                                                                                                                        Return of the Jedi
## 44                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
## 45                                                                                                                        The Phantom Menace
## 46                                                                                                                        The Phantom Menace
## 47                                                                                                                        The Phantom Menace
## 48                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
## 49                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
## 50                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
## 51                                                                                                   The Phantom Menace, Revenge of the Sith
## 52                                                                                                   The Phantom Menace, Revenge of the Sith
## 53                                                                                                   The Phantom Menace, Revenge of the Sith
## 54                                                                                                                        The Phantom Menace
## 55                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
## 56                                                                                                  Attack of the Clones, The Phantom Menace
## 57                                                                                                                      Attack of the Clones
## 58                                                                                                                      Attack of the Clones
## 59                                                                                                                      Attack of the Clones
## 60                                                                                                 Attack of the Clones, Revenge of the Sith
## 61                                                                                                 Attack of the Clones, Revenge of the Sith
## 62                                                                                                                      Attack of the Clones
## 63                                                                                                                      Attack of the Clones
## 64                                                                                                 Attack of the Clones, Revenge of the Sith
## 65                                                                                                 Attack of the Clones, Revenge of the Sith
## 66                                                                                                                      Attack of the Clones
## 67                                                                                                                      Attack of the Clones
## 68                                                                                                                      Attack of the Clones
## 69                                                                                                                      Attack of the Clones
## 70                                                                                                                      Attack of the Clones
## 71                                                                                                                      Attack of the Clones
## 72                                                                                                                        The Phantom Menace
## 73                                                                                                 Attack of the Clones, Revenge of the Sith
## 74                                                                                                                      Attack of the Clones
## 75                                                                                                                      Attack of the Clones
## 76                                                                                                 Attack of the Clones, Revenge of the Sith
## 77                                                                                                                       Revenge of the Sith
## 78                                                                                                                       Revenge of the Sith
## 79                                                                                                           Revenge of the Sith, A New Hope
## 80                                                                                                 Attack of the Clones, Revenge of the Sith
## 81                                                                                                                       Revenge of the Sith
## 82                                                                                                                         The Force Awakens
## 83                                                                                                                         The Force Awakens
## 84                                                                                                                         The Force Awakens
## 85                                                                                                                         The Force Awakens
## 86                                                                                                                         The Force Awakens
## 87                                                                             Attack of the Clones, The Phantom Menace, Revenge of the Sith
##                                vehicles
## 1    Snowspeeder, Imperial Speeder Bike
## 2                                      
## 3                                      
## 4                                      
## 5                 Imperial Speeder Bike
## 6                                      
## 7                                      
## 8                                      
## 9                                      
## 10                      Tribubble bongo
## 11 Zephyr-G swoop bike, XJ-6 airspeeder
## 12                                     
## 13                                AT-ST
## 14                                     
## 15                                     
## 16                                     
## 17                          Snowspeeder
## 18                                     
## 19                                     
## 20                                     
## 21                                     
## 22                                     
## 23                                     
## 24                                     
## 25                                     
## 26                                     
## 27                                     
## 28                                     
## 29                                     
## 30                                     
## 31                      Tribubble bongo
## 32                                     
## 33                                     
## 34                                     
## 35                                     
## 36                                     
## 37                                     
## 38                                     
## 39                                     
## 40                                     
## 41                                     
## 42                         Sith speeder
## 43                                     
## 44                                     
## 45                                     
## 46                                     
## 47                                     
## 48                                     
## 49                                     
## 50                                     
## 51                                     
## 52                                     
## 53                                     
## 54                                     
## 55                                     
## 56                                     
## 57                                     
## 58                                     
## 59                                     
## 60                                     
## 61                                     
## 62                                     
## 63                                     
## 64                     Flitknot speeder
## 65                                     
## 66                                     
## 67           Koro-2 Exodrive airspeeder
## 68                                     
## 69                                     
## 70                                     
## 71                                     
## 72                                     
## 73                                     
## 74                                     
## 75                                     
## 76                                     
## 77          Tsmeu-6 personal wheel bike
## 78                                     
## 79                                     
## 80                                     
## 81                                     
## 82                                     
## 83                                     
## 84                                     
## 85                                     
## 86                                     
## 87                                     
##                                                                                                   starships
## 1                                                                                  X-wing, Imperial shuttle
## 2                                                                                                          
## 3                                                                                                          
## 4                                                                                           TIE Advanced x1
## 5                                                                                                          
## 6                                                                                                          
## 7                                                                                                          
## 8                                                                                                          
## 9                                                                                                    X-wing
## 10 Jedi starfighter, Trade Federation cruiser, Naboo star skiff, Jedi Interceptor, Belbullab-22 starfighter
## 11                                                Trade Federation cruiser, Jedi Interceptor, Naboo fighter
## 12                                                                                                         
## 13                                                                      Millennium Falcon, Imperial shuttle
## 14                                                                      Millennium Falcon, Imperial shuttle
## 15                                                                                                         
## 16                                                                                                         
## 17                                                                                                   X-wing
## 18                                                                                                   X-wing
## 19                                                                                                         
## 20                                                                                                         
## 21                                                                                                  Slave 1
## 22                                                                                                         
## 23                                                                                                         
## 24                                                                                        Millennium Falcon
## 25                                                                                                         
## 26                                                                                                         
## 27                                                                                                         
## 28                                                                                                   A-wing
## 29                                                                                                         
## 30                                                                                        Millennium Falcon
## 31                                                                                                         
## 32                                                                                                         
## 33                                                                                                         
## 34                                                                                                         
## 35                                                                                                         
## 36                                                                                                         
## 37                                                                                     Naboo Royal Starship
## 38                                                                                                         
## 39                                                                                                         
## 40                                                                                                         
## 41                                                                                                         
## 42                                                                                                 Scimitar
## 43                                                                                                         
## 44                                                                                                         
## 45                                                                                                         
## 46                                                                                                         
## 47                                                                                                         
## 48                                                                                                         
## 49                                                                                                         
## 50                                                                                                         
## 51                                                                                                         
## 52                                                                                                         
## 53                                                                                                         
## 54                                                                                                         
## 55                                                                                         Jedi starfighter
## 56                                                                                                         
## 57                                                                                            Naboo fighter
## 58                                                                                                         
## 59                                                                                                         
## 60                                                                                                         
## 61                                                                                                         
## 62                                                                                                         
## 63                                                                                                         
## 64                                                                                                         
## 65                                                                                                         
## 66                                                                                                         
## 67                                                                                                         
## 68                                                                                                         
## 69                                                                                                         
## 70                                                                                                         
## 71                                                                                                         
## 72                                                                                                         
## 73                                                                                                         
## 74                                                                                                         
## 75                                                                                                         
## 76                                                                                                         
## 77                                                                                 Belbullab-22 starfighter
## 78                                                                                                         
## 79                                                                                                         
## 80                                                                                                         
## 81                                                                                                         
## 82                                                                                                         
## 83                                                                                                         
## 84                                                                                      T-70 X-wing fighter
## 85                                                                                                         
## 86                                                                                                         
## 87                                                     H-type Nubian yacht, Naboo star skiff, Naboo fighter
```

> Обратите внимание, что после подключения набора данных он становится доступным в текущей сесси R именно с тем именем, с которым он сохранен в пакете

Если вызвать функцию `data()` без параметров, будет выведен список данных со всех пакетов, которые подключены в текущей сессии R:

```r
data()
```

![_Данные, доступные в текущей сессии R_](images/data.png)

По умолчанию в RStudio всегда подключен пакет _datasets_, который устанавливается вместе с базовым дистрибутивом R. Если пакет подключен в текущую сессию, то можно получить набор данных по его имени, не указывая название пакета. Например, в пакете _datasets_ есть набор данных `quakes` о землетрясениях на о. Фиджи:

```r
data(quakes)
quakes
##         lat   long depth mag stations
## 1    -20.42 181.62   562 4.8       41
## 2    -20.62 181.03   650 4.2       15
## 3    -26.00 184.10    42 5.4       43
## 4    -17.97 181.66   626 4.1       19
## 5    -20.42 181.96   649 4.0       11
## 6    -19.68 184.31   195 4.0       12
## 7    -11.70 166.10    82 4.8       43
## 8    -28.11 181.93   194 4.4       15
## 9    -28.74 181.74   211 4.7       35
## 10   -17.47 179.59   622 4.3       19
## 11   -21.44 180.69   583 4.4       13
## 12   -12.26 167.00   249 4.6       16
## 13   -18.54 182.11   554 4.4       19
## 14   -21.00 181.66   600 4.4       10
## 15   -20.70 169.92   139 6.1       94
## 16   -15.94 184.95   306 4.3       11
## 17   -13.64 165.96    50 6.0       83
## 18   -17.83 181.50   590 4.5       21
## 19   -23.50 179.78   570 4.4       13
## 20   -22.63 180.31   598 4.4       18
## 21   -20.84 181.16   576 4.5       17
## 22   -10.98 166.32   211 4.2       12
## 23   -23.30 180.16   512 4.4       18
## 24   -30.20 182.00   125 4.7       22
## 25   -19.66 180.28   431 5.4       57
## 26   -17.94 181.49   537 4.0       15
## 27   -14.72 167.51   155 4.6       18
## 28   -16.46 180.79   498 5.2       79
## 29   -20.97 181.47   582 4.5       25
## 30   -19.84 182.37   328 4.4       17
## 31   -22.58 179.24   553 4.6       21
## 32   -16.32 166.74    50 4.7       30
## 33   -15.55 185.05   292 4.8       42
## 34   -23.55 180.80   349 4.0       10
## 35   -16.30 186.00    48 4.5       10
## 36   -25.82 179.33   600 4.3       13
## 37   -18.73 169.23   206 4.5       17
## 38   -17.64 181.28   574 4.6       17
## 39   -17.66 181.40   585 4.1       17
## 40   -18.82 169.33   230 4.4       11
## 41   -37.37 176.78   263 4.7       34
## 42   -15.31 186.10    96 4.6       32
## 43   -24.97 179.82   511 4.4       23
## 44   -15.49 186.04    94 4.3       26
## 45   -19.23 169.41   246 4.6       27
## 46   -30.10 182.30    56 4.9       34
## 47   -26.40 181.70   329 4.5       24
## 48   -11.77 166.32    70 4.4       18
## 49   -24.12 180.08   493 4.3       21
## 50   -18.97 185.25   129 5.1       73
## 51   -18.75 182.35   554 4.2       13
## 52   -19.26 184.42   223 4.0       15
## 53   -22.75 173.20    46 4.6       26
## 54   -21.37 180.67   593 4.3       13
## 55   -20.10 182.16   489 4.2       16
## 56   -19.85 182.13   562 4.4       31
## 57   -22.70 181.00   445 4.5       17
## 58   -22.06 180.60   584 4.0       11
## 59   -17.80 181.35   535 4.4       23
## 60   -24.20 179.20   530 4.3       12
## 61   -20.69 181.55   582 4.7       35
## 62   -21.16 182.40   260 4.1       12
## 63   -13.82 172.38   613 5.0       61
## 64   -11.49 166.22    84 4.6       32
## 65   -20.68 181.41   593 4.9       40
## 66   -17.10 184.93   286 4.7       25
## 67   -20.14 181.60   587 4.1       13
## 68   -21.96 179.62   627 5.0       45
## 69   -20.42 181.86   530 4.5       27
## 70   -15.46 187.81    40 5.5       91
## 71   -15.31 185.80   152 4.0       11
## 72   -19.86 184.35   201 4.5       30
## 73   -11.55 166.20    96 4.3       14
## 74   -23.74 179.99   506 5.2       75
## 75   -17.70 181.23   546 4.4       35
## 76   -23.54 180.04   564 4.3       15
## 77   -19.21 184.70   197 4.1       11
## 78   -12.11 167.06   265 4.5       23
## 79   -21.81 181.71   323 4.2       15
## 80   -28.98 181.11   304 5.3       60
## 81   -34.02 180.21    75 5.2       65
## 82   -23.84 180.99   367 4.5       27
## 83   -19.57 182.38   579 4.6       38
## 84   -20.12 183.40   284 4.3       15
## 85   -17.70 181.70   450 4.0       11
## 86   -19.66 184.31   170 4.3       15
## 87   -21.50 170.50   117 4.7       32
## 88   -23.64 179.96   538 4.5       26
## 89   -15.43 186.30   123 4.2       16
## 90   -15.41 186.44    69 4.3       42
## 91   -15.48 167.53   128 5.1       61
## 92   -13.36 167.06   236 4.7       22
## 93   -20.64 182.02   497 5.2       64
## 94   -19.72 169.71   271 4.2       14
## 95   -15.44 185.26   224 4.2       21
## 96   -19.73 182.40   375 4.0       18
## 97   -27.24 181.11   365 4.5       21
## 98   -18.16 183.41   306 5.2       54
## 99   -13.66 166.54    50 5.1       45
## 100  -24.57 179.92   484 4.7       33
## 101  -16.98 185.61   108 4.1       12
## 102  -26.20 178.41   583 4.6       25
## 103  -21.88 180.39   608 4.7       30
## 104  -33.00 181.60    72 4.7       22
## 105  -21.33 180.69   636 4.6       29
## 106  -19.44 183.50   293 4.2       15
## 107  -34.89 180.60    42 4.4       25
## 108  -20.24 169.49   100 4.6       22
## 109  -22.55 185.90    42 5.7       76
## 110  -36.95 177.81   146 5.0       35
## 111  -15.75 185.23   280 4.5       28
## 112  -16.85 182.31   388 4.2       14
## 113  -19.06 182.45   477 4.0       16
## 114  -26.11 178.30   617 4.8       39
## 115  -26.20 178.35   606 4.4       21
## 116  -26.13 178.31   609 4.2       25
## 117  -13.66 172.23    46 5.3       67
## 118  -13.47 172.29    64 4.7       14
## 119  -14.60 167.40   178 4.8       52
## 120  -18.96 169.48   248 4.2       13
## 121  -14.65 166.97    82 4.8       28
## 122  -19.90 178.90    81 4.3       11
## 123  -22.05 180.40   606 4.7       27
## 124  -19.22 182.43   571 4.5       23
## 125  -31.24 180.60   328 4.4       18
## 126  -17.93 167.89    49 5.1       43
## 127  -19.30 183.84   517 4.2       21
## 128  -26.53 178.57   600 5.0       69
## 129  -27.72 181.70    94 4.8       59
## 130  -19.19 183.51   307 4.3       19
## 131  -17.43 185.43   189 4.5       22
## 132  -17.05 181.22   527 4.2       24
## 133  -19.52 168.98    63 4.5       21
## 134  -23.71 180.30   510 4.6       30
## 135  -21.30 180.82   624 4.3       14
## 136  -16.24 168.02    53 4.7       12
## 137  -16.14 187.32    42 5.1       68
## 138  -23.95 182.80   199 4.6       14
## 139  -25.20 182.60   149 4.9       31
## 140  -18.84 184.16   210 4.2       17
## 141  -12.66 169.46   658 4.6       43
## 142  -20.65 181.40   582 4.0       14
## 143  -13.23 167.10   220 5.0       46
## 144  -29.91 181.43   205 4.4       34
## 145  -14.31 173.50   614 4.2       23
## 146  -20.10 184.40   186 4.2       10
## 147  -17.80 185.17    97 4.4       22
## 148  -21.27 173.49    48 4.9       42
## 149  -23.58 180.17   462 5.3       63
## 150  -17.90 181.50   573 4.0       19
## 151  -23.34 184.50    56 5.7      106
## 152  -15.56 167.62   127 6.4      122
## 153  -23.83 182.56   229 4.3       24
## 154  -11.80 165.80   112 4.2       20
## 155  -15.54 167.68   140 4.7       16
## 156  -20.65 181.32   597 4.7       39
## 157  -11.75 166.07    69 4.2       14
## 158  -24.81 180.00   452 4.3       19
## 159  -20.90 169.84    93 4.9       31
## 160  -11.34 166.24   103 4.6       30
## 161  -17.98 180.50   626 4.1       19
## 162  -24.34 179.52   504 4.8       34
## 163  -13.86 167.16   202 4.6       30
## 164  -35.56 180.20    42 4.6       32
## 165  -35.48 179.90    59 4.8       35
## 166  -34.20 179.43    40 5.0       37
## 167  -26.00 182.12   205 5.6       98
## 168  -19.89 183.84   244 5.3       73
## 169  -23.43 180.00   553 4.7       41
## 170  -18.89 169.42   239 4.5       27
## 171  -17.82 181.83   640 4.3       24
## 172  -25.68 180.34   434 4.6       41
## 173  -20.20 180.90   627 4.1       11
## 174  -15.20 184.68    99 4.1       14
## 175  -15.03 182.29   399 4.1       10
## 176  -32.22 180.20   216 5.7       90
## 177  -22.64 180.64   544 5.0       50
## 178  -17.42 185.16   206 4.5       22
## 179  -17.84 181.48   542 4.1       20
## 180  -15.02 184.24   339 4.6       27
## 181  -18.04 181.75   640 4.5       47
## 182  -24.60 183.50    67 4.3       25
## 183  -19.88 184.30   161 4.4       17
## 184  -20.30 183.00   375 4.2       15
## 185  -20.45 181.85   534 4.1       14
## 186  -17.67 187.09    45 4.9       62
## 187  -22.30 181.90   309 4.3       11
## 188  -19.85 181.85   576 4.9       54
## 189  -24.27 179.88   523 4.6       24
## 190  -15.85 185.13   290 4.6       29
## 191  -20.02 184.09   234 5.3       71
## 192  -18.56 169.31   223 4.7       35
## 193  -17.87 182.00   569 4.6       12
## 194  -24.08 179.50   605 4.1       21
## 195  -32.20 179.61   422 4.6       41
## 196  -20.36 181.19   637 4.2       23
## 197  -23.85 182.53   204 4.6       27
## 198  -24.00 182.75   175 4.5       14
## 199  -20.41 181.74   538 4.3       31
## 200  -17.72 180.30   595 5.2       74
## 201  -19.67 182.18   360 4.3       23
## 202  -17.70 182.20   445 4.0       12
## 203  -16.23 183.59   367 4.7       35
## 204  -26.72 183.35   190 4.5       36
## 205  -12.95 169.09   629 4.5       19
## 206  -21.97 182.32   261 4.3       13
## 207  -21.96 180.54   603 5.2       66
## 208  -20.32 181.69   508 4.5       14
## 209  -30.28 180.62   350 4.7       32
## 210  -20.20 182.30   533 4.2       11
## 211  -30.66 180.13   411 4.7       42
## 212  -16.17 184.10   338 4.3       13
## 213  -28.25 181.71   226 4.1       19
## 214  -20.47 185.68    93 5.4       85
## 215  -23.55 180.27   535 4.3       22
## 216  -20.94 181.58   573 4.3       21
## 217  -26.67 182.40   186 4.2       17
## 218  -18.13 181.52   618 4.6       41
## 219  -20.21 183.83   242 4.4       29
## 220  -18.31 182.39   342 4.2       14
## 221  -16.52 185.70    90 4.7       30
## 222  -22.36 171.65   130 4.6       39
## 223  -22.43 184.48    65 4.9       48
## 224  -20.37 182.10   397 4.2       22
## 225  -23.77 180.16   505 4.5       26
## 226  -13.65 166.66    71 4.9       52
## 227  -21.55 182.90   207 4.2       18
## 228  -16.24 185.75   154 4.5       22
## 229  -23.73 182.53   232 5.0       55
## 230  -22.34 171.52   106 5.0       43
## 231  -19.40 180.94   664 4.7       34
## 232  -24.64 180.81   397 4.3       24
## 233  -16.00 182.82   431 4.4       16
## 234  -19.62 185.35    57 4.9       31
## 235  -23.84 180.13   525 4.5       15
## 236  -23.54 179.93   574 4.0       12
## 237  -28.23 182.68    74 4.4       20
## 238  -21.68 180.63   617 5.0       63
## 239  -13.44 166.53    44 4.7       27
## 240  -24.96 180.22   470 4.8       41
## 241  -20.08 182.74   298 4.5       33
## 242  -24.36 182.84   148 4.1       16
## 243  -14.70 166.00    48 5.3       16
## 244  -18.20 183.68   107 4.8       52
## 245  -16.65 185.51   218 5.0       52
## 246  -18.11 181.67   597 4.6       28
## 247  -17.95 181.65   619 4.3       26
## 248  -15.50 186.90    46 4.7       18
## 249  -23.36 180.01   553 5.3       61
## 250  -19.15 169.50   150 4.2       12
## 251  -10.97 166.26   180 4.7       26
## 252  -14.85 167.24    97 4.5       26
## 253  -17.80 181.38   587 5.1       47
## 254  -22.50 170.40   106 4.9       38
## 255  -29.10 182.10   179 4.4       19
## 256  -20.32 180.88   680 4.2       22
## 257  -16.09 184.89   304 4.6       34
## 258  -19.18 169.33   254 4.7       35
## 259  -23.81 179.36   521 4.2       23
## 260  -23.79 179.89   526 4.9       43
## 261  -19.02 184.23   270 5.1       72
## 262  -20.90 181.51   548 4.7       32
## 263  -19.06 169.01   158 4.4       10
## 264  -17.88 181.47   562 4.4       27
## 265  -19.41 183.05   300 4.2       16
## 266  -26.17 184.20    65 4.9       37
## 267  -14.95 167.24   130 4.6       16
## 268  -18.73 168.80    82 4.4       14
## 269  -20.21 182.37   482 4.6       37
## 270  -21.29 180.85   607 4.5       23
## 271  -19.76 181.41   105 4.4       15
## 272  -22.09 180.38   590 4.9       35
## 273  -23.80 179.90   498 4.1       12
## 274  -20.16 181.99   504 4.2       11
## 275  -22.13 180.38   577 5.7      104
## 276  -17.44 181.40   529 4.6       25
## 277  -23.33 180.18   528 5.0       59
## 278  -24.78 179.22   492 4.3       16
## 279  -22.00 180.52   561 4.5       19
## 280  -19.13 182.51   579 5.2       56
## 281  -30.72 180.10   413 4.4       22
## 282  -22.32 180.54   565 4.2       12
## 283  -16.45 177.77   138 4.6       17
## 284  -17.70 185.00   383 4.0       10
## 285  -17.95 184.68   260 4.4       21
## 286  -24.40 179.85   522 4.7       29
## 287  -19.30 180.60   671 4.2       16
## 288  -21.13 185.32   123 4.7       36
## 289  -18.07 181.57   572 4.5       26
## 290  -20.60 182.28   529 5.0       50
## 291  -18.48 181.49   641 5.0       49
## 292  -13.34 166.20    67 4.8       18
## 293  -20.92 181.50   546 4.6       31
## 294  -25.31 179.69   507 4.6       35
## 295  -15.24 186.21   158 5.0       57
## 296  -16.40 185.86   148 5.0       47
## 297  -24.57 178.40   562 5.6       80
## 298  -17.94 181.51   601 4.0       16
## 299  -30.64 181.20   175 4.0       16
## 300  -18.64 169.32   260 4.6       23
## 301  -13.09 169.28   654 4.4       22
## 302  -19.68 184.14   242 4.8       40
## 303  -16.44 185.74   126 4.7       30
## 304  -21.09 181.38   555 4.6       15
## 305  -14.99 171.39   637 4.3       21
## 306  -23.30 179.70   500 4.7       29
## 307  -17.68 181.36   515 4.1       19
## 308  -22.00 180.53   583 4.9       20
## 309  -21.38 181.39   501 4.6       36
## 310  -32.62 181.50    55 4.8       26
## 311  -13.05 169.58   644 4.9       68
## 312  -12.93 169.63   641 5.1       57
## 313  -18.60 181.91   442 5.4       82
## 314  -21.34 181.41   464 4.5       21
## 315  -21.48 183.78   200 4.9       54
## 316  -17.40 181.02   479 4.4       14
## 317  -17.32 181.03   497 4.1       13
## 318  -18.77 169.24   218 5.3       53
## 319  -26.16 179.50   492 4.5       25
## 320  -12.59 167.10   325 4.9       26
## 321  -14.82 167.32   123 4.8       28
## 322  -21.79 183.48   210 5.2       69
## 323  -19.83 182.04   575 4.4       23
## 324  -29.50 182.31   129 4.4       14
## 325  -12.49 166.36    74 4.9       55
## 326  -26.10 182.30    49 4.4       11
## 327  -21.04 181.20   483 4.2       10
## 328  -10.78 165.77    93 4.6       20
## 329  -20.76 185.77   118 4.6       15
## 330  -11.41 166.24    83 5.3       55
## 331  -19.10 183.87    61 5.3       42
## 332  -23.91 180.00   534 4.5       11
## 333  -27.33 182.60    42 4.4       11
## 334  -12.25 166.60   219 5.0       28
## 335  -23.49 179.07   544 5.1       58
## 336  -27.18 182.18    56 4.5       14
## 337  -25.80 182.10    68 4.5       26
## 338  -27.19 182.18    69 5.4       68
## 339  -27.27 182.38    45 4.5       16
## 340  -27.10 182.18    43 4.7       17
## 341  -27.22 182.28    65 4.2       14
## 342  -27.38 181.70    80 4.8       13
## 343  -27.27 182.50    51 4.5       13
## 344  -27.54 182.50    68 4.3       12
## 345  -27.20 182.39    69 4.3       14
## 346  -27.71 182.47   103 4.3       11
## 347  -27.60 182.40    61 4.6       11
## 348  -27.38 182.39    69 4.5       12
## 349  -21.54 185.48    51 5.0       29
## 350  -27.21 182.43    55 4.6       10
## 351  -28.96 182.61    54 4.6       15
## 352  -12.01 166.29    59 4.9       27
## 353  -17.46 181.32   573 4.1       17
## 354  -30.17 182.02    56 5.5       68
## 355  -27.27 182.36    65 4.7       21
## 356  -17.79 181.32   587 5.0       49
## 357  -22.19 171.40   150 5.1       49
## 358  -17.10 182.68   403 5.5       82
## 359  -27.18 182.53    60 4.6       21
## 360  -11.64 166.47   130 4.7       19
## 361  -17.98 181.58   590 4.2       14
## 362  -16.90 185.72   135 4.0       22
## 363  -21.98 179.60   583 5.4       67
## 364  -32.14 179.90   406 4.3       19
## 365  -18.80 169.21   221 4.4       16
## 366  -26.78 183.61    40 4.6       22
## 367  -20.43 182.37   502 5.1       48
## 368  -18.30 183.20   103 4.5       14
## 369  -15.83 182.51   423 4.2       21
## 370  -23.44 182.93   158 4.1       20
## 371  -23.73 179.99   527 5.1       49
## 372  -19.89 184.08   219 5.4      105
## 373  -17.59 181.09   536 5.1       61
## 374  -19.77 181.40   630 5.1       54
## 375  -20.31 184.06   249 4.4       21
## 376  -15.33 186.75    48 5.7      123
## 377  -18.20 181.60   553 4.4       14
## 378  -15.36 186.66   112 5.1       57
## 379  -15.29 186.42   153 4.6       31
## 380  -15.36 186.71   130 5.5       95
## 381  -16.24 167.95   188 5.1       68
## 382  -13.47 167.14   226 4.4       26
## 383  -25.50 182.82   124 5.0       25
## 384  -14.32 167.33   204 5.0       49
## 385  -20.04 182.01   605 5.1       49
## 386  -28.83 181.66   221 5.1       63
## 387  -17.82 181.49   573 4.2       14
## 388  -27.23 180.98   401 4.5       39
## 389  -10.72 165.99   195 4.0       14
## 390  -27.00 183.88    56 4.9       36
## 391  -20.36 186.16   102 4.3       21
## 392  -27.17 183.68    44 4.8       27
## 393  -20.94 181.26   556 4.4       21
## 394  -17.46 181.90   417 4.2       14
## 395  -21.04 181.20   591 4.9       45
## 396  -23.70 179.60   646 4.2       21
## 397  -17.72 181.42   565 5.3       89
## 398  -15.87 188.13    52 5.0       30
## 399  -17.84 181.30   535 5.7      112
## 400  -13.45 170.30   641 5.3       93
## 401  -30.80 182.16    41 4.7       24
## 402  -11.63 166.14   109 4.6       36
## 403  -30.40 181.40    40 4.3       17
## 404  -26.18 178.59   548 5.4       65
## 405  -15.70 184.50   118 4.4       30
## 406  -17.95 181.50   593 4.3       16
## 407  -20.51 182.30   492 4.3       23
## 408  -15.36 167.51   123 4.7       28
## 409  -23.61 180.23   475 4.4       26
## 410  -33.20 181.60   153 4.2       21
## 411  -17.68 186.80   112 4.5       35
## 412  -22.24 184.56    99 4.8       57
## 413  -20.07 169.14    66 4.8       37
## 414  -25.04 180.10   481 4.3       15
## 415  -21.50 185.20   139 4.4       15
## 416  -14.28 167.26   211 5.1       51
## 417  -14.43 167.26   151 4.4       17
## 418  -32.70 181.70   211 4.4       40
## 419  -34.10 181.80   246 4.3       23
## 420  -19.70 186.20    47 4.8       19
## 421  -24.19 180.38   484 4.3       27
## 422  -26.60 182.77   119 4.5       29
## 423  -17.04 186.80    70 4.1       22
## 424  -22.10 179.71   579 5.1       58
## 425  -32.60 180.90    57 4.7       44
## 426  -33.00 182.40   176 4.6       28
## 427  -20.58 181.24   602 4.7       44
## 428  -20.61 182.60   488 4.6       12
## 429  -19.47 169.15   149 4.4       15
## 430  -17.47 180.96   546 4.2       23
## 431  -18.40 183.40   343 4.1       10
## 432  -23.33 180.26   530 4.7       22
## 433  -18.55 182.23   563 4.0       17
## 434  -26.16 178.47   537 4.8       33
## 435  -21.80 183.20   325 4.4       19
## 436  -27.63 182.93    80 4.3       14
## 437  -18.89 169.48   259 4.4       21
## 438  -20.30 182.30   476 4.5       10
## 439  -20.56 182.04   499 4.5       29
## 440  -16.10 185.32   257 4.7       30
## 441  -12.66 166.37   165 4.3       18
## 442  -21.05 184.68   136 4.7       29
## 443  -17.97 168.52   146 4.8       33
## 444  -19.83 182.54   524 4.6       14
## 445  -22.55 183.81    82 5.1       68
## 446  -22.28 183.52    90 4.7       19
## 447  -15.72 185.64   138 4.3       21
## 448  -20.85 181.59   499 5.1       91
## 449  -21.11 181.50   538 5.5      104
## 450  -25.31 180.15   467 4.5       25
## 451  -26.46 182.50   184 4.3       11
## 452  -24.09 179.68   538 4.3       21
## 453  -16.96 167.70    45 4.7       23
## 454  -23.19 182.80   237 4.3       18
## 455  -20.81 184.70   162 4.3       20
## 456  -15.03 167.32   136 4.6       20
## 457  -18.06 181.59   604 4.5       23
## 458  -19.00 185.60   107 4.5       15
## 459  -23.53 179.99   538 5.4       87
## 460  -18.18 180.63   639 4.6       39
## 461  -15.66 186.80    45 4.4       11
## 462  -18.00 180.62   636 5.0      100
## 463  -18.08 180.70   628 5.2       72
## 464  -18.05 180.86   632 4.4       15
## 465  -29.90 181.16   215 5.1       51
## 466  -20.90 181.90   556 4.4       17
## 467  -15.61 167.50   135 4.4       21
## 468  -16.03 185.43   297 4.8       25
## 469  -17.68 181.11   568 4.4       22
## 470  -31.94 180.57   168 4.7       39
## 471  -19.14 184.36   269 4.7       31
## 472  -18.00 185.48   143 4.4       29
## 473  -16.95 185.94    95 4.3       12
## 474  -10.79 166.06   142 5.0       40
## 475  -20.83 185.90   104 4.5       19
## 476  -32.90 181.60   169 4.6       27
## 477  -37.93 177.47    65 5.4       65
## 478  -29.09 183.20    54 4.6       23
## 479  -23.56 180.23   474 4.5       13
## 480  -19.60 185.20   125 4.4       13
## 481  -21.39 180.68   617 4.5       18
## 482  -14.85 184.87   294 4.1       10
## 483  -22.70 183.30   180 4.0       13
## 484  -32.42 181.21    47 4.9       39
## 485  -17.90 181.30   593 4.1       13
## 486  -23.58 183.40    94 5.2       79
## 487  -34.40 180.50   201 4.4       41
## 488  -17.61 181.20   537 4.1       11
## 489  -21.07 181.13   594 4.9       43
## 490  -13.84 170.62   638 4.6       20
## 491  -30.24 181.63    80 4.5       17
## 492  -18.49 169.04   211 4.8       30
## 493  -23.45 180.23   520 4.2       19
## 494  -16.04 183.54   384 4.2       23
## 495  -17.14 185.31   223 4.1       15
## 496  -22.54 172.91    54 5.5       71
## 497  -15.90 185.30    57 4.4       19
## 498  -30.04 181.20    49 4.8       20
## 499  -24.03 180.22   508 4.2       23
## 500  -18.89 184.46   242 4.8       36
## 501  -16.51 187.10    62 4.9       46
## 502  -20.10 186.30    63 4.6       19
## 503  -21.06 183.81   203 4.5       34
## 504  -13.07 166.87   132 4.4       24
## 505  -23.46 180.09   543 4.6       28
## 506  -19.41 182.30   589 4.2       19
## 507  -11.81 165.98    51 4.7       28
## 508  -11.76 165.96    45 4.4       51
## 509  -12.08 165.76    63 4.5       51
## 510  -25.59 180.02   485 4.9       48
## 511  -26.54 183.63    66 4.7       34
## 512  -20.90 184.28    58 5.5       92
## 513  -16.99 187.00    70 4.7       30
## 514  -23.46 180.17   541 4.6       32
## 515  -17.81 181.82   598 4.1       14
## 516  -15.17 187.20    50 4.7       28
## 517  -11.67 166.02   102 4.6       21
## 518  -20.75 184.52   144 4.3       25
## 519  -19.50 186.90    58 4.4       20
## 520  -26.18 179.79   460 4.7       44
## 521  -20.66 185.77    69 4.3       25
## 522  -19.22 182.54   570 4.1       22
## 523  -24.68 183.33    70 4.7       30
## 524  -15.43 167.38   137 4.5       16
## 525  -32.45 181.15    41 5.5       81
## 526  -21.31 180.84   586 4.5       17
## 527  -15.44 167.18   140 4.6       44
## 528  -13.26 167.01   213 5.1       70
## 529  -15.26 183.13   393 4.4       28
## 530  -33.57 180.80    51 4.7       35
## 531  -15.77 167.01    64 5.5       73
## 532  -15.79 166.83    45 4.6       39
## 533  -21.00 183.20   296 4.0       16
## 534  -16.28 166.94    50 4.6       24
## 535  -23.28 184.60    44 4.8       34
## 536  -16.10 167.25    68 4.7       36
## 537  -17.70 181.31   549 4.7       33
## 538  -15.96 166.69   150 4.2       20
## 539  -15.95 167.34    47 5.4       87
## 540  -17.56 181.59   543 4.6       34
## 541  -15.90 167.42    40 5.5       86
## 542  -15.29 166.90   100 4.2       15
## 543  -15.86 166.85    85 4.5       22
## 544  -16.20 166.80    98 4.5       21
## 545  -15.71 166.91    58 4.8       20
## 546  -16.45 167.54   125 4.6       18
## 547  -11.54 166.18    89 5.4       80
## 548  -19.61 181.91   590 4.6       34
## 549  -15.61 187.15    49 5.0       30
## 550  -21.16 181.41   543 4.3       17
## 551  -20.65 182.22   506 4.3       24
## 552  -20.33 168.71    40 4.8       38
## 553  -15.08 166.62    42 4.7       23
## 554  -23.28 184.61    76 4.7       36
## 555  -23.44 184.60    63 4.8       27
## 556  -23.12 184.42   104 4.2       17
## 557  -23.65 184.46    93 4.2       16
## 558  -22.91 183.95    64 5.9      118
## 559  -22.06 180.47   587 4.6       28
## 560  -13.56 166.49    83 4.5       25
## 561  -17.99 181.57   579 4.9       49
## 562  -23.92 184.47    40 4.7       17
## 563  -30.69 182.10    62 4.9       25
## 564  -21.92 182.80   273 5.3       78
## 565  -25.04 180.97   393 4.2       21
## 566  -19.92 183.91   264 4.2       23
## 567  -27.75 182.26   174 4.5       18
## 568  -17.71 181.18   574 5.2       67
## 569  -19.60 183.84   309 4.5       23
## 570  -34.68 179.82    75 5.6       79
## 571  -14.46 167.26   195 5.2       87
## 572  -18.85 187.55    44 4.8       35
## 573  -17.02 182.41   420 4.5       29
## 574  -20.41 186.51    63 5.0       28
## 575  -18.18 182.04   609 4.4       26
## 576  -16.49 187.80    40 4.5       18
## 577  -17.74 181.31   575 4.6       42
## 578  -20.49 181.69   559 4.5       24
## 579  -18.51 182.64   405 5.2       74
## 580  -27.28 183.40    70 5.1       54
## 581  -15.90 167.16    41 4.8       42
## 582  -20.57 181.33   605 4.3       18
## 583  -11.25 166.36   130 5.1       55
## 584  -20.04 181.87   577 4.7       19
## 585  -20.89 181.25   599 4.6       20
## 586  -16.62 186.74    82 4.8       51
## 587  -20.09 168.75    50 4.6       23
## 588  -24.96 179.87   480 4.4       25
## 589  -20.95 181.42   559 4.6       27
## 590  -23.31 179.27   566 5.1       49
## 591  -20.95 181.06   611 4.3       20
## 592  -21.58 181.90   409 4.4       19
## 593  -13.62 167.15   209 4.7       30
## 594  -12.72 166.28    70 4.8       47
## 595  -21.79 185.00    74 4.1       15
## 596  -20.48 169.76   134 4.6       33
## 597  -12.84 166.78   150 4.9       35
## 598  -17.02 182.93   406 4.0       17
## 599  -23.89 182.39   243 4.7       32
## 600  -23.07 184.03    89 4.7       32
## 601  -27.98 181.96    53 5.2       89
## 602  -28.10 182.25    68 4.6       18
## 603  -21.24 180.81   605 4.6       34
## 604  -21.24 180.86   615 4.9       23
## 605  -19.89 174.46   546 5.7       99
## 606  -32.82 179.80   176 4.7       26
## 607  -22.00 185.50    52 4.4       18
## 608  -21.57 185.62    66 4.9       38
## 609  -24.50 180.92   377 4.8       43
## 610  -33.03 180.20   186 4.6       27
## 611  -30.09 182.40    51 4.4       18
## 612  -22.75 170.99    67 4.8       35
## 613  -17.99 168.98   234 4.7       28
## 614  -19.60 181.87   597 4.2       18
## 615  -15.65 186.26    64 5.1       54
## 616  -17.78 181.53   511 4.8       56
## 617  -22.04 184.91    47 4.9       47
## 618  -20.06 168.69    49 5.1       49
## 619  -18.07 181.54   546 4.3       28
## 620  -12.85 165.67    75 4.4       30
## 621  -33.29 181.30    60 4.7       33
## 622  -34.63 179.10   278 4.7       24
## 623  -24.18 179.02   550 5.3       86
## 624  -23.78 180.31   518 5.1       71
## 625  -22.37 171.50   116 4.9       38
## 626  -23.97 179.91   518 4.5       23
## 627  -34.12 181.75    75 4.7       41
## 628  -25.25 179.86   491 4.2       23
## 629  -22.87 172.65    56 5.1       50
## 630  -18.48 182.37   376 4.8       57
## 631  -21.46 181.02   584 4.2       18
## 632  -28.56 183.47    48 4.8       56
## 633  -28.56 183.59    53 4.4       20
## 634  -21.30 180.92   617 4.5       26
## 635  -20.08 183.22   294 4.3       18
## 636  -18.82 182.21   417 5.6      129
## 637  -19.51 183.97   280 4.0       16
## 638  -12.05 167.39   332 5.0       36
## 639  -17.40 186.54    85 4.2       28
## 640  -23.93 180.18   525 4.6       31
## 641  -21.23 181.09   613 4.6       18
## 642  -16.23 167.91   182 4.5       28
## 643  -28.15 183.40    57 5.0       32
## 644  -20.81 185.01    79 4.7       42
## 645  -20.72 181.41   595 4.6       36
## 646  -23.29 184.00   164 4.8       50
## 647  -38.46 176.03   148 4.6       44
## 648  -15.48 186.73    82 4.4       17
## 649  -37.03 177.52   153 5.6       87
## 650  -20.48 181.38   556 4.2       13
## 651  -18.12 181.88   649 5.4       88
## 652  -18.17 181.98   651 4.8       43
## 653  -11.40 166.07    93 5.6       94
## 654  -23.10 180.12   533 4.4       27
## 655  -14.28 170.34   642 4.7       29
## 656  -22.87 171.72    47 4.6       27
## 657  -17.59 180.98   548 5.1       79
## 658  -27.60 182.10   154 4.6       22
## 659  -17.94 180.60   627 4.5       29
## 660  -17.88 180.58   622 4.2       23
## 661  -30.01 180.80   286 4.8       43
## 662  -19.19 182.30   390 4.9       48
## 663  -18.14 180.87   624 5.5      105
## 664  -23.46 180.11   539 5.0       41
## 665  -18.44 181.04   624 4.2       21
## 666  -18.21 180.87   631 5.2       69
## 667  -18.26 180.98   631 4.8       36
## 668  -15.85 184.83   299 4.4       30
## 669  -23.82 180.09   498 4.8       40
## 670  -18.60 184.28   255 4.4       31
## 671  -17.80 181.32   539 4.1       12
## 672  -10.78 166.10   195 4.9       45
## 673  -18.12 181.71   594 4.6       24
## 674  -19.34 182.62   573 4.5       32
## 675  -15.34 167.10   128 5.3       18
## 676  -24.97 182.85   137 4.8       40
## 677  -15.97 186.08   143 4.6       41
## 678  -23.47 180.24   511 4.8       37
## 679  -23.11 179.15   564 4.7       17
## 680  -20.54 181.66   559 4.9       50
## 681  -18.92 169.37   248 5.3       60
## 682  -20.16 184.27   210 4.4       27
## 683  -25.48 180.94   390 4.6       33
## 684  -18.19 181.74   616 4.3       17
## 685  -15.35 186.40    98 4.4       17
## 686  -18.69 169.10   218 4.2       27
## 687  -18.89 181.24   655 4.1       14
## 688  -17.61 183.32   356 4.2       15
## 689  -20.93 181.54   564 5.0       64
## 690  -17.60 181.50   548 4.1       10
## 691  -17.96 181.40   655 4.3       20
## 692  -18.80 182.41   385 5.2       67
## 693  -20.61 182.44   518 4.2       10
## 694  -20.74 181.53   598 4.5       36
## 695  -25.23 179.86   476 4.4       29
## 696  -23.90 179.90   579 4.4       16
## 697  -18.07 181.58   603 5.0       65
## 698  -15.43 185.19   249 4.0       11
## 699  -14.30 167.32   208 4.8       25
## 700  -18.04 181.57   587 5.0       51
## 701  -13.90 167.18   221 4.2       21
## 702  -17.64 177.01   545 5.2       91
## 703  -17.98 181.51   586 5.2       68
## 704  -25.00 180.00   488 4.5       10
## 705  -19.45 184.48   246 4.3       15
## 706  -16.11 187.48    61 4.5       19
## 707  -23.73 179.98   524 4.6       11
## 708  -17.74 186.78   104 5.1       71
## 709  -21.56 183.23   271 4.4       36
## 710  -20.97 181.72   487 4.3       16
## 711  -15.45 186.73    83 4.7       37
## 712  -15.93 167.91   183 5.6      109
## 713  -21.47 185.86    55 4.9       46
## 714  -21.44 170.45   166 5.1       22
## 715  -22.16 180.49   586 4.6       13
## 716  -13.36 172.76   618 4.4       18
## 717  -21.22 181.51   524 4.8       49
## 718  -26.10 182.50   133 4.2       17
## 719  -18.35 185.27   201 4.7       57
## 720  -17.20 182.90   383 4.1       11
## 721  -22.42 171.40    86 4.7       33
## 722  -17.91 181.48   555 4.0       17
## 723  -26.53 178.30   605 4.9       43
## 724  -26.50 178.29   609 5.0       50
## 725  -16.31 168.08   204 4.5       16
## 726  -18.76 169.71   287 4.4       23
## 727  -17.10 182.80   390 4.0       14
## 728  -19.28 182.78   348 4.5       30
## 729  -23.50 180.00   550 4.7       23
## 730  -21.26 181.69   487 4.4       20
## 731  -17.97 181.48   578 4.7       43
## 732  -26.02 181.20   361 4.7       32
## 733  -30.30 180.80   275 4.0       14
## 734  -24.89 179.67   498 4.2       14
## 735  -14.57 167.24   162 4.5       18
## 736  -15.40 186.87    78 4.7       44
## 737  -22.06 183.95   134 4.5       17
## 738  -25.14 178.42   554 4.1       15
## 739  -20.30 181.40   608 4.6       13
## 740  -25.28 181.17   367 4.3       25
## 741  -20.63 181.61   599 4.6       30
## 742  -19.02 186.83    45 5.2       65
## 743  -22.10 185.30    50 4.6       22
## 744  -38.59 175.70   162 4.7       36
## 745  -19.30 183.00   302 5.0       65
## 746  -31.03 181.59    57 5.2       49
## 747  -30.51 181.30   203 4.4       20
## 748  -22.55 183.34    66 4.6       18
## 749  -22.14 180.64   591 4.5       18
## 750  -25.60 180.30   440 4.0       12
## 751  -18.04 181.84   611 4.2       20
## 752  -21.29 185.77    57 5.3       69
## 753  -21.08 180.85   627 5.9      119
## 754  -20.64 169.66    89 4.9       42
## 755  -24.41 180.03   500 4.5       34
## 756  -12.16 167.03   264 4.4       14
## 757  -17.10 185.90   127 5.4       75
## 758  -21.13 185.60    85 5.3       86
## 759  -12.34 167.43    50 5.1       47
## 760  -16.43 186.73    75 4.1       20
## 761  -20.70 184.30   182 4.3       17
## 762  -21.18 180.92   619 4.5       18
## 763  -17.78 185.33   223 4.1       10
## 764  -21.57 183.86   156 5.1       70
## 765  -13.70 166.75    46 5.3       71
## 766  -12.27 167.41    50 4.5       29
## 767  -19.10 184.52   230 4.1       16
## 768  -19.85 184.51   184 4.4       26
## 769  -11.37 166.55   188 4.7       24
## 770  -20.70 186.30    80 4.0       10
## 771  -20.24 185.10    86 5.1       61
## 772  -16.40 182.73   391 4.0       16
## 773  -19.60 184.53   199 4.3       21
## 774  -21.63 180.77   592 4.3       21
## 775  -21.60 180.50   595 4.0       22
## 776  -21.77 181.00   618 4.1       10
## 777  -21.80 183.60   213 4.4       17
## 778  -21.05 180.90   616 4.3       10
## 779  -10.80 165.80   175 4.2       12
## 780  -17.90 181.50   589 4.0       12
## 781  -22.26 171.44    83 4.5       25
## 782  -22.33 171.46   119 4.7       32
## 783  -24.04 184.85    70 5.0       48
## 784  -20.40 186.10    74 4.3       22
## 785  -15.00 184.62    40 5.1       54
## 786  -27.87 183.40    87 4.7       34
## 787  -14.12 166.64    63 5.3       69
## 788  -23.61 180.27   537 5.0       63
## 789  -21.56 185.50    47 4.5       29
## 790  -21.19 181.58   490 5.0       77
## 791  -18.07 181.65   593 4.1       16
## 792  -26.00 178.43   644 4.9       27
## 793  -20.21 181.90   576 4.1       16
## 794  -28.00 182.00   199 4.0       16
## 795  -20.74 180.70   589 4.4       27
## 796  -31.80 180.60   178 4.5       19
## 797  -18.91 169.46   248 4.4       33
## 798  -20.45 182.10   500 4.5       37
## 799  -22.90 183.80    71 4.3       19
## 800  -18.11 181.63   568 4.3       36
## 801  -23.80 184.70    42 5.0       36
## 802  -23.42 180.21   510 4.5       37
## 803  -23.20 184.80    97 4.5       13
## 804  -12.93 169.52   663 4.4       30
## 805  -21.14 181.06   625 4.5       35
## 806  -19.13 184.97   210 4.1       22
## 807  -21.08 181.30   557 4.9       78
## 808  -20.07 181.75   582 4.7       27
## 809  -20.90 182.02   402 4.3       18
## 810  -25.04 179.84   474 4.6       32
## 811  -21.85 180.89   577 4.6       43
## 812  -19.34 186.59    56 5.2       49
## 813  -15.83 167.10    43 4.5       19
## 814  -23.73 183.00   118 4.3       11
## 815  -18.10 181.72   544 4.6       52
## 816  -22.12 180.49   532 4.0       14
## 817  -15.39 185.10   237 4.5       39
## 818  -16.21 186.52   111 4.8       30
## 819  -21.75 180.67   595 4.6       30
## 820  -22.10 180.40   603 4.1       11
## 821  -24.97 179.54   505 4.9       50
## 822  -19.36 186.36   100 4.7       40
## 823  -22.14 179.62   587 4.1       23
## 824  -21.48 182.44   364 4.3       20
## 825  -18.54 168.93   100 4.4       17
## 826  -21.62 182.40   350 4.0       12
## 827  -13.40 166.90   228 4.8       15
## 828  -15.50 185.30    93 4.4       25
## 829  -15.67 185.23    66 4.4       34
## 830  -21.78 183.11   225 4.6       21
## 831  -30.63 180.90   334 4.2       28
## 832  -15.70 185.10    70 4.1       15
## 833  -19.20 184.37   220 4.2       18
## 834  -19.70 182.44   397 4.0       12
## 835  -19.40 182.29   326 4.1       15
## 836  -15.85 185.90   121 4.1       17
## 837  -17.38 168.63   209 4.7       29
## 838  -24.33 179.97   510 4.8       44
## 839  -20.89 185.26    54 5.1       44
## 840  -18.97 169.44   242 5.0       41
## 841  -17.99 181.62   574 4.8       38
## 842  -15.80 185.25    82 4.4       39
## 843  -25.42 182.65   102 5.0       36
## 844  -21.60 169.90    43 5.2       56
## 845  -26.06 180.05   432 4.2       19
## 846  -17.56 181.23   580 4.1       16
## 847  -25.63 180.26   464 4.8       60
## 848  -25.46 179.98   479 4.5       27
## 849  -22.23 180.48   581 5.0       54
## 850  -21.55 181.39   513 5.1       81
## 851  -15.18 185.93    77 4.1       16
## 852  -13.79 166.56    68 4.7       41
## 853  -15.18 167.23    71 5.2       59
## 854  -18.78 186.72    68 4.8       48
## 855  -17.90 181.41   586 4.5       33
## 856  -18.50 185.40   243 4.0       11
## 857  -14.82 171.17   658 4.7       49
## 858  -15.65 185.17   315 4.1       15
## 859  -30.01 181.15   210 4.3       17
## 860  -13.16 167.24   278 4.3       17
## 861  -21.03 180.78   638 4.0       14
## 862  -21.40 180.78   615 4.7       51
## 863  -17.93 181.89   567 4.1       27
## 864  -20.87 181.70   560 4.2       13
## 865  -12.01 166.66    99 4.8       36
## 866  -19.10 169.63   266 4.8       31
## 867  -22.85 181.37   397 4.2       15
## 868  -17.08 185.96   180 4.2       29
## 869  -21.14 174.21    40 5.7       78
## 870  -12.23 167.02   242 6.0      132
## 871  -20.91 181.57   530 4.2       20
## 872  -11.38 167.05   133 4.5       32
## 873  -11.02 167.01    62 4.9       36
## 874  -22.09 180.58   580 4.4       22
## 875  -17.80 181.20   530 4.0       15
## 876  -18.94 182.43   566 4.3       20
## 877  -18.85 182.20   501 4.2       23
## 878  -21.91 181.28   548 4.5       30
## 879  -22.03 179.77   587 4.8       31
## 880  -18.10 181.63   592 4.4       28
## 881  -18.40 184.84   221 4.2       18
## 882  -21.20 181.40   560 4.2       12
## 883  -12.00 166.20    94 5.0       31
## 884  -11.70 166.30   139 4.2       15
## 885  -26.72 182.69   162 5.2       64
## 886  -24.39 178.98   562 4.5       30
## 887  -19.64 169.50   204 4.6       35
## 888  -21.35 170.04    56 5.0       22
## 889  -22.82 184.52    49 5.0       52
## 890  -38.28 177.10   100 5.4       71
## 891  -12.57 167.11   231 4.8       28
## 892  -22.24 180.28   601 4.2       21
## 893  -13.80 166.53    42 5.5       70
## 894  -21.07 183.78   180 4.3       25
## 895  -17.74 181.25   559 4.1       16
## 896  -23.87 180.15   524 4.4       22
## 897  -21.29 185.80    69 4.9       74
## 898  -22.20 180.58   594 4.5       45
## 899  -15.24 185.11   262 4.9       56
## 900  -17.82 181.27   538 4.0       33
## 901  -32.14 180.00   331 4.5       27
## 902  -19.30 185.86    48 5.0       40
## 903  -33.09 180.94    47 4.9       47
## 904  -20.18 181.62   558 4.5       31
## 905  -17.46 181.42   524 4.2       16
## 906  -17.44 181.33   545 4.2       37
## 907  -24.71 179.85   477 4.2       34
## 908  -21.53 170.52   129 5.2       30
## 909  -19.17 169.53   268 4.3       21
## 910  -28.05 182.39   117 5.1       43
## 911  -23.39 179.97   541 4.6       50
## 912  -22.33 171.51   112 4.6       14
## 913  -15.28 185.98   162 4.4       36
## 914  -20.27 181.51   609 4.4       32
## 915  -10.96 165.97    76 4.9       64
## 916  -21.52 169.75    61 5.1       40
## 917  -19.57 184.47   202 4.2       28
## 918  -23.08 183.45    90 4.7       30
## 919  -25.06 182.80   133 4.0       14
## 920  -17.85 181.44   589 5.6      115
## 921  -15.99 167.95   190 5.3       81
## 922  -20.56 184.41   138 5.0       82
## 923  -17.98 181.61   598 4.3       27
## 924  -18.40 181.77   600 4.1       11
## 925  -27.64 182.22   162 5.1       67
## 926  -20.99 181.02   626 4.5       36
## 927  -14.86 167.32   137 4.9       22
## 928  -29.33 182.72    57 5.4       61
## 929  -25.81 182.54   201 4.7       40
## 930  -14.10 166.01    69 4.8       29
## 931  -17.63 185.13   219 4.5       28
## 932  -23.47 180.21   553 4.2       23
## 933  -23.92 180.21   524 4.6       50
## 934  -20.88 185.18    51 4.6       28
## 935  -20.25 184.75   107 5.6      121
## 936  -19.33 186.16    44 5.4      110
## 937  -18.14 181.71   574 4.0       20
## 938  -22.41 183.99   128 5.2       72
## 939  -20.77 181.16   568 4.2       12
## 940  -17.95 181.73   583 4.7       57
## 941  -20.83 181.01   622 4.3       15
## 942  -27.84 182.10   193 4.8       27
## 943  -19.94 182.39   544 4.6       30
## 944  -23.60 183.99   118 5.4       88
## 945  -23.70 184.13    51 4.8       27
## 946  -30.39 182.40    63 4.6       22
## 947  -18.98 182.32   442 4.2       22
## 948  -27.89 182.92    87 5.5       67
## 949  -23.50 184.90    61 4.7       16
## 950  -23.73 184.49    60 4.7       35
## 951  -17.93 181.62   561 4.5       32
## 952  -35.94 178.52   138 5.5       78
## 953  -18.68 184.50   174 4.5       34
## 954  -23.47 179.95   543 4.1       21
## 955  -23.49 180.06   530 4.0       23
## 956  -23.85 180.26   497 4.3       32
## 957  -27.08 183.44    63 4.7       27
## 958  -20.88 184.95    82 4.9       50
## 959  -20.97 181.20   605 4.5       31
## 960  -21.71 183.58   234 4.7       55
## 961  -23.90 184.60    41 4.5       22
## 962  -15.78 167.44    40 4.8       42
## 963  -12.57 166.72   137 4.3       20
## 964  -19.69 184.23   223 4.1       23
## 965  -22.04 183.95   109 5.4       61
## 966  -17.99 181.59   595 4.1       26
## 967  -23.50 180.13   512 4.8       40
## 968  -21.40 180.74   613 4.2       20
## 969  -15.86 166.98    60 4.8       25
## 970  -23.95 184.64    43 5.4       45
## 971  -25.79 182.38   172 4.4       14
## 972  -23.75 184.50    54 5.2       74
## 973  -24.10 184.50    68 4.7       23
## 974  -18.56 169.05   217 4.9       35
## 975  -23.30 184.68   102 4.9       27
## 976  -17.03 185.74   178 4.2       32
## 977  -20.77 183.71   251 4.4       47
## 978  -28.10 183.50    42 4.4       17
## 979  -18.83 182.26   575 4.3       11
## 980  -23.00 170.70    43 4.9       20
## 981  -20.82 181.67   577 5.0       67
## 982  -22.95 170.56    42 4.7       21
## 983  -28.22 183.60    75 4.9       49
## 984  -27.99 183.50    71 4.3       22
## 985  -15.54 187.15    60 4.5       17
## 986  -12.37 166.93   291 4.2       16
## 987  -22.33 171.66   125 5.2       51
## 988  -22.70 170.30    69 4.8       27
## 989  -17.86 181.30   614 4.0       12
## 990  -16.00 184.53   108 4.7       33
## 991  -20.73 181.42   575 4.3       18
## 992  -15.45 181.42   409 4.3       27
## 993  -20.05 183.86   243 4.9       65
## 994  -17.95 181.37   642 4.0       17
## 995  -17.70 188.10    45 4.2       10
## 996  -25.93 179.54   470 4.4       22
## 997  -12.28 167.06   248 4.7       35
## 998  -20.13 184.20   244 4.5       34
## 999  -17.40 187.80    40 4.5       14
## 1000 -21.59 170.56   165 6.0      119
```

Таким образом, если вы используйете пакет `dplyr` в своей программе, данные о героях Звездных Войн можно загрузить не указывая пакет, т.к. он был ранее подключен через функцию `library()`:

```r
library(dplyr)
## 
## Присоединяю пакет: 'dplyr'
## Следующие объекты скрыты от 'package:stats':
## 
##     filter, lag
## Следующие объекты скрыты от 'package:base':
## 
##     intersect, setdiff, setequal, union
data(starwars)
```

### Текстовые таблицы {#tables_reading_text}

Текстовые таблицы бывают, как правило, двух типов: с разделителем (CSV) и с фиксированной шириной столбца.

#### Файлы с разделителем {#tables_reading_text_csv}

__CSV (Comma-separated value)__ --- общее название для формата представления таблиц в виде текстовых файлов, организованных по следующему принципу:

1. Каждая строка в файле соответствует строке в таблице.
2. Ячейки отделяются друг от друга символом-разделителем.
3. Если ячейка пустая, то между соседними разделителями не должно быть никаких символов.

Стандартным разделителем ячеек является запятая (`,`), а десятичным разделителем --- точка (`.`). Однако это не является строгим правилом. Например, в ряде локалей (например, русской) запятая используется в качестве десятичного разделителя, поэтому колонки часто разделяют точкой с запятой (`;`).

Формат CSV никак не оговаривает наличие заголовочной строки с названиями столбцов в начале файла — она может как отсутствовать, так и присутствовать. Поэтому при чтении таблиц из файлов необходимо информировать программу о наличии заголовка путем указания соответствующего параметра.

> Любая функция, используемая вами для чтения файлов, вне зависимости от пакета, который вы используете, как правило, содержит параметры, с помощью которых можно задать символы, отвечающие за десятичный разделитель и разделитель столбцов, а также наличие или отсутствие строки-заголовка и кодировку файла. Если таблица читается некорректно, ознакомьтесь со справкой к функции и при необходимости замените стандартные значения этих параметров на те, что соответствуют формату вашей таблицы.

Например, вот так выглядит текстовая таблица в формате CSV с данными по численности населения в Федеральных округах Российской Федерации за 2005 и 2010-2013 гг. (по данным Росстата):
```
N,Region,Year05,Year10,Year11,Year12,Year13
1,Центральный,4341,3761,3613,3651,3570
2,Северо-Западный,3192,3088,2866,2877,2796
3,Южный федеральный,1409,1446,1436,1394,1321
4,Северо-Кавказский,496,390,397,395,374
5,Приволжский,3162,2883,2857,2854,2849
6,Уральский,1681,1860,1834,1665,1624
7,Сибирский,2575,2218,2142,2077,1941
8,Дальневосточный,871,870,821,765,713
```

Таблицы в формате __CSV__ можно прочесть как с помощью стандартных средств языка R, так и с помощью пакета `readr`, который входит в набор пакетов _tidyverse_. Мы будем использовать последние, а стандартные средства языка оставим на самостоятельное изучение.

Для чтения таблиц с разделителем в readr имеется несколько функций:

- `read_csv()` читает файлы с разделителем запятой
- `read_csv2()` читайт файоы с разделителем точкой-с-запятой (может быть особенно актуально для русских файлов)
- `read_tsv()` читает файлы с разделителем табуляцией или пробелом
- `read_delim()` читает файлы с произвольным разделителем (указывается в качестве параметра)

Вышеуказанный файл сохранен с разделителем запятой, поэтому мы можем прочесть его посредством первой функции из списка:


```r
library(readr)
(okruga = read_csv('okruga.csv'))
## Parsed with column specification:
## cols(
##   `№` = col_integer(),
##   Регион = col_character(),
##   `2005` = col_integer(),
##   `2010` = col_integer(),
##   `2011` = col_integer(),
##   `2012` = col_integer(),
##   `2013` = col_integer()
## )
## # A tibble: 8 x 7
##     `№` Регион            `2005` `2010` `2011` `2012` `2013`
##   <int> <chr>              <int>  <int>  <int>  <int>  <int>
## 1     1 Центральный         4341   3761   3613   3651   3570
## 2     2 Северо-Западный     3192   3088   2866   2877   2796
## 3     3 Южный федеральный   1409   1446   1436   1394   1321
## 4     4 Северо-Кавказский    496    390    397    395    374
## 5     5 Приволжский         3162   2883   2857   2854   2849
## 6     6 Уральский           1681   1860   1834   1665   1624
## 7     7 Сибирский           2575   2218   2142   2077   1941
## 8     8 Дальневосточный      871    870    821    765    713
```

Как видно, функции пакета `readr` выдают диагностическую информацию о том, к какому типу были приведены столбцы таблицы при чтении. Помимо этого, первая строка была использована в качестве заголовочной.

#### Файлы с фиксированной шириной столбца {#tables_reading_text_fwf}

В файлах с фиксированной шириной на каждый столбец резервируется определенное количество символов. При этом данные выравниваются по правому краю, а короткие строки отбиваются слева пробелами. Такой формат часто используется в численных моделях (например, метеорологических) для представления входных данных или результатов расчетов. Например, файл ниже содержит данные об энергии ветра ($Вт/м^2$) на высотах 50 и 110 м по точкам вдоль побережья Черного моря<!-- TODO: Дать ссылку на статью -->:
```
           1   43.500000       28.000000       111.05298       178.41447    
           2   43.500000       28.500000       187.38620       301.05331    
           3   44.000000       28.500000       168.82031       271.22421    
           4   44.500000       28.500000       157.22586       252.59746    
           5   44.500000       29.000000       189.46452       304.39597    
           6   45.000000       29.000000       170.40709       273.77536    
           7   45.000000       29.500000       198.92389       319.58777    
           8   45.500000       29.500000       188.64406       303.07242    
           9   46.000000       30.000000       180.10541       289.35379    
          10   46.000000       30.500000       207.91818       334.03564
```

Для чтения таких файлов в __readr__ есть функции:

- `read_fwf()` читает файлы с фиксированной шириной столбца, позволяя задавать ширины столбцов (через `fwf_widths()`) или начальные позиции каждого столбца (через `fwf_positions()`)
- `read_table()` читает наиболее распространенный вариант файла с фиксированной шириной столбца, в котором колонки разделены пробелами. Позиции столбцов определяются автоматически, что очень удобно.

Прочитаем вышеприведенный файл с данными о ветровой энергии:

```r
(wenergy = read_table('wind_energy.txt', col_names = c('id', 'lat', 'lon', 'energy50', 'energy110')))
## Parsed with column specification:
## cols(
##   id = col_integer(),
##   lat = col_double(),
##   lon = col_double(),
##   energy50 = col_double(),
##   energy110 = col_double()
## )
## # A tibble: 92 x 5
##       id   lat   lon energy50 energy110
##    <int> <dbl> <dbl>    <dbl>     <dbl>
##  1     1  43.5  28       111.      178.
##  2     2  43.5  28.5     187.      301.
##  3     3  44    28.5     169.      271.
##  4     4  44.5  28.5     157.      253.
##  5     5  44.5  29       189.      304.
##  6     6  45    29       170.      274.
##  7     7  45    29.5     199.      320.
##  8     8  45.5  29.5     189.      303.
##  9     9  46    30       180.      289.
## 10    10  46    30.5     208.      334.
## # ... with 82 more rows
```

### Таблицы Microsoft Excel {#tables_reading_excel}

Для чтения таблиц Microsoft Excel, так же как и для тектовых файлов, существуют множество пакетов, таких как [xlsx](https://cran.r-project.org/web/packages/xlsx/index.html), [openxlsx](https://cran.r-project.org/web/packages/openxlsx/index.html) и [readxl](https://cran.r-project.org/web/packages/readxl/index.html). 

Я рекомендую пользоваться пакетом __readxl__, поскольку он не имеет внешних зависимостей, а его функции концептуально идентичны функциям пакета __readr__. Прочтем данные о лесовосстановлении (в тысяч га), полученные из регионального ежегодника Росстата за 2017 год. Эта таблица содержит колонку с названием субъекта и еще 8 колонок с данными по годам. Поскольку в таблице есть пропущенные значения, необходимо определить типы столбцов (в противном случае они могут быть определены как текстовые):

```r
library(readxl)
(reforest = read_excel('reforest.xlsx', 
                       col_types = c('text', rep('numeric', 8))))
## # A tibble: 89 x 9
##    Region          `2005` `2010` `2011` `2012` `2013` `2014` `2015` `2016`
##    <chr>            <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
##  1 Российская Фед…  812.   812.   860    842.   872.   863    803.   840. 
##  2 Центральный фе…   52.6   62.7   60.9   60.3   70.9   71.2   72.6   77  
##  3 Белгородская о…    0.4    0.1    0.3    0.3    0.4    0.4    0.2    0.2
##  4 Брянская облас…    2.9    2.8    3      3.2    3.5    3.3    3.1    3  
##  5 Владимирская о…    4.4    5.3    5.7    6      7.1    5.9    6      4.9
##  6 Воронежская об…    1.1    1.1    1.8    3      2.7    2.7    2.6    2.3
##  7 Ивановская обл…    2.1    1.6    2.2    3.1    4      4.8    4.6    4.2
##  8 Калужская обла…    2.2    2.3    2.3    2.5    2.4    3.1    3.2    3.2
##  9 Костромская об…   10     25.2   11     11.8   15.3   13.6   15.1   16.4
## 10 Курская область    0.5    0.3    0.4    0.6    0.6    0.6    0.5    0.4
## # ... with 79 more rows
```

### Параметры {#tables_reading_params}

Функции пакетов `readr` и `readxl` имеют идентичный набор параметров, позволяющих управлять процедурой чтения данных (многоточие используется вместо перечисления параметров):

- `skip = n` позволяет пропустить первые n строк таблицы (например, если в них содержатся какие-то комментарии)
- `col_names = FALSE` позволяет не интерпретировать первую строку как заголовочную (вместо этого она будет читаться как строка с данными)
- `col_names = c(...)` позволяет задать имена столбцов (удобно, если в файле они длинные)
- `col_types = cols(...)` позволяет задать типы столбцов (необходимо, если функция неправильно определяет их сама)
- `na = '-'` позволяет указать символ, который используется для указания пропущенных значений (в данном случае указан прочерк-дефис)
- `locale = locale(...)` управляет локалью (в том числе позволяет указать кодировку файла)

> __Стандартной кодировкой для представления текста__ в UNIX-подобных системах (_Ubuntu_, _macOS_ и т.д.) является __UTF-8 (Unicode)__, в русскоязычных версиях _Windows_ --- __CP1251 (Windows-1251)__. Текстовый файл __CSV__, созданный в разных операционных системах, будет по умолчанию сохраняться в соответствующей кодировке, если вы не указали ее явным образом. Если при загрузке таблицы в __R__ вы видите вместо текста нечитаемые символы --- _кракозябры_ --- то, скорее всего, вы читаете файл не в той кодировке, в которой он был сохранен. Если вы не знаете, что такое кодировка и Юникод, то вам [сюда](https://ru.wikipedia.org/wiki/Набор_символов)

По умолчанию файлы читаются в той кодировке, которая соответствует операционной системе, на которой запущен R. Если файл создан в другой кодировке, придется указать ее при чтении. Например, вы пользуетесь macOS (UTF-8), а ваш коллега --- Windows (CP1251), то для чтения созданного им файла вам, скорее всего, понадобится указать что-то вроде `locale = locale(encoding = 'CP1251')`

## Просмотр {#tables_view}

Для просмотра фрейма данных в консоли __RStudio__ вы можете использовать несколько опций. Пусть наш фрейм данных называется `reforest`. Тогда:

1. `print(reforest)` --- выводит фрейм в консоль целиком (можно написать просто `tab` в консоли).
2. `head(reforest, n)` --- отбирает первые $n$ строк фрейма 
3. `tail(reforest, n)` --- отбирает последние $n$ строк фрейма

По умолчанию для функций `head()` и `tail()` $n=6$. Обычно этот параметр опускают, поскольку нужно просмотреть только первые несколько строк и шести вполне достаточно. Если вы напечатаете в консоли `head(reforest)` или `tail(reforest)`, то для выбранных строк будет вызвана функция `print()`, аналогично выводу всего фрейма:

```r
# ПРОСМОТР ТАБЛИЦЫ
print(reforest)
## # A tibble: 89 x 9
##    Region          `2005` `2010` `2011` `2012` `2013` `2014` `2015` `2016`
##    <chr>            <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
##  1 Российская Фед…  812.   812.   860    842.   872.   863    803.   840. 
##  2 Центральный фе…   52.6   62.7   60.9   60.3   70.9   71.2   72.6   77  
##  3 Белгородская о…    0.4    0.1    0.3    0.3    0.4    0.4    0.2    0.2
##  4 Брянская облас…    2.9    2.8    3      3.2    3.5    3.3    3.1    3  
##  5 Владимирская о…    4.4    5.3    5.7    6      7.1    5.9    6      4.9
##  6 Воронежская об…    1.1    1.1    1.8    3      2.7    2.7    2.6    2.3
##  7 Ивановская обл…    2.1    1.6    2.2    3.1    4      4.8    4.6    4.2
##  8 Калужская обла…    2.2    2.3    2.3    2.5    2.4    3.1    3.2    3.2
##  9 Костромская об…   10     25.2   11     11.8   15.3   13.6   15.1   16.4
## 10 Курская область    0.5    0.3    0.4    0.6    0.6    0.6    0.5    0.4
## # ... with 79 more rows
head(reforest)
## # A tibble: 6 x 9
##   Region           `2005` `2010` `2011` `2012` `2013` `2014` `2015` `2016`
##   <chr>             <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
## 1 Российская Феде…  812.   812.   860    842.   872.   863    803.   840. 
## 2 Центральный фед…   52.6   62.7   60.9   60.3   70.9   71.2   72.6   77  
## 3 Белгородская об…    0.4    0.1    0.3    0.3    0.4    0.4    0.2    0.2
## 4 Брянская область    2.9    2.8    3      3.2    3.5    3.3    3.1    3  
## 5 Владимирская об…    4.4    5.3    5.7    6      7.1    5.9    6      4.9
## 6 Воронежская обл…    1.1    1.1    1.8    3      2.7    2.7    2.6    2.3
tail(reforest)
## # A tibble: 6 x 9
##   Region           `2005` `2010` `2011` `2012` `2013` `2014` `2015` `2016`
##   <chr>             <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
## 1 Хабаровский край  107.    70.2   68.7   67.2   58.4   50.5   59.6   60.3
## 2 Амурская область   33.3   29.8   32.2   33.6   35.5   37.7   28.5   27.7
## 3 Магаданская обл…    2.7    2.6    2.6    2.8    3      2.5    0.4   NA  
## 4 Сахалинская обл…   13.1   12.7   12.5    4.6    4.7    4.9    4.7    4.1
## 5 Еврейская автон…    2.9   NA      2.6    2.5    2.3   NA     NA      2.4
## 6 Чукотский автон…    0.3   NA     NA     NA     NA     NA     NA     NA
```

`RStudio` предоставляет графический интерфейс для просмотра таблиц, в котором таблицу можно сортировать и фильтровать. Чтобы его активировать, надо вызвать функцию `View()`:

```r
View(tab)
```

Поскольку функции `head()` и `tail()` возвращают строки с хвоста или начала фрейма данных, их можно и подать на вход функции `View()`:


```r
View(head(reforest, 3))
```

> __Как правило, не следует оставлять вызовы функции `View()` в тексте законченной программы.__ Это приведет к тому, что при запуске будут открываться новые вкладки с просмотром таблиц, что может раздражать пользователя (в том числе и вас самих). Используйте `View()` для вывода окончательного результата в конце программы или при отладке программы. Все вызовы `View()` в программе  можно легко закомментировать или раскомментировать, выполнив поиск с заменой `'View('` на `'# View('` и наоборот.

## Столбцы, строки и ячейки {#tables_elements}

### Названия {#tables_elements_names}

Столбцы, строки и ячейк представляют собой основные структурные элементы фрейма данных или тиббла. Перед тем как мы поднимемся на уровень выше и рассмотрим обобщенные операции преобразования таблиц, необходимо посмотреть, как извлекать структурные элементы таблиц.

Столбцы и строки таблицы имеют названия, которые можно читать и записывать с помощью функций `colnames()` и `rownames()`:

```r
# Чтение названий столбцов и строк
colnames(okruga)
## [1] "№"      "Регион" "2005"   "2010"   "2011"   "2012"   "2013"
rownames(okruga)
## [1] "1" "2" "3" "4" "5" "6" "7" "8"

# Замена названий столбцов и строк
colnames(okruga) <- c("N", "Region", "Year05", "Year10", "Year11", "Year12", "Year13")
print(okruga)
## # A tibble: 8 x 7
##       N Region            Year05 Year10 Year11 Year12 Year13
##   <int> <chr>              <int>  <int>  <int>  <int>  <int>
## 1     1 Центральный         4341   3761   3613   3651   3570
## 2     2 Северо-Западный     3192   3088   2866   2877   2796
## 3     3 Южный федеральный   1409   1446   1436   1394   1321
## 4     4 Северо-Кавказский    496    390    397    395    374
## 5     5 Приволжский         3162   2883   2857   2854   2849
## 6     6 Уральский           1681   1860   1834   1665   1624
## 7     7 Сибирский           2575   2218   2142   2077   1941
## 8     8 Дальневосточный      871    870    821    765    713
```

Названия строк редко заменяются, поскольку с точки зрения реляционной алгебры большого смысла они не имеют.

### Обращение к столбцам {#tables_elements_columns}

К столбцу можно обращаться по номеру и названию (с помощью оператора `$` или в кавычках внутри скобок). Если вы указываете в квадратных скобках номер без запятой, он трактуется именно как номер столбца, а не строки. Тип возвращаемого значения зависит от синтаксиса:

- обращение через `$` возвращает вектор;
- обращение в скобках с запятой к одному столбцу возвращает вектор;
- обращение в скобках с запятой к нескольким столбцам возвращает фрейм данных;
- обращение в скобках без запятой возвращает фрейм данных.

Несколько примеров:

```r
# Один столбец - результат зависит от запятой
okruga$Year05      # столбец в виде вектора
okruga[, "Year05"] # столбец в виде вектора
okruga[, 2]        # столбец в виде вектора

okruga["Year05"] # столбец в виде фрейма данных/тиббла
okruga[2]        # столбец в виде фрейма данных/тиббла

# Несколько столбцов - всегда фрейм данных/тиббл
okruga[, c(1, 4)]
okruga[, c("Region", "Year11")]
okruga[c("Region", "Year11")]
okruga[c(1, 4)]
```

### Обращение к строкам {#tables_elements_rows}

Обращаться к строкам можно по их номерам. В этом случае в качестве индекса можно передать номер (номера) интересующих строк, либо вектор логических значений, в котором интересующие строки помечены как TRUE, а остальные — FALSE (в этом случае длина вектора должна равняться количеству строк в таблице):

```r
okruga[5, ] # Одна строка
okruga[2:4, ] # Несколько строк
okruga[okruga$Year10 > 2000, ] # Несколько строк через TRUE/FALSE
```
> В отличие от работы со столбцами, выбор строк всегда возвращает таблицу (фрейм или тиббл).

### Обращение к ячейкам {#tables_elements_cells}

Чтобы выбрать конкретные ячейки в таблице, необходимо задать оба измерения:

```r
okruga[2:3, c("Year11", "Year12")]
## # A tibble: 2 x 2
##   Year11 Year12
##    <int>  <int>
## 1   2866   2877
## 2   1436   1394
```

Обратите внимание на то, что при этом возвращаются все комбинации строк и столбцов. То есть, нельзя выбрать ячейки `2,"Year11"` и `3,"Year2"` --- вместе с ними также будут выбраны ячейки `3,"Year11"` и `2,"Year2"`. Впрочем, подобные задачи возникают довольно редко

## Преобразования {#tables_manipuilations}

### Грамматика манипуляций {#tables_manipiulations_grammar}

Если проанализировать наиболее типичные манипуляции, которые осуществляются над таблицами, то их окажется совсем немного. К таким манипуляциям относятся выбор переменных, фильтрация строк, сортировка, вычисление новых столбцов, агрегирующие статистики и группировка.

Все эти задачи можно решать стандартными средствами R (и мы увидим, как это делается). Однако некоторые из них достаточно громоздки в реализации (например, группировка). К счастью, экосистема R предлагает готовые средства, позволяющие справляться с подобными задачами простым и элегантным путем. Эти средства предоставляет пакет [__dplyr__](https://dplyr.tidyverse.org), входящий в набор инструментов [tidyverse](https://www.tidyverse.org).

В основе конецепции __dplyr__ лежит понятие о грамматике табличных манипуляций, которая включает в себя ограниченное число наиболее используемых операций, а также ряд вспомогательных функций.

Основные функции пакета __dplyr__ представлены в таблице ниже:

Функция       | Назначение
--------------|-----------------
`select()`    | Выбор переменных по их названиям
`filter()`    | Выбор строк по заданному критерию (запросу)
`arrange()`   | Упорядочение по указанным переменным
`mutate()`    | Вычисление новых переменных (мутирование)
`summarise()` | Агрегирование значений переменных
`group_by()`  | Группировка строк (для последующего агрегирования)

Как можно видеть, этих функций совсем немного. Дополнительно к ним пакет __dplyr__ содержит еще множество вспомогательных функций, которые применяются при выполнении основных манипуляций.

Рассмотрим применение этих функций на примере работы с таблицей по восстановлению лесного фонда в регионах России. Для начала переименуем столбцы с годами, чтобы их названия начинались с буквы `y`:

```r
old_names = colnames(reforest)
colnames(reforest) = c(old_names[1], paste('y', old_names[2:9], sep = ''))
```

Начнем с __выбора__ нужных переменных, используя `select()`. Оставим только название региона и данные за 2010 и 2015 гг:

```r
(rdf = select(reforest, Region, y2010, y2015))
## # A tibble: 89 x 3
##    Region                        y2010 y2015
##    <chr>                         <dbl> <dbl>
##  1 Российская Федерация          812.  803. 
##  2 Центральный федеральный округ  62.7  72.6
##  3 Белгородская область            0.1   0.2
##  4 Брянская область                2.8   3.1
##  5 Владимирская область            5.3   6  
##  6 Воронежская область             1.1   2.6
##  7 Ивановская область              1.6   4.6
##  8 Калужская область               2.3   3.2
##  9 Костромская область            25.2  15.1
## 10 Курская область                 0.3   0.5
## # ... with 79 more rows
```
Ту же самую задачу можно решить от противного — указать со знаком `-` те столбцы, которые надо убрать:

```r
(rdf = select(reforest, -y2005, -y2011:-y2014, -y2016))
## # A tibble: 89 x 3
##    Region                        y2010 y2015
##    <chr>                         <dbl> <dbl>
##  1 Российская Федерация          812.  803. 
##  2 Центральный федеральный округ  62.7  72.6
##  3 Белгородская область            0.1   0.2
##  4 Брянская область                2.8   3.1
##  5 Владимирская область            5.3   6  
##  6 Воронежская область             1.1   2.6
##  7 Ивановская область              1.6   4.6
##  8 Калужская область               2.3   3.2
##  9 Костромская область            25.2  15.1
## 10 Курская область                 0.3   0.5
## # ... with 79 more rows
```
Обратите внимание на то, что можно указывать еще и диапазоны названий столбцов, если они идут друг за другом.

> Названия столбцов в функциях __dplyr__ указываются без кавычек, что позволяет сделат код проще и читаемее. Этот прием называется _квотацией_, с ним мы познакомимся подробнее в следующей лекции.

Чтобы осуществить __фильтрацию__, необходимо задать условие, накладываемое на строки. Текущая таблица содержит данные по субъектам, федеральным округам и России в целом. Поскольку данные по округам и стране являются избыточными (их можно получить путем агрегирования данных по субъектам), выполним фильтрацию таблицы, убрав строки, в которых содержатся слова `Федерация` и `федеральный округ`. Для этого используем функцию `str_detect()` из пакета __stringr__, который также входит в _tidyverse_:

```r
flt = !stringr::str_detect(rdf$Region, 'Федерация|федеральный округ') # готовим фильтр для строк
(regdf = filter(rdf, flt)) # применяем фильтр
## # A tibble: 80 x 3
##    Region               y2010 y2015
##    <chr>                <dbl> <dbl>
##  1 Белгородская область   0.1   0.2
##  2 Брянская область       2.8   3.1
##  3 Владимирская область   5.3   6  
##  4 Воронежская область    1.1   2.6
##  5 Ивановская область     1.6   4.6
##  6 Калужская область      2.3   3.2
##  7 Костромская область   25.2  15.1
##  8 Курская область        0.3   0.5
##  9 Липецкая область       0.4   1.1
## 10 Московская область     2.7   8.9
## # ... with 70 more rows
```

Условие можно прописать непосредственно при вызове `filter()`. Например, выберем регионы, в которых объем лесовосстановительных работ в 2015 году был более 50 тыс. га:

```r
filter(regdf, y2015 > 50)
## # A tibble: 4 x 3
##   Region                y2010 y2015
##   <chr>                 <dbl> <dbl>
## 1 Архангельская область  39.4  57.6
## 2 Красноярский край      49    50.4
## 3 Иркутская область      80.4 117. 
## 4 Хабаровский край       70.2  59.6
```

Для сортировки таблицы посредством `arrange()` необходимо указать столбцы, по которым будет осуществлено упорядочение строк. Чаще всего это один столбец, например _y2015_:

```r
arrange(regdf, y2015) # по возрастанию
## # A tibble: 80 x 3
##    Region                              y2010 y2015
##    <chr>                               <dbl> <dbl>
##  1 Орловская область                     0     0.1
##  2 Астраханская область                  0.1   0.1
##  3 Кабардино-Балкарская Республика       0.1   0.1
##  4 Карачаево-Черкесская Республика       0.2   0.1
##  5 Республика Северная Осетия – Алания  NA     0.1
##  6 Ставропольский край                   0.4   0.1
##  7 Белгородская область                  0.1   0.2
##  8 Тульская область                      0.1   0.2
##  9 Магаданская область                   2.6   0.4
## 10 Курская область                       0.3   0.5
## # ... with 70 more rows
arrange(regdf, desc(y2015)) # по убыванию
## # A tibble: 80 x 3
##    Region                y2010 y2015
##    <chr>                 <dbl> <dbl>
##  1 Иркутская область      80.4 117. 
##  2 Хабаровский край       70.2  59.6
##  3 Архангельская область  39.4  57.6
##  4 Красноярский край      49    50.4
##  5 Вологодская область    32.3  49  
##  6 Республика Коми        33.3  36.7
##  7 Пермский край          22.9  32.5
##  8 Кировская область      26    31.1
##  9 Амурская область       29.8  28.5
## 10 Томская область         9.3  25.6
## # ... with 70 more rows
```
Добавление новых столбцов осуществляется посредством `mutate()`. Например, определим, как изменился объем лесовосстановительных работ в 2015 году по сравнению с 2010 годом:

```r
(regdf = mutate(regdf, delta = y2015 - y2010))
## # A tibble: 80 x 4
##    Region               y2010 y2015  delta
##    <chr>                <dbl> <dbl>  <dbl>
##  1 Белгородская область   0.1   0.2   0.1 
##  2 Брянская область       2.8   3.1   0.3 
##  3 Владимирская область   5.3   6     0.7 
##  4 Воронежская область    1.1   2.6   1.5 
##  5 Ивановская область     1.6   4.6   3.00
##  6 Калужская область      2.3   3.2   0.9 
##  7 Костромская область   25.2  15.1 -10.1 
##  8 Курская область        0.3   0.5   0.2 
##  9 Липецкая область       0.4   1.1   0.7 
## 10 Московская область     2.7   8.9   6.2 
## # ... with 70 more rows
```
Существует редко используемая разновидность мутирования, при которой сохраняются только столбцы, указанные в параметрах. Она называется `transmute()` --- по сути это кобинация `mutate()` и `select()`. Если вы хотите просто сохранить какой-то из столбцов, то укажите его через оператор равенства:

```r
transmute(regdf, Region = Region, delta = y2015 - y2010) # сохраняем только Region и delta
## # A tibble: 80 x 2
##    Region                delta
##    <chr>                 <dbl>
##  1 Белгородская область   0.1 
##  2 Брянская область       0.3 
##  3 Владимирская область   0.7 
##  4 Воронежская область    1.5 
##  5 Ивановская область     3.00
##  6 Калужская область      0.9 
##  7 Костромская область  -10.1 
##  8 Курская область        0.2 
##  9 Липецкая область       0.7 
## 10 Московская область     6.2 
## # ... with 70 more rows
```

Вы можете выполнять агрегирование данных и вычислять суммы, средние значения и т.д. используя `summarise()`. После того как мы избавились от избыточных данных в таблице, мы всегда можем получить их через агрегирование. Например, посчитаем суммарный, минимальный и максимальный объем лесовосстановительных работ по всей стране:

```r
summarise(regdf, 
          sumforest = sum(y2015, na.rm = TRUE),
          minforest = min(y2015, na.rm = TRUE),
          maxforest = max(y2015, na.rm = TRUE))
## # A tibble: 1 x 3
##   sumforest minforest maxforest
##       <dbl>     <dbl>     <dbl>
## 1      801.       0.1      117.
```

Достаточно часто данные надо агрегировать не по всей таблице, а _по группам_ измерений. Предположим, что нам нужно найти регион с наихудшей тенденцией изменения лесовосстановительных работ в каждом федеральном округе. Для этого нам потребуется:

- Дополнить каждую строку региона информацией о принадлежности к федеральному округу
- Сгруппировать субъекты по федеральным округам
— Отсортировать каждую группу по убыванию значения поля
- Взять первую строку в каждой группе
- Объединить результаты

Для начала вернемся на этап, когда мы избавлялись от федеральных округов в таблице. Поскольку в исходной таблице данные были упорядочены по округам, эту информацию можно использовать для создания нового столбца с названием округа каждого субъекта. В этом нам поможет функция `fill()` из пакета __tidyr__:

```r
flt2 = stringr::str_detect(rdf$Region, 'федеральный округ') # ищем округа
(rdf2 = mutate(rdf, okrug = if_else(flt2, Region, NULL))) # перенесем названия округов в новый столбец
## # A tibble: 89 x 4
##    Region                        y2010 y2015 okrug                        
##    <chr>                         <dbl> <dbl> <chr>                        
##  1 Российская Федерация          812.  803.  <NA>                         
##  2 Центральный федеральный округ  62.7  72.6 Центральный федеральный округ
##  3 Белгородская область            0.1   0.2 <NA>                         
##  4 Брянская область                2.8   3.1 <NA>                         
##  5 Владимирская область            5.3   6   <NA>                         
##  6 Воронежская область             1.1   2.6 <NA>                         
##  7 Ивановская область              1.6   4.6 <NA>                         
##  8 Калужская область               2.3   3.2 <NA>                         
##  9 Костромская область            25.2  15.1 <NA>                         
## 10 Курская область                 0.3   0.5 <NA>                         
## # ... with 79 more rows
(rdf2 = tidyr::fill(rdf2, okrug)) # заполним все пустые строчки предыдущим значением
## # A tibble: 89 x 4
##    Region                        y2010 y2015 okrug                        
##    <chr>                         <dbl> <dbl> <chr>                        
##  1 Российская Федерация          812.  803.  <NA>                         
##  2 Центральный федеральный округ  62.7  72.6 Центральный федеральный округ
##  3 Белгородская область            0.1   0.2 Центральный федеральный округ
##  4 Брянская область                2.8   3.1 Центральный федеральный округ
##  5 Владимирская область            5.3   6   Центральный федеральный округ
##  6 Воронежская область             1.1   2.6 Центральный федеральный округ
##  7 Ивановская область              1.6   4.6 Центральный федеральный округ
##  8 Калужская область               2.3   3.2 Центральный федеральный округ
##  9 Костромская область            25.2  15.1 Центральный федеральный округ
## 10 Курская область                 0.3   0.5 Центральный федеральный округ
## # ... with 79 more rows
(regdf = filter(rdf2, flt)) # оставим только регионы
## # A tibble: 80 x 4
##    Region               y2010 y2015 okrug                        
##    <chr>                <dbl> <dbl> <chr>                        
##  1 Белгородская область   0.1   0.2 Центральный федеральный округ
##  2 Брянская область       2.8   3.1 Центральный федеральный округ
##  3 Владимирская область   5.3   6   Центральный федеральный округ
##  4 Воронежская область    1.1   2.6 Центральный федеральный округ
##  5 Ивановская область     1.6   4.6 Центральный федеральный округ
##  6 Калужская область      2.3   3.2 Центральный федеральный округ
##  7 Костромская область   25.2  15.1 Центральный федеральный округ
##  8 Курская область        0.3   0.5 Центральный федеральный округ
##  9 Липецкая область       0.4   1.1 Центральный федеральный округ
## 10 Московская область     2.7   8.9 Центральный федеральный округ
## # ... with 70 more rows
```
Теперь мы можем определить регион с максимальным объемом лесовосстановительных работ в каждом Федеральном округе, используя вспомогательную функцию `row_number()` которая возвращает номер для каждой строки таблицы:

```r
regdf_gr = group_by(regdf, okrug)
regdf_arr = arrange(regdf_gr, desc(y2015))
(regdf_res = filter(regdf_arr, row_number() == 1))
## # A tibble: 8 x 4
## # Groups:   okrug [8]
##   Region                y2010 y2015 okrug                              
##   <chr>                 <dbl> <dbl> <chr>                              
## 1 Иркутская область      80.4 117.  Сибирский федеральный округ        
## 2 Хабаровский край       70.2  59.6 Дальневосточный федеральный округ  
## 3 Архангельская область  39.4  57.6 Северо-Западный федеральный округ  
## 4 Пермский край          22.9  32.5 Приволжский федеральный округ      
## 5 Свердловская область   25.6  24.4 Уральский федеральный округ        
## 6 Костромская область    25.2  15.1 Центральный федеральный округ      
## 7 Волгоградская область   1.8   0.9 Южный федеральный округ            
## 8 Чеченская Республика    0.9   0.7 Северо-Кавказский федеральный округ
```

Использование __dplyr__ целым обладает рядом преимуществ по сравнению с применением стандартных средств __R__: 

- вызов функций с говорящими названиями операции более понятными;
- код выглядит более чистым и легко читаемым за счет отсутствия обращений к фреймам данных через квадратные скобки, доллары и «закавыченные» названия переменных;
- код с использованием функций __dplyr__ часто оказывается короче, чем его традиционные аналоги;
- операции dplyr можно выстраивать в конвейеры с помощью пайп-оператора `%>%`.
 
Последнюю возможность мы рассмотрим в следующем параграфе.

### Конвейер манипуляций {#tables_manipiulations_pipeline}

В предыдущем параграфе было показано как найти регион-лидер в каждой группе по выбранному показателю. При этом, несмотря на то что интерес представляет только конечный результат, нам пришлось шесть раз осуществить запись промежуточного результата в соответствующую переменную. Чтобы избежать подобного многословия в программах, в __R__ реализована возможность организации __конвейера манипуляций__ (pipeline) посредством использования _пайп-оператора_ `%>%`.

 __Пайп-оператор `%>%`__ предназначен для компактной и наглядной записи _последовательностей_ обработки данных. Работает он следующим образом:

 - `x %>% f` эквивалентно `f(x)`
 - `x %>% f(y)` эквивалентно `f(x, y)`
 - `x %>% f %>% g %>% h` эквивалентно `h(g(f(x)))`

Коротко говоря, пайп оператор берет результат вычисления выражения слева и подставляет его в качестве первого аргумента в выражение справа. С помощью этого оператора вышеприведенный код по нахождению региона-лидера можно записать так:

```r
regdf = rdf %>% 
  mutate(okrug = if_else(flt2, Region, NULL)) %>% 
  tidyr::fill(okrug) %>% 
  filter(flt)

leaders = regdf %>% 
  group_by(okrug) %>% 
  arrange(desc(y2015)) %>% 
  filter(row_number() == 1)

print(leaders)
## # A tibble: 8 x 4
## # Groups:   okrug [8]
##   Region                y2010 y2015 okrug                              
##   <chr>                 <dbl> <dbl> <chr>                              
## 1 Иркутская область      80.4 117.  Сибирский федеральный округ        
## 2 Хабаровский край       70.2  59.6 Дальневосточный федеральный округ  
## 3 Архангельская область  39.4  57.6 Северо-Западный федеральный округ  
## 4 Пермский край          22.9  32.5 Приволжский федеральный округ      
## 5 Свердловская область   25.6  24.4 Уральский федеральный округ        
## 6 Костромская область    25.2  15.1 Центральный федеральный округ      
## 7 Волгоградская область   1.8   0.9 Южный федеральный округ            
## 8 Чеченская Республика    0.9   0.7 Северо-Кавказский федеральный округ
```

Если бы мы попытались написать те же последовательности операций одним выражением в традиционной «матрешечной» парадигме, это выглядело так:

```r
regdf = filter(
           tidyr::fill(
             mutate(
               rdf,
               okrug = if_else(flt2, Region, NULL)
             ),
             okrug
           ),
           flt
         )

result = filter(
           arrange(
             group_by(
               regdf, 
               okrug
             ),
             desc(y2015)
           ),
           row_number() == 1
         )
```

Выглядит несколько устрашающе. К тому же, читать такой код приходится задом наперед (изнутри наружу), чтобы понять последовательность действий. Таким образом, организация конвейера манипуляций с использованием пайп-оператора позволяет:

- упорядочить операции по обработке данных слева направо (в противоположность направлению изнутри наружу);
- избежать вложенных вызовов функций (матрёшки);
- минимизировать количество переменных для храненния промежуточных результатов;
- упростить добавление новых операций по обработке данных в любое место последовательности.

> __Пайп-оператор `%>%` можно быстро набрать в RStudio__, нажав клавиатурное сочетание <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd> (<kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd> на помпьютерах Mac)

### Преобразование структуры {#tables_tidy}

Одни и те же данные можно предствить в табличной форме по-разному. Одна форма будет удобной для ручного заполнения таблицы. Другая форма будет удобной для программной обработки и анализа. Большинство же остальных форм не будут оптимальными ни для того, ни для другого. Наш курс посвящен автоматизированной обработке данных на языке R, поэтомы мы должны определить, какая форма таблицы удобна для этих целей.

В экосистеме R такие данные принято называть «аккуратными», или по-английски [__tidy data__](https://www.jstatsoft.org/article/view/v059i10). Аккуратные таблицы отвечают следующим требованиям:

1. Каждый столбец представляет переменную
2. Каждая строка представляет измерение
3. Каждая ячейка представляет значение

С некоторой долей условности можно говорить, что это [третья нормальная форма](https://ru.wikipedia.org/wiki/Третья_нормальная_форма) реляционного отношения.

Таблицы, с которыми мы работали до настоящего момента в этой главе, не отвечают данным требованиям. В частности, данные по лесовосстановлению содержат столбцы, в которых приведены данные за соответствующие года. Это __одна__ переменная, разбитая на несколько столбцов. При этом _год измерения_ является второй переменной. Такая форма удобна для заполнения и визуального анализа, но неудобна для программной обработки. Предположим, что нам надо найти все регионы, у которых в промежутке между 2012 и 2015 годами лесовосстановительные работы хотя бы в один год не производились (их объем был равен нулю). В текущей форме таблицы нам придется сделать 4 условия --- по одному на каждый год-столбец. Это при том, что мы должны быть уверены, что все промежуточные года в таблице присутствуют. Приведя таблицу к аккуратному виду, мы можем решить задачу более компактно, отправив всего 2 запроса: один на год измерения и второй на величину показателя.

Приведение таблицы к аккуратному виду можно сделать, используя функции из пакета [__tidyr__](https://tidyr.tidyverse.org). Основных функций в этом пакете всего две:

- `gather()` берет несколько колонок и преобразует их к виду «ключ---значение»: широкие таблицы становятся длинными.
- `spread()` берет две колонки, соответствующие ключу и значению, и распределяет их на множество колонок: длинные таблицы становятся широкими.

Помимо этого, есть еще 2 полезных функции, которые позволяют «распиливать» или «склеивать» колонки:

- `separate()` разделяет колонку на несколько колонок, используя заданный символ-разделитель или позицию.
- `unite()` скливает несколько колонок, используя заданный символ-разделитель.

Функция `gather()` ожидает получить следующие параметры:

- `data` --- входная таблица (фрейм данных или тиббл)
- `key` --- имя нового столбца, который будет хранить ключи
- `value` --- имя нового столбца, который будет хранить значения
- `...` --- перечисление столбцов, которые необходимо подвергнуть преобразованию

Рассмотрим на примере таблицы _reforest_ приведение к аккуратному виду:

```r
library(tidyr)
(reforest_tidy = reforest %>% gather(year, value, y2005:y2016))
## # A tibble: 712 x 3
##    Region                        year  value
##    <chr>                         <chr> <dbl>
##  1 Российская Федерация          y2005 812. 
##  2 Центральный федеральный округ y2005  52.6
##  3 Белгородская область          y2005   0.4
##  4 Брянская область              y2005   2.9
##  5 Владимирская область          y2005   4.4
##  6 Воронежская область           y2005   1.1
##  7 Ивановская область            y2005   2.1
##  8 Калужская область             y2005   2.2
##  9 Костромская область           y2005  10  
## 10 Курская область               y2005   0.5
## # ... with 702 more rows
```
Осталось избавиться от буквы `y` перед каждым годом — для этого можно использовать `separate()`, `select()` и `mutate()` чтобы отделить букву в отдельный столбец, отбросить его, а оставшийся год преобразовать к целочисленному значению:

```r
reforest_tidy = reforest_tidy %>% 
  separate(year, c('y', 'year'), 1) %>% 
  select(-y) %>% 
  mutate(year = as.integer(year))
reforest_tidy
## # A tibble: 712 x 3
##    Region                         year value
##    <chr>                         <int> <dbl>
##  1 Российская Федерация           2005 812. 
##  2 Центральный федеральный округ  2005  52.6
##  3 Белгородская область           2005   0.4
##  4 Брянская область               2005   2.9
##  5 Владимирская область           2005   4.4
##  6 Воронежская область            2005   1.1
##  7 Ивановская область             2005   2.1
##  8 Калужская область              2005   2.2
##  9 Костромская область            2005  10  
## 10 Курская область                2005   0.5
## # ... with 702 more rows
```
Теперь можно выполнять любые запросы, комбинирующие год измерения и величину показателя:

```r
reforest_tidy %>% filter(year > 2011 & year < 2016 & value == 0)
## # A tibble: 2 x 3
##   Region             year value
##   <chr>             <int> <dbl>
## 1 Орловская область  2013     0
## 2 Республика Адыгея  2014     0
```
В некоторых случая бывает удобно распределить переменную по нескольким колонкам. В частности, это может быть удобно, если нам надо вычислить разности между годами. Для этого используем `spread()`:

```r
(reforest = reforest_tidy %>% spread(year, value))
## # A tibble: 89 x 9
##    Region          `2005` `2010` `2011` `2012` `2013` `2014` `2015` `2016`
##    <chr>            <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
##  1 Алтайский край    12     10.9   13.5   13.8   13.2   14.3   13.7   12  
##  2 Амурская облас…   33.3   29.8   32.2   33.6   35.5   37.7   28.5   27.7
##  3 Архангельская …   42.6   39.4   48.5   48.8   52.7   60.7   57.6   63.5
##  4 Астраханская о…    0.1    0.1    0      0.1    0.1    0.1    0.1    0  
##  5 Белгородская о…    0.4    0.1    0.3    0.3    0.4    0.4    0.2    0.2
##  6 Брянская облас…    2.9    2.8    3      3.2    3.5    3.3    3.1    3  
##  7 Владимирская о…    4.4    5.3    5.7    6      7.1    5.9    6      4.9
##  8 Волгоградская …    1.6    1.8    2      1.3    1.1    1.2    0.9    0.9
##  9 Вологодская об…   25.6   32.3   44.2   43.3   43.6   44.8   49     52  
## 10 Воронежская об…    1.1    1.1    1.8    3      2.7    2.7    2.6    2.3
## # ... with 79 more rows
```

Теперь вычислим разности по сравнению с предыдущим годом:

```r
diffs = reforest %>% select(`2011`:`2016`) -
        reforest %>% select(`2010`:`2015`)

diffs %>% 
  mutate(Region = reforest$Region) %>% 
  select(Region, `2011`:`2016`)
##                                 Region  2011  2012 2013  2014  2015 2016
## 1                       Алтайский край   2.6   0.3 -0.6   1.1  -0.6 -1.7
## 2                     Амурская область   2.4   1.4  1.9   2.2  -9.2 -0.8
## 3                Архангельская область   9.1   0.3  3.9   8.0  -3.1  5.9
## 4                 Астраханская область  -0.1   0.1  0.0   0.0   0.0 -0.1
## 5                 Белгородская область   0.2   0.0  0.1   0.0  -0.2  0.0
## 6                     Брянская область   0.2   0.2  0.3  -0.2  -0.2 -0.1
## 7                 Владимирская область   0.4   0.3  1.1  -1.2   0.1 -1.1
## 8                Волгоградская область   0.2  -0.7 -0.2   0.1  -0.3  0.0
## 9                  Вологодская область  11.9  -0.9  0.3   1.2   4.2  3.0
## 10                 Воронежская область   0.7   1.2 -0.3   0.0  -0.1 -0.3
## 11                      г. Севастополь    NA    NA   NA    NA    NA   NA
## 12   Дальневосточный федеральный округ   0.8 -27.5  8.0 -13.3 -56.9  2.3
## 13        Еврейская автономная область    NA  -0.1 -0.2    NA    NA   NA
## 14                  Забайкальский край  -1.3  -0.1  1.6  -2.4  -3.6  1.5
## 15                  Ивановская область   0.6   0.9  0.9   0.8  -0.2 -0.4
## 16                   Иркутская область   1.4   9.1  8.6   8.1   9.2  6.1
## 17     Кабардино-Балкарская Республика   0.0   0.0  0.0   0.0   0.0  0.0
## 18             Калинингpадская область    NA    NA   NA   0.3  -0.6  0.0
## 19                   Калужская область   0.0   0.2 -0.1   0.7   0.1  0.0
## 20                    Камчатский  край    NA    NA   NA    NA    NA   NA
## 21     Карачаево-Черкесская Республика   0.0   0.0  0.0   0.0  -0.1  0.0
## 22                 Кемеровская область   1.5  -0.3 -0.4   0.0   1.9 -0.3
## 23                   Кировская область   2.1   0.5 -1.1   0.7   2.9  3.9
## 24                 Костромская область -14.2   0.8  3.5  -1.7   1.5  1.3
## 25                  Краснодарский край  -0.3   0.2  0.0   0.1  -0.4 -0.1
## 26                   Красноярский край   7.3   0.7 -2.1  -3.1  -1.4  2.7
## 27                  Курганская область  -0.4   0.1 -0.1  -0.2  -0.2  0.0
## 28                     Курская область   0.1   0.2  0.0   0.0  -0.1 -0.1
## 29               Ленинградская область    NA    NA  1.9  -0.7  -1.0 -0.2
## 30                    Липецкая область   1.0   0.1 -0.1   0.1  -0.4  0.3
## 31                 Магаданская область   0.0   0.2  0.2  -0.5  -2.1   NA
## 32                  Московская область   0.7  -2.3  5.1   0.8   1.9  2.3
## 33                  Мурманская область  -1.1    NA   NA   0.0   0.0 -0.6
## 34               Нижегородская область   3.1  -0.4  1.1  -0.8   3.0  0.5
## 35                Новгородская область   1.0  -0.1  0.5  -0.1   0.0 -0.2
## 36               Новосибирская область   0.8  -3.7 -0.1   0.0   0.1 -0.7
## 37                      Омская область   0.4   0.7 -1.4  -0.2  -0.1  0.8
## 38                Оренбургская область    NA    NA  0.0   0.0   0.0  0.0
## 39                   Орловская область   0.1   0.0 -0.1   0.1   0.0  0.1
## 40                  Пензенская область   0.1   0.1 -0.1  -0.8  -0.3 -0.1
## 41                       Пермский край   5.1  -1.2  4.0  -3.2   4.9 -3.1
## 42       Приволжский федеральный округ  13.6  -2.2  5.1  -4.8   8.9  2.3
## 43                     Приморский край   1.9  -4.0 -1.4  -2.3   1.1 -1.3
## 44                   Псковская область  -0.3  -0.3  0.4   0.0   0.4  0.2
## 45                   Республика Адыгея   0.2   0.0   NA    NA    NA   NA
## 46                    Республика Алтай   0.0  -0.3 -1.7  -0.1  -0.1  0.1
## 47             Республика Башкортостан  -0.1   0.0  0.1   1.4  -0.6  1.5
## 48                  Республика Бурятия  -0.9   1.5 -2.4   0.0 -14.1 10.0
## 49                 Республика Дагестан    NA    NA   NA    NA    NA   NA
## 50                Республика Ингушетия    NA    NA   NA    NA    NA   NA
## 51                 Республика Калмыкия  -0.3   0.0  0.1  -0.1  -0.2   NA
## 52                  Республика Карелия  -4.0  -0.9 -1.1  -1.1  -0.3  0.7
## 53                     Республика Коми   3.8   3.3 -0.2  -2.7  -0.8 -1.5
## 54                     Республика Крым    NA    NA   NA    NA    NA   NA
## 55                 Республика Марий Эл   0.1  -0.1  0.0   0.2  -0.1 -0.3
## 56                 Республика Мордовия   0.3   0.2 -0.2  -0.2   0.1 -0.2
## 57            Республика Саха (Якутия)   2.3 -16.6 16.6  -3.7 -54.7  2.7
## 58 Республика Северная Осетия – Алания    NA    NA   NA   0.0   0.0  0.0
## 59                Республика Татарстан   0.4   0.0  0.1   0.2  -0.5 -0.2
## 60                     Республика Тыва   0.0  -0.4 -2.6   3.6   0.5 -0.8
## 61                  Республика Хакасия   0.0   0.3  0.1  -0.1   0.1  0.0
## 62                Российская Федерация  48.5 -18.3 30.6  -9.3 -60.1 37.0
## 63                  Ростовская область   0.6  -0.6  0.0   0.0  -0.6  0.2
## 64                   Рязанская область   7.0  -2.2  0.2   0.1  -2.0 -0.4
## 65                   Самарская область    NA    NA  0.5  -0.6   0.1 -0.4
## 66                 Саратовская область   0.4  -0.5  0.6  -0.1   0.0 -0.5
## 67                 Сахалинская область  -0.2  -7.9  0.1   0.2  -0.2 -0.6
## 68                Свердловская область   1.8  -1.4  0.7  -3.2   0.9 -1.8
## 69   Северо-Западный федеральный округ  23.3  -1.3  5.3   4.9  -1.3  7.3
## 70 Северо-Кавказский федеральный округ   0.0  -0.5 -0.2  -0.2  -0.2 -0.1
## 71         Сибирский федеральный округ  13.0  15.5  4.2   8.0  -7.2 20.4
## 72                  Смоленская область   0.3   0.1  0.7   0.3   0.0  0.1
## 73                 Ставропольский край   0.2  -0.2 -0.1   0.0  -0.2  0.0
## 74                  Тамбовская область   0.4   0.1 -0.4   0.1   0.0  0.2
## 75                    Тверская область   0.4   0.4 -0.7   0.5   0.7  1.9
## 76                     Томская область   1.2   7.9  5.1   1.2   0.9  2.6
## 77                    Тульская область   0.0   0.0  0.0   0.0   0.1  0.0
## 78                   Тюменская область  -1.9   0.6 -2.0  -1.0  -3.6  1.7
## 79               Удмуртская Республика   0.6  -0.7 -0.7  -0.4   0.2  0.9
## 80                 Ульяновская область   1.0   0.1  1.1  -1.3  -0.6  0.3
## 81         Уральский федеральный округ  -0.8  -0.4 -2.2  -4.3  -3.2  0.3
## 82                    Хабаровский край  -1.5  -1.5 -8.8  -7.9   9.1  0.7
## 83       Центральный федеральный округ  -1.8  -0.6 10.6   0.3   1.4  4.4
## 84                 Челябинская область  -0.3   0.3 -0.9   0.2  -0.3  0.4
## 85                Чеченская Республика  -0.5  -0.2  0.0   0.3   0.2 -0.1
## 86                Чувашская Республика   0.6  -0.2 -0.3   0.0  -0.1  0.1
## 87          Чукотский автономный округ    NA    NA   NA    NA    NA   NA
## 88             Южный федеральный округ   0.4  -1.1 -0.3   0.0  -1.5  0.0
## 89                 Ярославская область   0.4  -0.6  0.2   0.1   0.2  0.4
```

## Соединение {#tables_join}

Данные, с которыми мы работаем, часто распределены по нескольким таблицам. Если возникает задача их совместного использования (сравнения, вычисления производных показателей), таблицы необходимо соединить.

В процессе __соединения__ в обеих таблицах находятся строки, соответствующие одному и тому же измерению (например, региону). После этого столбцы второй таблицы пристыковываются к столбцам первой таблицы, а строки — к соответствующим строкам _(мутирующее соединение)_, либо же происходит фильтрация строк первой таблицы на основе нахождения соответствующих строк во второй таблице _(фильтрующее соединение)_.

Чтобы найти соответствие, в обеих таблицах должен быть по крайней мере один столбец, идентифицирующий каждую строку. В первой таблице он называется __первичным ключом__ _(primary key)_, во второй таблице --- __внешним ключом__ _(foreign key)_.

Для выполнения соедининия в пакете dplyr имеется несколько функций.

_Мутирующее соединение:_

- `inner_join(x, y, by = )` возвращает все строки из `x`, для которых имеются соответствующие строки в `y`, а также все столбцы из `x` и `y`.
- `left_join(x, y, by = )` возвращает все строки из `x`, а также все столбцы из `x` и `y`. Строки в `x`, для которых не найдены соответствия в `y`, будут иметь значения `NA` в присоединенных столбцах
- `right_join(x, y, by = )` возвращает все строки из `y`, а также все столбцы из `x` и `y`. Строки в `y`, для которых не найдены соответствия в `x`, будут иметь значения `NA` в присоединенных столбцах
- `full_join(x, y, by = )` возвращает все строки и колонки из `x` и `y`. В строках, для которых не найдено соответствие ячейки присоединяемых стольков будут заполнены значениями `NA`

_Фильтрующее соединение:_

- `semi_join(x, y, by = )` возвращает все строки из `x`, для которых имеются соответствующие строки в `y`, а также все столбцы из `x`
- `anti_join(x, y, by = )` возвращает все строки из `x`, для которыхне найдены соответствующие строки в `y`, а также все столбцы из `x`

Рассмотрим соединение таблиц на примере данных по лесовосстановлению и заготовкам древесины. Наша задача — оценить количество гектаров восстанавливаемой лесной площади (в га) на тысячу кубометров лесозаготовок (и таким образом оценить эффективность лесовосстановительных мероприятий).

Подгрузим таблицу по лесозаготовкам:

```r
(timber = read_excel('timber.xlsx', 
                    col_types = c('text', rep('numeric', 8))) %>% 
  filter(!stringr::str_detect(Регион, 'Федерация|федеральный округ')))
## # A tibble: 75 x 9
##    Регион           `2010` `2011` `2012` `2013` `2014` `2015` `2016` Место
##    <chr>             <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl>
##  1 Белгородская об…   30.4   39.6   27.7   37.4   34.1   45.6   30.4    60
##  2 Брянская область  614.   616.   824.   850.   793.   739.   750.     27
##  3 Владимирская об… 1078   1335   1236   1142   1165   1272   1252      20
##  4 Воронежская обл…   73.6   69.5   68.6   47.9   81.1   86.6   53.5    58
##  5 Ивановская обла…  130.   140.   200.   199.   231.   326.   421.     38
##  6 Калужская облас…  274.   244.   192.   198.   183    145.   204      44
##  7 Костромская обл… 3000   3332   2797   2692   2564   2186   2515      14
##  8 Курская область    22.8   55.4   49.7   50.1   65.9   74.6   80.7    55
##  9 Липецкая область  163.   139     49.7   42.6   50.1   73.1   87.8    53
## 10 Московская обла…  126.   265.   299.   108.    15.6   NA     NA      74
## # ... with 65 more rows
```

Приведем ее к аккуратному виду, который соответствует виду таблицы по лесовосстановлению:

```r
(timber_tidy = timber %>% 
  gather(year, harvest, `2010`:`2016`) %>% 
  transmute(Region = Регион,
            year = as.numeric(year),
            harvest = harvest))
## # A tibble: 525 x 3
##    Region                year harvest
##    <chr>                <dbl>   <dbl>
##  1 Белгородская область  2010    30.4
##  2 Брянская область      2010   614. 
##  3 Владимирская область  2010  1078  
##  4 Воронежская область   2010    73.6
##  5 Ивановская область    2010   130. 
##  6 Калужская область     2010   274. 
##  7 Костромская область   2010  3000  
##  8 Курская область       2010    22.8
##  9 Липецкая область      2010   163. 
## 10 Московская область    2010   126. 
## # ... with 515 more rows
```

Теперь нам осталось присоединить данные по лесозаготовкам к таблице по лесовосстановлению, используя имя региона (`Region`) и год (`year`) в качестве ключевых полей. 

Для этого мы используем функцию `inner_join()`, поскольку нас интересует сравнение по тем годам, для которых имеются данные в обеих таблицах:

```r
(compare = reforest_tidy %>% 
  inner_join(timber_tidy, by = c("Region" = "Region", "year" = "year")))
## # A tibble: 511 x 4
##    Region                year value harvest
##    <chr>                <dbl> <dbl>   <dbl>
##  1 Белгородская область  2010   0.1    30.4
##  2 Брянская область      2010   2.8   614. 
##  3 Владимирская область  2010   5.3  1078  
##  4 Воронежская область   2010   1.1    73.6
##  5 Ивановская область    2010   1.6   130. 
##  6 Калужская область     2010   2.3   274. 
##  7 Костромская область   2010  25.2  3000  
##  8 Курская область       2010   0.3    22.8
##  9 Липецкая область      2010   0.4   163. 
## 10 Московская область    2010   2.7   126. 
## # ... with 501 more rows
```
Наконец, вычислим искомое отношние и упорядочим регионы по году (возрастание) и отношению (убывание):

```r
(compare = compare %>% 
   mutate(ratio = 1000 * value / harvest) %>% 
   select(Region, year, ratio, value, harvest) %>% 
   arrange(year, desc(ratio)))
## # A tibble: 511 x 5
##    Region                    year ratio value harvest
##    <chr>                    <dbl> <dbl> <dbl>   <dbl>
##  1 Ставропольский край       2010 182.    0.4     2.2
##  2 Ростовская область        2010 149.    1.5    10.1
##  3 Магаданская область       2010 118.    2.6    22  
##  4 Сахалинская область       2010  63.8  12.7   199. 
##  5 Республика Саха (Якутия)  2010  63.3  58     917. 
##  6 Республика Тыва           2010  61.8   4.4    71.2
##  7 Мурманская область        2010  52.2   3      57.5
##  8 Волгоградская область     2010  48.4   1.8    37.2
##  9 Камчатский  край          2010  38.9   5.2   134. 
## 10 Амурская область          2010  38.5  29.8   773. 
## # ... with 501 more rows
```
Из этой таблицы видно, что площадь восстанавливаемых лесов далеко не всегда пропорциональна объему заготовок необработанной древесины.

## Запись {#tables_write}

Запись файлов _в текстовом формате_ можно осуществить посредством функций из пакета __readr__, таких как `write_delim()`, `write_csv()` и `write_tsv()`. Базовый синтаксис их предельно прост:

```r
write_csv(compare, "output/timber_compare.csv")
```

Для записи таблиц _Microsoft Excel_ можно использовать возможности пакета [__writexl__](https://cran.r-project.org/web/packages/writexl/index.html):

```r
library(writexl)
write_xlsx(compare, "output/timber_compare.xlsx")
```

Каждая из этих функций содержит ряд дополнительных параметров, позволяющих управлять внешним видом выгружаемых таблиц. Более подробно с ними вы можете ознакомиться, вызвав справку для соответствующей функции.

## Правила подготовки таблиц для чтения в R {#tables_rules}

Несмотря на то, что каких-то четких правил подготовки таблиц для программной обработки не существует, можно дать несколько полезных рекомендаций по данному поводу:

1. В первой строке таблицы должны располагаться названия столбцов.
1. Во второй строке таблицы должны начинаться данные. Не допускайте многострочных заголовков.
1. В названиях столбцов недопустимы объединенные ячейки, покрывающие несколько столбцов. Это может привести к неверному подсчету количества столбцов и, как следствие, некорректному чтению таблицы в целом.
1. Названия столбцов должны состоять из латинских букв и цифр, начинаться с буквы и не содержать пробелов. Сложносочиненные названия выделяйте прописными буквами. Плохое название столбца: `Валовый внутренний продукт за 2015 г.`. Хорошее название столбца: `GDP2015`.
1. Некоторые ошибки данных в таблицах (такие как неверные десятичные разделители), проще найти и исправить в табличном/текстовом редакторе, нежели после загрузки в __R__.

Следование этим правилам значительно облегчит работу с табличными данными в среде __R__.

## Краткий обзор {#tables_review}

## Контрольные вопросы и упражнения {#tables_questions}

### Вопросы {#tables_questions_questions}

### Упражнения {#tables_questions_tasks}

----
_Самсонов Т.Е._ **Визуализация и анализ географических данных на языке R.** М.: Географический факультет МГУ, 2017. DOI: 10.5281/zenodo.901911
----
