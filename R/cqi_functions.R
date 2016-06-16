#' start CQP server 
#' 
#' The function will start the CQP server by way of a system call 
#' to cqpserver. 
#' @param registryDir path to the registry directory
#' @param initFile path to the init file required by cqpserver
#' @param debugMode logical, whether to run debug mode
#' @export startServer
#' @rdname cqpserver
#' @name cqpserver
startServer <- function(
  registryDir=Sys.getenv("CORPUS_REGISTRY"),
  initFile=system.file("init", "cqpserver.init", package="cqi"),
  debugMode=TRUE,
  exec=TRUE
  ){
  cmdRaw <- c(
    "cqpserver",
    "-I", initFile,
    "-r", registryDir,
    ifelse(debugMode, "-d ALL", "")
  )
  cmd <- paste(cmdRaw, collapse=" ")
  if (exec == TRUE) {
    system(cmd)
  } else {
    return(cmd)
  }
}


  

#' authenticate with cqpserver
#' 
#' @param host host, defaults to 'localhost'
#' @param port port, defaults to '4877'
#' @param user user name
#' @param pw password
#' @export authenticate
#' @rdname cqpserver
authenticate <- function(host="localhost", port="4877", user="anonymous", pw=""){
  conn <- socketConnection(host, port, open="wb")
  writeBin(c(as.raw(0), unname(unlist(cqiCmd[["CQI_CTRL_CONNECT"]])), as.raw(0)), conn)
  writeBin(as.raw(nchar(user)), conn)
  writeBin(user, conn)
  
  writeBin(as.raw(nchar(pw)), conn)
  writeLines(pw, conn, sep="")
  status <- readBin(conn, what="raw", n=2)
  cqiFeedback <- rawToMsg(status)
  message("... ", cqiFeedback)
  conn
}

cqi_list_corpora <- function(conn){
  writeBin(c(unname(unlist(cqiCmd[["CQI_CORPUS_LIST_CORPORA"]])), as.raw(0)), conn)
  status <- readBin(conn, what="raw", n=2)
  cqi_read_string_list(conn)
}

cqi_charset <- function(conn, corpus){
  # writeBin(c(unname(unlist(cqiCmd[["CQI_CORPUS_CHARSET"]])), as.raw(0)), conn)
  cqi_send_word(cqiCmd[["CQI_CORPUS_CHARSET"]], conn)
  cqi_send_string(corpus, conn)
  cqi_expect_string(conn)
}

cqi_attribute_size <- function(conn, attribute){
  # writeBin(c(unname(unlist(cqiCmd[["CQI_CL_ATTRIBUTE_SIZE"]])), as.raw(0)), conn)
  cqi_send_word(cqiCmd[["CQI_CL_ATTRIBUTE_SIZE"]], conn)
  cqi_send_string(attribute, conn)
  cqi_expect_int(conn)
}

cqi_lexicon_size <- function(conn, attribute){
  # writeBin(c(unname(unlist(cqiCmd[["CQI_CL_LEXICON_SIZE"]])), as.raw(0)), conn)
  cqi_send_word(cqiCmd[["CQI_CL_LEXICON_SIZE"]], conn)
  cqi_send_string(attribute, conn)
  cqi_expect_int(conn)
}

cqi_str2id <- function(C, attribute, vect){
  # writeBin(c(unname(as.raw(0), unlist(cqiCmd[["CQI_CL_STR2ID"]])), as.raw(0)), conn)
  cqi_send_word(cqiCmd[["CQI_CL_STR2ID"]], C)
  cqi_send_string(attribute, C)
  cqi_send_string_list(vect, C)
  # cqi_flush();
  retval <- cqi_expect_int_list(C)
  retval
}


#' cqi commands
#' @param attribute the corpus attribute ("CORPUS.pAttribute")
#' @param ids ids to convert
#' @rdname cqi_commands
#' @export cqi_id2str
cqi_id2str <- function(attribute, ids){
  writeBin(c(unname(unlist(cqiCmd[["CQI_CL_ID2STR"]])), as.raw(0)), conn)
  cqi_send_string(x=attribute, conn)
  cqi_send_int_list(ids, conn)
  status <- readBin(conn, what="raw", n=2)
  foo <- readBin(conn, what="raw", n=4)
  n <- as.integer(foo)[length(foo)]
  tokens <- sapply(
    c(1:length(ids)),
    function(i){
      len <- readBin(conn, what="raw", n=1)
      readBin(conn, what="character", n=1)
    })
  tokens
}
