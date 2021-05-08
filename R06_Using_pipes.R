#Pipes in R 


library(magrittr)

#We read from right to left

# f(x) can be rewritten as x %>% f
x <- c(0.109, 0.359, 0.63, 0.996, 0.515, 0.142, 0.017, 0.829, 0.907)

# Compute the logarithm of `x` 
log(x)

# compure using pipe
x %>% log

# sin(pi) in pipe
x %>% sin

# cos(sin(x))
x %>% sin %>% cos


# f(x, y) is written as x%>% f(y)
# Round pi
round(pi, 6)

# in pipe
pi %>% round(6)


# Import `babynames` data
install.packages("babynames")
library(babynames)
# Import `dplyr` library
library(dplyr)

# Load the data
data(babynames)
View(babynames)


# Count how many young boys with the name "Taylor" are born

sum(select(filter(babynames, sex == "M", name == "Taylor"),n))


# With pipe
babynames %>% filter(sex == "M", name == "Taylor") %>% select(n) %>% sum


library("tidyverse")
gapminder <- read.csv("C:/Users/13kau/Desktop/NLP(R)/gapminder-FiveYearData.csv")
gapminder
View(gapminder)


gapminder_Asia <- filter(gapminder, continent=="Asia") 
View(gapminder_Asia)

gapminder_Africa <- filter(gapminder, continent=="Africa") 
View(gapminder_Africa)




gapminder_scandinavia <- gapminder %>% 
  filter(country %in% c("Denmark",
                        "Norway",
                        "Sweden"))

View(gapminder_scandinavia)
