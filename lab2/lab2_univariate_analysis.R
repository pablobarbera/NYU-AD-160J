################################################################
## Univariate analysis
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 2, January 7th 2015
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching/social-media-political-participation/code")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

dataset <- read.csv("lab1_nyu_data.csv", stringsAsFactors=F)

##############################
### REVIEW FROM YESTERDAY ####
##############################

# Variables in a data frame can be accessed with $. For example:
dataset$created_time

# Each variable is a vector of numbers. Each value can be accessed with '[]'. 
dataset$created_time[1] ## first value

# To access a row of a data frame, use '[]' with a comma after the row number.
dataset[1, ] # first row 

# You can also use "which" to subset the data frame.
dataset[which(dataset$likes_count>500), ] ## all posts with 500+ likes

# Something new: how can we combine statements to subset the data frame?

# a) to specify an AND condition:
dataset[which(dataset$likes_count>100 & dataset$comments_count>30), ] 
## all posts with 100+ likes AND 30+ comments

# b) to specify an OR condition:
dataset[which(dataset$type=="status" | dataset$comments_count>30), ] 
## all posts that are status updates OR have 30+ comments

############################
### UNIVARIATE ANALYSIS ####
############################

#### CONTINUOUS VARIABLES ####

# Distribution of number of likes for each post (count variable)
summary(dataset$likes_count)
# Same for comments count
summary(dataset$comments_count)

# Each statistic has its own function, but 'summary' is more convenient
mean(dataset$likes_count)
median(dataset$likes_count)
min(dataset$likes_count)
quantile(dataset$likes_count)

# To visualize the distribution of a continuous variable, we can generate an histogram
hist(dataset$likes_count)
# x axis indicates number of likes, in "bins"
# y axis indicates count of posts within each category

# we can modify some of the options to make it more informative
hist(dataset$likes_count, breaks=50, 
     xlab="Number of likes", main="Histogram of number of likes")

#### CATEGORICAL VARIABLES ####

# What if a variable is categorical? For example, month of the year
# (Ignore the following line for now, we'll come back to this later)
dataset$month <- substr(dataset$created_time, 6, 7)
# We can use a frequency table
table(dataset$month)

# Or a proportion table
prop.table(table(dataset$month))

# As shown in the slides, we can turn this table into a bar chart
barplot(table(dataset$month), xlab="Month of the year", ylab="Number of posts")

# How can you save the plot to use it in Word? Click on "export", and then
# "Save plot as Image..."

############################
## In-class quiz
############################

# What is the average number of shares per post?
mean(dataset$shares_count)
# Prepare a histogram of the number of comments per post
hist(dataset$comments_count)
# Use a frequency table to look at the distribution of post types
table(dataset$type)
# Turn the previous table into a bar chart
barplot(table(dataset$type), xlab="Type of Status", ylab="Number of posts")

