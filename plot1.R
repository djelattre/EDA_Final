#----------------------------------------------------------
# Set locale to English
#----------------------------------------------------------

Sys.setlocale("LC_TIME", "English")

#----------------------------------------------------------
# Load library
#----------------------------------------------------------

library(RColorBrewer)

#----------------------------------------------------------
# Code
#----------------------------------------------------------

# Load Data
# This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
  NEI <- readRDS("./data/summarySCC_PM25.rds")
}
if(!exists("SCC")){
  SCC <- readRDS("./data/Source_Classification_Code.rds")
}

#Question 1:
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from all 
#sources for each of the years 1999, 2002, 2005, and 2008.

# Aggregate data
aggEmissionByYear <- aggregate(Emissions ~ year, NEI, sum,na.rm=TRUE)

# Build plot and save it as png
png("plot1.png", width=640, height=640)
with(aggEmissionByYear, plot(Emissions~year,type="o",lty=2,xlab="Years",ylab=expression('Total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emission in the United States from 1999 to 2008'),pch=19,col=brewer.pal(8,"Set2")))
dev.off()
