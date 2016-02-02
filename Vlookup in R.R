##################################Vlook up in R#######################################

##make data frame
master <-  data.frame(ID = 1:50, name = letters[1:50],
                           date = seq(as.Date("2016-01-01"), by = "week", len = 50))
                           
##lookup value
lookup =data.frame(id =  c(23, 50, 4, 45))
                           
                           
####load dplyr
required(dplyr)


##lookup
id_lookup = left_join(id, master, by="id") # output are only value that matches to id, if no match is found it return as NA
or
id_lookup = right_join(master, id, by="id")


###If column name are different you can
id = right_join(master, id, by=c("id"="id2"))

##rename column
colnames(id)[x]  = "id"   # x is cloume index
id = rename(id, id=id2)  # rename is dplyr funcation

###subset of data
id_lookup = id_lookup[ , -c("date")]
or
id_lookup = id_lookup[ , c("id", "date")
or
id_lookup = id_lookup[,c(1,3)]
or
id_lookup = subset(id_lookup, condition, select=c("id", "date"))



