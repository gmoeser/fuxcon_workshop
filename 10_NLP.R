## Install and test rJava package
# install.packages("rJava", dependencies = TRUE)
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre7') # for 64-bit version
#Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre7') # for 32-bit version
library(rJava)


## OpenNLP
install.packages("openNLP", dependencies = TRUE)
#install.packages("openNLPmodels", dependencies = TRUE)
library(openNLP)

# Short Introduction

## Erster Test

## Part-of-speech Tagging
sentence <- "This is a short sentence consisting of some nouns, verbs, and adjectives."
tagPOS(sentence, language = "en")

sentence2 <- "This is really nerdy, isn't it?"
tagPOS(sentence2, language = "en")


## Sentence Detection
s <- "This is a sentence. This another---but with dash-like  structures, and some commas. Maybe another with question  marks? Sure!"
sentDetect(s, language = "en")

## Tokenizer
s <- "Como se llama usted? El castellano es la lengua espanola oficial del Estado."
tokenize(s, language = "es")


## Enhancements to tm
# tmTagPOS
# tmSentDetect
# tmTokenize


tok_apple_en <- tokenize(tweets_apple_en$text)
head(tok_apple_en)





