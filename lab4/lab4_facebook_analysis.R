################################################################
## Collecting and Analyzing Facebook Data
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 4, January 10th 2014
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Dropbox/teaching_2014/code")
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
## 2) OPTIONAL: if you want to draw a network plot of your friends, click on
## "user_friends" to give R permission to access your network of friends
## And note that only *you* have access to this information, not me! 
## 3) Copy the long code ("Access Token") and paste it here below, substituting
## the fake one I wrote:

my_oauth = 'XXXXYYYYYYY11111AAAAA'

## Now try running the following line:
getUsers("me", token=my_oauth)

## Does it return your Facebook public information? Yes? Then we're ready to go

############################################################
### SEARCHING PUBLIC FACEBOOK POSTS FILTERING BY KEYWORD ###
############################################################

## How can I collect public Facebook posts that mention a given keyword?
## This line returns the 100 most recent public posts that mention "obama"
posts = searchFacebook("obama", token=my_oauth, n=100)
## (this might take a few seconds)

## Click on the top right panel (in "posts") to see what you downloaded

## Let's explore the data a little bit...

# How can I see the content of the first (most recent) Facebook post?
posts[1,]

# Which of these posts got more likes?
posts[which.max(posts$likes_count),]

# Which of these posts got more comments?
posts[which.max(posts$comments_count),]

# Which of these posts got more shares?
posts[which.max(posts$shares_count),]

############################################
### COLLECTING USERS' PUBLIC INFORMATION ###
############################################

## Imagine that I want to know from what countries people are posting about
## Obama, and what their gender is, based on this sample of 100 posts.

## Then, I use "getUsers", with users' ID numbers as option:
users = getUsers(posts$from_id, token=my_oauth)

## "users" is also a data frame! So you can click on the top right panel to
## view it.

# In what language are users posting about Obama?
languages = substr(users$locale, 1, 2)
table(languages)
## (Note that above I'm using the substr function, which takes the first to
## second characters of the 'locale' variable, which contains geographic 
## information about the user. Don't worry too much about this for now.)

# From what country are users posting about Obama?
countries = substr(users$locale, 4, 5)
table(countries)

# What is the gender of users posting about Obama?
table(users$gender) 


################################################
### SCRAPING INFORMATION FROM FACEBOOK PAGES ###
################################################

# How can I get a list of posts from a Facebook page?
# The following line downloads the ~100 most recent posts on Barack Obama's
# facebook page: www.facebook.com/barackobama
page = getPage("barackobama", token=my_oauth, n=10000) 

# What information is available for each of these posts?
page[1,]

# Which post got more likes?
page[which.max(page$likes_count),]

# Which post got more comments?
page[which.max(page$comments_count),]

# Which post was shared the most?
page[which.max(page$shares_count),]

# How can I get a list of users who liked a specific post?
# The following line downloads more information about the first post
# (note that it uses the ID of the post as main option), as well
# as a list of 1,000 people who "liked" it
post = getPost(page$id[1], token=my_oauth, n.likes=1000)

# This is how you can view that list of people:
likes = post$likes
# And I extract the likes into a data frame (you can click on the top right
# panel to check the data)

# How can I see the gender, country, and language of these users?
# The first step is to use again "getUsers" to gather their public Facebook
# information, with their names as main option.
users = getUsers(likes$from_name, token=my_oauth)

# And now we replicate the analysis from above.

# What is the predominant language of users who liked this post?
languages = substr(users$locale, 1, 2)
table(languages)

# In what country are these people located?
countries = substr(users$locale, 4, 5)
table(countries)

# What is their distribution by gender?
table(users$gender) 

# What are the most common first names?
head(sort(table(users$first_name), dec=TRUE), n=10)






