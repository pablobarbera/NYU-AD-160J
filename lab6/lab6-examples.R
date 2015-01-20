################################################################
## More Examples of Twitter and Facebook Data Analysis
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 6, January 20 2015
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching/social-media-political-participation/code")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## Loading the libraries to work with your Twitter and Facebook data
library(streamR)
library(Rfacebook)

## we are going to re-install the package with additional functions
## that I have prepared for the course
library(devtools)
install_github("pablobarbera/NYU-AD-160J/NYU160J")

## And now we load the package
library(NYU160J)

#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####
#### TWITTER
#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####


############################################
### LOADING YOUR DATASET OF TWEETS       ###
############################################

## The first step is to open your dataset of tweets. Here I'm using tweets
## by John McCain as an example, but feel free to change the name of the file
## to yours

tweets = parseTweets("senjohnmccain.json")

######################################################
### FINDING TWEETS THAT CONTAIN A PICTURE         ###
######################################################

# each tweet contains a variable that indicates whether it contains a picture
table(tweets$photo)

# do tweets that contain more photos receive more retweets?
mean(tweets$retweet_count[tweets$photo==TRUE])
mean(tweets$retweet_count[tweets$photo==FALSE])


######################################################
### FINDING TWEETS THAT MENTION SPECIFIC WORDS  ###
######################################################

## This line shows you the tweets that mention the word Syria
grep("syria", tweets$text, ignore.case=TRUE)
## This line computes HOW MANY tweets these are
length(grep("syria", tweets$text, ignore.case=TRUE))
## And this line shows you the text of such tweets
tweets$text[ grep("syria", tweets$text, ignore.case=TRUE) ]

# How many tweets are retweets?
length(grep("RT @", tweets$text, ignore.case=TRUE))

#####################################
### SUBSETTING TWEETS BY DATE     ###
#####################################

# First, we create a new variable that saves the date and time of
# each tweet in a format that R likes

tweets$datetime = formatTwDate(tweets$created_at, format="date")

## Now imagine that we want to subset all tweets from October 2014
subset.tweets = tweets[tweets$datetime > as.Date("2014-10-01") & 
       tweets$datetime < as.Date("2014-10-31"),]

## ...and find the most retweeted tweet in October
max(subset.tweets$retweet_count)

subset.tweets[subset.tweets$retweet_count == max(subset.tweets$retweet_count),]

# Be careful to always use the name of the new data frame you just created!


#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####
#### FACEBOOK
#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####

###################################
### LOADING YOUR FACEBOOK DATA  ###
###################################

## This is how you open your Facebook data
data = read.csv("johnmccain.csv", stringsAsFactors=F)


######################################################
### VISUALIZE NUMBER OF POSTS OVER TIME      ###
######################################################

## How can you count the number of posts per month? 

## I have prepared a function that will do that for you:
months = countMonthsPosts(data$created_time)
months

## And now we can use the basic R plot command to make a decent-looking graph
plot(x=months$month, y=months$posts,
    xlab="Date", ylab="Posts per month")
lines(x=months$month, y=months$posts)

## What do we learn about McCain? 

## same for weeks
weeks = countWeeksPosts(data$created_time)

## And now we can use the basic R plot command to make a decent-looking graph
plot(x=weeks$week, y=weeks$posts,
    xlab="Date", ylab="Posts per week")
lines(x=weeks$week, y=weeks$posts)














