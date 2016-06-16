# start server: 
# cqpserver -I cqpserver.init -r $CORPUS_REGISTRY -d ALL

user <- "blaette"
pw <- "simsalabim"
conn <- socketConnection("localhost", "4877", open="wb")

authenticate(user, pw)
authenticate <- function(user, pw){
  writeBin(c("\x11\x01"), conn)
  
  writeBin(as.raw(nchar(user)), conn)
  writeBin(user, conn)
  
  writeBin(as.raw(nchar(pw)), conn)
  writeBin(pw, conn)
}

system.time(a <- cqi_id2str())

cqi_id2str <- function(attribute="PLPRBTTXT.word", ids=c(1:100)){
  writeBin(c(as.raw(20), as.raw(5), as.raw(0)), conn)
  writeBin(as.raw(nchar(attribute)), conn)
  writeBin(attribute, conn)
  ids <- c(1:100)
  writeBin(c(as.raw(0), as.raw(0), as.raw(length(ids))), conn)
  dummy <- lapply(
    c(1:100),
    function(i) writeBin(c(as.raw(0), as.raw(0), as.raw(0), as.raw(i)), conn)
  )
  readBin(conn, what="raw", n=2)
  foo <- readBin(conn, what="raw", n=2)
  n <- as.integer(foo)[length(foo)]
  n <- 100
  tokens <- sapply(
    c(1:n),
    function(i){
      len <- readBin(conn, what="raw", n=1)
      readBin(conn, what="character", n=1)
    })
  tokens
}

writeBin(c("\x13\x01"), conn)
x <- 1
ret <- readLines(conn)
conn <- readBin(conn, what="integer", size <- endian="little")
while( x>0 ){
  corpus <- readBin(conn, what="character", n=1)  
  x <- length(corpus)
  print(corpus)
}

# command: id2str

writeBin(intToBits(2), conn)
writeBin(c("", "", "\x05"), conn) # 1 
writeBin(c("", "", "\x01"), conn) # 1 
writeBin(c("", "", "\x02"), conn) # 1 
writeBin(c("", "", "\x03"), conn) # 1 
writeBin(c("", "", "\x04"), conn) # 1 
writeBin(c("", "", "\x05"), conn) # 1 
writeBin(c("", "", 1), conn, useBytes=TRUE)
writeBin("", conn)
