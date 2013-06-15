## Machine Learning Approaches to classify text

## http://tm.r-forge.r-project.org/
#install.packages("tm", dependencies = TRUE)
#install.packages("tau", dependencies = TRUE)
#install.packages("Snowball", dependencies = TRUE)
library(tm)
library(tau)
#library(Snowball)
#Stemmer - use Rstem - http://www.omegahat.org/Rstem/


## Clean the dataset to work on
## We will use tweet_list_complete with 4909 obs. of 8 variables as a starting point
## Delete all variable not used in the analyses
## We need only company, sentiment and text
tweets_complete <- tweet_list_complete[,c(2,3,6,8)]
str(tweets_complete)

# Correct column names...
names(tweets_complete) <- c("company", "sentiment", "lang", "text")
names(tweets_complete)

# Check first six entries
head(tweets_complete)

# Build subset with only company = apple and language = en and delete categorie = irrelevant 
tweets_apple_en <- subset(tweets_complete, lang == "en" & company == "apple" & sentiment != "irrelevant")
head(tweets_apple_en)
dim(tweets_apple_en)

# Clean up - remove language and company
tweets_apple_en <- tweets_apple_en[,c(2,4)]
head(tweets_apple_en)

# Distribution of sentiments in dataset
t1 <- table(tweets_apple_en$sentiment)
prop.table(t1)*100

# Check ASCII compatibility
table(is.ascii(tweets_apple_en$text))
natw <- which(!is.ascii(tweets_apple_en$text))

# Remove non asci-tweets 
tweets_apple_en <- tweets_apple_en[-natw,]
dim(tweets_apple_en)

# Now all tweets should be ASCII-Compatible
table(is.ascii(tweets_apple_en$text))


### First, do some transformations on text using tm and tau packages 

# Replace all http:// and @ parts of the text with http only
# http://cran.r-project.org/web/packages/stringr/stringr.pdf
#install.packages("stringr", dependencies = TRUE)
#library(stringr)

# Do this step by step and check the results after each step is completed!

# remove retweet entities
tweets_apple_en$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets_apple_en$text)
head(tweets_apple_en)
# remove at people
tweets_apple_en$text = gsub("@\\w+", "", tweets_apple_en$text)
head(tweets_apple_en)
# remove punctuation
tweets_apple_en$text = gsub("[[:punct:]]", "", tweets_apple_en$text)
head(tweets_apple_en)
# remove numbers
tweets_apple_en$text = gsub("[[:digit:]]", "", tweets_apple_en$text)
head(tweets_apple_en)
# remove html links
tweets_apple_en$text = gsub("http\\w+", "", tweets_apple_en$text)
head(tweets_apple_en)
# remove unnecessary spaces
#tweets_apple_en$text = gsub("[ \t]{2,}", "", tweets_apple_en$text)
tweets_apple_en$text = gsub("^\\s+|\\s+$", "", tweets_apple_en$text)

# stem Document 
library(Rstem)
tweets_apple_en$text <- wordStem(tweets_apple_en$text, language = "english")
head(tweets_apple_en)


# Now, do some typical text-mining transformations
# Some helpful information how to do this with tweets could be found ...
# ... here: http://www.rdatamining.com/examples/text-mining

# Build two vectors
# Vector 1 - Tweets
tweets_apple_en_text <- tweets_apple_en$text
# Vector 2 - Sentiment
tweets_apple_en_sentiment <- tweets_apple_en$sentiment

# Create term-document matrix out of tweets
tweets_tm <- Corpus(VectorSource(tweets_apple_en_text))
tweets_tm 
inspect(tweets_tm[1:10])

# changing letters to lower cases
tweets_tm <- tm_map(tweets_tm, tolower)
# remove punctuation
tweets_tm <- tm_map(tweets_tm, removePunctuation)
# remove numbers
tweets_tm <- tm_map(tweets_tm, removeNumbers)
# remove stopwords
# build own dictionary to hold some special words in text
#myStopwords <- c(stopwords('english'), "@")
myStopwords <- c(stopwords('english'))
# Hold some words in text
#idx <- which(myStopwords == "r")
#myStopwords <- myStopwords[-idx]
tweets_tm <- tm_map(tweets_tm, removeWords, myStopwords)
#tweets_tm <- tm_map(tweets_tm, myStopwords)
#tweets_tm <- tm_map(tweets_tm, remove_stopwords)
#tweets_tm <- tm_map(tweets_tm, removeWords = myStopwords )
# removeWords(tweets_tm, myStopwords)
#tweets_tm <- tm_map(tweets_tm, stemDocument)
inspect(tweets_tm[1:10])

# Building a Document-Term Matrix
twitterTDM <- TermDocumentMatrix(tweets_tm, control = list(stopwords = TRUE))
inspect(twitterTDM)

# Frequent Terms and Associations
findFreqTerms(twitterTDM, lowfreq=20)
findAssocs(twitterTDM, 'awesome', 0.2)
findAssocs(twitterTDM, 'love', 0.2)

# Data Matrix for svm and add sentiment 
m <- t(as.matrix(twitterTDM))
dim(m)
sentim <- as.data.frame(as.numeric(tweets_apple_en_sentiment))
#names(sentim) <- c("sentiment")
#head(sentim)
#m <- as.data.frame(cbind(m,sentim))
#head(m)
#dim(m)
## Last column = sentiment
## 1 = irrelevant
## 2 = negative
## 3 = neutral
## 4 = positive
#m[,4099]

# Dataset for svm is ready
install.packages("e1071", dependencies = TRUE)
library(e1071)

## Train on complete dataset
system.time(model1 <- svm(m, tweets_apple_en_sentiment))
summary(model1)
# Performance of SVM 
table(model1$fitted, tweets_apple_en_sentiment)

## Train with crossfolding
## !! fitted = TRUE --> Training Set results will be shown!
system.time(model2 <- svm(m, tweets_apple_en_sentiment,  fitted = TRUE, cross=10, cachesize = 500))
#system.time(model2 <- svm(m, tweets_apple_en_sentiment,  gamma = 1, cost = 2, fitted = TRUE, cross=10, cachesize = 500))
summary(model2)
table(model2$fitted, tweets_apple_en_sentiment)
## Use model to train the dataset
pred <- predict(model2, m)
table(pred, tweets_apple_en_sentiment)
## Calculate quality in training data set
t_m2 <- table(pred, tweets_apple_en_sentiment)
(t_m2[1,1] + t_m2[2,2] + t_m2[3,3] + t_m2[4,4]) / dim(m)[1]








## Next step:
## Tune model

# test with train data
pred <- predict(model, m)
table(pred, tweets_apple_en_sentiment)


## USe tuning to improve performance
obj <- tune(svm, m, tweets_apple_en_sentiment,
            ranges = list(gamma = seq(0, 10, 0.1), cost = 2^(1:10)),
            tunecontrol = tune.control(sampling = "fix"))

summary(obj)

# Fill in tuning parameters
system.time(model3 <- svm(m, tweets_apple_en_sentiment, gamma = 0.5, cost = 4, cross=10, cachesize = 500))
summary(model3)
table(model3$fitted, tweets_apple_en_sentiment)


