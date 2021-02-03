library(lubridate)
library(stringr)
library(dplyr)
library(tidyverse)
library(padr)

cafeWritten = readxl::read_excel("D:/workspace/python_workspace/01_cafeCrawler/naverCafeWrite.xlsx")

# cafeWritten$title
# 
# regex
# regmatches(cafeWritten$title[1], regexpr("[\\[].+]", cafeWritten$title[20]))




cafeWritten$date[str_length(cafeWritten$date) == 5] = paste0(gsub("-",".",Sys.Date()),".")
cafeWritten$date = ymd(cafeWritten$date)

start_date = "2021-01-28"


cafeWritten %>% as.data.frame()
tid = cafeWritten %>% group_by(writer,date) %>% summarise(n = n()) %>% 
  filter(date >= start_date) 

tid = as.data.frame(tid)



source("./src/06_members.R", encoding = "UTF-8")


for(i in 1:length(writers)) {
  if(tid %>% filter(writer == writers[i], date == start_date) %>% nrow() != 1) {
    tid = rbind(tid, data.frame(writer = writers[i], 
                                date = start_date,
                                n = NA))
    
  }
  
  if(tid %>% filter(writer == writers[i], date == Sys.Date()) %>% nrow() != 1) {
    tid = rbind(tid, data.frame(writer = writers[i], 
                                date = Sys.Date(),
                                n = NA))
    
  }
  
  
}
tid = tid %>% arrange(writer, date)
tid[is.na(tid)] = 0


tid2 = tid %>%
  pad(group = 'writer', interval = 'day') %>%   # Explicitly fill by 1 min
  fill_by_value(n)


tid3 = tid2 %>% transform(logical_write = ifelse(n > 0, 1, 0))
colnames(tid3)[3] = "n_write"


