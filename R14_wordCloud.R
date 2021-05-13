#install wordcloud2
install.packages("wordcloud2")


library(wordcloud2)
wordcloud2(data = demoFreq)

#Data Frame demoFreq
head(demoFreq)
View(demoFreq)


#Use color and backgroundcolor
wordcloud2(demoFreq, color = "random-light", backgroundColor = "grey")


# Gives a proposed palette
wordcloud2(demoFreq, size=1.6, color='random-dark')

# or a vector of colors. vector must be same length than input data
wordcloud2(demoFreq, size=1.6, color=rep_len( c("green","blue"), nrow(demoFreq) ) )

# Change the background color
wordcloud2(demoFreq, size=1.6, color='random-light', backgroundColor="black")


#Use Rotations
wordcloud2(demoFreq, minRotation = -pi/6, maxRotation = -pi/6, minSize = 10,
           rotateRatio = 1)
#You can custom the wordcloud shape using the shape argument
#Available shapes are circle
#cardioid, diamond, triangle-forward, triangle, pentagon, star
wordcloud2(demoFreq, size = 0.5, shape = 'pentagon')





