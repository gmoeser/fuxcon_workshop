## Algorithm sanity check

# plyr and stringr must be installed!

# Build small test-dataset
test_corpus <- c(tweet_list_complete$text[3], tweet_list_complete$text[4])

# Function score.sentiment must be loaded!
result <- score.sentiment(test_corpus, hu.liu.pos, hu.liu.neg)
# score and text
result
# only scores
result$score







