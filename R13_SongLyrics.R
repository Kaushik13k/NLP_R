#Song Lyrics
#install.packages("tidyverse")
#install.packages("magrittr")
#install.packages("purrr")
#install.packages("stringr")
#install.packages("rvest")
#install.packages("xml2")


library(tidyverse)
library(magrittr)
library(purrr)
library(glue)
library(stringr)
library(rvest)
library(xml2)

#The lyrics will be extracted from this web link: https://www.musixmatch.com/ 


#Titles
#First thing first, we would like to get a list of those title. Let's see how.

page_url ="https://www.musixmatch.com/artist/Straight-Line-Stitch#"

page_title <- read_html(page_url)
page_title

html_structure(page_title)

#For example, the css selector for the titles are in the class ".title". 
html_nodes(page_title, '.title')


#We still need to clean the messy text
#Let's clean it up with html_text()
html_text(html_nodes(page_title, '.title'))


#Now we have the  song titles. But we want the lyrics! Let's go for them.
Song_df <- data_frame(Band = "Straight Line Stitch",
                      Title = page_title %>%
                        html_nodes(".title") %>%
                        html_text())

View(Song_df)
