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

#Question 2:
#Have total emissions from PM2.5 decreased in the Baltimore City, 
#Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
#system to make a plot answering this question.

# Subset data.frame
subsetBC <- subset(NEI, fips == "24510")

# Aggregate data
aggEmissionByYearBC <- aggregate(Emissions ~ year, subsetBC, sum,na.rm=TRUE)

# Build plot and save it as png
png("plot2.png", width=640, height=640)
with(aggEmissionByYearBC, plot(Emissions~year,type="o",lty=2,xlab="Years",ylab=expression('Total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emission in the Baltimore City, Maryland from 1999 to 2008'),pch=19,col=brewer.pal(8,"Set2")))
dev.off()
