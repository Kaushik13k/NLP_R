# Stopwords

install.packages("stopwords")
library(stopwords)
stopwords()

# List all sources
stopwords::stopwords_getsources()

# list languages for a specific source for snowball lexicon
stopwords::stopwords_getlanguages("snowball")


library(tokenizers)
tokenize_words(" The black deer runs away in the forest! It is a wild animal", stopwords = stopwords::stopwords("en"))



#quanteda
library(quanteda)
toks <- tokens("The judge will sentence Mr. Adams to nine years in prison", remove_punct = TRUE)
toks
tokens_remove(toks, c(stopwords("english"), "will", "mr", "nine"))
