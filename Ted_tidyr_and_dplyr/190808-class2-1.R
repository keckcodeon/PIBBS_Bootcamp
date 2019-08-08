#####
# Review session
## numeric variables
1
2.5
pi
exp(1)
class(exp(1))
a = exp(5)
class(a)

## character (string) variables
"I'm a string"
b = "b is a string"
class(b)

## logical (Boolean) variables
TRUE
FALSE
class(TRUE)
1 > 2
class(1 > 2)

## vector
v = c(1, 2, 3, 4, 5)
v
class(v)
w = 1:8
w
class(w)

## list
a = pi
b = 'a equals to pi'
c = T
l = list(a, b, c)
l
class(l)
### What will happen if we use vector?
v = c(a, b, c)
v

## matrix
1:16
m = matrix(1:16, nrow = 4, ncol = 4); m
m = matrix(1:16, nrow = 4, ncol = 4, byrow = TRUE); m
m = matrix(1:16, nrow = 2); m

## dataframe
iris
class(iris)
View(iris)
View(mtcars)

# Slice a data.frame
iris[c(1, 2, 3), c(3, 4, 5)]
iris[___, ___]
iris[, c(4, 3, 5)]
iris[, c(F, F, T, T, T)]

## variable extract
iris$___

iris$___ == "virginica"
table(iris$Species == "virginica")

iris[___ == ___, ]

## Exercise!! 
View(mtcars)

##### 
# Data import
install.packages('tidyverse')
install.packages('readxl')
library(tidyverse)
library(readxl)

getwd()

## you can also use the "Session -> Set Working Directory" to set 
setwd("___")
getwd()
list.files() # list all the files in working directory

## Import IMDB score talbe into variable called "movie"
movie = ___(___)
movie2 = ___(___, header = T, sep = ___)

## with the help of proper packages
movie3 = ___(___, ___ = 3)

# Movie data.frame
movie.all = c()
for(i in 1:3){movie.all = rbind(movie.all, read_excel('movies.xlsx', sheet = i))}
colnames(movie.all) = movie.all %>% colnames() %>% str_replace_all(' - ', '_') %>% str_replace_all(' ', '_')
View(movie.all)

## extract the movies of Language English from movie3
English.movie = movie.all[movie.all$Language == "English", ]

## extract the movies in 2010 from English.movie
English.2010.movie = English.movie[English.movie$Year == 2010, ]

## order these movies by IMDB score
## use order function
order(English.2010.movie$IMDB_Score)
ordered.English.2010.movie = English.2010.movie[order(English.2010.movie$IMDB_Score),]
ordered.English.2010.movie = English.2010.movie[order(English.2010.movie$IMDB_Score, decreasing = T),]

# use grepl function to return a logical vector indicating whether the character contains specific pattern
my.comedy = ordered.English.2010.movie[grepl("Comedy", ordered.English.2010.movie$Genres), ]
my.R.comedy = my.comedy[my.comedy$Content_Rating == "R", ]

## dplyr
dp.movie = movie.all %>% ___(___ == "English")
dp.movie = movie.all %>% 
  filter(___ == "English") %>% 
  filter(___ >= ___) %>% 
  arrange(desc(___)) %>% 
  filter(str_detect(Genres, "Comedy")) %>% 
  filter(Content_Rating == ___)

## calculate Total Facebook_Like
dp.movie = dp.movie %>% 

View(dp.movie)  

# Case Study: Is ??? a box office poison?
Test.movie = movie.all %>% filter(___) %>% 
  filter(Actor_1 == '___' | Actor_2 == '___' | Actor_3 == '___') %>% 
  filter(!duplicated(Title))

## For control, generate a random sampled data.frame
Ctrl.movie = movie.all %>% filter(___) %>%  sample_n(___)

## Put these two data.frame together and do a summarise
Test.movie$group = 'Test'; Ctrl.movie$group = 'Ctrl'
Compared.movie = rbind(Test.movie, Ctrl.movie)
Compared.movie %>% group_by(group) %>% 
  summarise(avg_IMDB = mean(IMDB_Score),
            sd_IMDB = sd(IMDB_Score),
            avg_gross_earning = mean(Gross_Earnings, na.rm = T),
            sd_gross_earning = sd(Gross_Earnings, na.rm = T))
