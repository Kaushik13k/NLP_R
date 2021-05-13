#An analysis of the text of the novel
install.packages("corpus")
install.packages('plyr')

library(dplyr)
library(plyr)
library(corpus)
url <- "http://www.gutenberg.org/cache/epub/55/pg55.txt"

#load the corpus
fulltext <- readLines(url, encoding = "UTF-8")

fulltext


#Display a few last lines of the novel
tail(fulltext)

# the text starts after the Project Gutenberg header...
start <- grep("^\\*\\*\\* START OF THIS PROJECT GUTENBERG EBOOK", fulltext) + 1
start


# ...end ends at the Project Gutenberg footer.
stop <- grep("^End of Project Gutenberg", fulltext) - 1
stop
lines <- fulltext[start:stop]
lines
View(lines)


#The novel starts with front matter: a title page, table of contents, introduction, and half title page. 
#Then, a series of chapters follow.
#Grouping the lines by section 

# the front matter ends at the half title page
half_title <- grep("^THE WONDERFUL WIZARD OF OZ", lines)
half_title
# chapters start with "1.", "2.", etc...
chapter <- grep("^[[:space:]]*[[:digit:]]+\\.", lines)
chapter
# ... and appear after the half title page
chapter <- chapter[chapter > half_title]
chapter
# get the section texts (including the front matter)
start <- c(1, chapter + 1) # + 1 to skip title
start
end <- c(chapter - 1, length(lines))
end
text <- mapply(function(s, e) paste(lines[s:e], collapse = "\n"), start, end)
text
# trim leading and trailing white space
text <- trimws(text)

# discard the front matter
text <- text[-1]
text

# extracting titles of each chapter
# get the section titles, removing the prefix ("1.", "2.", etc.)
title <- sub("^[[:space:]]*[[:digit:]]+[.][[:space:]]*", "", lines[chapter])
title <- trimws(title)
title
View(title)

#Creating the Corpus object in R
#Now that we have obtained our raw text data, we put everything together into a corpus data frame object, 
#constructed via the corpus_frame() function:

corpusdf <- corpus_frame(title, text)
corpusdf
View(corpusdf)

# set the row names; not necessary but makes results easier to read
rownames(corpusdf) <- sprintf("ch%02d", seq_along(chapter))

print(corpusdf) # better output than printing a data frame, cuts off after 20 rows

print(corpusdf, 5) # cuts off after 5 rows

print(corpusdf, -1) # prints all rows


#Tokenization Process
#Text in corpus is represented as a sequence of tokens, each taking a value in a set of types. 
#We can see the tokens for one or more elements using the text_tokens function:

text_tokens(corpusdf["ch24",]) # Chapter 24's tokens

text_tokens(corpusdf["ch10",]) # Chapter 10's tokens


#The default behavior is to normalize tokens by changing the cases of the letters to lower case. 
#A text_filter object controls the rules for segmentation and normalization.

text_filter(corpusdf)

#We can change the text filter properties:

text_filter(corpusdf)$map_case <- FALSE
text_filter(corpusdf)$drop_punct <- TRUE
text_tokens(corpusdf["ch24",])
text_tokens(corpusdf["ch10",])


#To restore the defaults, set the text filter to NULL:
text_filter(corpusdf) <- NULL
text_tokens(corpusdf["ch24",])

#drop punctuation
text_filter(corpusdf) <- text_filter(drop_punct = TRUE)

#to get the last 10 tokens in each chapter:
text_sub(corpusdf, 10)
text_sub(corpusdf, -10)

#Text Statistics

text_ntoken(corpusdf)


text_ntype(corpusdf)


text_nsentence(corpusdf)


#The text_stats function computes all three counts and presents the results in a data frame:

stats <- text_stats(corpusdf)


print(stats, -1) # print all rows instead of truncating at 20




#In this analysis, we will exclude the last chapter (Chapter 24), 
#because it is much shorter than the others and has a disproportionate influence on the fit.

subset <- row.names(stats) != "ch24"
model <- lm(log(types) ~ log(tokens), stats, subset)
summary(model)



#We can also inspect the relation visually
#Separate the graph space into 1 row and 2 columns to display graphs side by side 
par(mfrow = c(1, 2))
plot(log(types) ~ log(tokens), stats, col = 2, subset = subset)
abline(model, col = 1, lty = 2)

plot(log(stats$tokens[subset]), rstandard(model), col = 2,
     xlab = "log(tokens)")
abline(h = 0, col = 1, lty = 2)

outlier <- abs(rstandard(model)) > 2
text(log(stats$tokens)[subset][outlier], rstandard(model)[outlier],
     row.names(stats)[subset][outlier], cex = 0.75, adj = c(-0.25, 0.5),
     col = 2)

# The analysis tells us that Heap's law accurately characterizes the lexical diversity (type-to-token ratio) for the main chapters in The Wizard of Oz. 
# The number of unique types grows roughly as the number of tokens raised to the power 0.6.
# The one chapter with an unusually low lexical diversity is Chapter 16. This chapter contains mostly dialogue between Oz and Dorothy's simple-minded companions 
# (the Scarecrow, Tin Woodman, and Lion).

#Term statistics
#Counts and prevalence
#We get term statistics using the term_stats function:

term_stats(corpusdf)

#This returns a data frame with each row giving the count and support for each term. The "count" is the total number of occurrences of the term in the corpus. 
#The "support" is the number of texts containing the term. In the output above, we can see that "the" is the most common term, appearing 2922 times total in all 24 chapters. 
#The pronoun "her" is the 20th most common term, appearing in all but one chapter.

#The most common words are English function words, commonly known as "stop" words. We can exclude these terms from the tally using the subset argument.
term_stats(corpusdf, subset = !term %in% stopwords_en)
#The character names "dorothy", "toto", and "scarecrow" show up at the top of the list of the most common terms.

#Higher-order n-grams
#Beyond searching for single-type terms, we can also search for multi-type terms ("n-grams").

term_stats(corpusdf, ngrams = 5)
term_stats(corpusdf, ngrams = 3) #tri-grams
term_stats(corpusdf, ngrams = 2) #bi-grams

#The types argument allows us to request the component types in the result:

term_stats(corpusdf, ngrams = 3, types = TRUE)


#Here are the most common 2-, 3-grams starting with "dorothy", where the second type is not a function word

term_stats(corpusdf, ngrams = 2:3, types = TRUE,
           subset = type1 == "dorothy" & !type2 %in% stopwords_en)


##Searching for terms
#Now that we have identified common terms, we might be interested in seeing where they appear. For this, we use the text_locate function.
#Here are all instances of the term "dorothy looked":

text_locate(corpusdf, "dorothy looked")

#Note that we match against the type of the token, not the raw token itself, so we are able to detect capitalized "Dorothy". 
#This is especially useful when we want to search for a stemmed token. Here are all instances of tokens that stem to the word "scream":

text_locate(corpusdf, "scream", stemmer = "en") # english stemmer


#If we would like, we can search for multiple phrases at the same time:

text_locate(corpusdf, c("wicked witch", "toto", "oz"))


#We can also request that the results be returned in random order, using the text_sample() function. 
#This function takes the results from text_locate() and randomly orders the rows; this is useful for inspecting a random sample of the matches:

text_sample(corpusdf, c("wicked witch", "toto", "oz"))


#Other functions allow counting term occurrences, testing for whether a term appears in a text, and getting the subset of texts containing a term:

text_count(corpusdf, "the great oz")

text_detect(corpusdf, "the great oz")

text_subset(corpusdf, "the great oz")
