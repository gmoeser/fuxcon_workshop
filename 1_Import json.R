# RJSONIO
#install.packages("RJSONIO", dependencies = TRUE)
library(RJSONIO)


## Set working directory
setwd("D:/Google Drive/02_Science/Publikationen/Moeser & Moryson 2013/BLOG Twitter/rawdata")


## Read content of directory
files <- list.files(pattern=".json")


## Initialize first values
dat <- NULL
tweet_list <- data.frame()
i = 0
leng <- length(files) - 1


## Read in data
for (i in 0:leng) {
  i = i + 1
  print(i)
  
  dat <- fromJSON(content=files[i], encoding = "UTF-8")
  tweet_list[i,1] <- (dat$id_str)
  tweet_list[i,2] <- (dat$id)
  tweet_list[i,3] <- (dat$id)
  tweet_list[i,4] <- (dat$text)
  tweet_list[i,5] <- (dat$lang)
  tweet_list[i,6] <- (dat$created_at)
}


## Label dataset
names(tweet_list) <- c("id_str", "id", "id_control", "test", "lang", "created_at" )


## Clean up
rm(dat)
rm(files)
rm(i)
rm(leng)
