## Sentiment manual coding in apple text corpus
tab_pop1 <- with(twitter_results_comb_apple_en, table(sentiment))

## Draw a sample
?sample
sample50 <- twitter_results_comb_apple_en[sample(1:nrow(twitter_results_comb_apple_en), 50, replace=FALSE),]
tab_samp1 <- with(sample50, table(sentiment))

## Build one table
tab_comp1 <- rbind(tab_pop1, tab_samp1)
tab_comp1
prop.table(tab_comp1, 1)*100





?prop.table




