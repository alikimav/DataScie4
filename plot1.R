#---------------------------------------------------------------------------------------------------------------
## Exploratory Data Analysis: Course Project 2 (plot 1)

# The code in this .R file generates a barplot depicting the total emissions of PM2.5 from all sources for each of
# the years 1999, 2002, 2005, 2008.

#---------------------------------------------------------------------------------------------------------------

#========================================  1. READING IN THE DATA  ==================================================
# The data: we use a data set showing the PM2.5 emissions in the United States for the years 1999, 2002, 2005 and 2008 
# across 4 sources (point,non-point, or-road, non-road). The amount of PM2.5 emissions is measured in tons.

# Clear environment, set working directory (wd) to where the plot1.R file is saved

rm(list=ls())
wd <- dirname(sys.frame(1)$ofile)
setwd(dir = wd)

# Download and unzip the data to the current wd

if(!file.exists("./peerdata.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, destfile = "./peerdata.zip", method = "curl")
}

unzip("./peerdata.zip")

# Use the readRDS command to read in the data into 2 dataframes: NEI and SCC

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Quick information on data frames

names(NEI)
names(SCC)
      
str(NEI)
str(SCC)

#=====================================================================================================================

#========================================  2. SUMMARIZING DATA  ======================================================

# In this first task, we investigate whether *total* emissions from PM2.5 have decreased in the United States in the above
# mentioned years. The information we need is found in the NEI data frame and in particular we are interested in creating
# a tidy data set with the total (sum) PM2.5 emissions per year (for all sources). We proceed using the *aggregate* command
# to create the tidy data set.

aggdata <-aggregate(NEI$Emissions, by = list(year = NEI$year), FUN = sum)
colnames(aggdata) <- c("year", "Emissions" )

#=====================================================================================================================

#========================================  3. CREATING THE PLOT  =====================================================

# Our exploration is supported by a barplot whose height indicates the amount of total PM2.5 emissions 
# measured in tons. Using the base graphics package and the barplot command we create plot1 and save as a png file.

png(filename="plot1.png", width = 480, height = 480)
barplot(aggdata$Emissions, names.arg=c("1999","2002","2005","2008"),
        xlab = "Year", ylab="Total PM2.5 emissions [tons]", border="blue", density=c(25, 50, 75, 100),
        main = "Total PM2.5 emissions from all sources")
axis(side = 1, at = seq(0,7e06, 7))
dev.off()

#=====================================================================================================================

#============================================== 4. Question 1   ======================================================

# QUESTION 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

# ANSWER: We observe that the data we are given includes information on PM2.5 emissions every 3 years. While there is a 
# monotonic decrease in the emissions, plot1.png depicts a larger decrease from PM2.5 emissions from years 1999 to 2002
# and 2005 to 2008 compared to the years 2002 to 2005. 

#=====================================================================================================================


