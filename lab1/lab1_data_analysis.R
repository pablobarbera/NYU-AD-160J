################################################################
## Introduction to data analysis with R
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 1, January 6th 2015
################################################################

### SUBSETTING VECTORS ###

## We're going to continue with our previous example, but now with 10 individuals
height = c(181, 175, 179, 175, 176, 172, 182, 174, 169, 177)
weight = c(80, 61, 74, 58, 67, 58, 91, 74, 55, 63)

## We can extract specific values of these vectors with square brakets
## height and weight for 5th individual
height[5]
weight[5]

## And for more than one individual using ':' if numbers are consecutive
## Example: height for first 3 individuals
height[1:3]

## this is the same as
height[c(1,2,5)]
## note what this last line does: it creates a vector c(1,2,3), which is then
## used to subset the vector "height"

## we can use the "which" function to find out what individuals meet a condition
## for example, which individuals are more than 175cm tall?
which(height>175)

## we can save this as a vector and use it to subset the "weight" vector and know
## the specific heights of the individuals over 175cm
tall = which(height>175)
height[tall]

## to know how many elements a given vector has, we can use the "length" function
length(weight)
## 10 individuals in the sample

### BASIC STATISTICAL FUNCTIONS ###

## We can use R to compute summary statistics for these vectors, the same way
## we would do it with Excel, Stata or SPSS

# average / mean
mean(height)
# sum
sum(weight)
# min and max
min(height)
max(height)

# if we multiply or divide vectors, the operations apply to each element of the vector
# For example, how can we compute the body mass index?
# BMI = weight / (height in m)^2
bmi = weight / (height/100)^2
print(bmi)
mean(bmi)
min(bmi)
max(bmi)

# you can use the "summary" function to compute quickly all of these
summary(bmi)

## how many individuals have a body mass index over 25?
over25 = which(bmi>25)
length(over25)
## 1 individual
## who?
over25
## height and weight for that individual
height[over25]
weight[over25]


### DATA FRAMES ###

## The most common format for data we will use in the class is a "data frame"
## It's essentially an Excel spreadsheet, where each row contains information
## for an individual (or "unit", in general) and each column is a variable
## (for example, weight, height, etc.)

## this is how we create a data frame from scratch:
dataset = data.frame("H" = height, "W" = weight)
## note that we have two variables, which we label "H" for height 
## and "W" for weight.

## To see the data, either type "dataset" on the console, or click on the
## top right panel, where it says "dataset"

## We will work with data frames because it makes it much easier to work with
## variables and subsets of the data

## What you need to know:
## 1) How do I access a variable? Use the dollar sign and then the name of the variable
dataset$H
## note that each variable is still a vector!
dataset$H[1]

## 2) How do I subset the data set?
## First example: data for first individual
dataset[1, ]
## we use the square brackets and then specify the rows (individuals) we're interested in
## and the columns (variables) we want to see, separated by a comma
## (here we leave variable names empty because we want to see them all)

## Second example: data for first five individuals
dataset[1:5, ]

## Third example: data for individuals over 180cm
dataset[which(dataset$H > 180),]

## how does this work?
## look what happens when you type
which(dataset$H > 180)
## and then we're just using this new vector to subset the data!


### IMPORTING DATA ###

## While typing small datasets like this in R makes sense, for anything larger than
## 10 rows, you will want to read it from a file

## The file "lab1_nyu_data.csv" contains a data set with information about the
## posts on the NYU Abu Dhabi Facebook page since it was created in 2010

## Download it from NYU Classes (if you haven't done it already), and navigate using
## the right-hand panel (Files tab) to the folder where you saved it.

## Then, click on "More" (with the wheel sign) and choose "Set as Working Directory"

## You will see that a new line appears on the console -- copy and paste it here
## This is my line of code, but it will be different from yours
setwd("~/Dropbox/teaching/social-media-political-participation/code")

## Now, let's open the file!
## We use the "read.csv" function. A "csv" file is just a plain text file where the
## data for each individual is separated by commas (csv = comma separated values)
dataset = read.csv("lab1_nyu_data.csv", stringsAsFactors=F)

## (Ignore for now the "stringsAsFactors" option...)

## How can I see the data? 
## Either click on 'dataset' on the top right corner or run the following line
View(dataset)
## I also use the "str" command a lot
str(dataset)

## We can also access variables and summarize the data as shown above...
## message of first post ever
dataset$message[1] 
## all information available for first post ever
dataset[1,] 
## average number of likes for each post
mean(dataset$likes_count) 
## minimum number of likes for a post
max(dataset$likes_count) 

## How can we find out what post received more likes?
which(dataset$likes_count==860) ## note that here we need to use two equal signs!
## here:
dataset[392,]

## We can combine it all in one line:
dataset[which(dataset$likes_count==max(dataset$likes_count)),]












