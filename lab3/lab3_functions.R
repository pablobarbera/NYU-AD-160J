################################################################
## Additional R materials
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 3, January 8th 2014
################################################################

## This script contains additional functions that I have coded to help you
## analyze tweets. You do not need to edit anything here. Just run the following
## command:

## source("lab3_functions.R")

## from another R script to make it available.

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


getTimeline <- function(file.name, screen_name=NULL, n=1000, oauth){

    require(rjson); require(ROAuth)

    ## url to call
    url <- "https://api.twitter.com/1.1/statuses/user_timeline.json"

    ## first API call
    params <- list(screen_name = screen_name, count=200, trim_user="false")
   
    url.data <- oauth$OAuthRequest(URL=url, params=params, method="GET", 
    cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl")) 

    ## trying to parse JSON data
    json.data <- fromJSON(url.data, unexpected.escape = "skip")
    if (length(json.data$error)!=0){
        cat(url.data)
        stop("error parsing tweets!")
    }
    ## writing to disk
    conn <- file(file.name, "w")
    invisible(lapply(json.data, function(x) writeLines(toJSON(x), con=conn)))
    close(conn)
    ## max_id
    tweets <- length(json.data)
    max_id <- json.data[[tweets]]$id_str
    max_id_old <- "none"
    cat(tweets, "tweets.\n")

    while (tweets < n & max_id != max_id_old){
        max_id_old <- max_id
        params <- list(screen_name = screen_name, count=200, max_id=max_id,
                trim_user="false")
        url.data <- oauth$OAuthRequest(URL=url, params=params, method="GET", 
        cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl")) 
        ## trying to parse JSON data
        json.data <- fromJSON(url.data, unexpected.escape = "skip")
        if (length(json.data$error)!=0){
            cat(url.data)
            stop("error! Last cursor: ", cursor)
        }
        ## writing to disk
        conn <- file(file.name, "a")
        invisible(lapply(json.data, function(x) writeLines(toJSON(x), con=conn)))
        close(conn)
        ## max_id
        tweets <- tweets + length(json.data)
        max_id <- json.data[[length(json.data)]]$id_str
        cat(tweets, "tweets.\n")
    }
}


