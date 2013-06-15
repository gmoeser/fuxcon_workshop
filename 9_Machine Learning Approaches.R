## Machine Learning Approach to classify sentiment in tweets
## Uses svm - other approaches could be checked as well, e.g. Naive Bayes, Trees etc.







#### First part - Install relevant packages - uncomment to do this ##

#install.packages("tm", dependencies = TRUE)
#install.packages("tau", dependencies = TRUE)
library(tm)
library(tau)

## Stemmer - use Rstem - Repository on http://www.omegahat.org/Rstem/
#setRepositories(addURLs =c(CRANxtras = "http://www.omegahat.org/Rstem/"))
#install.packages("Rstem", dependencies = TRUE)
library(Rstem)

## Packages for machine learning - here svm
#install.packages("e1071", dependencies = TRUE)
library(e1071)





#### Second Part - Build dataset for text mining ##

## Clean the dataset to work on
## We will use tweet_list_complete with 4909 obs. of 8 variables as a starting point
## Delete all variable not used in the analyses
## We need only company, sentiment and text
tweets_complete <- tweet_list_complete[,c(2,3,6,8)]
head(tweets_complete) 
# Build subset with only company = apple and language = en and delete categorie = irrelevant 
tweets_apple_en <- subset(tweets_complete, lang == "en" & company == "apple" & sentiment != "irrelevant")
head(tweets_apple_en)
# Clean up - remove language and company
tweets_apple_en <- tweets_apple_en[,c(2,4)]
head(tweets_apple_en)
# Check ASCII compatibility - requires tau-package
table(is.ascii(tweets_apple_en$text))
natw <- which(!is.ascii(tweets_apple_en$text))
# Remove non asci-tweets 
tweets_apple_en <- tweets_apple_en[-natw,]
dim(tweets_apple_en)
# Now all tweets should be ASCII-Compatible
table(is.ascii(tweets_apple_en$text))


# Distribution of sentiments in dataset
t1 <- table(tweets_apple_en$sentiment)
options(digits=4)
prop.table(t1)*100






#### Third part - Do some transformations on text - requires Rstem an tm-package 

## Do this step by step and check the results after each step is completed!

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
# define "tolower error handling" function 

# Functions from Gaston Sanchez - https://sites.google.com/site/miningtwitter/questions/sentiment/sentiment
# Thanks Gaston!
try.error = function(x)
{
  # create missing value
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error=function(e) e)
  # if not an error
  if (!inherits(try_error, "error"))
    y = tolower(x)
  # result
  return(y)
}

# lower case using try.error with sapply 
tweets_apple_en$text = sapply(tweets_apple_en$text, try.error)
# stem Document 
tweets_apple_en$text <- wordStem(tweets_apple_en$text, language = "english")
head(tweets_apple_en)





#### Fourth part - Build corpora and do some transformations on text - requires tm-package 

# Build two vectors
# Vector 1 - Tweets
tweets_apple_en_text <- tweets_apple_en$text
# Vector 2 - Sentiment
tweets_apple_en_sentiment <- tweets_apple_en$sentiment

# Create term-document matrix out of tweets
tweets_tm <- Corpus(VectorSource(tweets_apple_en_text))
tweets_tm 
inspect(tweets_tm[1:10])

# Remove stopwords
# Build own dictionary to hold some special words in text - uncomment this if needed
# myStopwords <- c(stopwords('english'), "@")
myStopwords <- c(stopwords('english'))
tweets_tm <- tm_map(tweets_tm, removeWords, myStopwords)
inspect(tweets_tm[1:10])




#### Fifth part - Build term document matrix and data-frame for machine learning - requires tm-package

# Building a Document-Term Matrix
twitterTDM <- TermDocumentMatrix(tweets_tm, control = list(stopwords = TRUE))
head(inspect(twitterTDM), 1)


# Frequent Terms and Associations
findFreqTerms(twitterTDM, lowfreq=10)
findAssocs(twitterTDM, 'awesome', 0.2)
findAssocs(twitterTDM, 'love', 0.2)

# Data Matrix for svm  
m <- t(as.matrix(twitterTDM))
dim(m)
sentim <- as.data.frame(as.numeric(tweets_apple_en_sentiment))
# Dataset for svm is ready!




#### Sixth part - Classfication: Tune svm-model

## Train on complete dataset
## !! Overfitting
system.time(model1 <- svm(m, tweets_apple_en_sentiment, gamma = 0.1, cost = 2 ))
summary(model1)
# Performance of SVM 
t_m1 <- table(model1$fitted, tweets_apple_en_sentiment)
t_m1
# Accuracy
(t_m1[1,1] + t_m1[2,2] + t_m1[3,3] + t_m1[4,4]) / dim(m)[1]


## USe tuning to improve performance of svm - use crossfolding
system.time(obj1 <- tune(svm, m, tweets_apple_en_sentiment,
                         ranges = list(gamma = seq(0, 2, 0.05), cost = 2^(1:5)),
                         tunecontrol = tune.control(sampling = "cross"), cross = 2))
summary(obj1)

## USe tuning to improve performance of svm - use crossfolding
system.time(obj2 <- tune(svm, m, tweets_apple_en_sentiment,
                         ranges = list(gamma = seq(0, 1, 0.01), cost = 2^(1:5)),
                         tunecontrol = tune.control(sampling = "cross"), cross = 2))
summary(obj2)


## SVM with tuned parameters
system.time(model2 <- svm(m, tweets_apple_en_sentiment,  gamma = 0.05, cost = 4, fitted = TRUE, cross=3, cachesize = 500))
summary(model2)
table(model2$fitted, tweets_apple_en_sentiment)







## Train with crossfolding
## !! fitted = TRUE --> Training Set results will be shown!
#system.time(model2 <- svm(m, tweets_apple_en_sentiment,  fitted = TRUE, cross=10, cachesize = 500))

## SVM with tuned parameters
system.time(model2 <- svm(m, tweets_apple_en_sentiment,  gamma = 0.1, cost = 2, fitted = TRUE, cross=4, cachesize = 500))
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




# Fill in tuning parameters
system.time(model3 <- svm(m, tweets_apple_en_sentiment, gamma = 0.1, cost = 8, cross=10, cachesize = 500))
summary(model3)
table(model3$fitted, tweets_apple_en_sentiment)



