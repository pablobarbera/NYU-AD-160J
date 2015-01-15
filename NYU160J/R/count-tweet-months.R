#' @rdname countMonthsTweets
#' @export
#'
#' @title 
#' Count the number of tweets sent by month
#'
#' @author
#' Pablo Barbera \email{pablo.barbera@@nyu.edu}
#'
#' @param dates Vector of dates in Twitter format
#'

countMonthsTweets <- function(dates){
    month = formatTwDate(dates, format="date")
    month = substr(month, 1, 7)
    month = as.Date(paste0(month, "-01"))
    month = table(month)
    month.x <- seq(as.Date(names(month)[1]), 
    	as.Date(names(month)[length(month)]), by="month")
    tweets.df <- data.frame(month = month.x, tweets = 0,
        stringsAsFactors=F)
    tweets.df$tweets[month.x %in% as.Date(names(month))] <- 
    	as.numeric(month)
    return(tweets.df)
}



