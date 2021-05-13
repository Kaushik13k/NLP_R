#What is Named Entity Recognition?


library(rvest)
library(NLP)
library(openNLP)
library(rJava)

#download the package offline from http://datacube.wu.ac.at/src/contrib/ then install it from RStudio

library(openNLPmodels.en)


page = read_html('https://en.wikipedia.org/wiki/Justin_Trudeau')

text = html_text(html_nodes(page,'p'))
text = text[text != ""]
text = gsub("\\[[0-9]]|\\[[0-9][0-9]]|\\[[0-9][0-9][0-9]]","",text) # removing references [101] type

# Make one complete document
text = paste(text,collapse = " ") 

text = as.String(text)
text


sent_annot = Maxent_Sent_Token_Annotator()
sent_annot
word_annot = Maxent_Word_Token_Annotator()
word_annot
loc_annot = Maxent_Entity_Annotator(kind = "location") #annotate location
people_annot = Maxent_Entity_Annotator(kind = "person") #annotate person
people_annot


annot = NLP::annotate(text, list(sent_annot,word_annot,loc_annot,people_annot))
annot

k <- sapply(annot$features, `[[`, "kind")

find_locations = text[annot[k == "location"]]
unique(find_locations)

find_people = text[annot[k == "person"]]
unique(find_people)


