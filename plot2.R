#---------------------------------------------------------------------------------------------------------------
## Exploratory Data Analysis: Course Project 2 (plot 2)

# The code in this .R file generates a barplot depicting the total emissions of PM2.5 from all sources for each of
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

# The second task is similar to the first (refer to plot1.R); we now investigate whether *total* emissions from PM2.5 have 
# decreased in Baltimore City between 1999 to 2008. The information we need is found in the NEI data frame and in particular we are interested in creating
# a tidy data set with the total (sum) PM2.5 emissions per year (for all sources) for Baltimore City, MD.
# We proceed by first subsetting the data correspondong to fips = 24510 which gives the data for Baltimore City, MD

NEIBalt <- NEI[NEI$fips %in% c("24510"),]

# Next, we use the *aggregate* command to create the tidy data set.

aggdata <-aggregate(NEIBalt$Emissions, by = list(year = NEIBalt$year), FUN = sum)
colnames(aggdata) <- c("year", "Emissions" )

#=====================================================================================================================

#========================================  3. CREATING THE PLOT  =====================================================

# Our exploration is supported by a barplot whose height indicates the amount of total PM2.5 emissions 
# measured in tons. Using the base graphics package and the barplot command we create plot1 and save as a png file.

png(filename="plot2.png", width = 480, height = 480)
barplot(aggdata$Emissions, names.arg=c("1999","2002","2005","2008"),
        xlab = "Year", ylab="Total PM2.5 emissions [tons]", border="blue", density=c(25, 50, 75, 100),
        main = "Total PM2.5 emissions from all sources in Baltimore City, Maryland", cex.main = 1.0)
axis(side = 1, at = seq(0,3500, 7))
dev.off()

#=====================================================================================================================

#============================================== 4. Question 2   ======================================================

# QUESTION 2: Have total emissions from PM2.5 decreased in Baltimore City, MD from 1999 to 2008?

# ANSWER: We observe that the data we are given includes information on PM2.5 emissions every 3 years. The barplot shows
# that the PM2.5 emissions are lower in 2008 compared to 1999; however, we observe that after an initial decrease between 1999
# and 2002, the emissions increased in the next 3 years followed by a large decrease (approx. 40%) from 2005 to 2008.

#=====================================================================================================================



