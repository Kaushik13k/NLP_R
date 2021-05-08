#Stemming
install.packages("tm")
library(tm)
stem1 <- c("computational", "computers", "computation")
stemDocument(stem1) 


data("crude")
str(crude)
stemCompletion(c("compan", "entit", "suppl"), crude)

stem2 <- stemCompletion(c("comput"), crude)
stem2


# Remove punctuaton
text_data <-"But, Mister Speaker, I appreciate the constructive approach that you and other leaders took at the end of last year to pass a budget and make tax cuts permanent for working families. "

rm_punc <- removePunctuation(text_data)
rm_punc

# Create character vector: n_char_vec
n_char_vec <- unlist(strsplit(rm_punc, split = ' '))
n_char_vec


# Perform word stemming: stem_doc
stm_doc <- stemDocument(n_char_vec)
stm_doc


install.packages("corpus")
#The package comes with built-in support for the algorithmic stemmers provided by the Snowball Stemming Library, 
library(corpus)

text1 <- "communicate communicated communication communications communicator"
text_tokens(text1, stemmer = "en")

text2 <- "computational computers computation"
text_tokens(text2, stemmer = "en")

