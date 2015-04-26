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
        pm25 <- 
}

##----------------------------------------------------------------------
## list all emissions from coal combustion-related sources
coal <- scc[grepl("Fuel Comb.*Coal", scc$EI.Sector),]

## subset the dataframe by all coal combustion sources
newData <- pm25[pm25$SCC %in% coal$SCC,]

## run a sum over data
newDataFrame <- ddply(newData, "year", summarise, total=sum(Emissions))

png(filename="plotNo4.png")
qplot(x      = year,
      xlab   = "Year",
      y      = total,
      ylab   = "Total Emissions (tons)",
      data   = newDataFrame,
      geom   = c("point", "smooth"),
      method = "loess")
dev.off()

## clean up
rm(theLink)
rm(newDataFrame)
rm(newData)
rm(coal)