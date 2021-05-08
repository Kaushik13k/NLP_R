#Regular Expressions / REGEX

#search pattern for a string. 
#Regular expression - a sequence of symbols and characters expressing a string or pattern to 
#be searched for within a longer piece of text.


install.packages("stringr")
library(stringr)

data1 <- read.csv("C:/Users/13kau/Desktop/NLP(R)/gapminder-FiveYearData.csv")
str(data1)
head(data1)
View(data1)

##ESCAPE SEQUENCES
nameic <- "Cote d'Ivore"
nameic

#we need to use the "escape" character \'

nameic <- "Cote d\'Ivore"
nameic


#The grep function takes your regex as the first argument, and 
#the input vector as the second argument. 
# + Matching the preceding

grep("a+", c("abc", "def", "ghi a", "jka"), value = FALSE)
grep("a+", c("abc", "def", "ghi a", "jka"), value = TRUE)


#grepl returns a logical vector with the same length as the input vector. 
grepl("a+", c("abc", "def", "addd", "fgfa"))

string = c("r is the shiny", "r is the shiny1", "r shines brightly")
grepl(string, pattern='^r.*shiny[0-9]$')


# ^: starts with, so ^r means starts with r
# . : any character
# * : match the preceding zero or more times
# shiny : match shiny
# [0-9] : any digit 0-9 (note that we are still talking about strings, not actual numbered values)
# $ : ends with preceding

#Common ones

# [a-z] : Letters a-z
# [A-Z] : capital letters
# + : match the preceding one or more times
# () : groupings
# | : logical or e.g. [a-z]|[0-9] (a lower-case letter or a number)
# ? : preceding item is optional, and will be matched at most once. Typically used for ‘look ahead’ and ‘look behind’
# \ : escape a character, like if you actually wanted to search for a period instead of using it as a regex pattern, you’d use \., 
#  though in R you need \\, i.e. double slashes, for escape.

#In R there are certain predefined characters that can be called:
# [:punct:] : punctuation
# [:blank:] : spaces and tabs
# [:alnum:] : alphanumeric characters


grepl(c("apple", "banana", "mango"), pattern = "a") # Has "a" in it
grepl(c("apple", "banana", "mango"), pattern = "^a") # Starts with "a"
grepl(c("apple", "banana", "mango"), pattern = "^a|a$") # Starts with "a" or ends with "a"


#The regexpr function takes the same arguments as grepl. 
#regexpr returns an integer vector with the same length as the input vector. 
#gregexpr is the same as regexpr, except that it finds all matches in each string. 
#It returns a vector with the same length as the input vector.

regexpr("a+", c("abc", "fff", "asdf a", "aa"))
gregexpr("a+", c("abc", "fff", "asdf a", "aa"))

####
x <- c("abc", "fff", "asdf a", "aa")
m <- regexpr("a+", x)
m
regmatches(x, m)

####
x <- c("abc", "fff", "asdf a", "aa")
m <- gregexpr("a+", x)
m
regmatches(x, m)