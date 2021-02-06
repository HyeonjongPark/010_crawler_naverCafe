# library(lubridate)
# library(stringr)
# library(dplyr)
# library(tidyverse)
# library(padr)

# cafeWritten = readxl::read_excel("D:/workspace/python_workspace/01_cafeCrawler/naverCafeWrite_A.xlsx")
# 
# # cafeWritten$title
# # 
# # regex
# # regmatches(cafeWritten$title[1], regexpr("[\\[].+]", cafeWritten$title[20]))
# 
# 
# 
# 
# cafeWritten$date[str_length(cafeWritten$date) == 5] = paste0(gsub("-",".",Sys.Date()),".")
# cafeWritten$date = ymd(cafeWritten$date)
# 
# start_date = "2021-01-29"
# 
# cafeWritten$writer = gsub("'","",cafeWritten$writer)
# cafeWritten$writer = gsub("\\[","",cafeWritten$writer)
# cafeWritten$writer = gsub("\\]","",cafeWritten$writer)
# 
# 
# cafeWritten %>% as.data.frame()
# tid = cafeWritten %>% group_by(writer,date) %>% summarise(n = n()) %>% 
#   filter(date >= start_date) 
# 
# tid = as.data.frame(tid)
# 
# 
# 
# source("./src/06_members.R", encoding = "UTF-8")
# 
# 
# for(i in 1:length(writers)) {
#   if(tid %>% filter(writer == writers[i], date == start_date) %>% nrow() != 1) {
#     tid = rbind(tid, data.frame(writer = writers[i], 
#                                 date = start_date,
#                                 n = NA))
#     
#   }
#   
#   if(tid %>% filter(writer == writers[i], date == Sys.Date()) %>% nrow() != 1) {
#     tid = rbind(tid, data.frame(writer = writers[i], 
#                                 date = Sys.Date(),
#                                 n = NA))
#     
#   }
#   
#   
# }
# tid = tid %>% arrange(writer, date)
# tid[is.na(tid)] = 0
# 
# 
# tid2 = tid %>%
#   pad(group = 'writer', interval = 'day') %>%   # Explicitly fill by 1 min
#   fill_by_value(n)
# 
# 
# tid3 = tid2 %>% transform(logical_write = ifelse(n > 0, 1, 0))
# colnames(tid3)[3] = "n_write"






cafe_write_func = function(data, start_date, end_date) {
  
  # cafeWritten = readxl::read_excel("D:/workspace/python_workspace/01_cafeCrawler/naverCafeWrite_A.xlsx")
  
  data$date[str_length(data$date) == 5] = paste0(gsub("-",".",end_date),".")
  data$date = ymd(data$date)
  
  data$writer = gsub("'","",data$writer)
  data$writer = gsub("\\[","",data$writer)
  data$writer = gsub("\\]","",data$writer)
  
  
  tid = data %>% group_by(writer,date) %>% summarise(n = n()) %>% 
    filter(date >= start_date) 
  
  tid = as.data.frame(tid)
  
  
  
  
  for(i in 1:length(writers)) {
    if(tid %>% filter(writer == writers[i], date == start_date) %>% nrow() != 1) {
      tid = rbind(tid, data.frame(writer = writers[i], 
                                  date = start_date,
                                  n = NA))
      
    }
    
    if(tid %>% filter(writer == writers[i], date == end_date) %>% nrow() != 1) {
      tid = rbind(tid, data.frame(writer = writers[i], 
                                  date = end_date,
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
  
  return(tid3)
  
}


cafe_viwer_func = function(data, start_date, end_date) {
  
  data$date[str_length(data$date) == 5] = paste0(gsub("-",".",end_date),".")
  data$date = ymd(data$date)
  
  data$writer = gsub("'","",data$writer)
  data$writer = gsub("\\[","",data$writer)
  data$writer = gsub("\\]","",data$writer)
  
  
  data$viewCount = gsub(",", "", data$viewCount)
  data$viewCount = as.integer(data$viewCount)

  tid = data %>% group_by(writer) %>% summarise(ViewCount_total = sum(viewCount)) %>%
    arrange(desc(ViewCount_total))

  tid = as.data.frame(tid)

  return(tid)
  
}
