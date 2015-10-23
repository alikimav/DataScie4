## Exploratory Data Analysis Project 2

rm(list=ls())
wd <- dirname(sys.frame(1)$ofile)
setwd(dir = wd)

if(!file.exists("./peerdata.zip")){
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./peerdata.zip", method = "curl")
}

unzip("./peerdata.zip")

NEI <- readRDS("summarySCC_PM25.rds")
# NEI$year <- as.factor(NEI$year)
# NEI$type <- as.factor(NEI$type)
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
NEIsample <- sample_n(NEI, 50) # randomly sample 50 obs.

aggdata2 <-aggregate(NEI$Emissions, by = list(year = NEI$year), FUN = sum)
colnames(aggdata2) <- c("year", "Emissions" )

barplot(aggdata2$Emissions, names.arg=c("1999","2002","2005","2008"),
        xlab = "year", ylab="total PM2.5 emissions", border="blue", density=c(25, 50, 75, 100),
        main = "Total PM2.5 emissions from all sources")


