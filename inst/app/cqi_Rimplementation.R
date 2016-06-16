user <- "blaette"
pw <- "simsalabim"

conn <- socketConnection("localhost", "4877", open="wb")
authenticate(user, pw)


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

base64decode("0101", what="raw")


writeBin(c("\x13\x01"), conn)
x <- 1
ret <- readLines(conn)
conn <- readBin(conn, what="integer", size <- endian="little")
while( x>0 ){
  corpus <- readBin(conn, what="character", n=1)  
  x <- length(corpus)
  print(corpus)
}
