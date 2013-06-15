## Score the tweets

# only english tweets - corpus contents only English words!
tweet_list_en <- subset(tweet_list_complete, lang == "en")
tweet_list_en

# apple
tweet_list_en_apple <- subset(tweet_list_en, company == "apple")
twitter_corpus_en_apple <- tweet_list_en_apple$test
head(twitter_corpus_en_apple)


# NOT RUNNING - UTF8 (??) problems
# Function score.sentiment must be loaded!
result_apple_en <- score.sentiment(twitter_corpus_en_apple, hu.liu.pos, hu.liu.neg)
# score and text
result_apple_en


#install.packages("tau", dependencies = TRUE)
library(tau)

table(is.utf8(twitter_corpus_en_apple))
table(is.ascii(twitter_corpus_en_apple))

# Translate into local 
twitter_corpus_en_apple2 <- translate(twitter_corpus_en_apple)
table(is.ascii(twitter_corpus_en_apple2))

result_apple_en <- score.sentiment(twitter_corpus_en_apple2, hu.liu.pos, hu.liu.neg)
result_apple_en

# combine with original data set
twitter_results_comb_apple_en <- as.data.frame(cbind(tweet_list_en_apple, result_apple_en))

# Display results - scores
with(twitter_results_comb_apple_en, table(score, sentiment))






