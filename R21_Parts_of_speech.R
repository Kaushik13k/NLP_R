#POS Tagger

#install.packages("RDRPOSTagger", repos = "http://www.datatailor.be/rcube", type = "source")


Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jdk-12.0.2')
library(rJava)
library(RDRPOSTagger) # from the Bnosac package
library("tokenizers")

models <- rdr_available_models()
models

models$MORPH$language

models$POS$language 

models$UniversalPOS$language

x <- c("POS tagging is the process of marking up a word in a corpus to a corresponding part of a speech tag, based on its context and definition. This task is not straightforward, as a particular word may have a different part of speech based on the context in which the word is used.")
tagger <- rdr_model(language = "English", annotation = "POS")
rdr_pos(tagger, x = x)

x <- c("Dus godvermehoeren met pus in alle puisten, zei die schele van Van Bukburg.", 
       "Er was toen dat liedje van tietenkonttieten kont tieten kontkontkont",
       "  ", "", NA)
tagger <- rdr_model(language = "Dutch", annotation = "MORPH")
rdr_pos(tagger, x = x)

tagger <- rdr_model(language = "Dutch", annotation = "UniversalPOS")
rdr_pos(tagger, x = x)

x <- c("La présidence de la République est la plus haute fonction du pouvoir exécutif de la République française.")
tagger <- rdr_model(language = "French", annotation = "POS")
rdr_pos(tagger, x = x)


#Using openNLP package

library (NLP )
library ( openNLP )

#Load some text

url <- "C:\\TANLP\\Data\\Obama_Speech_1-27-10.txt"
fulltext <- readLines(url, encoding = "UTF-8")
s <- as.String(fulltext)
s
## Need sentence and word token annotations.
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))

pos_tag_annotator <- Maxent_POS_Tag_Annotator()
pos_tag_annotator
a3 <- annotate(s, pos_tag_annotator, a2)
a3
## Variant with POS tag probabilities as (additional) features.
head(annotate(s, Maxent_POS_Tag_Annotator(probs = TRUE), a2))

## Determine the distribution of POS tags for word tokens.
a3w <- subset(a3, type == "word")
tags <- sapply(a3w$features, `[[`, "POS")
tags
table(tags)
## Extract token/POS pairs (all of them): 
sprintf("%s/%s", s[a3w], tags)

## Extract pairs of word tokens and POS tags for second sentence:
a3ws2 <- annotations_in_spans(subset(a3, type == "word"),
                              subset(a3, type == "sentence")[2L])[[1L]]
sprintf("%s/%s", s[a3ws2], sapply(a3ws2$features, `[[`, "POS"))