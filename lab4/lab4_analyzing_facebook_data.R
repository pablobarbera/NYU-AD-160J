################################################################
## Analyzing Facebook Data
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 4, January 13th 2015
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching/social-media-political-participation/code")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## we are going to re-install another package with additional functions
## that I have prepared for the course
install.packages("devtools")
library(devtools)
install_github("pablobarbera/NYU-AD-160J/NYU160J")

## and three more packages we need to do the plots
install.packages("scales")
install.packages("ggplot2")
install.packages("wordcloud")

## Now we load the packages and add the OAuth token
library(NYU160J)
library(Rfacebook)
my_oauth = 'CAACEdEose0cBAHpogwp8zZCXoqJmf9aEAA7aw3icJFSqSdFjIcYkZA3XVwDmFCpnNMcZABHolOVhN0Hc6QLCtr0cZBEv9p6T0FsY9OKVMeW580dfPg8yEtMm6LiAR3Bhvol3Kq7zkQGVItPL3QeaKTB2WqtNCzLJRFXVbXTijBSYCnfS1rRXxVzwphrVvXTjXE5nXCioUQgJ7TPvmqiX'
## Remember that you can get yours from this website:
## https://developers.facebook.com/tools/explorer

##########################################################
### VISUALIZING EVOLUTION IN NUMBER OF LIKES OVER TIME ###
##########################################################

# The code below shows you how to visualize the number of likes on posts
# on a page, over time

# First, we download the data
# page = getPage("humansofnewyork", token=my_oauth, n=10000) 

# NOTE: the previous command takes a couple of minutes, so to speed
# up the process I have already downloaded it for you, and you can load
# it with the following command:
data(humansofnewyork)

# create a new variable with date and time for each post
page$datetime = formatFbDate(page$created_time)

# create a new data frame that computes the sum of likes for each month
results = aggregateMetric(page, metric="likes")

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
    scale_x_date(breaks = "1 year", labels = date_format("%Y")) +
    scale_y_continuous("Total number of likes received")


###########################################################################
### VISUALIZING TEXT FROM COMMENTS ON A FACEBOOK PAGE WITH A WORD CLOUD ###
###########################################################################

# Let's download 1,000 comments from the most recent post on the Facebook
# page Humans of New York Facebook page
post = getPost(page$id[1], token=my_oauth, likes=FALSE, n.comments=1000)

# Now we save the comments into a data frame
comments = post$comments

## Here we are creating a frequency tables with the most frequently used
## words. "Stopwords" indicates words that we are excluding (since 'humans'
# is very common, we just remove it to make the plot easier to read)
wordFreq = word.frequencies(comments$message, stopwords=c("humans"))

## Now we load the library that contains the function to visualize the text
library(wordcloud)

## And time to get the graphic! Don't worry too much about the options
wordcloud(words=names(wordFreq), freq=wordFreq, max.words=50, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)





