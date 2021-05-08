#Tokenization

#Tokenization is an important step for text analytics

install.packages("tokenizers")
install.packages("stopwords")

library(tokenizers)
library(stopwords)


text1 <- paste0(
  "Bianca Andreescu, age 19, was born as Bianca Vanessa Andreescu on 16 June 2000 in Mississauga, Canada. \n",
  "She is the daughter of her Romanian parents, Maria Andreescu and Nicu Andreescu.\n", 
  "Maria had to move to Canada after completing her graduation in Romania for the \n",
  "purpose of serving as a chief financial officer of Global Maxfin Investments Inc. \n",
  "in Toronto. Fortunately, her husband also landed the job in Canada after his graduation.\n",
  "Largely focused for her recent debut Singles championship at Indian Wells Open aka \n",
  "BNP Paribas Open on 18 March 2019, Bianca Andreescu marched into the tennis court at \n",
  "a very early age. Her professional significance came in 2016 when she claimed the top \n",
  "seed in both girls' singles and doubles at the Australian Open. She had to sadly \n",
  "withdraw from the competition after foot injury which kept her from tennis for six months.\n",
  "\n",
  "Bianca came back stronger in 2017 bagging the 2017 Australian Open and French Open junior\n", 
  "doubles titles with Carson Branstine. While her 2019 started on a high note with the victory \n",
  "over first seed Caroline Wozniacki and sixth seed Venus Williams at the ASB Classic.\n")


#The character tokenizer splits texts into individual characters.
tokenize_characters(text1)[[1]]


#The word tokenizer splits texts into words.
tokenize_words(text1)

#You can also provide a vector of stopwords which will be omitted.
tokenize_words(text1, stopwords = stopwords::stopwords('en'))



#An alternative word stemmer often used in NLP that preserves punctuation and separates common English contractions is the Penn Treebank tokenizer.
tokenize_ptb(text1)


#N-gram and skip n-gram tokenizers
tokenize_ngrams(text1, n = 2)
tokenize_ngrams(text1, n = 4, n_min = 2)
tokenize_ngrams(text1, n = 4, n_min = 2,lowercase=TRUE)
tokenize_ngrams(text1, n = 4, n_min = 2,stopwords = stopwords::stopwords("en"))


#Tweet tokenizer
#Tokenizing tweets --> usernames (@username) and hashtags (#hashtag) --> special characters 
tokenize_tweets("Welcome, @user, to the tokenizers package. #rstats #forever")


#Sentence and paragraph tokenizers
tokenize_sentences(text1)
tokenize_paragraphs(text1)


#Text chunking
#When one has a very long document, sometimes it is desirable to split the document into smaller chunks, each with the same length. 
chunks <- chunk_text(mobydick, chunk_size = 100, doc_id = "mobydick")
length(chunks)
chunks[5:6]
tokenize_words(chunks[5:6])




#Counting words, characters, sentences
count_words(text1)
count_sentences(text1)
count_characters(text1)