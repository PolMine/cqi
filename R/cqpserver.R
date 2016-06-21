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


  
