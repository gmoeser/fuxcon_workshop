## Language Detection with textcat: n-Gram Based Text Categorization in R

#install.packages("textcat", dependencies = TRUE)
library(textcat)

## Information about textcat - http://www.jstatsoft.org/v52/i06/paper

## Detect language
## Perform some first tests
tweets_apple_en_lang <- textcat(tweets_apple_en$text)
t_lang <- table(tweets_apple_en_lang)
options(digits = 3)
prop.table(t_lang)*100
str(tweets_apple_en_lang)


# Example for misclassification
tweets_apple_en[which(tweets_apple_en_lang == "malay"),]



### First step - All as language = en marked tweets --> definitely English
tweets_apple_en


### Second step - All remaining tweets with ASCII = F will be deleted



### Third step - All remaining tweets with ASCII = T will be classified with textcat












