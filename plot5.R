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

#Question 5:
#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Subset data.frame, filter on type ON-ROAD
subsetBCOR <- subset(NEI, fips == "24510" & type == "ON-ROAD" )

# Select SCC on SCC and EI.Sector
subsetTemp <- select(SCC, c("SCC","EI.Sector") )
subsetTemp$SCC <- as.character(subsetTemp$SCC)

# Left join the 2 datasets
subsetBCOR<-left_join(subsetBCOR,subsetTemp,by="SCC")
rm(subsetTemp)

# Aggregate data with dplyr for fun
aggEmissionByYearBCOR <- summarize(group_by(subsetBCOR, year,EI.Sector), Emissions=sum(Emissions),na.rm=TRUE)
rm(subsetBCOR)

# Build plot and save it as png
png("plot5.png", width=640, height=640)
q5 <- ggplot(aggEmissionByYearBCOR, aes(x=factor(year), y=Emissions, fill=EI.Sector)) +
	geom_bar(stat="identity") +
	scale_fill_brewer(palette="Set2") +
	xlab("Years") +
	ylab(expression('Total PM'[2.5]*' emission')) +
	ggtitle("Total emissions from motor vehicle (type ON-ROAD) in the Baltimore City, Maryland from 1999 to 2008") +
	theme(legend.position="bottom") +
	guides(fill=guide_legend(nrow=2,byrow=TRUE))
print(q5)
dev.off()
