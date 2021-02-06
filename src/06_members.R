library(stringr)


# library(excel.link)
# writers_df = xl.read.file("./data/members.xlsx")
# for(i in 1:length(writers_df$habit_mate)) {
#   if(grepl("\\(", writers_df$habit_mate[i])) {
#     writers_df$habit_mate[i] = regmatches(writers_df$habit_mate[i], regexpr(".+[(]", writers_df$habit_mate[i]))
#   }
# }
# writers_df$habit_mate = gsub("\\(","",writers_df$habit_mate)

# write.csv(writers_df,"./data/members.csv")

writers_df = read.csv("./data/members.csv")






