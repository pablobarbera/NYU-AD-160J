################################################################
## Analysis of Instagram data
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

# Installing the package to work with Instagram data
library(devtools)
install_github("pablobarbera/instaR/instaR")

## And now we load the package
library(instaR)

## And we also load the token we are going to use
## to execute the authenticated requests to the API 
load("instagram-token.Rdata")
options(warn=-1)

############################################
### DOWNLOADING PICTURES USING A HASHTAG ###
############################################

euromaidan <- searchInstagram("euromaidan", token, 
	n=50, folder="euromaidan")

# descriptive statistics
table(euromaidan$filter)
table(euromaidan$type)
euromaidan[which.max(euromaidan$likes_count),]

######################################################
### SEARCH FOR PICTURES FROM A GIVEN LOCATION      ###
######################################################

maidan <- searchInstagram(lat=50.45, lng=30.524, distance=1000, 
    token=token, n=50, folder="maidan")

######################################################
### DOWNLOAD PICTURES FROM A GIVEN USER		      ###
######################################################

wh <- getUserMedia("whitehouse", token, n=200)

wh[which.max(wh$likes_count),]


######################################################
### COUNTING PICTURES MENTIONING A HASHTAG	      ###
######################################################

getTagCount("love", token)







