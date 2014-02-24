################################################################
## Visualizing Facebook Data
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

## We will also use some additional commands I have prepared for you.
## Make sure you have saved the following file in your working folder
## and then run this line:
source("lab4_functions.R")

## Now we load the packages and add the OAuth token
library(Rfacebook)
my_oauth = 'XXXXXYYYYYY1111'

## Remember that you can get yours from this website:
## https://developers.facebook.com/tools/explorer

##########################################################
### VISUALIZING EVOLUTION IN NUMBER OF LIKES OVER TIME ###
##########################################################

# The code below shows you how to visualize the number of likes on posts
# on page, over time

page = getPage("barackobama", token=my_oauth, n=300) 

# create a new variable with date and time for each post
page$datetime = format.facebook.date(page$created_time)

# create a new data frame that computes the sum of likes for each month
results = aggregate.metric(page, metric="likes")

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
    scale_x_date(breaks = "2 months", labels = date_format("%b-%Y")) +
    scale_y_continuous("Total number of likes received")


###########################################################################
### VISUALIZING TEXT FROM COMMENTS ON A FACEBOOK PAGE WITH A WORD CLOUD ###
###########################################################################

# Let's download 1,000 comments from the most recent post on Barack Obama's
# Facebook page
post = getPost(page$id[1], token=my_oauth, likes=FALSE, n.comments=1000)

# Now we save the comments into a data frame
comments = post$comments

## Here we are creating a frequency tables with the most frequently used
## words. "Stopwords" indicates words that we are excluding (since 'obama'
# is very commen, we just remove it to make the plot easier to read)
wordFreq = word.frequencies(comments$message, stopwords=c("obama"))

## Now we load the library that contains the function to visualize the text
library(wordcloud)

## And time to get the graphic! Don't worry too much about the options
wordcloud(words=names(wordFreq), freq=wordFreq, max.words=50, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)


########################################
### VISUALIZING A FRIENDSHIP NETWORK ###
########################################

# The code below shows you how to replicate the graph displaying your network
# of friends (the one I showed on the slides)

# If you prefer not to use your own Facebook data, I have prepared an
# additional file with my network, so feel free to uncomment the next line
# and use that
load("lab4_network.Rdata")

# This line of code connects to Facebook and downloads your network of friends
mat <- getNetwork(token=my_oauth, format="adj.matrix")

# Now we install the R packages that allow you to work with networks
install.packages("igraph")
# and we load it...
library(igraph)

# creating network object
network <- graph.adjacency(mat, mode="undirected") ## igraph object
# This line of code shows you how many friends you have, and how many connections
# there are among them
network

# Now we find the "clusters" in which they are organized
fc <- fastgreedy.community(network) ## communities / clusters

# We keep only clusters with 10 or more people
large.clusters <- which(table(fc$membership)>=10)

# Preparing the data for the plot
l <- layout.fruchterman.reingold(network, niter=1000, coolexp=0.5) ## layout
d <- data.frame(l); names(d) <- c("x", "y") ## data frame
edgelist <- get.edgelist(g, names=FALSE) ## adding connections between friends
edges <- data.frame(d[edgelist[,1],c("x", "y")], d[edgelist[,2],c("x", "y")])
names(edges) <- c("x1", "y1", "x2", "y2")
edges$cluster <- NA ## adding cluster names
fc$membership[fc$membership %in% large.clusters == FALSE] <- "Others"
d$cluster <- factor(fc$membership)

p <- ggplot(d, aes(x=x, y=y, fill=cluster))
pq <- p + geom_segment(
        aes(x=x1, y=y1, xend=x2, yend=y2), 
        data=edges, size=0.25, color="black", alpha=1/3) +
            ## note that here I add a border to the points
        geom_point(color="grey20", shape=21, size=2) +
        theme(
            panel.background = element_blank(),
            plot.background = element_blank(),
            axis.line = element_blank(), axis.text = element_blank(), 
            axis.ticks = element_blank(), 
            axis.title = element_blank(), panel.border = element_blank(), 
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank()
            )
pq

# And you can find who is in each cluster running the following line:
lapply(communities(fc), function(x) V(network)[x])


