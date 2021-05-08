#SelectorGadget
#to extract desired components from a page.

install.packages("rvest")
library(rvest)

#> Loading required package: xml2
html <- read_html("https://www.tripadvisor.ca/Hotel_Review-g154948-d182610-Reviews-Crystal_Lodge_Hotel-Whistler_British_Columbia.html")


#SelectorGadget is a JavaScript bookmarklet that allows you to interactively figure out what css selector you need 
cast <- html_nodes(html, ".common-text-ReadMore__content--2X4LR")
cast
cast[1:2]

length(cast)

text <- html_text(cast)
text


#loading libraries
library(rvest)
library(dplyr)

#Reading the data from a website

# Store the website address in the variable web_address

web_address<-'http://www.news.com.au/'


# Read the html code of the webpage in to the variable webpage_code
webpage_code<-read_html(web_address)
webpage_code


# Read the headlines of the News.com.au portal using the CSS path identified using the Selector Gadget
news_headlines <- html_nodes(webpage_code,'.widget_newscorpau_capi_sync_collection:nth-child(1) .story-block > .heading a')
news_headlines

# Convert the new headlines to text and view the summary data
news_headlines_text <- html_text(news_headlines)
head(news_headlines_text)


# Read the description of the News.com.au portal using the CSS path identified using the Selector Gadget and view the summary data

news_description <- html_text(html_nodes(webpage_code,'.widget_newscorpau_capi_sync_collection:nth-child(1) .standfirst'))
head(news_description)


# Format the descriptions information
news_description<-gsub("\n\t\t\t\t","",news_description)
news_description<-gsub("\n\t","",news_description)


#Let's have another look at the description data 
head(news_description)
View(news_description)
