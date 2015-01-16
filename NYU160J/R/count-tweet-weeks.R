#' @rdname countWeeksTweets
#' @export
#'
#' @title 
#' Count the number of tweets sent by week
#'
#' @author
#' Pablo Barbera \email{pablo.barbera@@nyu.edu}
#'
#' @param dates Vector of dates in Twitter format
#'

countWeeksTweets <- function(dates){
  month = formatTwDate(dates, format="date")
  weeks <- seq(min(month), max(month), by="week")
  counts <- rep(NA, length(weeks)-1)
  for (i in 1:(length(weeks)-1)){
    counts[i] <- length(month[month>weeks[i] & month<=weeks[i+1]])
  }
  tweets.df <- data.frame(week=weeks[-length(weeks)], tweets=counts)
  return(tweets.df)
}
