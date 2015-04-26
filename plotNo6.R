##----------------------------------------------------------------------
## this part of code is same for all plot source codes
## all ifs are there, as i was running these files number of times
## and didn't want the datasets duplicate if they are already there
## nor the file to be downloaded every each time

## lets download, unzip and load data, make sure plyr library is
## loaded
library(plyr)
library(ggplot2)
if (!dir.exists("Data")){
        dir.create("Data")
}
if (!file.exists("Data/data.zip")){
        theLink <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(url=theLink, destfile="Data/data.zip", method="curl")
}
if (!file.exists("Data/Source_Classification_Code.rds")){
        unzip("Data/data.zip", exdir="Data")
}
if (!exists("scc")){
        scc <- data.frame()
        scc <- readRDS(file ="Data/Source_Classification_Code.rds");
}
if (!exists("pm25")){
        pm25 <- data.frame()
        pm25 <- readRDS(file="Data/summarySCC_PM25.rds")
}

##----------------------------------------------------------------------
## subset the Baltimore City and Los Angeles
baltimoreAndLA <- pm25[pm25["fips"] == "24510" | pm25$fips == "06037",]

## list motor vehicle sources
listData <- scc[grepl("*Vehicles", scc$EI.Sector),]
newData <- baltimoreAndLA[baltimoreAndLA$SCC %in% listData$SCC,]

## run a sum over that dataset
newDataFrame <- ddply(newData, c("year", "fips"), summarise, total = sum(Emissions))

## add another variable for factoring the plot
newDataFrame$city <- ifelse(newDataFrame$fips == "24510", "Baltimore", "Los Angeles")
newDataFrame$city <- as.factor(newDataFrame$city)

## do the plot
png(filename="plotNo6.png")
qplot(x = year,
      xlab = "Year",
      y = total,
      ylab = "Total Emissions",
      data = newDataFrame,
      color = city,
      geom = c("point", "smooth"),
      method = "loess")
dev.off()

## and clean up
rm(theLink)
rm(newDataFrame)
rm(newData)
rm(baltimoreAndLA)
rm(listData)