####words and sentences

# for reading in and working with text data sets
install.packages("tidyverse")
library(tidyverse)

# to split text data into words and sentences.
install.packages("tokenizers")
library(tokenizers)

textData <- paste("My purpose in writing this article about my weaknesses in data science is threefold. First, I genuinely care about getting better so I need to admit my weak points. By outlining my deficiencies and how I can address them, my objective is to keep myself motivated to follow through on my learning goals.
Second, I hope to encourage others to think about what skills they might not know and how they can work on acquiring them. You don't have to write your own article disclosing what you don't know, but taking a few moments to consider the question can pay off if you find a skill to work on.
Finally, I want to show you don't need to know everything to be a successful data scientist. There are an almost unlimited number of data science/ machine learning topics, but a limited amount you can actually know. Despite what unrealistic job applications proclaim, you don't need complete knowledge of every algorithm (or 5 to 10 years of experience) to be a practicing data scientist. Often, I hear from beginners who are overwhelmed by the number of topics they think they must learn and my advice is always the same: start with the basics and understand you don't need to know it all!
")

#The character tokenizer splits texts into individual characters.
tokenize_characters(textData)[[1]]


# Word stemming
install.packages("SnowallC")
library(SnowballC)
tokenize_word_stems(textData)


#split text into individual words
wordss = tokenize_words(textData)
wordss


#length of document
length(wordss)
length(wordss[[1]])


#split text into sentences
sent <- tokenize_sentences(textData)
sent

length(sent[[1]])


sentence_words <- tokenize_words(sent[[1]])
sentence_words


sentence_words_8 <- tokenize_words(sent[[1]][8])
sentence_words_8


#Length of each sentence
length(sentence_words[[1]])
length(sentence_words[[2]])
length(sentence_words[[5]])
length(sentence_words[[8]])


#calculate the length of every sentence in the paragraph with one line of code
sapply(sentence_words, length)