## Load Hu & Liu's opinion lexicon

# Download Hu & Liu's opinion lexicon:
# http://www.cs.uic.edu/~liub/FBS/opinion-lexicon-English.rar

# Loading data
## You should change directories!! 
hu.liu.pos <- scan('D:/Google Drive/02_Science/Publikationen/Moeser & Moryson 2013/Opinion Lexicon Hu & Liu/positive-words.txt',
                   what = 'character', comment.char=';')
hu.liu.neg <- scan('D:/Google Drive/02_Science/Publikationen/Moeser & Moryson 2013/Opinion Lexicon Hu & Liu/negative-words.txt',
                   what = 'character', comment.char=';')

# Add a few specific and/or especially emphatic terms:
# If you want to add some specific word expressing sentiments you can add them here!
#pos.words <- c(hu.liu.pos, '')
#neg.words <- c(hu-liu.neg, '')

