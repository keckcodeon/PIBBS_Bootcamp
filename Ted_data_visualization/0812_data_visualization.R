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
hist(___$___)
hist(___$___, breaks = 25)

# Take a step forward, we can generate a more beautiful plot with density plot
d = density(___$___)
plot(d)
plot(d, ___ = 'Sepal.Length', ___ = 'Density Plot of iris Spepal.Length')

# Then, can we separate the density plot based on the species?
## First, separate the data and generate corresponding density object
d_setosa = density(iris$Sepal.Length[___ == ___])
d_versicolor = density(iris$Sepal.Length[___ == ___])
d_virginica = density(iris$Sepal.Length[___ == ___])
## Second, define the frame by making a plot
plot(___)
## Third, add the other two density data by function: line
lines(___)
lines(___)

# Trial #2: fix the range of x-axis with argument xlim
plot(d_setosa, xlim = c(min(iris$Sepal.Length), max(iris$Sepal.Length)), col = ___)
lines(d_versicolor, col = ___)
lines(d_virginica, col = ___)

# Final polish with argument xlab (x-axis label) and main (title)
plot(d_setosa, xlim = c(min(iris$Sepal.Length), max(iris$Sepal.Length)), col = 'green',
     ___ = 'Sepal.Length', ___ = 'cm')
lines(d_versicolor, col = 'red')
lines(d_virginica, col = 'blue')
## Add a legend with function legend
legend(7, 1.2, legend = c('setosa', 'versicolor', 'virginica'), col = c('green', 'red', 'blue'),
       lty = 1, cex = 0.8, title = 'Species')

# Boxplot
boxplot(iris$Sepal.Length)

## This also works: boxplot(y ~ x, data)
boxplot(___ ~ ___, iris)

# Scatter plot: plot(x, y)
## Plot a Petal.Length to Sepal.Length graph
plot(x = iris$___, y = iris$___)

# The same logic if we're interested in separate different species
## ylim is just the y-axis limitation as xlim
## ylab: y-axis label
plot(x = iris$Sepal.Length[iris$___ == 'setosa'],
     y = iris$Petal.Length[iris$___ == 'setosa'],
     xlim = c(min(iris$Sepal.Length), max(iris$Sepal.Length)),
     ylim = c(min(iris$Petal.Length), max(iris$Petal.Length)),
     col = 'green', xlab = 'Sepal.Length', ylab = 'Petal.Length', main = 'Sepal vs Petal Length')
## Instead of using function `line, here we use function `points` to add point
points(x = iris$Sepal.Length[iris$Species == 'versicolor'],
     y = iris$Petal.Length[iris$Species == 'versicolor'],
     col = 'red')
points(x = iris$Sepal.Length[iris$Species == 'virginica'],
       y = iris$Petal.Length[iris$Species == 'virginica'],
       col = 'blue')
## Add legend
legend('topleft', legend = c('setosa', 'versicolor', 'virginica'), col = c('green', 'red', 'blue'),
       pch = 1, cex = 0.8, title = 'Species')


#####
# Work with ggplot2
# Easier and improved visualization methods (at least for me)
# Let's start with histogram
## Generate a graph with data = iris, x-axis mapping to Sepal.Length, and visualize using geom_histogram
ggplot(___, aes(___ = ___)) + ___()
## Take a step further, use fill color (argument fill) to represent the variable Species
## Polish the histogram with transparency (alpha) and adjust the position to avoid data stacking
ggplot(iris, aes(x = Sepal.Length, ___ = ___)) + geom_histogram(alpha = 0.7, position = 'identity')
## Facet layer, a powerful layer of ggplot2. Give it a try.
ggplot(iris, aes(x = Sepal.Length, fill = Species)) + geom_histogram(alpha = 0.7, position = 'identity') +
  facet_wrap(~ Species)

# The same logic also works for density plot
ggplot(___, aes(x = ___)) + ___()
## Insteal of using fill color (fill), use line color (col) to represent the variable Species
ggplot(iris, aes(x = Sepal.Length, col = ___)) + geom_density()
## Facet by Species
ggplot(iris, aes(x = Sepal.Length, col = Species)) + geom_density() + facet_wrap(~ Species)

# Boxplot for y corresponding to Sepal.Length and x to Species
ggplot(iris, aes(x = ___, y = ___)) + ___()

# Scatter plot for y corresponding to Petal.Length and x to Sepal.Length
ggplot(iris, aes(x = ___, y = ___)) + ___()
## Same logic for mapping point col by argument col in aesthetics layer
ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, col = ___)) + geom_point()

# Let's work with a more comlex graph
## View the dataset gapminder
View(gapminder)

## Focus on the data of year 2007 only, we can use filter and pipe to filter out observations that's not in 2007
## Then generate a scatter plot of life expectency (lifeExp) ~ gdp per capita (gdpPercap)
ggplot(gapminder %>% filter(___ == 2007), aes(___)) + ___()
## Make the graph carry more information, with x-axis, y-axis, color, point size corresponding to gdpPercap, lifeExp, continent, and population
ggplot(gapminder %>% filter(year == 2007), aes(___)) + geom_point()
## Polish the graph by increasing the transparency, encrease the point size scale, log-transform x-axis, and etc.
ggplot(gapminder %>% filter(year == 2007), aes(x = gdpPercap, y = lifeExp, col = continent, size = pop, label = country)) +
  geom_point(alpha = 0.7) + 
  scale_size(range = c(0, 10)) +
  scale_x_log10() +
  ggtitle('gapminder') +
  geom_text_repel(data = gapminder %>% filter(year == 2007 & pop >= 10^8), 
                  aes(x = gdpPercap, y = lifeExp, label = country),  
                  col = 'black', size = 3, segment.color = 'black')
  

# Make it into animation
p = ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, col = continent, size = pop)) +
  geom_point(alpha = 0.7) + 
  scale_size(range = c(0, 10)) +
  scale_x_log10() +
  labs(title = '{frame_time}') +
  transition_time(year)

anim_save('gapminder.gif', animation = p, path = getwd())
