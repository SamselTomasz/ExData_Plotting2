##----------------------------------------------------------------------
## this part of code is same for all plot source codes
## all ifs are there, as i was running these files number of times
## and didn't want the datasets duplicate if they are already there
## nor the file to be downloaded every each time

## lets download, unzip and load data
library(plyr)
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

## now lets subset the dataframe, apply sum function and combine result 
## into new dataframe
newDataFrame <- ddply(pm25, "year", summarise, total=sum(Emissions))

## and do the plot
png(filename="plotNo1.png")
plot(x=newDataFrame$year,
     y=newDataFrame$total/1000,
     type="l",
     col="red",
     ylab="Total emissions, all sources (kilotons)",
     xlab="Year"
)
dev.off()

## clean up
rm(theLink)
rm(newDataFrame)