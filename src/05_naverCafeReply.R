
library(lubridate)
library(stringr)
library(dplyr)
library(tidyverse)
library(padr)

cafeRepl = readxl::read_excel("D:/workspace/python_workspace/01_cafeCrawler/naverCafeReply.xlsx")

cafeRepl$date[str_length(cafeRepl$date) == 5] = paste0(gsub("-",".",Sys.Date()),".")
cafeRepl$date = ymd(cafeRepl$date)

start_date = "2021-01-28"


cafeRepl$writer = gsub("'","",cafeRepl$writer)
cafeRepl$writer = gsub("\\[","",cafeRepl$writer)
cafeRepl$writer = gsub("\\]","",cafeRepl$writer)
cafeRepl$writer %>% unique


tid_Repl = cafeRepl %>% group_by(writer,date) %>% summarise(n = n()) %>% 
  filter(date >= start_date) 

tid_Repl = as.data.frame(tid_Repl)




source("./src/06_members.R", encoding = "UTF-8")


for(i in 1:length(writers)) {
  if(tid_Repl %>% filter(writer == writers[i], date == start_date) %>% nrow() != 1) {
    tid_Repl = rbind(tid_Repl, data.frame(writer = writers[i], 
                                date = start_date,
                                n = NA))
    
  }
  
  if(tid_Repl %>% filter(writer == writers[i], date == Sys.Date()) %>% nrow() != 1) {
    tid_Repl = rbind(tid_Repl, data.frame(writer = writers[i], 
                                date = Sys.Date(),
                                n = NA))
    
  }
  
  
}
tid_Repl = tid_Repl %>% arrange(writer, date)
tid_Repl[is.na(tid_Repl)] = 0



tid_Repl2 = tid_Repl %>%
  pad(group = 'writer', interval = 'day') %>%   # Explicitly fill by 1 min
  fill_by_value(n)



tid_Repl3 = tid_Repl2 %>% transform(logical_reply = ifelse(n >= 5, 1, 0))
colnames(tid_Repl3)[3] = "n_reply"

