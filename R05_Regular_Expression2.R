#Replacing Regex Matches in String Vectors

data1 <- read.csv("C:/Users/13kau/Desktop/NLP(R)/gapminder-FiveYearData.csv")


#If we want to search country names with an apostrophe
grep("\'", levels(data1$country))
grep("\'", levels(data1$country), value = TRUE)


#update data or use another dataset and repeat above commands

#There are other characters in R that require escaping, and this rule applies to all string 
#functions in R, including regular expressions:

# \': single quote. You don't need to escape single quote inside a double-quoted string, 
#so we can also use "'" in the previous example.
# \": double quote. Similarly, double quotes can be used inside a single-quoted string, i.e. '"'.
# \n: newline.
# \r: carriage return.
# \t: tab character.


##QUANTIFIERS
#Quantifiers specify how many repetitions of the pattern.

# *: matches at least 0 times.
# +: matches at least 1 times.
# ?: matches at most 1 times.
# {n}: matches exactly n times.
# {n,}: matches at least n times.
# {n,m}: matches between n and m times.


strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")
strings
strings[5]
strings[-1]
length(strings)



grep("ab", strings, value = TRUE)
grep("abc", strings, value = TRUE)
grep("ac*b", strings)
grep("ac*b", strings, value = FALSE)
grep("a*b", strings, value = TRUE)
grep("a*cb", strings, value = TRUE)
grep("ca*b", strings, value = TRUE)
grep("a*bc", strings, value = TRUE)


grep("ac?b", strings)
grep("ac?b", strings, value = FALSE)
grep("a?b", strings, value = TRUE)
grep("a?cb", strings, value = TRUE)
grep("ca?b", strings, value = TRUE)
grep("a?bc", strings, value = TRUE)


grep("ac+b", strings)
grep("ac+b", strings, value = FALSE)
grep("a+b", strings, value = TRUE)
grep("a+cb", strings, value = TRUE)
grep("ca+b", strings, value = TRUE)
grep("a+bc", strings, value = TRUE)



grep("ac{2}b", strings, value = TRUE)
grep("ac{2,}b", strings, value = TRUE)
grep("ac{2,3}b", strings, value = TRUE)
stringr::str_extract_all(strings, "ac{2,3}b", simplify = TRUE)

grep("zim", gapminderData$country, value = TRUE)
grep("Zim", gapminderData$country, value = TRUE)

# Position of pattern within the string
# ^: matches the start of the string.
# $: matches the end of the string.
# \b: matches the empty string at either edge of a word. Don’t confuse it with ^ $ which marks the edge of a string.
# \B: matches the empty string provided it is not at an edge of a word.
# For the last example, \b is not a recognized escape character, so we need to double slash it \\b.

strings <- c("abcd", "cdab", "cabd", "c abd")
strings
grep("ab", strings, value = TRUE)
grep("^ab", strings, value = TRUE)
grep("ab$", strings, value = TRUE)
grep("\\bab", strings, value = TRUE)
