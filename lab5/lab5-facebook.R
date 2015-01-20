################################################################
## Advanced Examples of Facebook Data Analysis
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 5, January 16th 2015
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching/social-media-political-participation/code")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## Loading the libraries we will be using 
library(Rfacebook)
library(NYU160J)


##############################################
### LOADING YOUR DATASET OF FACEBOOK POST  ###
##############################################

## The first step is to open your Facebook dataset. Here I'm using posts
## by John McCain as an example, but feel free to change the name of the file
## to yours

data = read.csv("johnmccain.csv", stringsAsFactors=F)


############################################
### PRELIMINARY DESCRIPTIVE ANALYSIS     ###
############################################

## Let's review how to answer a few quick descriptive questions...

## 1) How many posts are there in the dataset?
length(data$message)

## 2) What are the first and last post included in the dataset?
head(data, n=1)
tail(data, n=1)

## 3) How many likes do posts on this page usually get?
summary(data$likes_count)
hist(data$likes_count, breaks=100)

## 4) What posts got more than 25,000 likes?
data[data$likes_count>25000,]

## 5) Same for shares and comments
summary(data$comments_count)
data[data$comments_count>15000,]

summary(data$shares_count)
data[data$shares_count>2000,]

############################################
### FINDING WORDS                        ###
############################################

## How many of these posts mention Syria?

## This line shows you the posts that mention Syria
grep("syria", data$message, ignore.case=TRUE)
## This line computes HOW MANY posts these are
length(grep("syria", data$message, ignore.case=TRUE))
## And this line shows you the text of such posts
data$message[ grep("syria", data$message, ignore.case=TRUE) ]


############################################
### WORD CLOUD                           ###
############################################

## We can also do a word cloud with the content of the Facebook messages
## (usually less informative because Facebook posts have less text!)

## First we are creating a frequency tables with the most frequently used
## words. "Stopwords" indicates words that we are excluding (since 'mccain' is
## very common, we just remove that to make the plot easier to read)
wordFreq = word.frequencies(data$message, stopwords=c("mccain"))

## Now we load the library that contains the function to visualize the text
library(wordcloud)

## And time to get the graphic! Don't worry too much about the options
wordcloud(words=names(wordFreq), freq=wordFreq, max.words=50, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)


############################################
### NUMBER OF LIKES OVER TIME           ###
############################################

# We already learned how to do this, but let's do it again with
# this new dataset...

# first, we create a new variable with date and time for each post
data$datetime = formatFbDate(data$created_time)

# create a new data frame that computes the sum of likes for each month
results = aggregateMetric(data, metric="likes")
results

# visualizing evolution in metric
plot(x=results$month, y=results$x, type="l", ylim=c(0, max(results$x)),
    xlab="Month", 
    ylab="Total likes received", 
    main="Evolution in number of likes on a Facebook page")


# a slightly better looking plot...
library(ggplot2)
library(scales)
ggplot(results, aes(x = month, y = x)) + 
    geom_line() + geom_point() +
    scale_y_continuous("Total number of likes received")


##############################################
### SUBSETTING DATE FROM A PERIOD OF TIME  ###
##############################################

# first, we create a new variable with date and time for each post
data$datetime = formatFbDate(data$created_time)

## we use the "as.POSIXct" function specify the time
subset = data[data$datetime > as.POSIXct("2014-01-01") & 
       			data$datetime < as.POSIXct("2014-03-01"),]


####################################
### COLLECTING PAGES' LIKES DATA ###
####################################

# finding most popular post
id = data$id[which.max(data$likes_count)]
id

# creating OAuth token
my_oauth = 'XXXXXXXXYYYYYYYYZZZZZZZ11111'
# get yours from here:
# https://developers.facebook.com/tools/explorer

# Download the information about most popular post
post = getPost(id, token=my_oauth, comments=FALSE, n.likes=1000)

# Extract the likes data frame
likes = post$likes

# Download user information
users = getUsers(likes$from_id, token=my_oauth)

# What are the most common first names?
head(sort(table(users$first_name), decreasing=TRUE), n=10)

# Why?
data[which.max(data$likes_count),]


