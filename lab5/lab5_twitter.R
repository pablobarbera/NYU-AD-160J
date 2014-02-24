################################################################
## Advanced Examples of Twitter Data Analysis
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 5, January 15th 2014
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching_2014/code")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## Loading the library to load your twitter data
library(streamR)

## We will also use some additional commands I have prepared for you.
## Make sure you have saved the following file in your working folder
## and then run this line:
source("lab5_functions.R")

############################################
### LOADING YOUR DATASET OF TWEETS       ###
############################################

## The first step is to open your dataset of tweets. Here I'm using tweets
## by John McCain as an example, but feel free to change the name of the file
## to yours

tweets = parseTweets("senjohnmccain.json")


############################################
### PRELIMINARY DESCRIPTIVE ANALYSIS     ###
############################################

## Let's review how to answer a few quick descriptive questions...

## 1) How many tweets are there in the dataset?
length(tweets$text)

## 2) In what language are they written?
table(tweets$lang)

## 3) What devices were used to send these tweets?
table(tweets$source)

## 4) What are the first and last tweet included in the dataset?
head(tweets, n=1)
tail(tweets, n=1)

## 5) How many followers/friends/statuses does the user currently have
tweets$followers_count[1]
tweets$friends_count[1]
tweets$statuses_count[1]


############################################
### FINDING MOST COMMON HASHTAGS         ###
############################################

## To find the N most common hashtags, you can use the following function
getCommonHashtags(tweets$text, n=20)
## It will display that N hashtags that were used more often in a dataset of
## tweets, as well as the number of times they were used.

## For example, for McCain 369 tweets mentioned #Syria
## Since he has sent 3,217 tweets, that means around 10% of his tweets
## used this hashtag


############################################
### WORDCLOUDS                           ###
############################################

## How can you make a word cloud with the most common hashtags, where the
## size of each hashtag depends on how often it was used?

## first step is to find most common hashtags again
tab = getCommonHashtags(tweets$text, n=50)

## Now we load the library that contains the function to visualize the text
library(wordcloud)

## And time to get the graphic! Don't worry too much about the options
wordcloud(words=names(tab), freq=tab, max.words=50, 
    random.order=FALSE, colors="black", scale=c(2.5,.5), rot.per=0)

## That's a word cloud of hashtags, but how can you do a word cloud
## of the most common words? (not only hashtags)

## First we are creating a frequency tables with the most frequently used
## words. "Stopwords" indicates words that we are excluding (since 'mccain' is
## very common, we just remove that to make the plot easier to read)
wordFreq = word.frequencies(tweets$text, stopwords=c("mccain", "john"))

## Now we load the library that contains the function to visualize the text
library(wordcloud)

## And time to get the graphic! Don't worry too much about the options
wordcloud(words=names(wordFreq), freq=wordFreq, max.words=50, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)

## What do we learn?


############################################
### NUMBER OF TWEETS OVER TIME           ###
############################################

## How can you count the number of tweets per month? This is important to
## understand how social media strategies are constant over time or if
## there are periods of more activity

## I have prepared a function that will do that for you:
countMonthsTweets(tweets$created_at)
## This will return the number of tweets per month
tweets$day <- format.twitter.date(tweets$created_at, format="date")
table(tweets$day)
tweets$year <- substr(as.character(tweets$day), 1, 4)
table(tweets$year)

## How can you do a plot that visualizes that over time?
## First, we save the results from the previous function in an R object
months = countMonthsTweets(tweets$created_at)

## Now this gets a bit tricky! First step is to convert the dates into
## a date object that R can work with:
dates = names(months) ## extract months
dates = paste0(dates, "-01") ## add a "-01" to make them dates and not just months
dates = as.Date(dates) ## convert into a Date format

## And now we can use the basic R plot command to make a decent-looking graph
plot(x=dates, y=as.numeric(months),
    xlab="Date", ylab="Tweets per month")
lines(x=dates, y=as.numeric(months))

## BUT: I have also prepared another function that will produce another version
## of this plot much more easily
plotMonthsTweets(months)

## What do we learn about McCain? 


############################################
### FINDING TOP TWEETS ###
############################################

## As with Facebook, it's very informative to look at the tweets that went
## more viral. On Twitter, that's going to be the tweets that were retweeted
## more often.

## First, let's look at how many retweets McCain usually gets...
summary(tweets$retweet_count)
## around 50 retweets

## Graphically, this is the distribution
hist(tweets$retweet_count, breaks=100)

## So tweets usually get 10-50 retweets, and there are a few tweets that
## get thousands. Let's look at those
tweets[tweets$retweet_count>2500,]

## Another dimension that measures popularity is the number of times each
## tweet got favorited
summary(tweets$favorite_count)
## We get similar results: usually around 10-20 favorites

## And again, let's look at the top tweets on this dimension
tweets[tweets$favorite_count>1000,]

## In this case we get the same results...



