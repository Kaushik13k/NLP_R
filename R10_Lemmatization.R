#Lemmatization
#Lemmatization is smarter than Stemming.

install.packages("textstem")
install.packages("tidytext")
library(tidytext)
library(SnowballC)
library(textstem)

x <- c("the", NA, 'doggies', ',', 'well', 'they', 'talking', 'ran', 'running', '.','annoying','being')
lemmatize_words(x)


y <- c(
  'the dirtier dog has eaten the pies',
  'that shameful pooch is tricky and sneaky',
  "He opened and then reopened the food bag",
  'There are skies of blue and red roses too!',
  NA,
  "The doggies, well they aren't joyfully running.",
  "The daddies are coming over...",
  "This is 34.546 above"
)

lemmatize_strings(y)

lemmatize_strings("He stopped talking loudly with me")

lemmatize_strings("For this problem, I used LSTM which uses gates to flow gradients back in time and reduce the vanishing gradient problem.")