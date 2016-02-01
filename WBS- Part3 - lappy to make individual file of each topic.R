##########################################WBS - Part 2 - Data Data Visualization ##########################################
###download world bank data "http://data.worldbank.org/products/wdi" >> "Data catalog downloads (Excel | CSV)">>  "CSV"
##unzip and keep in directory of your choice my is "M:/R_scripts/Combine"


#################load required package

##if (!require("dplyr")) install.packages('dplyr') # if you are not sure if package is installed
suppressPackageStartupMessages(require("dplyr"))
suppressPackageStartupMessages(require("tidyr"))
suppressPackageStartupMessages(require("reshape2"))
suppressPackageStartupMessages(require("readr"))
suppressPackageStartupMessages(require("googleVis"))
currentDate = Sys.Date()


#########Set the file directory

setwd("M:/")
filepath=getwd()
setwd(paste(filepath, "R_Script/Combine", sep="/"))

#####readfile from your directory

wdi = read_csv("WDI_Data.csv")

country = read_csv("WDI_Country.csv")

i_name= read_csv("WDI_Series.csv")

#### create subset of above data, select only required row
##select only data after 1980 and required col from wdi

wdi_sub = wdi[ , c(1,3,5:60)]


##lets run anysis on country name only; country name in wdi file has other names like summary of region

country_sub = subset(country, country$`Currency Unit`!="" , 
                     select = c("Table Name", "Region")) # if currency unit is blank its not country
colnames(country_sub) <- c("Country Name", "Region")



##lets get only all topic 

i_name_sub = as.data.frame(table(i_name$Topic))
i_name_sub = as.character(i_name_sub[,1])


###lets make single file of each list
lapply(i_name_sub, function(x){
  temp = as.character(i_name_sub[x])
  temp = subset(i_name, i_name$Topic==temp, select="Indicator Name")
  wdi_sub_temp = left_join(country_sub, wdi_sub)
  wdi_sub_temp = left_join(temp, wdi_sub_temp)
  wdi_sub_temp = gather(wdi_sub_temp, "years", "sample", 4:59)
  colnames(wdi_sub_temp) <- c("Indicator.Name", "Country.Name","Region" ,"years", "Value")
  wdi_sub_temp = dcast(wdi_sub_temp, Country.Name+years+Region~Indicator.Name, value.var = "Value", na.rm = T )
  wdi_sub_temp$years = paste(wdi_sub_temp$years,"-01-01", sep="")
  
  wdi_sub_temp$years=as.Date(wdi_sub_temp$years, "%Y-%m-%d")
  setwd(paste(filepath, "Output", sep="/"))
  csvname = paste(gsub(":",",",i_name_sub[x]),".csv",paste=" ")
  write.csv(wdi_sub_temp, file=csvname)
  setwd(filepath)
})
