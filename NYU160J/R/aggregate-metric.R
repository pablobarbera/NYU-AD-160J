#' @rdname aggregateMetric
#' @export
#'
#' @title 
#' Aggregates data from Facebook page by period of time
#'
#' @author
#' Pablo Barbera \email{pablo.barbera@@nyu.edu}
#'
#' @param page Data frame with Facebook page data
#'
#' @param metric Either "likes", "comments" or "shares"
#'
#' @param FUN function used to aggregate. Generally, "sum"
#'
#' @examples \dontrun{
#' ## example of Facebook data
#'   page = getPage("barackobama", token=my_oauth, n=300) 
#'	 page$datetime = formatFBdate(page$created_time)
#'   results = aggregate.metric(page, metric="likes")
#' }
#'

aggregateMetric <- function(page, metric, FUN) {
    page$month <- format(page$datetime, "%Y-%m")
    m <- aggregate(page[[paste0(metric, "_count")]], list(month = page$month), 
        sum)
    m$month <- as.Date(paste0(m$month, "-01"))
    m$metric <- metric
    return(m)
}
