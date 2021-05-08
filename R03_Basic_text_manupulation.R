# Basic text manipulation


# Paste: glue text and numeric values together
# Concatenation
paste("welcome", "!!!")


# With seperators
paste("welcome", "!!!", sep = "_")
paste("welcome", "!!!", sep = "")


# Combining Letters
x <- c("a", "b", "c")
paste(x,x)
paste(x,x, sep = "-")
paste(x,x, collapse = "++")
paste(x,x, sep = "_", collapse = "++")
paste(x,x, sep = "")


#SPC
paste(c('a', 'b', 'cd'), collapse = "|")
paste(c('a', 'b', 'cd'), collapse = "")
paste(c('a', 'b', 'cd'))
paste0('a', 'b', 'cd')# Shortcut for collapse = ""
paste0('x', 1:3)


# Length of char string
# Function nchar()
text1 <- "Welcome!"
nchar(text1, type = "chars")
text2 <- c("welcome", "to", "you", "all", "!")
nchar(text2, type = 'chars')


# Substring
text3 <- c("ABCDEFG")
substr(text3, start = 3, stop = 6)
text4 <- c("ABCD", "EFGH","IJKL","MNOP")
substr(text4, start = 2, stop = 3)


# Replacing segment of the string
substr(text3, start = 3, stop = 6) <- '@@@'
text3
substr(text3, start = 3, stop = 6)
substr(text4, start = 2, stop = 3)
substr(text4, start = 2, stop = 3) <- '##'
substr(text4, start = 2, stop = 3)
text4


# substring -- extract substring
text5 <- paste(LETTERS, collapse="")
text5

substring(text5, first = 1)
substring(text5, first = 2) # Excludes first letter
substring(text5, first = 5) # Exclused first 4 letters

text6 <- c("ABCD", "EFGHIJKLMNOPQR")
substring(text6, first = 2)


# Replace segment of string
substring(text5, first = 3, last = 6) <- "@@@"
text5


# Lowercasing
tolower("GOOD MORNING")
tolower(LETTERS)


# Uppercasing
toupper("good morning")
toupper(LETTERS)


# Replacing letters in the sring
text6 <- "cHaInED slavEs"
chartr(text6, old = "caE", new = ";@#")


# Letter "c" is replaced b :, letter "a" is preplaced by @, letter "E" is replaced t #


# Splitting the string
text8 <- c("I Like to play cricket and kabbadi.I do not lie to play ice hockey.")
strsplit(text8, split = " ", fixed = TRUE)
strsplit(text8, split = "'", fixed = TRUE)
strsplit(text8, split = "a", fixed = TRUE)
strsplit(text8, split = ".", fixed = TRUE)


unlist(strsplit(text8, split = " ", fixed = TRUE) )