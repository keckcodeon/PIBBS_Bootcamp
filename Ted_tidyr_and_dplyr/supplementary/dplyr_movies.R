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
v = c(1, 2, 3, 4, 5); class(v)
w = 1:8; class(w)
w = seq(1, 8); class(w)
w = seq(1, 8, by = 0.5); class(w)

## matrix
m = matrix(1:16, nrow = 4, ncol = 4); m
m = matrix(1:16, nrow = 4, ncol = 4, byrow = TRUE); m
m = matrix(1:16, nrow = 2); m

## dataframe
class(iris)
View(iris)
View(mtcars)

# Slice a data.frame
iris[c(1, 2, 3), c(3, 4, 5)]
iris[1:3, 3:5]
iris[, c(3, 4, 5)]
iris[, c(F, F, T, T, T)]

## variable extract
iris$Species

iris$Species == "virginica"
table(iris$Species == "virginica")

iris[iris$Species == "virginica", ]

## Exercise!! 
View(mtcars)

# Data import
getwd()

## you can also use the "Session -> Set Working Directory" to set 
setwd("~/Documents/Code on/R")
getwd()
list.files() # list all the files in working directory

## Import IMDB score talbe into variable called "movie"
movie = read.csv("movies.csv")
movie2 = read.table("movies.txt", header = T, sep = "\t")

## with the help of proper packages
install.packages("readxl")
library(readxl)
movie3 = read_excel("movies.xlsx", sheet = 3)

## let's play with the data.frame
## generate a count table of the language
table(movie3$Language)

## extract the movies of Language English from movie3
English.movie = movie3[movie3$Language == "English", ]

## extract the movies in 2010 from English.movie
English.2010.movie = English.movie[English.movie$Year == 2010, ]

## order these movies by IMDB score
## use order function
order(English.2010.movie$`IMDB Score`)
ordered.English.2010.movie = English.2010.movie[order(English.2010.movie$`IMDB Score`),]

ordered.English.2010.movie = English.2010.movie[order(English.2010.movie$`IMDB Score`, decreasing = T),]

# use grepl function to return a logical vector indicating whether the character contains specific pattern
my.comedy = ordered.English.2010.movie[grepl("Comedy", ordered.English.2010.movie$Genres), ]
my.R.comedy = my.comedy[my.comedy$`Content Rating` == "R", ]


## dplyr
install.packages("dplyr")
library(dplyr)

install.packages("stringr")
library(stringr)

dp.movie = movie3 %>% filter(Language == "English")
dp.movie = movie3 %>% 
  filter(Language == "English") %>% 
  filter(Year == 2010) %>% 
  arrange(desc(`IMDB Score`)) %>% 
  filter(str_detect(Genres, "Comedy")) %>% 
  filter(`Content Rating` == "R")

# calculate earning per IMDB
dp.movie = dp.movie %>% 
  mutate("Earning per IMDB" = `Gross Earnings`/`IMDB Score`) %>% 
  arrange(desc(`Earning per IMDB`))
