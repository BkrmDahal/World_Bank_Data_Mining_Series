##########################################Data cleaning and manipulation ##########################################
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

wdi_sub = wdi[ , c(1,3,5:60)]


##lets run anysis on country name only; country name in wdi file has other names like summary of region

country_sub = subset(country, country$`Currency Unit`!="" , 
                     select = c("Table Name", "Region")) # if currency unit is blank its not country
colnames(country_sub) <- c("Country Name", "Region")



##lets get only one Topic

# i_name_sub = subset(i_name, i_name$Topic=="Public Sector: Defense & arms trade", select="Indicator Name")

##OR get particular Indicator Name

#to remove multiple comment just select line click shif+ctrl+c
i_name_sub = subset(i_name, i_name$`Indicator Name`=="Foreign direct investment, net (BoP, current US$)" |
                      i_name$`Indicator Name`=="GDP growth (annual %)" | 
                      i_name$`Indicator Name`=="Population density (people per sq. km of land area)" |
                      i_name$`Indicator Name`=="CO2 emissions (kt)" |
                      i_name$`Indicator Name`=="Access to electricity (% of population)" |
                      i_name$`Indicator Name`=="Forest area (% of land area)" |
                      i_name$`Indicator Name`=="Inflation, consumer prices (annual %)" |
                      i_name$`Indicator Name`=="Life expectancy at birth, total (years)" |
                      i_name$`Indicator Name`=="Birth rate, crude (per 1,000 people)" , select="Indicator Name")

####let join all data to get only required data

wdi_sub = left_join(country_sub, wdi_sub)
wdi_sub = left_join(i_name_sub, wdi_sub)

###########################################################Bikram Dahal############################################

