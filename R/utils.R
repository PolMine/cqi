rawToMsg <- function(x){
  cqiMsg[as.character(as.integer(x[1])*256 + as.integer(x[2]))]
}

longIntToRaw <- function(x){
  eightDigits <- as.character(format(as.hexmode(x), 8))
  chunks <- sapply(c(0:3), function(i) substr(eightDigits, start=i*2+1, stop=i*2+2))
  unname(sapply(chunks, function(i) as.raw(as.hexmode(i))))
}

rawToInt <- function(x){
  result <- as.integer(x)
  as.integer(sum(result * (256^((length(result):1) - 1))))
}

