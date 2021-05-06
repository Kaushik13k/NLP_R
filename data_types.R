#### Data types


# Numeric
#Decimal values are always called numerics in R. It is the default computational data type

x <- 25.5

#print the value of x
x

# or
print(x)

#print type of x
class(x)

# if an integer value is assigned to a variable it will have class Numeric
p <- 5

class(p)

# p is not interpreted as an numeric
is.integer(p)


## Integer 

l <- as.integer(3.14)
l

m <- as.integer("5.77")
m

n <- as.integer("joe")  # Not valid
n

x <- 5L # 'L' is the syntax for the integer
x

h <- as.integer(TRUE) #sTORES THE VALUE AS 1
h

i <- as.integer(FALSE) # Stores the value as 0
i

k <- 1:5
k

class(k)

l <- as.numeric(k)
class(l)
print(l)



### CHARACTER
h <- 'text mining'
h
class(h)

##Logical
false <- FALSE
class(false)
true <- TRUE
true

##COMPLEX
z <- 1i + 2
class(z)

y <- 5i
class(y)

c <- as.complex(4)
c



#### DATA STRUCTURES ####
vector() #An empty list of vector
vector("character", length = 10) # A vector of mode 'character' with 10 elements

character(10) # same thing but using the constructer directly 
n <- numeric(5)
n

d <- double(5)
d

l <- logical(5)
l


# We can create vectors by directly specifying their content
# function c() for combine
s <- c(1, 2, 3, 4, 5)
s 
s[1]
s[2]

flag <- c(TRUE, FALSE, TRUE, FALSE)
flag
flag[1]



# Quoted text
# Join elements into a vector

ss<- c("john", "tracy", "kaushik")
ss
ss[3]
length(ss)
str(ss)

ss <- c(ss, "Janme")
ss



# vector from a sequence of numbers
# An integer sequence 
series <- 1:5
series

se <- seq(3)
se

ls <- seq(from = 1 , to = 10 , by = 2)
ls

####  OBJECTS ATTRIBUTES
length(1:10)
nchar("DAta svience")


# Objects can have attributes. Attribute are a part of the objects. These inclues:

# Names
# Dimnames
# DIm 
# Class


# Tibble 
# Tibbles are a modern data type of data frames.

# Installing 
install.packages("tibble")
# Loading
library("tibble")

# Create a dataframe from list of values
friends_data <- data_frame(
  name = c("nicolas", "john", "aushi"),
  age = c(27,88, 21),
  height = c(180, 170, 175),
  married = c(TRUE, FALSE , FALSE)
)

# Print 
friends_data
view(friends_data)


# Loading data

data("iris")

#Class of iris
class(iris)


# Print first 6 rows of iris
head(iris, 6)

# Tibble provides as_tibble() to convert objects into tibbles
# as_tibbles() has been written with an eye for performance
my_data <- as_tibble(iris)
class(my_data)
my_data


# ADVANTAGES OF TIBBLES COMPARES TO DATAFRAMES
# Tibbles has nice printing method that show only the 1st 10 columns and all th columns that fit on the screen
# This is useful when you work with large data set

# When printed, the data type of each column is specified (see below)
#: for double
#: for character
#: for factor
#: for logical

# The function tibble() is a nice way to create data frames
tibble(x = letters)

tibble(x = 1:3, y = list(1:5, 1:10, 1:20))


l <- replicate(26, sample(100), simplify = FALSE)
names(l) <- letters
names(l)

# Function Explained

my_sum <- function(x, y) {
  sumn <- x + y
  return(sumn)
}

my_sum(2, 4)
my_sum(10, 20)






