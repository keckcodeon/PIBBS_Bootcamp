install.packages(c('ggplot2', 'gapminder'))
install.packages('ggrepel')
install.packages(c('gganimate', 'gifski', 'png'))
library(tidyverse)
library(ggplot2)
library(gapminder)
library(ggrepel)
library(gganimate)
library(gifski)

# First, let's look at the dataset we're going to work with
View(iris)

# Generate a histogram of Sepal.Length
hist(iris$Sepal.Length)
hist(iris$Sepal.Length, breaks = 25)

# Take a step forward, we can generate a more beautiful plot with density plot
d = density(iris$Sepal.Length)
plot(d)
plot(d, xlab = 'Sepal.Length', main = 'Density Plot of iris Spepal.Length')

# Then, can we separate the density plot based on the species?
d_setosa = density(iris$Sepal.Length[iris$Species == 'setosa'])
d_versicolor = density(iris$Sepal.Length[iris$Species == 'versicolor'])
d_virginica = density(iris$Sepal.Length[iris$Species == 'virginica'])

plot(d_setosa)
lines(d_versicolor)
lines(d_virginica)

# iris Sepal.Length density plot by Species Trial #2
plot(d_setosa, xlim = c(min(iris$Sepal.Length), max(iris$Sepal.Length)), col = 'green')
lines(d_versicolor, col = 'red')
lines(d_virginica, col = 'blue')

# Final polish
plot(d_setosa, xlim = c(min(iris$Sepal.Length), max(iris$Sepal.Length)), col = 'green',
     main = 'Sepal.Length', xlab = 'cm')
lines(d_versicolor, col = 'red')
lines(d_virginica, col = 'blue')
legend(7, 1.2, legend = c('setosa', 'versicolor', 'virginica'), col = c('green', 'red', 'blue'),
       lty = 1, cex = 0.8, title = 'Species')

# Boxplot
boxplot(iris$Sepal.Length)
boxplot(Sepal.Length ~ Species, iris)

# Scatter plot
plot(x = iris$Sepal.Length, y = iris$Petal.Length)

# The same logic if we're interested in separate different species
plot(x = iris$Sepal.Length[iris$Species == 'setosa'],
     y = iris$Petal.Length[iris$Species == 'setosa'],
     xlim = c(min(iris$Sepal.Length), max(iris$Sepal.Length)),
     ylim = c(min(iris$Petal.Length), max(iris$Petal.Length)),
     col = 'green', xlab = 'Sepal.Length', ylab = 'Petal.Length', main = 'Sepal vs Petal Length')

points(x = iris$Sepal.Length[iris$Species == 'versicolor'],
     y = iris$Petal.Length[iris$Species == 'versicolor'],
     col = 'red')

points(x = iris$Sepal.Length[iris$Species == 'virginica'],
       y = iris$Petal.Length[iris$Species == 'virginica'],
       col = 'blue')

legend('topleft', legend = c('setosa', 'versicolor', 'virginica'), col = c('green', 'red', 'blue'),
       pch = 1, cex = 0.8, title = 'Species')


#####
# Work with ggplot2
# Easier and improved visualization methods
ggplot(iris, aes(x = Sepal.Length)) + geom_histogram()
ggplot(iris, aes(x = Sepal.Length, fill = Species)) + geom_histogram(alpha = 0.7, position = 'identity')
ggplot(iris, aes(x = Sepal.Length, fill = Species)) + geom_histogram(alpha = 0.7, position = 'identity') +
  facet_wrap(~ Species)

ggplot(iris, aes(x = Sepal.Length)) + geom_density()
ggplot(iris, aes(x = Sepal.Length, col = Species)) + geom_density()
ggplot(iris, aes(x = Sepal.Length, col = Species)) + geom_density() + facet_wrap(~ Species)

ggplot(iris, aes(x = Species, y = Sepal.Length)) + geom_boxplot()

ggplot(iris, aes(x = Sepal.Length, y = Petal.Length)) + geom_point()
ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, col = Species)) + geom_point()

# Let's work with a more comlex graph
# Load the dataset gapminder
View(gapminder)

ggplot(gapminder %>% filter(year == 2007), aes(x = gdpPercap, y = lifeExp)) + geom_point()

ggplot(gapminder %>% filter(year == 2007), aes(x = gdpPercap, y = lifeExp, col = continent, size = pop)) + geom_point()

ggplot(gapminder %>% filter(year == 2007), aes(x = gdpPercap, y = lifeExp, col = continent, size = pop, label = country)) +
  geom_point(alpha = 0.7) + 
  scale_size(range = c(0, 10)) +
  scale_x_log10() +
  geom_text_repel(data = gapminder %>% filter(year == 2007 & pop >= 10^8), 
                  aes(x = gdpPercap, y = lifeExp, label = country),  
                  col = 'black', size = 3, segment.color = 'black') +
  ggtitle('gapminder')

# Make it into animation
p = ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, col = continent, size = pop, label = country)) +
  geom_point(alpha = 0.7) + 
  scale_size(range = c(0, 10)) +
  scale_x_log10() +
  labs(title = '{frame_time}') +
  transition_time(year)

anim_save('gapminder.gif', animation = p, path = getwd())

#####
microarray = read.table('~/Downloads/microarray.txt', sep = '\t', header = T)

m.matrix = as.matrix(microarray[, -c(1:3)])
row.names(m.matrix) = row.names(microarray)
pc.micro = prcomp(m.matrix, retx = T, center = T, scale. = T)
