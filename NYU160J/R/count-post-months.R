#' @rdname countMonthsPosts
#' @export
#'
#' @title 
#' Count the number of posts sent by month
#'
#' @author
#' Pablo Barbera \email{pablo.barbera@@nyu.edu}
#'
#' @param dates Vector of dates in Facebook format
#'

countMonthsPosts <- function(dates){
    month = formatFbDate(dates, format="date")
    month = substr(month, 1, 7)
    month = as.Date(paste0(month, "-01"))
    month = table(month)
    month.x <- seq(as.Date(names(month)[1]), 
    	as.Date(names(month)[length(month)]), by="month")
    posts.df <- data.frame(month = month.x, posts = 0,
        stringsAsFactors=F)
    posts.df$posts[month.x %in% as.Date(names(month))] <- 
    	as.numeric(month)
    return(posts.df)
}



