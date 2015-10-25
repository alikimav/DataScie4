#---------------------------------------------------------------------------------------------------------------
## Exploratory Data Analysis: Course Project 2 (plot 4)

# The code in this .R file generates a barplot depicting coal-combustion-related emissions of PM2.5 per source (2 source types
# contribute) for each of the years 1999, 2002, 2005, 2008 across the US.

#---------------------------------------------------------------------------------------------------------------

#========================================  1. READING IN THE DATA  ==================================================
# See comments in plot1.R

rm(list=ls())
wd <- dirname(sys.frame(1)$ofile)
setwd(dir = wd)

if(!file.exists("./peerdata.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, destfile = "./peerdata.zip", method = "curl")
}

unzip("./peerdata.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#=====================================================================================================================

#========================================  2. SUMMARIZING DATA  ======================================================

# A quick look at the SCC dataframe indicates that the variable EI.Sector contains information on emission sources. Each source is given
# a digit string under the variable name "SCC". Prior to analysing emission data, we subset the data according to a specific
# source of interest. In this task, we are concerned with PM2.5 emissions from coal-combustion-related sources. 

# First, we create a subset of the SCC dataframe which includes the SCC and EI.Sector variables.

library(dplyr)
SCCsubset <- select(SCC, c(SCC, EI.Sector))

# We then merge the two data frames (NEI, which includes the number of tons of PM2.5 emitted, and SCCsubset) according to their
# common variable "SCC"

mergedDF <- merge(NEI, SCCsubset, all =TRUE)

# Using grep, we subset data related to coal combustion sources 

mergedDF <- mergedDF[grep("[Cc]oal", mergedDF$EI.Sector), ]

# We also observe that after we subset the data according to coal combustion related sources, the type of emissions come from
# either POINT or NONPOINT (there are some NA values as well which we ignore in subsequent analyses)

unique(mergedDF$type)

# We therefore separate the emissions according to the two above mentioned sources. 

aggdata <-aggregate(mergedDF$Emissions, by = list(year = mergedDF$year, type = mergedDF$type), FUN = sum)
colnames(aggdata) <- c("Year", "Type", "Emissions" )

#=====================================================================================================================

#========================================  3. CREATING THE PLOT  =====================================================

library(ggplot2)
png(filename="plot4.png", width = 480, height = 480)
g1 <- ggplot(aggdata, aes(x = factor(Year), y = Emissions, fill = factor(Type))) +
  geom_bar(color = "blue", stat = "identity", position = position_dodge()) + scale_x_discrete("Year") +
  ggtitle("Coal-combustion-related emissions per source type across the US")+
  ylab("Emissions [tons]")+ scale_fill_manual(values = c("light blue"," dark blue"))+
  scale_fill_discrete(name ="Source type", labels=c("Non-point", "Point"))
print(g1)
dev.off()

#=====================================================================================================================

#============================================== 4. Question 4   ======================================================

# QUESTION 4: Across the United States, how have emissions from coal-combustion-related sources changed from 1999 to 2008?

# ANSWER: Coal-combustion-related sources data come from the nonpoint and point sources. Across the US, there has been a
# a decrease in emissions in 2008 compared to 1999. However, for the nonpoint type, emissons have increased in years 2002 and
# 2005 before droppping in 2008 while for the point source type, emissions have decreased from 1999 to 2002, slightly increased
# in 2005 and dropped again in 2008. We note also that emissions from the point source type are significantly higher than the
# nonpoint source type. 

#=====================================================================================================================


