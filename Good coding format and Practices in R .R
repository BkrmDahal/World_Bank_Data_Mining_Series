#######################################Daily_mail and dispatch_cockpit###############################
#######open VPN Client ######
##Send a mail to all seller manager and make output for dispatch cockpit
#delisted file from BI, order from BOB

#################load required package
suppressPackageStartupMessages(require("dplyr"))
suppressPackageStartupMessages(require("mailR"))
suppressPackageStartupMessages(require("xtable"))
suppressPackageStartupMessages(require("lubridate"))
suppressPackageStartupMessages(require("tidyr"))
suppressPackageStartupMessages(require("htmlTable"))
suppressPackageStartupMessages(require("googlesheets"))
currentDate = Sys.Date()



#########Set the file dir
#set input to require directory
setwd("M:/R_Script")
filepath=getwd()
setwd(paste(filepath, "Input", sep="/"))


####Read files from input
seller = read.csv("sellers_delisting.csv", stringsAsFactors = F)
order = read.csv("order.csv")

##subset
temp = subset(seller, seller$Date.delisted> as.Date(Sys.Date())-30 & 
                  seller$Status =="Delisted", select = c("Seller.Name..Dups.will.be.highlighted.in.yellow.","Reason.for.delisting"))
#summarize
seller_delisted = table(temp$Seller.Name..Dups.will.be.highlighted.in.yellow., temp$Reason.for.delisting)


#Save the the file

setwd("M:/Daily/Daily")
dir.create(as.character(currentDate))
setwd(paste("M:/Daily/Daily", currentDate, sep="/"))
csvFileName1 = paste("Threshold limit and seller delisted",currentDate,".csv",sep=" ") 
write.csv(seller_delisted, file=csvFileName1, row.names = F)

rm(list=ls())


##################################################Bikram Dahal#################################
