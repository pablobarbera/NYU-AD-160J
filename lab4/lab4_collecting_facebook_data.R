################################################################
## Collecting Facebook Data
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

###################################################
### INSTALLING PACKAGES AND LOADING OAUTH TOKEN ###
###################################################

## The first step is to install "Rfacebook", the R package that allow you to 
## capture Facebook data
install.packages("Rfacebook")
## Note that you will need to do this only once.

## Now we load the package
library(Rfacebook)

## To get access to the Facebook API, you need an OAuth code.
## You can get yours going to the following URL:

## https://developers.facebook.com/tools/explorer

## Once you're there:
## 1) Click on "Get Access Token"
## 2) note that only *you* will have access to your private information, not me! 
## 3) Copy the long code ("Access Token") and paste it here below, substituting
## the fake one I wrote:

my_oauth = 'XXXXXXXYYYYYYZZZZZZ11111'

## Now try running the following line:
getUsers("me", token=my_oauth, private_info=TRUE)

## Does it return your Facebook public information? Yes? Then we're ready to go

################################################
### SCRAPING INFORMATION FROM FACEBOOK PAGES ###
################################################

# How can I get a list of posts from a Facebook page?
# The following line downloads the ~100 most recent posts on the facebook
# page of "Humans of New York"
# facebook page: www.facebook.com/humansofnewyork
page = getPage("humansofnewyork", token=my_oauth, n=100) 

# What information is available for each of these posts?
page[1,]

# Which post got more likes?
page[which.max(page$likes_count),]

# (Note that here I'm introducing a new function, which.max)
which.max(c(5,7,9,4))
# it indicates the position where the maximum value in a vector is

# Which post got more comments?
page[which.max(page$comments_count),]

# Which post was shared the most?
page[which.max(page$shares_count),]

# We can also subset by date
# For example, imagine we want to get all the posts from July 2014
page = getPage("humansofnewyork", token=my_oauth, n=1000,
	since='2014/07/01', until='2014/07/31') 

# And we can do the same type of analysis
page[which.max(page$likes_count),]
page[which.max(page$comments_count),]
page[which.max(page$shares_count),]

####################################
### COLLECTING PAGES' LIKES DATA ###
####################################

# How can I get a list of users who liked a specific post?
# The following line downloads more information about the first post
# (note that it uses the ID of the post as main option), as well
# as a list of 1,000 people who "liked" it
post = getPost(page$id[1], token=my_oauth, n.likes=1000)

# This is how you can view that list of people:
likes = post$likes
# And I extract the likes into a data frame (you can click on the top right
# panel to check the data)

# What information is available for these users?
# The first step is to use again "getUsers" to gather their public Facebook
# information, with their IDs as main option.
users = getUsers(likes$from_id, token=my_oauth)

# What are the most common first names?
head(sort(table(users$first_name), decreasing=TRUE), n=10)

# This gives us an idea about the gender distribution of the people 
# interacting with this page.

##################################
### COLLECTING PAGES' COMMENTS ###
##################################

# How can I get the text of the comments on a specific post?
# The following line downloads more information about the first post
# (note that it uses the ID of the post as main option), as well
# as a list of the 1,000 most recent comments
post = getPost(page$id[1], token=my_oauth, n.comments=1000)

# This is how you can view those comments:
comments = post$comments
# And I extract the comments into a data frame (you can click on the top right
# panel to check the data)

# Also, note that users can like comments!
# What is the comment that got the most likes?
comments[which.max(comments$likes_count),]





