#----------------------------------------------------------
# Set locale to English
#----------------------------------------------------------

Sys.setlocale("LC_TIME", "English")

#----------------------------------------------------------
# Load library
#----------------------------------------------------------

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

#Question 4:
#Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Identify what is related to 'comb' and 'coal' in SCC
ILookFor <- c("*comb.*coal*", "*coal.*comb*")
CombCoal <- unique(grep(paste(ILookFor,collapse="|"), SCC$EI.Sector, value=TRUE, ignore.case=TRUE))
rm(ILookFor)

# Select SCC and EI.Sector from SCC
step1 <- SCC %>% 
	distinct(SCC,EI.Sector) %>%
	select(SCC, c(SCC,EI.Sector)) %>%
	filter( EI.Sector %in% CombCoal)
# Filter searched value of SCC in NEI
dataset <- filter( NEI, SCC %in% step1$SCC)
rm(step1)

# Aggregate data with dplyr for fun
datasetAgg <- summarize(group_by(dataset, year,type), Emissions=sum(Emissions),na.rm=TRUE)
rm(dataset)

# Build plot and save it as png
png("plot4.png", width=640, height=640)
q4 <- ggplot(datasetAgg, aes(x=factor(year), y=Emissions, fill=year)) +
	geom_bar(stat="identity") +
	xlab("Years") +
	ylab(expression('Total PM'[2.5]*' emission')) +
	ggtitle("Total emissions from coal combustion-related sources in the United States from 1999 to 2008")
print(q4)
dev.off()
