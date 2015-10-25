#---------------------------------------------------------------------------------------------------------------
## Exploratory Data Analysis: Course Project 2 (plot 6)

# The code in this .R file generates barplots depicting the comparison between total emissions of PM2.5 from motor
# vehicle sources for each of the years 1999, 2002, 2005, 2008 in Baltimore City, MD and Los Angeles County, CA. 

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

# First, we subset the data to include only Baltimore City and Los Angeles County:

NEI <- NEI[NEI$fips %in% c("24510", "06037"),]

# Then, we create a subset of the SCC dataframe which includes the SCC and EI.Sector variables.

library(dplyr)
SCCsubset <- select(SCC, c(SCC, EI.Sector))

# We then merge the two data frames (NEI, which includes the number of tons of PM2.5 emitted, and SCCsubset) according to their
# common variable "SCC"

mergedDF <- merge(NEI, SCCsubset, all =TRUE)

# Using grep, we subset data related to coal combustion sources 

mergedDF <- mergedDF[grep("[Vv]ehicle", mergedDF$EI.Sector), ]

# We also observe that after we subset the data according to coal combustion related sources, the type of emissions come from
# ON-ROAD and POINT sources (there are some NA values as well which we ignore in subsequent analyses)

 unique(mergedDF$type)
 
# # And there are 2 classes of motor vehicles considered: Light and Heavy duty and each class has a Gasoline and Diesel division.
 unique(mergedDF$EI.Sector)
# 
# # Here, we plot the aggregate emission without differentiating between the above mentioned classes to show how total motor
# # vehicle emissions have changed in Baltimore City, MD and Los Angeles County, CA.
# 
aggdata <-aggregate(mergedDF$Emissions, by = list(year = mergedDF$year, City = mergedDF$fips), FUN = sum)
colnames(aggdata) <- c("Year", "City","Emissions" )

# Finally, let us sub the city code with the actual city name (gsub used in cascade)

aggdata$City <- sapply(aggdata$City, function(x) gsub("06037", "Los Angeles County", gsub('24510', "Baltimore City", x)))
#=====================================================================================================================

#========================================  3. CREATING THE PLOT  =====================================================

library(ggplot2)
png(filename="plot6.png", width = 480, height = 480)
g1 <- ggplot(aggdata, aes(x = factor(Year), y = Emissions)) +
  geom_bar(color = "slateblue3", fill = "steelblue3", stat = "identity", position = position_dodge()) + scale_x_discrete("Year") +
  ggtitle("PM2.5 emissions from motor vehicle sources in Baltimore City, MD and Los Angeles County, CA")+
  ylab("PM2.5 emissions [tons]")+facet_wrap(~ City)+theme(title=element_text(size=8), axis.title=element_text(size=12))
print(g1)
dev.off()

#=====================================================================================================================

#============================================== 4. Question 6   ======================================================

# QUESTION 6: Compare emissions from motor vehicle sources in Baltimore City and Los Angeles County. Which city has
# greater changes over time in  motor vehicle emissions? 

# ANSWER:

# We first note that the emissions from motor vehicle sources in LA County have been far greater over all recorded years
# than in Baltimore City. While in Baltimore City, the emissions have been steadily decreasing, in LA County they have been 
# fluctuating.

# The amount of variation in Los Angeles County between 1999 and 2008 has been greater compared to Baltimore City.

#=====================================================================================================================


