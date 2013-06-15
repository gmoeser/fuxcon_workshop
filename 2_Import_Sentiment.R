## Import Sentiment and Merge Datasets

## Install and load required packages
#install.packages("hwriter", dependencies = TRUE)
library(hwriter)

## Set working directory
setwd("D:/Google Drive/02_Science/Publikationen/Moeser & Moryson 2013/BLOG Twitter/")

## Read in corpus.csv dataset
tweet_sentiments <- read.csv("corpus.csv", header = FALSE)

## Label variables in dataset
names(tweet_sentiments) <- c("company", "sentiment", "id")

## Match tweet_list and tweet_Sentiments
tweet_list_complete <- merge(x = tweet_sentiments, y = tweet_list, by.x = "id", by.y="id")

## Control merging - Result should be 0
sum(tweet_list_complete$id - tweet_list_complete$id_control)

## Number of tweets in dataset
nrow(tweet_list_complete)

## Rebuilt dataset to get rid of some typical text etc. problems
tweet_list_complete <- as.data.frame(tweet_list_complete[,c(1:5, 7,8, 6)])


## Clean up
rm(tweet_list)
rm(tweet_sentiments)

## Save to html
setwd("D:/Google Drive/02_Science/Publikationen/Moeser & Moryson 2013/BLOG Twitter/")

# Write out dataset as HTML table
hwrite(tweet_list_complete, "tweets.html")
























