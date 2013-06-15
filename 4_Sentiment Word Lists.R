<<<<<<< HEAD
## Load Hu & Liu's opinition lexicon
=======
## Load Hu & Liu's opinion lexicon
>>>>>>> 5cdc892797eeb6d848d58c730856532f147268b0

# Download Hu & Liu's opinion lexicon:
# http://www.cs.uic.edu/~liub/FBS/opinion-lexicon-English.rar

# Loading data

hu.liu.pos <- scan('D:/Google Drive/02_Science/Publikationen/Moeser & Moryson 2013/Opinion Lexicon Hu & Liu/positive-words.txt',
                   what = 'character', comment.char=';')
hu.liu.neg <- scan('D:/Google Drive/02_Science/Publikationen/Moeser & Moryson 2013/Opinion Lexicon Hu & Liu/negative-words.txt',
                   what = 'character', comment.char=';')

# Add a few specific and/or especially emphatic terms:
#pos.words <- c(hu.liu.pos, '')
#neg.words <- c(hu-liu.neg, '')

