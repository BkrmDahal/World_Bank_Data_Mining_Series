########################################## WBS- Part3 - lappy to make individual file of each topic.R ##########################################
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
## required col from wdi

wdi_sub = wdi[ , c(1,3,5:60)]

##lets run anysis on country name only; country name in wdi file has other names like summary of region

country_sub = subset(country, country$`Currency Unit`!="" , 
                     select = c("Table Name", "Region")) # if currency unit is blank its not country
colnames(country_sub) <- c("Country Name", "Region")

##lets get list of all topic 

i_name_sub = as.data.frame(table(i_name$Topic))
i_name_sub = as.character(i_name_sub[,1])


###lets make single file of each list
lapply(i_name_sub, function(x){
## take each list as temp and get Indicator Name related to it
  temp = as.character(x)
  temp = subset(i_name, i_name$Topic==temp, select="Indicator Name")
  
##left join to get only those Indicator Name and country
  wdi_sub_temp = left_join(country_sub, wdi_sub)
  wdi_sub_temp = left_join(temp, wdi_sub_temp)
  
##gather date and expand Indicator Name
  wdi_sub_temp = gather(wdi_sub_temp, "years", "sample", 4:59)
  colnames(wdi_sub_temp) <- c("Indicator.Name", "Country.Name","Region" ,"years", "Value")
  wdi_sub_temp = dcast(wdi_sub_temp, Country.Name+years+Region~Indicator.Name, value.var = "Value", na.rm = T )
  
##make years as date 
  wdi_sub_temp$years = paste(wdi_sub_temp$years,"-01-01", sep="")
  wdi_sub_temp$years=as.Date(wdi_sub_temp$years, "%Y-%m-%d")
  
##let make unique ID in each dataset if we want to join later on for any analysis
  wdi_sub_temp$ID_for_join = paste(wdi_sub_temp$Country.Name, wdi_sub_temp$years, sep="-")
  
##save file 
  setwd(paste(filepath, "R_script/Output", sep="/"))
  csvname = paste(gsub(":",",",x),".csv",paste=" ")
  write.csv(wdi_sub_temp, file=csvname, row.names = F)
  setwd(filepath)
})

###total of 91 file will be produced
###You can find all 91 file here https://www.dropbox.com/sh/sk7f7uoz9t7mb38/AACxA8gGTXZJV90CycB4uT_Ka?dl=0
##download anyfile you need and play around.
#happy coding

#######################################################Bikram dahal########################################
