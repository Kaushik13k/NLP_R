#spacyr: an R wrapper for spaCy
#spacyr provides a convenient R wrapper around the Python spaCy package. 


# ADJ   - Adjective
# ADP   - Adposition
# ADV   - Adverb
# AUX   - Auxilliray Verb
# CONJ  - Coordinating COnjunction
# DET   - Determiner
# INTJ  - Interjection 
# NOUN  - Noun
# NUM   - Numeral
# PART  - Particle
# PRON  - Pronoun
# PROPN - Proper Noun  
# PUNCT - Punctuation
# SCONJ - Subordinating Conjunction
# SYM   - Symbol
# VERB  - Verb
# X     - Other



install.packages('spacyr')
library("spacyr")
spacy_install()

#output expected
#Proceed? 

#1: No
#2: Yes

#Selection: 2



#Installation complete.

#spacy_initialize()
spacy_initialize(model = "en_core_web_sm")


#including punctuation characters and symbols.
text <- 
  c(d1 = "spaCy is great at fast natural language processing. Football, airport, skateboard.",
    d2 = "When you treat the food that billions consume like a work of art, you turn quality into a masterpiece. By conveying the authentic story and natural rice production process inside a carved single rice seed, Prompt Design packaging for Thai Wisdom Rice is more like a classic masterpiece that belongs on the walls of a museum.",
    d3 = "Working with the carvers to achieve the best wooden seed details has made us feel the hardship and meticulosity of rice cultivation before delivery to tasteful consumption.")

# process documents and obtain a data.table
parsedtxt <- spacy_parse(text)
parsedtxt

#spacy_parse(text, tag = TRUE, entity = FALSE, lemma = FALSE)
spacy_tokenize(text)

#output to a dataframe
head(spacy_tokenize(text, remove_punct = TRUE, output = "data.frame"))
tail(spacy_tokenize(text, remove_punct = TRUE, output = "data.frame"))


#Extracting language properties from texts
# Entity and noun phrase recognition
## spacyr can extract entities, either named or extended from the output of spacy_parse().

# Entity can be organizations, people, places, dates, etc... 
entity_extract(parsedtxt)

#"Extended" entities including entities such as dates, events, and cardinal or ordinal quantities.
entity_extract(parsedtxt, type = "all")

#One very useful feature is to use the consolidation functions to compound multi-word entities into single "tokens" as in German language 
head(entity_consolidate(parsedtxt))
tail(entity_consolidate(parsedtxt))


#similarly to named entity extraction, spacyr can extract or concatenate [noun phrases* (or noun chunks).
spacy_parse(text, tag = TRUE, entity = FALSE, lemma = FALSE)
parsedtxt <- spacy_parse(text, nounphrase = TRUE)
nounphrase_extract(parsedtxt)

#Just as with entities, noun phrases can also be consolidated into single "tokens":
nounphrase_consolidate(parsedtxt)

#If a user's only goal is entity or noun phrase extraction, then two functions make this easy without first parsing the entire text:
spacy_extract_entity(text)
spacy_extract_nounphrases(text)

#Dependency parsing
#Detailed parsing of syntactic dependencies is possible with the dependency = TRUE option:
spacy_parse(text, dependency = TRUE, lemma = FALSE, pos = FALSE)

#Extracting additional token attributes
#It is also possible to extract additional attributes of spaCy tokens with the additional_attributes option. For example, detecting numbers and email addresses:
spacy_parse("I have six email addresses, including me@mymail.com.", 
            additional_attributes = c("like_num", "like_email"),
            lemma = FALSE, pos = FALSE, entity = FALSE)

#Using other language models
#By default, spacyr loads an English language model. 
spacy_finalize()

#German language model
#python -m spacy download de_core_news_sm 

#Spanish language model
#python -m spacy download es_core_news_sm  

#spacy_initialize(model = "de_core_news_sm")
spacy_initialize(model = "C:\\Users\\sb85306\\AppData\\Local\\Programs\\Python\\Python37\\Lib\\site-packages\\de_core_news_sm\\de_core_news_sm-2.2.0")

txt_german <- c(R = "R ist eine freie Programmiersprache fur statistische Berechnungen und Grafiken. Sie wurde von Statistikern fur Anwender mit statistischen Aufgaben entwickelt.",
                python = "Python ist eine universelle, blicherweise interpretierte here Programmiersprache. Sie will einen gut lesbaren, knappen Programmierstil furdern.")
results_german <- spacy_parse(txt_german, dependency = FALSE, lemma = FALSE, tag = TRUE)
results_german

spacy_initialize(model = "C:\\Users\\sb85306\\AppData\\Local\\Programs\\Python\\Python37\\Lib\\site-packages\\es_core_news_sm\\es_core_news_sm-2.2.0")

txt_spanish <- c(One = "Despues para que se les reconociera el derecho sobre las tierras donde sus antepasados estan enterrados desde al menos finales de XIX. Sin estatus legal, no hay proteccion, ni servicios publicos ni posibilidad de emprender un litigio. Es no existir como colectivo a ojos de las autoridades. De entre las misiones emprendidas por el catolicismo en estas tierras, es probablemente la que mais molesta al presidente Jair Bolsonaro.")


results_spanish <- spacy_parse(txt_spanish, dependency = FALSE, lemma = FALSE, tag = TRUE)
results_spanish


####
#Integrating spacyr with other text analysis packages
#With quanteda

require(quanteda, warn.conflicts = FALSE, quietly = TRUE)

docnames(parsedtxt)

ndoc(parsedtxt)

ntoken(parsedtxt)

ntype(parsedtxt)

spacy_initialize(model = "en_core_web_sm")

parsedtxt <- spacy_parse(text, pos = TRUE, tag = TRUE)
parsedtxt
as.tokens(parsedtxt)

as.tokens(parsedtxt, include_pos = "pos")

as.tokens(parsedtxt, include_pos = "tag")

spacy_initialize(model = "C:\\Users\\sb85306\\AppData\\Local\\Programs\\Python\\Python37\\Lib\\site-packages\\en_core_web_sm\\en_core_web_sm-2.2.0")

#This is useful for selecting only nouns, using global pattern matching with quanteda's tokens_select() function:
spacy_parse("The cat in the hat ate green eggs and ham.", pos = TRUE) %>%
  as.tokens(include_pos = "pos") %>%
  tokens_select(pattern = c("*/NOUN"))

#Direct conversion of just the spaCy-based tokens is also possible:
spacy_tokenize(text) %>%
  as.tokens()

#including for sentences, for which spaCy's recognition is very smart:
txt2 <- "A Ph.D. in Washington D.C.  Mr. Smith went to Washington."
spacy_tokenize(txt2, what = "sentence") %>%
  as.tokens()


#This also works well with entity recognition, e.g.
spacy_parse(text, entity = TRUE) %>%
  entity_consolidate() %>%
  as.tokens() %>% 
  head(2)


#With tidytext package
#If you prefer a tidy approach to text analysis, spacyr works nicely because it returns parsed texts and (optionally) 
# tokenized texts as data.frame-based objects.
if (!requireNamespace("tidytext", quietly = TRUE))
  install.packages("tidytext", repos = "https://cran.rstudio.com/")

library("tidytext")
parsedtxt <- spacy_parse(text)
unnest_tokens(parsedtxt, word, token) %>%
  dplyr::anti_join(stop_words)


#Finishing a session
# When spacy_initialize() is executed, a background process of spaCy is attached in python space. 
# This can take up a significant size of memory especially when a larger language model is used (e.g. en_core_web_lg).
# When you do not need the connection to spaCy any longer, you can remove the spaCy object by calling the spacy_finalize() function.
#
spacy_finalize()





