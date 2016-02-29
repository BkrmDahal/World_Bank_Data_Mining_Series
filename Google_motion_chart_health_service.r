###loading packages

require("dplyr")
library(googleVis)


# Import file and change date string to date
setwd("M:/R_Script")
filepath=getwd()
setwd(paste(filepath, "Input", sep="/"))

bob=read.csv("https://raw.githubusercontent.com/BkrmDahal/csv_file/master/Health.Health.services.csv")
bob$years=as.Date(bob$years, "%d/%m/%Y")

##motionhart

M = gvisMotionChart(bob, idvar = "Country.Name", timevar = "years", colorvar = "Region",
                    options = list(width = 700, height = 600), chartid= "country_gdp")
plot(M)

print(M, file="Health Services.html")

