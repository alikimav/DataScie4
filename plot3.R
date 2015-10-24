#---------------------------------------------------------------------------------------------------------------
  ## Exploratory Data Analysis: Course Project 2 (plot 3)
  
  # The code in this .R file generates a barplot depicting the total emissions of PM2.5 per sources for each of
  # the years 1999, 2002, 2005, 2008 in Baltimore City, Maryland.
  
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

# The third task is similar to the first (refer to plot1.R); we now investigate whether *total* emissions from PM2.5 have 
# decreased in Baltimore City between 1999 to 2008. The information we need is found in the NEI data frame and in particular we are interested in creating
# a tidy data set with the total (sum) PM2.5 emissions per year (for all sources) for Baltimore City, MD.
# We proceed by first subsetting the data correspondong to fips = 24510 which gives the data for Baltimore City, MD

NEIBalt <- NEI[NEI$fips %in% c("24510"),]

# Next, we use the *aggregate* command to create the tidy data set.

aggdata <-aggregate(NEIBalt$Emissions, by = list(year = NEIBalt$year, type = NEIBalt$type), FUN = sum)
colnames(aggdata) <- c("Year", "Type", "Emissions" )

#=====================================================================================================================

#========================================  3. CREATING THE PLOT  =====================================================

library(ggplot2)
png(filename="plot3.png", width = 480, height = 480)
g1 <- ggplot(aggdata, aes(x = factor(Year), y = Emissions, fill = factor(Type))) +
  geom_bar(color = "black", stat = "identity", position = position_dodge()) + scale_x_discrete("Year") +
  scale_fill_discrete(name ="Source type", labels=c("Non-road", "Non-point", "On-road", "Point")) 
# +scale_fill_brewer(palette = "Set1")
# stat_summary(fun.y=max, geom = "line", mapping = aes(group = 1), color = "black")
print(g1)
dev.off()

#=====================================================================================================================

  

