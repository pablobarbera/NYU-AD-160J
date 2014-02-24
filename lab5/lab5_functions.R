################################################################
## Additional R materials
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 5, January 15th 2014
################################################################

## This script contains additional functions that I have coded to help you
## analyze tweets. You do not need to edit anything here. Just run the following
## command:

## source("lab5_functions.R")

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

options(digits=16)

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

## convert Twitter date format to R date format
format.twitter.date <- function(datestring, format="datetime"){
    if (format=="datetime"){
        date <- as.POSIXct(datestring, format="%a %b %d %H:%M:%S %z %Y")
    }
    if (format=="date"){
        date <- as.Date(datestring, format="%a %b %d %H:%M:%S %z %Y")
    }   
    return(date)
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

# find the N most common hashtags in a string vector
getCommonHashtags <- function(text, n=20){
    hashtags <- regmatches(text,gregexpr("#(\\d|\\w)+",text))
    hashtags <- unlist(hashtags)
    tab <- table(hashtags)
    return(head(sort(tab, dec=TRUE), n=n))
}

## counting tweets sent each mont
countMonthsTweets <- function(dates){
    month = format.twitter.date(dates, format="date")
    month = substr(month, 1, 7)
    return(table(month))
}

## ggplot2 plot for tweets by month
plotMonthsTweets <- function(months){
    require(ggplot2)
    require(scales)
    month = as.Date(paste0(names(months), "-01"))
    month.x <- seq(month[1], month[length(month)], by="month")
    tweets.df <- data.frame(month = month.x, tweets = 0,
        stringsAsFactors=F)
    tweets.df$tweets[month.x %in% month] <- as.numeric(months)
    p <- ggplot(tweets.df, aes(x=month, y=tweets))
    pq <- pq <- p + geom_line() + geom_point() +
       theme_bw() +
        scale_y_continuous(name="Tweets Per Month", expand = c(0, 0),
           limits=c(0, max(tweets.df$tweets))) +
       scale_x_date(labels = date_format("%b-%Y")) +
       theme(axis.line = element_line(colour = "black"),
       panel.grid.major = element_blank(),
       panel.grid.minor = element_blank(),
       panel.border = element_blank(),
       panel.background = element_blank(),
       axis.title.x = element_blank())
   print(pq)
}

# updated parseTweets function, with correct retweet_count
parseTweets <- function(tweets, simplify=FALSE, verbose=TRUE){
    
    ## from json to list
    results.list <- readTweets(tweets, verbose=FALSE)

    # if no text in list, change it to NULL
    if (length(results.list)==0){
        stop(deparse(substitute(tweets)), " did not contain any tweets. ",
            "See ?parseTweets for more details.")
    }
    
    # constructing data frame with tweet and user variable
    df <- data.frame(
        text = unlistWithNA(results.list, 'text'),
        retweet_count = unlistWithNA(results.list, 'retweet_count'),
        favorite_count = unlistWithNA(results.list, 'favorite_count'),
        favorited = unlistWithNA(results.list, 'favorited'),
        truncated = unlistWithNA(results.list, 'truncated'),
        id_str = unlistWithNA(results.list, 'id_str'),
        in_reply_to_screen_name = unlistWithNA(results.list, 'in_reply_to_screen_name'),
        source = unlistWithNA(results.list, 'source'),
        retweeted = unlistWithNA(results.list, 'retweeted'),
        created_at = unlistWithNA(results.list, 'created_at'),
        in_reply_to_status_id_str = unlistWithNA(results.list, 'in_reply_to_status_id_str'),
        in_reply_to_user_id_str = unlistWithNA(results.list, 'in_reply_to_user_id_str'),
        lang = unlistWithNA(results.list, 'lang'),
        listed_count = unlistWithNA(results.list, c('user', 'listed_count')),
        verified = unlistWithNA(results.list, c('user', 'verified')),
        location = unlistWithNA(results.list, c('user', 'location')),
        user_id_str = unlistWithNA(results.list, c('user', 'id_str')),
        description = unlistWithNA(results.list, c('user', 'description')),
        geo_enabled = unlistWithNA(results.list, c('user', 'geo_enabled')),
        user_created_at = unlistWithNA(results.list, c('user', 'created_at')),
        statuses_count = unlistWithNA(results.list, c('user', 'statuses_count')),
        followers_count = unlistWithNA(results.list, c('user', 'followers_count')),
        favourites_count = unlistWithNA(results.list, c('user', 'favourites_count')),
        protected = unlistWithNA(results.list, c('user', 'protected')),
        user_url = unlistWithNA(results.list, c('user', 'url')),
        name = unlistWithNA(results.list, c('user', 'name')),
        time_zone = unlistWithNA(results.list, c('user', 'time_zone')),
        user_lang = unlistWithNA(results.list, c('user', 'lang')),
        utc_offset = unlistWithNA(results.list, c('user', 'utc_offset')),
        friends_count = unlistWithNA(results.list, c('user', 'friends_count')),
        screen_name = unlistWithNA(results.list, c('user', 'screen_name')),
        stringsAsFactors=F)

    # retweet_count is extracted from retweeted_status. If this is not a RT, set to zero
    df$retweet_count[is.na(df$retweet_count)] <- 0

    # adding geographic variables and url entities
    if (simplify==FALSE){
        df$country_code <- unlistWithNA(results.list, c('place', 'country_code'))
        df$country <- unlistWithNA(results.list, c('place', 'country'))
        df$place_type <- unlistWithNA(results.list, c('place', 'place_type'))
        df$full_name <- unlistWithNA(results.list, c('place', 'full_name'))
        df$place_name <- unlistWithNA(results.list, c('place', 'place_name'))
        df$place_id <- unlistWithNA(results.list, c('place', 'place_id'))
        place_lat_1 <- unlistWithNA(results.list, c('place', 'bounding_box', 'coordinates', 1, 1, 2))
        place_lat_2 <- unlistWithNA(results.list, c('place', 'bounding_box', 'coordinates', 1, 2, 2))
        df$place_lat <- sapply(1:length(results.list), function(x) 
            mean(c(place_lat_1[x], place_lat_2[x]), na.rm=TRUE))
        place_lon_1 <- unlistWithNA(results.list, c('place', 'bounding_box', 'coordinates', 1, 1, 1))
        place_lon_2 <- unlistWithNA(results.list, c('place', 'bounding_box', 'coordinates', 1, 3, 1))
        df$place_lon <- sapply(1:length(results.list), function(x) 
            mean(c(place_lon_1[x], place_lon_2[x]), na.rm=TRUE))
        df$lat <- unlistWithNA(results.list, c('geo', 'coordinates', 1))
        df$lon <- unlistWithNA(results.list, c('geo', 'coordinates', 2))
        df$expanded_url <- unlistWithNA(results.list, c('entities', 'urls', 1, 'expanded_url'))
        df$url <- unlistWithNA(results.list, c('entities', 'urls', 1, 'url'))

    }

    # information message
    if (verbose==TRUE) cat(length(df$text), "tweets have been parsed.", "\n")
    return(df)
}


unlistWithNA <- function(lst, field){
    if (length(field)==1){
        notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field]])))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst[notnulls], '[[', field))
    }
    if (length(field)==2){
        notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field[1]]][[field[2]]])))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst[notnulls], function(x) x[[field[1]]][[field[2]]]))
    }
    if (length(field)==3 & field[1]!="geo"){
        notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field[1]]][[field[2]]][[field[3]]])))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst[notnulls], function(x) x[[field[1]]][[field[2]]][[field[3]]]))
    }
    if (field[1]=="geo"){
        notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field[1]]][[field[2]]])))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst[notnulls], function(x) x[[field[1]]][[field[2]]][[as.numeric(field[3])]]))
    }

    if (length(field)==4 && field[2]!="urls"){
        notnulls <- unlist(lapply(lst, function(x) length(x[[field[1]]][[field[2]]][[field[3]]][[field[4]]])>0))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst[notnulls], function(x) x[[field[1]]][[field[2]]][[field[3]]][[field[4]]]))
    }
    if (length(field)==4 && field[2]=="urls"){
        notnulls <- unlist(lapply(lst, function(x) length(x[[field[1]]][[field[2]]])>0))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst[notnulls], function(x) x[[field[1]]][[field[2]]][[as.numeric(field[3])]][[field[4]]]))
    }
    if (length(field)==6 && field[2]=="bounding_box"){
        notnulls <- unlist(lapply(lst, function(x) length(x[[field[1]]][[field[2]]])>0))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst[notnulls], function(x) 
            x[[field[1]]][[field[2]]][[field[3]]][[as.numeric(field[4])]][[as.numeric(field[5])]][[as.numeric(field[6])]]))
    }
    return(vect)
}
