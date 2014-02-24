################################################################
## More Examples of Twitter and Facebook Data Analysis
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 6, January 21st 2014
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching_2014/code")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## Loading the libraries to work with your Twitter and Facebook data
library(streamR)
library(Rfacebook)

## We will also use some additional commands I have prepared for you.
## Make sure you have saved the following file in your working folder
## and then run this line:
source("lab6_functions.R")

############################################
### LOADING YOUR DATASET OF TWEETS       ###
############################################

## The first step is to open your dataset of tweets. Here I'm using tweets
## by John McCain as an example, but feel free to change the name of the file
## to yours

tweets = parseTweets("senjohnmccain.json")


######################################################
### FINDING TWEETS THAT MENTION SPECIFIC HASHTAGS  ###
######################################################

## This line shows you the tweets that mention the hashtag #Syria
grep("#syria", tweets$text, ignore.case=TRUE)
## This line computes HOW MANY tweets these are
length(grep("#syria", tweets$text, ignore.case=TRUE))
## And this line shows you the text of such tweets
tweets$text[ grep("#syria", tweets$text, ignore.case=TRUE) ]

#####################################
### SUBSETTING TWEETS BY DATE     ###
#####################################

# First, we create a new variable that saves the date and time of
# each tweet in a format that R likes

tweets$datetime = format.twitter.date(tweets$created_at, format="date")

## Now imagine that we want to subset all tweets from October
subset.tweets = tweets[tweets$datetime > as.Date("2012-10-01") & 
       tweets$datetime < as.Date("2012-10-31"),]

## ...and find the most retweeted tweet in October
max(subset.tweets$retweet_count)

subset.tweets[subset.tweets$retweet_count == max(subset.tweets$retweet_count),]

# Be careful to always use the name of the new data frame you just created!


######################################################
### FINDING TWEETS THAT CONTAIN A PICTURE         ###
######################################################

# each tweet contains a variable that indicates whether it contains a picture
table(tweets$photo)

# do tweets that contain more photos receive more retweets?
mean(tweets$retweet_count[tweets$photo==TRUE])
mean(tweets$retweet_count[tweets$photo==FALSE])


###################################
### LOADING YOUR FACEBOOK DATA  ###
###################################

## This is how you open your Facebook data
data = read.csv("johnmccain.csv", stringsAsFactors=F)


######################################################
### FINDING POSTS THAT MENTION SPECIFIC WORDS      ###
######################################################


## How many of these posts mention Syria?

## This line shows you the posts that mention Syria
grep("syria", data$message, ignore.case=TRUE)
## This line computes HOW MANY posts these are
length(grep("syria", data$message, ignore.case=TRUE))
## And this line shows you the text of such posts
data$message[ grep("syria", data$message, ignore.case=TRUE) ]


#####################################
### SUBSETTING POSTS BY DATE     ###
#####################################

# Similar mechanism as above...

data$datetime = format.facebook.date(data$created_time, format="date")

## Subsetting all posts from October...
subset.data = data[data$datetime > as.Date("2012-10-01") & 
       data$datetime < as.Date("2012-10-31"),]

## ...and find the most liked post in October
max(subset.data$likes_count)

subset.data[subset.data$likes_count == max(subset.data$likes_count),]


######################################################
### COLLECTING INFORMATION ABOUT USERS             ###
######################################################

# get your token from: https://developers.facebook.com/tools/explorer/
my_oauth = 'XXXXYYYYY111'

# step 1) choosing a post and getting the id of that post
id = data$id[1] ## most recent post

# step 2) getting list of likes for that post
# NOTE: this only works if you set a number of likes equal or lower
# to the likes it has!

data$likes_count[1]
data$comments_count[1]

# Here this post has many likes and comments, so we can choose 100 and 100, 
# but check the number for your post and choose something equal or lower
# to the numbers above

post = getPost(id, token=my_oauth, n.likes=100, n.comments=100)

# Next step is to get information about the users who liked this post
likes = post$likes

users = getUsers(likes$from_name, token=my_oauth)

# and now we can do the usual analysis of their data...

# What is the predominant language of users who liked this post?
languages = substr(users$locale, 1, 2)
table(languages)

# In what country are these people located?
countries = substr(users$locale, 4, 5)
table(countries)

# What is their distribution by gender?
table(users$gender) 








