#----------------------------------------------------------
# Set locale to English
#----------------------------------------------------------

Sys.setlocale("LC_TIME", "English")

#----------------------------------------------------------
# Load library
#----------------------------------------------------------

library(RColorBrewer)
library(dplyr) #for fun, just to change the way of aggregating data
library(ggplot2)

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

#Question 3:
#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
#variable, which of these four sources have seen decreases in emissions from 1999–2008 
#for Baltimore City? Which have seen increases in emissions from 1999–2008? 
#Use the ggplot2 plotting system to make a plot answer this question.

# Subset data.frame, filter on 1999 and 2008
subsetBC2 <- subset(NEI, fips == "24510" & year %in% c(1999,2008) )

# Aggregate data with dplyr for fun
aggEmissionByYearBC2 <- summarize(group_by(subsetBC2, year,type), Emissions=sum(Emissions),na.rm=TRUE)

# Build plot and save it as png
png("plot3.png", width=640, height=640)
q3 <- ggplot(aggEmissionByYearBC2, aes(x=factor(year), y=Emissions, group=type, color=type)) +
	geom_point() +
	geom_line() +
	facet_grid(.~type) +
	xlab("Years") +
	ylab(expression('Total PM'[2.5]*' emission')) +
	ggtitle(expression('Total PM'[2.5]*' emission in the Baltimore City, Maryland in 1999 and 2008'))
print(q3)
dev.off()
