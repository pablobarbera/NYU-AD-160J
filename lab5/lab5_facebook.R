################################################################
## Advanced Examples of Facebook Data Analysis
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

## Loading the library to load your Facebook data
library(Rfacebook)

## We will also use some additional commands I have prepared for you.
## Make sure you have saved the following file in your working folder
## and then run this line:
source("lab5_functions.R")

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

# The code below shows you how to visualize the number of likes on posts
# on your Member of Congress' page, over time

# create a new variable with date and time for each post
data$datetime = format.facebook.date(data$created_time)

# create a new data frame that computes the sum of likes for each month
results = aggregate.metric(data, metric="likes")

# visualizing evolution in metric
plot(results$month, results$x, type="l", ylim=c(0, max(results$x)),
    xlab="Month", 
    ylab="Total likes received", 
    main="Evolution in number of likes on a Facebook page")

# a slightly better looking plot...
library(ggplot2)
library(scales)
ggplot(results, aes(x = month, y = x)) + 
    geom_line() + geom_point() +
    scale_x_date(labels = date_format("%b-%Y")) +
    scale_y_continuous("Total number of likes received")

## look for data between two specific dates
data[data$datetime > as.POSIXct("2012-10-01") & 
       data$datetime < as.POSIXct("2012-11-01"),]

## getting sociodemographic information for a list of users who
## liked a post
library(Rfacebook)
my_oauth = 'CAACEdEose0cBAJClNkqseBEbtvDz6jhobRHZCzyrPc7d4NQ6FBjbPI9uZBLowTRa4DCueMzTmNpEnfqOnv1yXftEIdMEIC4hFyfSQU0kQu4yUmL6YS7vo6MBsjF2pZC8HCR8ZCMqwLhpR55HER8Fhx4U1m5ZA2lHpHDSZCL8dhpLCU6qbZAcjrIEjaRh0WJMgwZD'

##data <- getPage("SenatorAngusSKingJr", token=my_oauth, n=50)
post <- getPost(data$id[2], token=my_oauth, n.likes=10)

data <- getPage("RepAllysonSchwartz", token=my_oauth, n=50)
post <- getPost(data$id[10], token=my_oauth, n.likes=10)




