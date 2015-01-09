#' @rdname word.frequencies
#' @export
#'
#' @title 
#' Counts words in a string vector
#'
#' @description
#' \code{word.frequencies} splits a string vector into words and returns
#' a data frame with each unique word and how many times it was used.
#'
#' @author
#' Pablo Barbera \email{pablo.barbera@@nyu.edu}
#'
#' @param text string or string vector, text from which words are counted
#'
#' @param stopwords Additional stopwords to be removed. 
#'
#' @param verbose logical, default is \code{TRUE}, which generates some output to the
#' R console with information.
#'
#' @examples \dontrun{
#' ## connect to the Mongo database
#'  mongo <- mongo.create("SMAPP_HOST:PORT", db="DATABASE")
#'  mongo.authenticate(mongo, username="USERNAME", password="PASSWORD", db="DATABASE")
#'  set <- "DATABASE.COLLECTION"
#'
#' ## extract text from all tweets in the database
#'  tweets <- extract.tweets(set, fields="text")
#' 
#' ## count words
#'  wordFreq <- word.frequencies(tweets$text)
#' }
#'

word.frequencies <- function(text, stopwords=NULL, verbose=TRUE, sparsity=0.999){
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
    myTdm2 <- removeSparseTerms(myTdm, sparsity)   
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

