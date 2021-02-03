
rm(list = ls())

source("./src/04_naverCafeWrite.R", encoding = "UTF-8")
source("./src/05_naverCafeReply.R", encoding = "UTF-8")




tid3 %>% head
tid_Repl3 %>% head

total = merge(tid3, tid_Repl3)


total$n_write = NULL
total$n_reply = NULL

total %>% head



