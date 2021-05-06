# Dataset using tibble
col1 <- c(2, 3, 4, 1, 2, 3, 5, 6, 5, 4)
col2 <-c(1, 4, 2, 3, 5, 4, 6, 2, 5, 3)
person <- rep(c("john", "kim"), each = 5)
person

dataEX <- tibble(col1, col2, person)
dataEX
dataEX$col2[7] <- NA
dataEX$person[3] <- NA
dataEX



table0 <- read.table("C:/Users/13kau/Desktop/NLP(R)/table1.txt", header = TRUE)
str(table0)
table0
table0$col1


table0 <- tibble(table0)
table0




table1 <- read.table(file.choose(), header = TRUE) # choosing from the folder
str(table1)


# Seperator is a comma
table2 <-  read.table(file.choose(), header = TRUE, sep =",")
str(table2)
View(table2)


table3 <- read.csv(file.choose(), header = TRUE, sep=",", encoding = "UTF-8")
str(table3)
View(table3)



table3 <- read.csv(file.choose(), header = TRUE)
str(table3)
View(table3)


# Seperator semi-colon
table4 <- read.csv2(file.choose(), header = TRUE)
head(table4)
str(table4)
View(table4)


# import from web
budget2016 = read.csv2("http://dimension.usherbrooke.ca/voute/Budget2016.csv", header=TRUE, encoding="latin1", row.names=1)
head(budget2016)
str(budget2016)
View(budget2016)


budget2016$province
View(budget2016$province)



install.packages('readr', dependencies = TRUE, repos='http://cran.rstudio.com/')
library(readr)
my_data <- read_tsv("http://www.sthda.com/upload/boxplot_format.txt")
head(my_data)
my_data
View(my_data)


# Reading lines from a file
my_data <- read_lines("C:/Users/13kau/Desktop/NLP(R)/Health-News-Tweets.txt")
head(my_data)
View(my_data)

# na.strings a vector strings which are to be interpreted as NA values
table5 <- read.csv2("C:/Users/13kau/Desktop/NLP(R)/table4.csv",na.strings = "" , header =TRUE)
View(table4)
head(table4)


#install.packages("jsonlite")
library(jsonlite)
table_jason <- fromJSON(file.choose())
str(table_jason)
table_jason
View(table_jason)



# DATABASE

#install.packages("foreign")
library(foreign)
dbf <- read.dbf("C:/Users/13kau/Desktop/NLP(R)/POS001.dbf")
str(dbf)
dbf
View(dbf)


#install.packages("RSQLite")
#install.packages("DBI")

library(RSQLite)
library(DBI)
datasetsDb()
db <- datasetsDb()
class(db)
dbListTables(db)
head(dbReadTable(db,'mtcars'))

# Load the mtcars as an R data frame put the row names as a column, and print the header
data("mtcars")
str(mtcars)
View(mtcars)

rownames(mtcars)
 # insert rownames into car_names
mtcars$car_names <- rownames(mtcars)
#remove rownames
rownames(mtcars) <- c()
head(mtcars)
View(mtcars)



library(tibble)
# Create toy data frames
car <- c('Camaro', 'California', 'Mustang', 'Explorer')
make <- c('Chevrolet','Ferrari','Ford','Ford')
df1 <- tibble(car,make)
View(df1)

car <- c('Corolla', 'Lancer', 'Sportage', 'XE')
make <- c('Toyota','Mitsubishi','Kia','Jaguar')
df2 <- tibble(car,make)
View(df2)