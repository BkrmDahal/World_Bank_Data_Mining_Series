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



##lets get only one Topic

 i_name_sub = subset(i_name, i_name$Topic=="Public Sector: Defense & arms trade", select="Indicator Name")



wdi_sub = left_join(country_sub, wdi_sub)
wdi_sub = left_join(i_name_sub, wdi_sub)

####lets gather all data into narrow form 

wdi_sub = gather(wdi_sub, "years", "sample", 4:59)

#### Rename for easy handling

colnames(wdi_sub) <- c("Indicator.Name", "Country.Name","Region" ,"years", "Value")

#### lets put indicator name in colume name

wdi_sub = dcast(wdi_sub, Country.Name+years+Region~Indicator.Name, value.var = "Value", na.rm = T )

###add month and day for motion chart 

wdi_sub$years = paste(wdi_sub$years,"-01-01", sep="")

wdi_sub$years=as.Date(wdi_sub$years, "%Y-%m-%d")


###google motion chart 
M = gvisMotionChart(wdi_sub, idvar = "Country.Name", timevar = "years", colorvar = "Region",
                    
                    options = list(width = 700, height = 600), chartid= "country_gdp")

plot(M)
setwd(filepath)
dir.create("Output")
setwd(paste(filepath, "Output", sep="/"))
write.csv(wdi_sub, file="Public Sector: Defense & arms trade.csv")
setwd(filepath)
rm(list=ls())

###########################################################Bikram Dahal############################################
