#Quanteda Package







#install.packages("quanteda")

library(quanteda)

#The corpus constructor command corpus() works directly on:

# a vector of character objects, for instance that you have already loaded into the workspace using other tools;
# a VCorpus corpus object from the tm package.
# a data.frame containing a text column and any other document-level metadata.

names(data_corpus_inaugural)
corp_inaugural <- corpus(data_corpus_inaugural)  # build a new corpus from the texts
summary(corp_inaugural)

docvars(corp_inaugural, "Year") <- names(data_corpus_inaugural)
summary(corp_inaugural)


metadoc(corp_inaugural, "language") <- "english"
metadoc(corp_inaugural, "docsource")  <- paste("data_corpus_inaugural", 1:ndoc(data_corpus_inaugural), sep = "_")
summary(corp_inaugural, showmeta = TRUE)


#another deafult dataset from the Quanteda package
corp_uk <- corpus(data_char_ukimmig2010) # build a new corpus from the texts
summary(corp_uk)



docvars(corp_uk, "Party") <- names(data_char_ukimmig2010)
docvars(corp_uk, "Year") <- 2010
summary(corp_uk)


#tag each document with some meta-data

metadoc(corp_uk, "language") <- "english"
metadoc(corp_uk, "docsource") <- paste("data_char_ukimmig2010", 1:ndoc(corp_uk), sep = "_")
summary(corp_uk, showmeta = TRUE)

## To extract texts from a corpus, we use an extractor, called texts().

texts(data_corpus_inaugural)[2]


#We  can use the function  summary() to summarize the texts from a corpus
summary(data_corpus_irishbudget2010)


#We can save the output from the summary command as a data frame, and plot some basic descriptive statistics
summary(data_corpus_inaugural)
tokeninfo <- summary(data_corpus_inaugural)
if (require(ggplot2))
  ggplot(data = tokeninfo, aes(x = Year, y = Tokens, group = 1)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(labels = c(seq(1789, 2017, 12)), breaks = seq(1789, 2017, 12)) +
  theme_bw()

# Longest inaugural address: William Henry Harrison
tokeninfo[which.max(tokeninfo$Tokens), ]

#Handling corpus objects in quanteda

#Combine 2 corpus objects together


corp1 <- corpus(data_corpus_inaugural[1:5])
corp1
corp2 <- corpus(data_corpus_inaugural[53:58])
corp2
corp3 <- corp1 + corp2
corp3
summary(corp3)

# Subsetting corpus objects
# using the function or method corpus_subset()
corpus_sub <- corpus_subset(data_corpus_inaugural, Year > 2000)
summary(corpus_sub)

summary(corpus_subset(data_corpus_inaugural, President == "Obama"))
summary(corpus_subset(data_corpus_inaugural, President == "Clinton"))

#Exploring corpus texts
# The kwic() method or function (keywords-in-context) performs a search for a word and allows us to view the contexts in which it occurs:

kwic(data_corpus_inaugural, pattern = "war")
kwic(data_corpus_inaugural, pattern = "terror")
kwic(data_corpus_inaugural, pattern = "climate")
kwic(data_corpus_inaugural, pattern = "technology")
kwic(data_corpus_inaugural, pattern = "budget")
kwic(data_corpus_inaugural, pattern = "citizen")


kwic(data_corpus_inaugural, pattern = "terror", valuetype = "regex")
kwic(data_corpus_inaugural, pattern = "techno", valuetype = "regex")
kwic(data_corpus_inaugural, pattern = "super", valuetype = "regex")
kwic(data_corpus_inaugural, pattern = "power", valuetype = "regex")
kwic(data_corpus_inaugural, pattern = "politic", valuetype = "regex")
kwic(data_corpus_inaugural, pattern = "supreme", valuetype = "regex")
kwic(data_corpus_inaugural, pattern = "tax", valuetype = "regex")

# Using wildcards

kwic(data_corpus_inaugural, pattern = "capital*")


# Using the function phrase() we can also look up multi-word expressions.

kwic(data_corpus_inaugural, pattern = phrase("United States")) 

kwic(data_corpus_inaugural, pattern = phrase("United States")) %>%
  tail() # show context of the last six occurrences of "United States"


# inspect the document-level variables
head(docvars(data_corpus_inaugural))

# inspect the corpus-level metadata
metacorpus(data_corpus_inaugural)


# Constructing a document-feature matrix using the function dfm()
# dfm() can perform tokenization and tabulates the extracted features into a matrix of documents by features.

corp_inaug_post2000 <- corpus_subset(data_corpus_inaugural, Year > 2000)
# make a dfm
dfmat_inaug_post2000 <- dfm(corp_inaug_post2000)
dfmat_inaug_post2000[, 1:5]

# Other options for a dfm() include removing stopwords, and stemming the tokens.
# make a dfm, removing stopwords and applying stemming
dfmat_inaug_post2000 <- dfm(dfmat_inaug_post2000,
                            remove = stopwords("english"),
                            stem = TRUE, remove_punct = TRUE)
dfmat_inaug_post2000[, 1:5]

# first 20 stopwords from the lexicon 
head(stopwords("en"), 20)

# Russian
head(stopwords("ru"), 10)

# French
head(stopwords("fr"), 10)


# Viewing the document-feature matrix

dfmat_uk <- dfm(data_char_ukimmig2010, remove = stopwords("english"), remove_punct = TRUE)
dfmat_uk

# To get a list of the most frequently occurring features, we can use the function topfeatures():
topfeatures(dfmat_uk, 20) # 20 most frequent words


# Plotting a word cloud is done using textplot_wordcloud(), for a dfm class object. This function passes arguments
# through to wordcloud() from the wordcloud package, and can prettify the plot using the same arguments:


set.seed(100)
textplot_wordcloud(dfmat_uk, min_count = 6, random_order = FALSE,
                   rotation = .25,
                   color = RColorBrewer::brewer.pal(8, "Dark2"))


corpus_inaugural <- dfm(data_corpus_inaugural, remove = stopwords("english"), remove_punct = TRUE)
textplot_wordcloud(corpus_inaugural, min_count = 6, random_order = FALSE,
                   rotation = .25,
                   color = RColorBrewer::brewer.pal(8, "Dark2"))


# Grouping documents by document variable

# Sometimes, we are interested in analysing how texts differ according to substantive factors which may be encoded in
# the document variables, rather than simply by the boundaries of the document files. We can group documents
# which share the same value for a document variable when creating a dfm:

dfmat_ire <- dfm(data_corpus_irishbudget2010, groups = "party",
                 remove = stopwords("english"), remove_punct = TRUE)

dfmat_ire  

# Sorting and inspect the dfm
dfm_sort(dfmat_ire)[, 1:10]
dfm_sort(dfmat_ire)[, 1:20]


# Grouping words by dictionary or equivalence class

corp_inaug_post1980 <- corpus_subset(data_corpus_inaugural, Year > 1980)

# Define our dictionary
dict <- dictionary(list(terror = c("terrorism", "terrorists", "threat"),
                        economy = c("jobs", "business", "grow", "work")))


# For example, a general list of positive words might indicate positive sentiment in a movie
# review, or we might have a dictionary of political terms which are associated with a particular ideological stance.
# In these cases, it is sometimes useful to treat these groups of words as equivalent for the purposes of analysis,
# and sum their counts into classes.
# For example, let's look at how words associated with terrorism and words associated with the economy vary by
# President in the inaugural speeches corpus. From the original corpus, we select Presidents since Reagan:

dfmat_inaug_post1980_dict <- dfm(corp_inaug_post1980, dictionary = dict)
dfmat_inaug_post1980_dict

# Document Similarity

dfmat_inaug_post1980 <- dfm(corpus_subset(data_corpus_inaugural, Year > 1980),
                            remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)
tstat_obama <- textstat_simil(dfmat_inaug_post1980,
                              dfmat_inaug_post1980[c("2009-Obama", "2013-Obama"), ],
                              margin = "documents", method = "cosine")

tstat_obama

# Plotting a dot chart
dotchart(as.list(tstat_obama)$"2009-Obama", xlab = "Cosine similarity")

# We can use these distances to plot a dendrogram, clustering presidents:

data_corpus_sotu <- readRDS(url("https://quanteda.org/data/data_corpus_sotu.rds"))
dfmat_sotu <- dfm(corpus_subset(data_corpus_sotu, Date > as.Date("1980-01-01")),
                  stem = TRUE, remove_punct = TRUE,
                  remove = stopwords("english"))
dfmat_sotu

dfmat_sotu <- dfm_trim(dfmat_sotu, min_termfreq = 5, min_docfreq = 3)


# hierarchical clustering - get distances on normalized dfm
tstat_dist <- textstat_dist(dfm_weight(dfmat_sotu, scheme = "prop"))
tstat_dist

# hiarchical clustering the distance object
pres_cluster <- hclust(as.dist(tstat_dist))
pres_cluster

# label with document names
pres_cluster$labels <- docnames(dfmat_sotu)
# plot as a dendrogram
plot(pres_cluster, xlab = "", sub = "",
     main = "Euclidean Distance on Normalized Token Frequency")


# We can also look at term similarities

tstat_sim <- textstat_simil(dfmat_sotu, dfmat_sotu[, c("fair", "health", "terror","citizen","power")],
                            method = "cosine", margin = "features")
lapply(as.list(tstat_sim), head, 10)
lapply(as.list(tstat_sim), head, 20)

#Scaling document positions
#Here is a demonstration of unsupervised document scaling comparing the "Wordfish" model:
# Topic models
#quanteda makes it very easy to fit topic models as well, e.g.:
## Document-feature matrix of: 14 documents, 1,263 features (64.5% sparse).
dfmat_ire <- dfm(data_corpus_irishbudget2010)
tmod_wf <- textmodel_wordfish(dfmat_ire, dir = c(2, 1))
tmod_wf
# plot the Wordfish estimates by party
textplot_scale1d(tmod_wf, groups = docvars(dfmat_ire, "party"))

# Topic modelling
# Quanteda makes it very easy to fit topic models as well

dfmat_ire2 <- dfm(data_corpus_irishbudget2010,
                  remove_punct = TRUE, remove_numbers = TRUE, remove = stopwords("english"))
dfmat_ire2 <- dfm_trim(dfmat_ire2, min_termfreq = 4, max_docfreq = 10)
dfmat_ire2

set.seed(100)
#install.packages("topicmodels")
library(topicmodels)
if (require(topicmodels)) {
  my_lda_fit20 <- LDA(convert(dfmat_ire2, to = "topicmodels"), k = 13)
  get_terms(my_lda_fit20, 5)
}
