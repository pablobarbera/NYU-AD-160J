################################################################
## Additional R materials
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 4, January 10th 2014
################################################################

## This script contains additional functions that I have coded to help you
## analyze tweets. You do not need to edit anything here. Just run the following
## command:

## source("lab4_functions.R")

## from another R script to make it available.

## Installing additional packages
if ("Rfacebook" %in% rownames(installed.packages()) == FALSE){
    install.packages("Rfacebook")
}
if ("ggplot2" %in% rownames(installed.packages()) == FALSE){
    install.packages("ggplot2")
}
if ("scales" %in% rownames(installed.packages()) == FALSE){
    install.packages("scales")
}
if ("tm" %in% rownames(installed.packages()) == FALSE){
    install.packages("tm")
}
if ("wordcloud" %in% rownames(installed.packages()) == FALSE){
    install.packages("wordcloud")
}

options(scipen=12)

## convert Facebook date format to R date format
format.facebook.date <- function(datestring) {
    date <- as.POSIXct(datestring, format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")
}
## aggregate metric counts over month
aggregate.metric <- function(page, metric, FUN) {
    page$month <- format(page$datetime, "%Y-%m")
    m <- aggregate(page[[paste0(metric, "_count")]], list(month = page$month), 
        sum)
    m$month <- as.Date(paste0(m$month, "-01"))
    m$metric <- metric
    return(m)
}

# compute word frequencies for a string vector
word.frequencies <- function(text, stopwords=NULL, verbose=TRUE){
    require(tm)

    cat("Removing punctuation... ")
    text <- gsub("\\.|\\,|\\;|\\:|\\'|\\&|\\-|\\?|\\!|\\)|\\(|-|‘|\\n|\\+|=|~", "", text) 
    cat("done!\n")
    # preparing corpus of words
    myCorpus <- Corpus(VectorSource(text))
    if (Sys.info()['sysname']=="Darwin"){
        myCorpus <- tm_map(myCorpus, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))   
    }
    if (Sys.info()['sysname']=="Windows"){
        myCorpus <- tm_map(myCorpus, function(x) iconv(enc2utf8(x), sub = "byte"))  
    }
   
    # convert to lower case
    cat("Converting to lowercase... ")
    myCorpus <- tm_map(myCorpus, tolower)
    cat("done!\n")
    # remove numbers
    cat("Removing digits and URLs... ")
    myCorpus <- tm_map(myCorpus, removeNumbers)
    # remove URLS
    removeURL <- function(x) gsub('"(http.*) |(http.*)$|\n', "", x)
    cat("done!\n")
    myCorpus <- tm_map(myCorpus, removeURL) 

    # building document term matrix
    cat("Counting words... ")
    myTdm <- TermDocumentMatrix(myCorpus, control=list(minWordLength=3))
    myTdm2 <- removeSparseTerms(myTdm, 0.999)   
    cat("done!\n") 

    # preparing word frequencies
    m <- as.matrix(myTdm2)
    wordFreq <- sort(rowSums(m), decreasing=TRUE)   
    # removing stopwords
    cat("Removing stopwords... ")
    stopwords <- c(stopwords, "dont", "amp", "will", "heres")
    wordFreq <- wordFreq[which(names(wordFreq) %in% 
        c(stopwords('english'), stopwords)==FALSE)]
    cat("done!")
    return(wordFreq)

}