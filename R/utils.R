cqi_send_byte <- function(x){
}

cqi_send_word <- function(x, conn){
  # writeBin(c(unname(unlist(x)), as.raw(0)), conn)
  # writeBin(c(as.raw(0), unname(unlist(x)), as.raw(0)), conn)
  writeBin(c(as.raw(0), unname(unlist(x))), conn)
  # writeBin(x, conn)
  # writeBin(as.raw(0), conn)
}

cqi_send_int <- function(x, conn, stump=TRUE){
  if (stump == FALSE){
    writeBin(longIntToRaw(x), conn)  
  } else {
    writeBin(longIntToRaw(x)[2:4], conn)  
  }
  
}


cqi_send_string <- function(x, conn){
  # writeBin(as.raw(nchar(x)), conn)
  # writeBin(longIntToRaw(nchar(x))[4], conn)
  writeBin(longIntToRaw(nchar(x))[3:4], conn)
  writeLines(x, conn, sep="")
}

cqi_send_byte_list <- function(x){
}

cqi_send_word_list <- function(x){
}

cqi_send_int_list <- function(x, conn){
  writeBin(longIntToRaw(length(x))[2:4], conn)
  lapply(x, function(i) cqi_send_int(i, conn))
}

cqi_send_string_list <- function(strList, conn){
  # writeBin(longIntToRaw(length(strList))[2:4], conn)
  cqi_send_int(length(strList), conn, stump=FALSE)
  dummy <- lapply(strList, function(x) cqi_send_string(x, conn))
}

cqi_flush <- function(){
}

cqi_read_byte <- function(){
}

cqi_read_word <- function(conn){
  lenRaw <- readBin(conn, what="raw", n=2)
  as.integer(lenRaw)[length(lenRaw)]
}

cqi_read_int <- function(conn){
  lenRaw <- readBin(conn, what="raw", n=4)
  rawToInt(lenRaw)
}

cqi_read_string <- function(conn){
  len <- cqi_read_word(conn)
  readBin(conn, what="character", n=1)
}

cqi_read_byte_list <- function(){
}

cqi_read_word_list <- function(){
}

cqi_read_int_list <- function(conn){
  no <- cqi_read_int(conn)
  unlist(sapply(c(1:no), function(i) cqi_read_int(conn)))
}

cqi_read_string_list <- function(conn){
  len <- cqi_read_int(conn)
  dummy <- readBin(conn, what="raw", n=1)
  unlist(sapply(c(1:len-1), function(i) cqi_read_string(conn)))
}

cqi_read_int_table <- function(){
}

cqi_expect_string <- function(conn){
  status <- readBin(conn, what="raw", n=2)
  dummy <- readBin(conn, what="raw", n=1)
  # cqi_read_word(conn)
  cqi_read_string(conn)
}

cqi_expect_int <- function(conn){
  status <- readBin(conn, what="raw", n=2)
  cqi_read_int(conn)
}

cqi_expect_int_list <- function(conn){
  status <- readBin(conn, what="raw", n=2)
  print(status)
  cqi_read_int_list(conn)
}
