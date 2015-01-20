#' @rdname create_matrix
#' @export

#' @title 
#' Creates data matrix from text


create_matrix <- function(text, sparsity=.998){
    require(tm)

    cat("Removing punctuation... ")
    text2 <- gsub("|\\\\|\\.|\\,|\\;|\\:|\\'|\\&|\\-|\\?|\\!|\\)|\\(|-|‘|\\n|\\’|\\“|\\[", "", text) 
    text2 <- gsub('\\"', "", text2) 
    cat("done!\n")
    # preparing corpus of words
    if (Sys.info()['sysname']=="Darwin"){
        text3 <- iconv(text2, to='UTF-8-MAC', sub='byte')
    }
    if (Sys.info()['sysname']=="Windows"){
        text3 <- iconv(enc2utf8(text2), sub='byte')
    }
   
    # convert to lower case
    cat("Converting to lowercase... ")
    text3 <- tolower(text3)
    cat("done!\n")
    # remove numbers
    cat("Removing digits and URLs... ")
    text3 <- removeNumbers(text3)

    # remove URLS
    removeURL <- function(x) gsub('"(http.*) |(http.*)$|\n', "", x)
    cat("done!\n")
    text3 <- removeURL(text3)

    # building document term matrix
    cat("Counting words... ")
    myTdm <- TermDocumentMatrix(Corpus(VectorSource(text3)), control=list(minWordLength=3))
    return(myTdm)

}
