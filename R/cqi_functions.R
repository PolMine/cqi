#' start CQP server 
#' 
#' The function will start the CQP server by way of a system call 
#' to cqpserver. 
#' @param registryDir path to the registry directory
#' @param initFile path to the init file required by cqpserver
#' @param debugMode logical, whether to run debug mode
#' @export startCqpServer
#' @rdname cqpserver
#' @name cqpserver
startCqpServer <- function(registryDir=NULL, initFile, debugMode=TRUE){
  if (is.null(registryDir)) registryDir <- Sys.getenv("CORPUS_REGISTRY")
  cmdRaw <- c(
    "cqpserver",
    "-I", initFile,
    "-r", registryDir,
    ifelse(debugMode, "-d ALL", "")
  )
  cmd <- paste(cmdRaw, collapse=" ")
  system(cmd)
}


#' authenticate with cqpserver
#' 
#' @param user user name
#' @param pw password
#' @export authenticate
#' @rdname cqpserver
authenticate <- function(user, pw){
  writeBin(c(as.raw(0), as.raw(17), as.raw(1), as.raw(0)), conn)
  # writeBin(c(as.raw(16), as.raw(1), c("\x11\x01"), conn)
  writeBin(as.raw(nchar(user)), conn)
  writeBin(user, conn)
  
  writeBin(as.raw(nchar(pw)), conn)
  writeBin(pw, conn)
  readBin(conn, what="raw", n=2)
}

#' cqi commands
#' @param attribute the corpus attribute ("CORPUS.pAttribute")
#' @param ids ids to convert
#' @rdname cqi_commands
#' @export cqi_id2str
cqi_id2str <- function(attribute, ids){
  writeBin(c(as.raw(20), as.raw(5), as.raw(0)), conn)
  writeBin(as.raw(nchar(attribute)), conn)
  writeBin(attribute, conn)
  ids <- c(1:100)
  writeBin(c(as.raw(0), as.raw(0), as.raw(length(ids))), conn)
  dummy <- lapply(
    c(1:100),
    function(i) writeBin(c(as.raw(0), as.raw(0), as.raw(0), as.raw(i)), conn)
  )
  readBin(conn, what="raw", n=4)
  foo <- readBin(conn, what="raw", n=4)
  n <- as.integer(foo)[length(foo)]
  tokens <- sapply(
    c(1:n),
    function(i){
      len <- readBin(conn, what="raw", n=1)
      readBin(conn, what="character", n=1)
    })
  tokens
}
