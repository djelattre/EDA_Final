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
library(data.table)

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

#Question 6:
#Compare emissions from motor vehicle sources in Baltimore City with emissions from 
#motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

# Subset data.frame, filter on type fips and ON-ROAD
aggBC<-summarise(group_by(filter(NEI, fips == "24510" & type == 'ON-ROAD'), year), Emissions=sum(Emissions))
aggLA<-summarise(group_by(filter(NEI, fips == "06037" & type == 'ON-ROAD'), year), Emissions=sum(Emissions))

# Calculate variation
aggBC <- as.data.table(aggBC)
aggBC[,EvoPrevMonth := (Emissions-shift(Emissions))/shift(Emissions)]
aggBC$EvoPrevMonth <- paste(round(aggBC$EvoPrevMonth*100,2),"%")
aggBC$city <- "Baltimore City, Maryland"

aggLA <- as.data.table(aggLA)
aggLA[,EvoPrevMonth := (Emissions-shift(Emissions))/shift(Emissions)]
aggLA$EvoPrevMonth <- paste(round(aggLA$EvoPrevMonth*100,2),"%")
aggLA$city <- "Los Angeles, California"

# Merge
aggTot <- bind_rows(aggBC,aggLA)
rm(aggBC,aggLA)

# Build plot and save it as png
png("plot6.png", width=640, height=640)
q6 <- ggplot(aggTot, aes(x=factor(year), y=Emissions, label=EvoPrevMonth)) +
	geom_bar(stat="identity",aes(colour=city,fill=city)) +
	#scale_fill_brewer(palette="Set2") +
	facet_grid(.~city) +
	xlab("Years") +
	ylab(expression('Total PM'[2.5]*' emission')) +
	ggtitle("Total emissions from motor vehicle (type ON-ROAD) in \nBaltimore City, Maryland Vs Los Angeles, California from 1999 to 2008") +
	geom_label() +
	theme(legend.position="bottom")
print(q6)
dev.off()
