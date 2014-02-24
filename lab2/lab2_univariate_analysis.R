################################################################
## Univariate analysis
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 2, January 7th 2014
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching_2014/code")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

dataset <- read.csv("lab1_obama_data.csv", stringsAsFactors=F)

##############################
### REVIEW FROM YESTERDAY ####
##############################

# Variables in a data frame can be accessed with $. For example:
dataset$created_time

# Each variable is a vector of numbers. Each value can be accessed with '[]'. 
dataset$created_time[1] ## first value

# To access a row of a data frame, use '[]' with a comma after the row number.
dataset[1, ] # first row (first post of 2013)

# You can also use "which" to subset the data frame.
dataset[which(dataset$month==1), ] ## all posts from January

############################
### UNIVARIATE ANALYSIS ####
############################

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

# What if a variable is categorical? For example, month of the year
# We can use a frequency table
table(dataset$month)

# Or a proportion table
prop.table(table(dataset$month))

# As shown in the slides, we can turn this table into a bar chart
barplot(table(dataset$month), xlab="Month of the year", ylab="Number of posts")

# How can you save the plot to use it in Word? Click on "export", and then
# "Save plot as Image..."



