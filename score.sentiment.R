<<<<<<< HEAD
=======
## R-syntax provided by Jeffrey Breen and update by Carl Howe - Thanx!!
## Web: http://jeffreybreen.wordpress.com/2011/07/04/twitter-text-mining-r-slides/
## GitHub: https://github.com/jeffreybreen/twitter-sentiment-analysis-tutorial-201107
## We - the Wiesbaden R Users Group - will use this for sentiment analysis during FUxCon 2013
## Wiesbaden R Users Group - http://www.meetup.com/Wiesbaden-R-Users-Group/
## FUxCon 2013 - http://www.fuxcon.de/


>>>>>>> 5cdc892797eeb6d848d58c730856532f147268b0
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  
  # we got a vector of sentences. plyr will handle a list
  # or a vector as an "l" for us
  # we want a simple array ("a") of scores back, so we use 
  # "l" + "a" + "ply" = "laply":
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # and convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
<<<<<<< HEAD
}
=======
}
>>>>>>> 5cdc892797eeb6d848d58c730856532f147268b0
