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
    month = as.Date(paste0(names(months), "-01"))
    month.x <- seq(month[1], month[length(month)], by="month")
    tweets.df <- data.frame(month = month.x, tweets = 0,
        stringsAsFactors=F)
    tweets.df$tweets[month.x %in% month] <- as.numeric(months)
    return(tweets.df)
}



