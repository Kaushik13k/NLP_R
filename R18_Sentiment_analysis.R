#Sentiment Analysis
#Using Pipe operators
install.packages("textdata")

# Creating visualizations using NRC, Bing and AFINN sentiment lexicons

library(tidyverse)   # tidyr, dplyr, ggplot2

library(tidytext)
library(stringr)

library(scales)

install.packages('wordcloud')
library(wordcloud)
library(reshape2)
library(textdata) 

data_frame <- read.csv('C:\\Users\\13kau\\Desktop\\NLP(R)\\lyrics.csv', header = TRUE, stringsAsFactors = FALSE)

View(data_frame)

str(data_frame, list.len = 3)
glimpse(data_frame)

#Remove <br> tag and tokenize
wordToken <-  data_frame %>%
  unnest_tokens(output = line, input = lyrics, token = str_split, pattern = ' <br>') %>%   
  unnest_tokens(output = word, input = line) 

glimpse(wordToken)


View(wordToken)

wordToken$word

#Remove stop words
wordToken <- wordToken %>% 
  anti_join(stop_words) %>% # Take out rows of `word` in wordToken that appear in stop_words
  arrange(ID) 
glimpse(wordToken)
View(wordToken)

#Removing cols writers, length and lengthS
tidy_lyrics <- wordToken %>% 
  select(-writers, -length, -lengthS)
View(tidy_lyrics)


# Using the bing Lexicon
# The bing lexicon categorizes words in a binary fashion into positive and negative categories. 

emotions_lyrics_bing <- tidy_lyrics %>% 
  filter(!grepl('[0-9]', word)) %>% 
  left_join(get_sentiments("bing"), by = "word") %>% 
  group_by(album) %>%   
  mutate(sentiment = ifelse(is.na(sentiment), 'neutral', sentiment)) %>%   # add in neutral
  ungroup()

View(emotions_lyrics_bing)

#sentiment counts
emotions_lyrics_bing %>% 
  count(sentiment)
# The Bing lexicon computes most of the words as neutral as not all words in our lyrics have a corresponding sentiment category 
# in the lexicon.


#Most common positive and negative words in the lyrics!
word_count <- emotions_lyrics_bing %>% 
  count(word, sentiment, sort = T) %>% 
  ungroup()
word_count


#Removing Neutral sentiments
top_sentiments_bing <-  word_count %>% 
  filter(sentiment != 'neutral') %>% 
  group_by(sentiment) %>% 
  top_n(5, n) %>% 
  mutate(num = ifelse(sentiment == "negative", -n, n)) %>%  
  select(-n) %>% 
  mutate(word = reorder(word, num)) %>% 
  ungroup() 
top_sentiments_bing

ggplot(top_sentiments_bing, aes(reorder(word, num), num, fill = sentiment)) +
  geom_bar(stat = 'identity', alpha = 0.75) + 
  scale_fill_manual(guide = F, values = c("black", "darkgreen")) +
  scale_y_continuous(limits = c(-40, 70), breaks = pretty_breaks(7)) + 
  labs(x = '', y = "Number of Occurrences",
       title = 'Lyrics Sentiment',
       subtitle = 'Most Common Positive and Negative Words') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 14, face = "bold"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(size = 1.1))


# Word Cloud: Most Common Positive and Negative Words
# Excluding the neutral sentiments
emotions_lyrics_bing %>% 
  filter(sentiment != 'neutral') %>% 
  count(word, sentiment, sort = T) %>% 
  acast(word ~ sentiment, value.var = "n", fill = 0) %>% 
  comparison.cloud(colors = c("black", "darkgreen"), title.size = 1.5)

emotions_lyrics_bing

# Love appears the most as positive words and Fall appears most often for negative words

# EDIT: with tidyverse, spread() instead of acast()
emotions_lyrics_bing %>% 
  filter(sentiment != "neutral") %>% 
  count(word, sentiment, sort = TRUE) %>% 
  spread(sentiment, n, fill = 0L) %>% 
  as.data.frame() %>% 
  remove_rownames() %>% 
  column_to_rownames("word") %>% 
  comparison.cloud(colors = c("black", "darkgreen"), title.size = 1.5)

emotions_lyrics_bing


#Proportions of Positive and Negative Words
pos_neg_bing <- tidy_lyrics %>% 
  filter(!grepl('[0-9]', word)) %>% 
  left_join(get_sentiments("bing"), by = "word") %>% 
  mutate(sentiment = ifelse(is.na(sentiment), 'neutral', sentiment)) %>%   
  group_by(album, sentiment) %>% 
  summarize(n = n()) %>% 
  mutate(percent = n / sum(n)) %>% 
  select(-n) %>% 
  ungroup() 

pos_neg_bing 

#Plot by excluding the neutral sentiment
pos_neg_bing %>% 
  filter(sentiment != "neutral") %>% 
  ggplot(aes(x = album, y = percent, color = sentiment, group = sentiment)) + 
  geom_line(size = 1) + 
  geom_point(size = 3) +
  scale_y_continuous(breaks = pretty_breaks(5), labels = percent_format()) +
  labs(x = "Album", y = "Emotion Words Count (as %)") +
  scale_color_manual(values = c(positive = "darkgreen", negative = "black")) +
  ggtitle("Proportion of Positive and Negative Words", subtitle = "Bing lexicon") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 11, face = "bold"),
        axis.title.x = element_blank(),
        axis.text.y = element_text(size = 11, face = "bold"))


# Boxplot of emotion terms
# The NRC lexicon not only categorizes words into positive and negative categories but also 
# into eight different emotion terms, Anger, Anticipation, Disgust, Fear, Joy, Sadness, Surprise, and Trust.

cols <- colorRampPalette(brewer.pal(n = 8, name = "Set1"))(8)

cols

cols <- c("anger" = "#E41A1C", "sadness" = "#377EB8", "disgust" = "#4DAF4A", 
          "fear" = "#984EA3", "surprise" = "#FF7F00", "joy" = "#FFFF33", 
          "anticipation" = "#A65628", "trust" = "#F781BF")

emotions_lyrics_nrc <- tidy_lyrics %>% 
  left_join(get_sentiments("nrc"), by = "word") %>% 
  filter(!(sentiment == "negative" | sentiment == "positive")) %>% 
  mutate(sentiment = as.factor(sentiment)) %>% 
  group_by(album, sentiment) %>% 
  summarize(n = n()) %>% 
  mutate(percent = n / sum(n)) %>%   
  select(-n) %>% 
  ungroup() 

emotions_lyrics_nrc

#install.packages("hrbrthemes")
library(hrbrthemes)

#Boxplot 
emotions_lyrics_nrc %>% 
  ggplot() +
  geom_boxplot(aes(x = reorder(sentiment, percent), y = percent, fill = sentiment)) +
  scale_y_continuous(breaks = pretty_breaks(5), labels = percent_format()) +
  scale_fill_manual(values = cols) +
  ggtitle("Distribution of Emotion Terms", subtitle = "n = 11 (Albums)") +
  labs(x = "Emotion Term", y = "Percentage") +
  theme_bw() +
  theme(legend.position = "none",
        axis.text.x = element_text(size = 11, face = "bold"),
        axis.text.y = element_text(size = 11, face = "bold"))
# the black bar inside the box signifies the median
# the dots are the outliers

#Using the NRC lexicon
emotions_lyrics_nrc %>% 
  ggplot(aes(album, percent, color = sentiment, group = sentiment)) +
  geom_line(size = 1.5) +
  geom_point(size = 3.5) +
  scale_y_continuous(breaks = pretty_breaks(5), labels = percent_format()) +
  xlab("Album") + ylab("Proportion of Emotion Words") +
  ggtitle("Lyric Sentiments along Albums", subtitle = "From 2000-2016") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 11, face = "bold"),
        axis.title.x = element_blank(),
        axis.text.y = element_text(size = 11, face = "bold")) +
  scale_color_brewer(palette = "Set1")


# split the emotions into groups to be able to see changes better
# Group1 = Anger, Disgust, Fear, and Sadness
# Group2 = Surprise, Anticipation, Joy, and Trust

# the positive emotions
emotions_lyrics_nrc %>% 
  filter(sentiment != "anger" & sentiment != "disgust" & 
           sentiment != "fear" & sentiment != "sadness") %>% 
  ggplot(aes(album, percent, color = sentiment, group = sentiment)) +
  geom_line(size = 1.5) +
  geom_point(size = 3.5) +
  scale_y_continuous(breaks = pretty_breaks(5), labels = percent_format()) +
  xlab("Album") + ylab("Proportion of Emotion Words") +
  ggtitle("Lyric Sentiments: Positive Emotion Terms", subtitle = "Release-date order (2000-2016)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 11, face = "bold"),
        axis.title.x = element_blank(),
        axis.text.y = element_text(size = 11, face = "bold")) +
  scale_color_manual(values = cols, name = "Emotion Terms")

# the negative emotions
emotions_lyrics_nrc %>% 
  filter(sentiment != "anticipation" & sentiment != "joy" & 
           sentiment != "trust" & sentiment != "surprise") %>% 
  ggplot(aes(album, percent, color = sentiment, group = sentiment)) +
  geom_line(size = 1.5) +
  geom_point(size = 3.5) +
  scale_y_continuous(breaks = pretty_breaks(5), labels = percent_format()) +
  labs(x = "Album", y = "Proportion of Emotion Words") +
  ggtitle("Lyric Sentiments: Negative Emotion Terms", subtitle = "Release-date order (2000-2016)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 11, face = "bold"),
        axis.title.x = element_blank(),
        axis.text.y = element_text(size = 11, face = "bold")) +
  scale_color_manual(values = cols, name = "Emotion Terms")

# We can see that both Fear and Sadness have sudden spikes

#Words tagged as fear
nrc_fear <- get_sentiments("nrc") %>% 
  filter(sentiment == "fear")
nrc_fear

tidy_lyrics %>% 
  filter(album == "The Alchemy Index Fire") %>% 
  inner_join(nrc_fear) %>% 
  count(word, sort = TRUE) %>% 
  head(5)

# How about words tagged as Anger?
nrc_anger <- get_sentiments("nrc") %>% 
  filter(sentiment == "anger")
nrc_anger

tidy_lyrics %>% 
  filter(album == "The Alchemy Index Earth") %>% 
  inner_join(nrc_anger) %>% 
  count(word, sort = TRUE)

tidy_lyrics %>% 
  filter(str_detect(album, "The Alchemy")) %>% 
  inner_join(nrc_anger) %>% 
  count(album, word, sort = TRUE) %>% 
  group_by(album) %>% 
  summarize(n = n())

# Words categorized as Anger only appear four times!

#Part 2

#Let's compare the lexicons themselves on how many positive and negative words they each categorize.

get_sentiments("bing") %>% 
  count(sentiment)


get_sentiments("nrc") %>% 
  count(sentiment)

# In the Bing lexicon: there are 4781 words that can be categorized as negative along with 2005 positive words.
# In the NRC lexicon: there are 3324 words that can be categorized as negative along with 2312 positive words.

#In the Bing lexicon, there are far more negative-categorized words than positive. more than twice as many in fact!

# Let's count how many words in the lyrics were categorized for each sentiment
emotions_lyrics_bing %>% 
  group_by(sentiment) %>% 
  summarize(sum = n())

tidy_lyrics %>% 
  left_join(get_sentiments("nrc"), by = "word") %>% 
  group_by(sentiment) %>% 
  summarize(sum = n())

# In the lyrics (Bing): there are 912 negative words along with 423 positive words.
# In the lyrics (NRC): there are 917 negative words along with 846 positive words.

# In summary, both the NRC and Bing lexicons did not have a category for most of the words in Thrice lyrics (neutral or NA) and 
# there were more negative words than positive.

# Let's see if this holds true with the AFINN lexicon
# The AFINN lexicon gives a score from -5 (for negative sentiment) to +5 (positive sentiment).
emotions_lyrics_afinn <- tidy_lyrics %>% 
  left_join(get_sentiments("afinn"), by = "word") %>% 
  filter(!grepl('[0-9]', word))

emotions_lyrics_afinn

emotions_lyrics_afinn %>% 
  summarize(NAs= sum(is.na(value)))

emotions_lyrics_afinn %>% 
  select(value) %>% 
  mutate(sentiment = if_else(value > 0, "positive", "negative", "NA")) %>% 
  group_by(sentiment) %>% 
  summarize(sum = n())
#5220 of 6430 words in our lyrics data set don't have AFINN score

afinn_scores <- emotions_lyrics_afinn %>% 
  replace_na(replace = list(value = 0)) %>%
  group_by(index = title) %>% 
  summarize(sentiment = sum(value)) %>% 
  mutate(lexicon = "AFINN")

afinn_scores
# combine the Bing and NRC lexicons into one data frame:

bing_nrc_scores <- bind_rows(
  tidy_lyrics %>% 
    inner_join(get_sentiments("bing")) %>% 
    mutate(lexicon = "Bing"),
  tidy_lyrics %>% 
    inner_join(get_sentiments("nrc") %>% 
                 filter(sentiment %in% c("positive", "negative"))) %>% 
    mutate(lexicon = "NRC")) %>% 
  # from here we count the sentiments, spread on positive/negative, then create the score:
  count(lexicon, index = title, sentiment) %>% 
  spread(sentiment, n, fill = 0) %>% 
  mutate(lexicon = as.factor(lexicon),
         sentiment = positive - negative)
bing_nrc_scores

all_lexicons <- bind_rows(afinn_scores, bing_nrc_scores)
lexicon_cols <- c("AFINN" = "#E41A1C", "NRC" = "#377EB8", "Bing" = "#4DAF4A")

all_lexicons

all_lexicons %>% 
  ggplot(aes(index, sentiment, fill = lexicon)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~lexicon, ncol = 1, scales = "free_y") +
  scale_fill_manual(values = lexicon_cols) +
  ggtitle("Comparison of Sentiments", subtitle = " Along Song-Order") +
  labs(x = "Index of All Songs", y = "Sentiment Score") +
  theme_bw() +
  theme(axis.text.x = element_blank())

#The Bing lexicon sentiment along song order is generally negative

