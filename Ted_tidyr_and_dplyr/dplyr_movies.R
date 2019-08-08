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

##### 
# Data import
install.packages('tidyverse')
install.packages('readxl')
library(tidyverse)
library(readxl)

getwd()

## you can also use the "Session -> Set Working Directory" to set 
setwd("~/Documents/Code on/R")
getwd()
list.files() # list all the files in working directory

## Import IMDB score talbe into variable called "movie"
movie = read.csv("movies.csv")
movie2 = read.table("movies.txt", header = T, sep = "\t")

## with the help of proper packages
movie3 = read_excel("movies.xlsx", sheet = 3)

## We can also import a whole excel file and store it 'excel-like' as a list
excel_sheets('movies.xlsx')
movie.list = list()
for(i in 1:3){movie.list[[i]] = read_excel('movies.xlsx', sheet = i)}

## Stack all the sheets together through function rbind and for loop
movie.all = c()
for(i in 1:3){movie.all = rbind(movie.all, read_excel('movies.xlsx', sheet = i))}

## Make the column name tidy
colnames(movie.all) = movie.all %>% colnames() %>% str_replace_all(' - ', '_') %>% str_replace_all(' ', '_')

## let's play with the data.frame
## generate a count table of the language
table(movie.all$Language)

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
dp.movie = movie.all %>% filter(Language == "English")
dp.movie = movie.all %>% 
  filter(Language == "English") %>% 
  filter(Year >= 2010) %>% 
  arrange(desc(IMDB_Score)) %>% 
  filter(str_detect(Genres, "Comedy")) %>% 
  filter(Content_Rating == "R")

## calculate Total Facebook_Like
dp.movie = dp.movie %>% 
  mutate("Total_FaceBook_like" = dp.movie %>%  select(starts_with('Facebook')) %>% rowSums(na.rm = T)) %>% 
  arrange(desc(Total_FaceBook_like))

# Case Study: Is ??? a box office poison?
Test.movie = movie.all %>% filter(Language == 'English') %>% 
  filter(Actor_1 == 'Ryan Reynolds' | Actor_2 == 'Ryan Reynolds' | Actor_3 == 'Ryan Reynolds') %>% 
  filter(!duplicated(Title))

## For control, generate a random sampled data.frame
Ctrl.movie = movie.all %>% filter(Language == 'English' & Year >= 1990) %>%  sample_n(36)

## Put these two data.frame together and do a summarise
Test.movie$group = 'Test'; Ctrl.movie$group = 'Ctrl'
Compared.movie = rbind(Test.movie, Ctrl.movie)
Compared.movie %>% group_by(group) %>% 
  summarise(avg_IMDB = mean(IMDB_Score),
            sd_IMDB = sd(IMDB_Score),
            avg_gross_earning = mean(Gross_Earnings, na.rm = T),
            sd_gross_earning = sd(Gross_Earnings, na.rm = T))
