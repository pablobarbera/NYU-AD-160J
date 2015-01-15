#' @rdname getCommonHashtags
#' @export
#'
#' @title 
#' Find the N most common hashtags in a string vector
#'
#' @author
#' Pablo Barbera \email{pablo.barbera@@nyu.edu}
#'
#' @param text Vector containing tweet text
#'
#' @param n number of hashtags to display
#'

getCommonHashtags <- function(text, n=20){
    hashtags <- regmatches(text,gregexpr("#(\\d|\\w)+",text))
    hashtags <- unlist(hashtags)
    tab <- table(hashtags)
    return(head(sort(tab, dec=TRUE), n=n))
}




