## Run some first analyses

## Check tweet topics and sentiments
table(tweet_list_complete$company)
table(tweet_list_complete$sentiment)

t1 <- table(tweet_list_complete$sentiment , tweet_list_complete$company)
prop.table(t1, 2) * 100
# use apply instead
apply(t1, 2, sum)

## You code here!!
