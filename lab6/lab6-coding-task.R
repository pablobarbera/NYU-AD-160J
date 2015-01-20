################################################################
## Example of Analysis of Coded Data
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 6, January 20 2015
################################################################

## Changing the working directory
setwd("~/Dropbox/teaching/social-media-political-participation/code")

## Loading sample of tweets
library(NYU160J)
library(streamR)
tweets = parseTweets("tweets-millions-march.json")

## Loading coding results
codings = read.csv("a669724.csv", stringsAsFactors=F, colClasses="character")

## Merging both datasets
tweets = merge(tweets, codings, by="id_str")
nrow(tweets)


############################################
### DESCRIPTIVE ANALYSIS     			 ###
############################################

# How many tweets about the protest?
table(tweets$relevant_december_protest)

# How many tweets express an opinion?
table(tweets$expresses_opinion)

# How many tweets express a POSITIVE opinion?
table(tweets$sentiment)

# How many tweets express participation in the protests?
table(tweets$participation)


############################################
### EXPLORATORY ANALYSIS  	 			 ###
############################################

# What words appear in tweets with positive opinions?
wordFreq = word.frequencies(tweets$text[tweets$sentiment=="positive"])
head(wordFreq, n=20)


# What words appear in tweets that indicate participation in protest
wordFreq = word.frequencies(tweets$text[tweets$participation=="yes"])
head(wordFreq, n=20)

wordFreq = word.frequencies(tweets$text[tweets$participation=="no"])
head(wordFreq, n=20)

####################################################
### BASIC EXAMPLE OF MACHINE LEARNING CLASSIFIER ###
####################################################

## converting text into a data matrix
doc_matrix <- t(as.matrix(create_matrix(tweets$text)))
doc_matrix <- doc_matrix[,colSums(doc_matrix)>1]
values <- (tweets$participation=="yes")*1

## training machine learning classifier
install.packages("e1071")
library(e1071)
classifier <- naiveBayes(doc_matrix, factor(values))

# looking at new examples
text <- paste0("I am protesting today in NYC Millions March ",
	"at 2pm #BlackLivesMatter #CrimingWhileWhite")
words <- unlist(strsplit(tolower(text), "\\s+"))
text <- (dimnames(doc_matrix)[[2]] %in% words)*1

predict(classifier, matrix(text, nrow=1), type="raw")




