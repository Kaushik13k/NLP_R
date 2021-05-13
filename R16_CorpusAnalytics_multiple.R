#loading packages
library(tm)
library(tidytext)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(stringr)
library(textdata)
library(igraph)

install.packages('textdata')
#loading corpus
#A list of documents - 170

docs <- VCorpus(DirSource("PATH"))


docs


#Corpus Preprocessing
#Remove punctuation - replace punctuation marks with " "
docs <- tm_map(docs, removePunctuation)
#Transform to lower case
docs <- tm_map(docs, content_transformer(tolower))
#Strip digits
docs <- tm_map(docs, removeNumbers)
#Remove stopwords from standard stopword list 
docs <- tm_map(docs, removeWords, stopwords("english"))
#Strip whitespace (cosmetic?)
docs <- tm_map(docs, stripWhitespace)
#inspect output
writeLines(as.character(docs[[10]]))


#Stemming process
docs <- tm_map(docs,stemDocument)
writeLines(as.character(docs[[10]]))


#convert the corpus document into a tidy format
#Create a data frame which represents each row as a document
t_corpus <- docs %>% tidy()
t_corpus


d_corpus <- t_corpus %>% 
  select(id, text)
d_corpus

#We can use the `unnest_tokens which tokenizes the text variable into works and creates one row per token
#unnest_tokens  also converts all characters to lower case.
tidy_df <- t_corpus %>%
  unnest_tokens(word, text)
tidy_df 


tidy_df %>%
  select(id, word) %>%
  head(15)


#Preprocessingand data cleanig

get_stopwords()


#excluding stop words using anti_join function
#The expression is.na(as.numeric(word))filters for words that can not be transformed to numeric values.
#This filters out all words that are just containing numbers (such as the "2019").
word_tidy <- tidy_df %>%
  anti_join(get_stopwords()) %>%
  filter(is.na(as.numeric(word)))


word_tidy %>%
  select(id, word) %>%
  head(10)


#Analysis step

#1. Term frequencies & TF-IDF

#Using the function count we can identify term frequencies of the entire corpus.
word_tidy %>%
  count(word, sort = TRUE) %>%
  head(10)

word_tidy %>%
  count(word, sort = TRUE) %>%
  head(10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()



word_tidy %>%
  select(id, word)


perb <- wosw_tidy %>%
  select(id, word) %>%
  count(id, word, sort = TRUE) %>%
  ungroup()


perb

peridc <- perb %>%
  group_by(id) %>%
  summarize(total = sum(n))
peridc

book_words <- left_join(perb, peridc)
book_words


#As per the output , we can see the most frequent terms per book showing overall total words in the document.

frequency <- word_tidy %>%
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(id, word) %>%
  group_by(id) %>%
  mutate(proportion = n / sum(n)) %>%
  select(-n) 

frequency %>%
  arrange(desc(proportion))

#Zipf's law states that the frequency that a word appears is inversely proportional to its rank.

freq_by_rank <- book_words %>% 
  group_by(id) %>%
  mutate(rank = row_number(), 
         `term frequency` = n/total)

freq_by_rank

#The rank column ranks each word within the frequency table.

freq_by_rank %>%
  ggplot(aes(rank, `term frequency`, colour = id)) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) +
  scale_x_log10() +
  scale_y_log10()

#By plotting in log-log co-ordinates we can see that the corpus, even though seperated by id, are similiar to each other and the relationship 
#between rank and frequency does have a negative slope.



# Net let's compute the tf and idf and tf_idf
book_words <- book_words %>%
  bind_tf_idf(word, id, n)

book_words

#We can see that with common words, the tf and tf-idf are close to zero because they are extremely common words. 
#They are common because they appear across all of our corpus (they will have a natural log of 1) and therefore this approach decreases 
#the weight for common words.


#Removing the total column and sort by tf_idf column
book_words %>%
  select(-total) %>%
  arrange(desc(tf_idf))


#Now , Here we can see proper nouns and names that are important in these documents. None of them occur in all of the corpus,
# and therefore important characteristic words.


#Sentiment Analysis
#Sentiment analysis gives us the opportunity to analyse and investigate the emotional intent of words whether the text are positive or negative and
# in some project the neutral keyword.

#To analyse sentiment, we generally consider a combintation of words rather than an individual word. This isn't the only method but often-used approach.

#List of words in the nrc lexicon from the tidytext package
sentiments

#The tidytext package contains a dictionary that containts several sentiment lexicons.

#The three general-purpose lexicons are:

#1.  AFINN from Finn Nielsen,
#2. bing from Bing Liu and Collaborators, and
#3. nrc from Saif Mohammad and Peter Turney.

#All of the lexicons above are based on unigrams (one word or token). 

#They assign english words and associate it with scores for negative or positive sentiment. nrc, however, is a binary yes/no in emotions.


#this will download the nrc NRC Word-Emotion Association Lexicon 
#from the URL http://saifmohammad.com/WebPages/lexicons.html 

tidy_joy <- get_sentiments("nrc") %>%
  filter(sentiment == "joy")

tidy_joy


tidy_df %>% 
  inner_join(tidy_joy) %>%
  count(word, sort = TRUE)

#Lets apply this across documents in our corpus using the bing lexicon.


tidy_df_sent <- tidy_df %>%
  inner_join(get_sentiments("bing")) %>%
  count(id, sentiment) %>%
  spread(sentiment, n, fill = 0)

tidy_df_sent

#mutate(sentiment = positve - negative)

tidy_df_sent <- tidy_df_sent %>%
  mutate(sentiment = positive - negative)

tidy_df_sent


#plot id against sentiment
ggplot(tidy_df_sent, aes(id, sentiment, fill = id)) +
  geom_col(show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# We can see some documents have +ve and some -ve sentiments

#Lets do a word count by sentiments
bing_word_counts <- tidy_df %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts


#Plot the +ve and -ve sentiments words

bing_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word,n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()

#Sentiment Analysis provides a useful way to understand the attributes associated in text.



# Relationships between words N-Gram

bigrams <- tidy_df %>%
  unnest_tokens(bigram, word, token = "ngrams", n=2)

bigrams

#Sort bigrams with highest counts
bigrams %>%
  count(bigram, sort = TRUE)

#we can see mostcommon bigram 


#similarly for trigrams and 4-grams, 5-grams , etc....

trigrams <- tidy_df %>%
  unnest_tokens(bigram, word, token = "ngrams", n=3)

trigrams

#Sort bigrams with highest counts
trigrams %>%
  count(bigram, sort = TRUE)


bigram_tf_idf <- bigrams %>%
  count(id, bigram) %>%
  bind_tf_idf(bigram, id, n) %>%
  arrange(desc(tf_idf))

bigram_tf_idf

#By applying tf-idf and n-gram we can discover the most important elements of each document within the corpus.

#Using bigrams over unigrams gives us the oppotunity to capture structure and understand the context.

#Visualising a network of bigrams

#R is able to visualise the relationships among words simultaneously. We can arrange the words into a network with a combination of nodes. The graphs have 3 variables:

# From: The node of an edge is coming from
# To: the node an edge is going towards
# Weight: A numeric value associated with each edge.


bigrams_separated <- bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)

bigram_counts

bigram_graph <- bigram_counts %>%
  filter(n > 20) %>%
  graph_from_data_frame()

bigram_graph 

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)


a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()

#The figure visualises the text structure and how they are linked and directionality. The more common they are the darker the arrows.

