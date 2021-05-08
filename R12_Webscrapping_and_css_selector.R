#robotstxt package allows us to know if a path at a web site is allowed to scrape or not


#Disallow + * means to stay out of the website altogether.

#Disallow + /xyz means to stay out of the specific directories.

#Disallow Googlebot means that the named bot should stay out of either the website

install.packages("robotstxt")
library(robotstxt)

robolist <- robotstxt("https://toronto.craigslist.org/robots.txt/")
robolist

robolist$permissions

paths_allowed("https://toronto.craigslist.org/reply")
paths_allowed("https://toronto.craigslist.org/public")


#TRUE means that bots are allowed to scrape that particular path


#HTTR request

# the request, the data sent to the web server
# the response, the data sent back from the web server.

install.packages("httr")
library(httr)


#GET() is used to make a request
req <- GET("http://httpbin.org/get")
req  


status_code(req)  
headers(req)  
str(content(req))  


req$status_code

#You can automatically throw a warning or raise an error if a request did not succeed:
warn_for_status(req)
stop_for_status(req)


# The request
req <- GET("http://httpbin.org/get", 
           query = list(key1 = "value1", key2 = "value2")
)
content(req)$args


sessionInfo()