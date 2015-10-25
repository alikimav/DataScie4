#---------------------------------------------------------------------------------------------------------------
## Exploratory Data Analysis: Course Project 2 (plot 5)

# The code in this .R file generates a barplot depicting the total emissions of PM2.5 from motor vehicle sources for each
# of the years 1999, 2002, 2005, 2008 in Baltimore City, Maryland. 

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
# source of interest. In this task, we are concerned with PM2.5 emissions from motor vehicle sources in Baltimore City, MD.

# First, we subset the data to include only Baltimore City:

NEI <- NEI[NEI$fips %in% c("24510"),]

# Second, we create a subset of the SCC dataframe which includes the SCC and EI.Sector variables.

library(dplyr)
SCCsubset <- select(SCC, c(SCC, EI.Sector))

# We then merge the two data frames (NEI, which includes the number of tons of PM2.5 emitted, and SCCsubset) according to their
# common variable "SCC"

mergedDF <- merge(NEI, SCCsubset, all =TRUE)

# Using grep, we subset data related to coal combustion sources 

mergedDF <- mergedDF[grep("[Vv]ehicle", mergedDF$EI.Sector), ]

# We also observe that after we subset the data according to motor vehicle sources, the type of emissions come from
# ON-ROAD source (there are some NA values as well which we ignore in subsequent analyses)
unique(mergedDF$type)

# And there are 2 classes of motor vehicles considered: Light and Heavy duty and each class has a Gasoline and Diesel division.
unique(mergedDF$EI.Sector)

# Here, we plot the aggregate emission without differentiating between the above mentioned classes to show how total motor
# vehicle emissions have changed in Baltimore City, MD.

aggdata <-aggregate(mergedDF$Emissions, by = list(year = mergedDF$year), FUN = sum)
colnames(aggdata) <- c("Year", "Emissions" )

#=====================================================================================================================

#========================================  3. CREATING THE PLOT  =====================================================

library(ggplot2)
png(filename="plot5.png", width = 480, height = 480)
g1 <- ggplot(aggdata, aes(x = factor(Year), y = Emissions)) +
  geom_bar(color = "red3", fill = "peachpuff3", stat = "identity", position = position_dodge()) + scale_x_discrete("Year") +
  ggtitle("PM2.5 emissions from motor vehicle sources in Baltimore City, MD")+
  ylab("PM2.5 emissions [tons]")
print(g1)
 dev.off()

#=====================================================================================================================

#============================================== 4. Question 5   ======================================================

# QUESTION 5: How have emissions from motor vehicle sources changed from 1999 to 2008 in Baltimore City, MD?

# ANSWER: The contributing classes in emissions from motor vehicle sources come from Heavy and Light duty and each class
# has a Gasoline and Diesel division. The plot compares total emissions from the aforementioned classes for each year. We
# observe a significant decrease in emissions from 1999 to 2002 and a slower decrease from 2002 onwards. 

#=====================================================================================================================


