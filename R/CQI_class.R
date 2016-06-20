# cqpserver -I /Library/Frameworks/R.framework/Versions/3.2/Resources/library/cqi/init/cqpserver.init -r /Users/blaette/Lab/cwb/registry
# cqpserver -I /home/blaette/tmp/cqpserver.init -r /var/local/cwb/registry_files -P 8787
# foo$authenticate("polmine.sowi.uni-due.de", "8787", "blaette", "simsalabim")

CQI <- R6Class(
  
  "CQI",
  
  private = list(
  ),
  
  
  public = list(
    connection = NULL,
    
    cqi_send_int = function(x){
      writeBin(longIntToRaw(x), self$connection)  
    },
    
    cqi_send_int_list = function(x){
      writeBin(longIntToRaw(length(x)), self$connection)  
      sapply(x, self$cqi_send_int)
    },
    
    cqi_send_word = function(x){
      writeBin(c(as.raw(0), unname(unlist(x))), self$connection)
    },
    
    cqi_read_word = function(n=2){
      readBin(self$connection, what="raw", n=n)
    },
    
    cqi_read_string = function(){
      strLengthRaw <- self$cqi_read_word()
      strLength <- as.integer(strLengthRaw[length(strLengthRaw)])
      strRaw <- readBin(self$connection, what="raw", n=strLength)
      rawToChar(strRaw)
    },
    
    cqi_expect_string = function(){
      self$cqi_read_word()
      self$cqi_read_string()
    },
    
    cqi_send_string = function(x){
      writeBin(longIntToRaw(nchar(x))[3:4], self$connection)
      writeLines(x, self$connection, sep="")
    },
    
    cqi_send_string_list = function(strs){
      self$cqi_send_int(length(strs))
      sapply(strs, self$cqi_send_string)
    },
    
    cqi_read_int = function(){
      lenRaw <- readBin(self$connection, what="raw", n=4)
      rawToInt(lenRaw)
    },
    
    cqi_expect_int = function(){
      #status <- readBin(self$connection, what="raw", n=2)
      self$cqi_read_word()
      self$cqi_read_int()
    },
    
    cqi_expect_int_list = function(){
      self$cqi_read_word() # status message
      len <- self$cqi_read_int()
      sapply(c(1:len), function(i) self$cqi_read_int())
    },
    
    cqi_read_string_list = function(){
      len <- self$cqi_read_int()
      sapply(c(1:len), function(i) self$cqi_read_string())
    },
    
    cqi_expect_string_list = function(){
      self$cqi_read_word()
      self$cqi_read_string_list()
    },
    
    authenticate = function(host="localhost", port="4877", user="anonymous", pw=""){
      self$connection <- socketConnection(host, port, open="wb")
      self$cqi_send_word(cqiCmd[["CQI_CTRL_CONNECT"]])
      self$cqi_send_string(user)
      self$cqi_send_string(pw)
      Sys.sleep(0.1)
      status <- self$cqi_read_word()
      message("... ", rawToMsg(status))
    },
    
    cqi_list_corpora = function(){
      self$cqi_send_word(cqiCmd[["CQI_CORPUS_LIST_CORPORA"]])
      Sys.sleep(0.1)
      self$cqi_read_word()
      self$cqi_read_string_list()
    },
    
    cqi_attribute_size = function(attribute){
      self$cqi_send_word(cqiCmd[["CQI_CL_ATTRIBUTE_SIZE"]])
      self$cqi_send_string(attribute)
      Sys.sleep(0.1)
      self$cqi_expect_int()
    },
    
    cqi_charset = function(corpus){
      self$cqi_send_word(cqiCmd[["CQI_CORPUS_CHARSET"]])
      self$cqi_send_string(corpus)
      Sys.sleep(0.1)
      self$cqi_expect_string()
    },
    
    cqi_lexicon_size = function(attribute){
      self$cqi_send_word(cqiCmd[["CQI_CL_LEXICON_SIZE"]])
      self$cqi_send_string(attribute)
      Sys.sleep(0.1)
      self$cqi_expect_int()
    },
    
    cqi_str2id = function(attribute, strs){
      self$cqi_send_word(cqiCmd[["CQI_CL_STR2ID"]])
      self$cqi_send_string(attribute)
      self$cqi_send_string_list(strs)
      Sys.sleep(0.1)
      self$cqi_expect_int_list()
    },
    
    cqi_id2str = function(attribute, ids){
      self$cqi_send_word(cqiCmd[["CQI_CL_ID2STR"]])
      self$cqi_send_string(attribute)
      self$cqi_send_int_list(ids)
      Sys.sleep(0.1)
      self$cqi_expect_string_list()
    }
    
  )
)
