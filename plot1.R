#Read a subset
data <- read.table("./data/household_power_consumption.txt",
                   header=TRUE,
                   sep=";",
                   na.strings="?",
                   nrows=10000,
                   skip=62000,
                   stringsAsFactors=FALSE,
                   
)

#Clean: Add variable labels.
names(data) <- c("date", "time", "global_active_power", "global_reactive_power", "voltage", "global_intensity", 
                 "sub_metering_1", "sub_metering_2", "sub_metering_3"
)

#Subset for observations on dates of interest.
library(dplyr)
feb01 <-filter(data, date=="1/2/2007")
feb02 <-filter(data, date=="2/2/2007")

#Combine.
library(data.table)
plotdata <- data.table(rbind(feb01, feb02))

#Clean: Transform dates. You have to assign it.
library(lubridate)
plotdata <- mutate(plotdata, new_date=dmy(date))

library(graphics)
#Initiate plot.
# hist(plotdata$global_active_power, xlab="Global Active Power (kilowatts)", col="red")
with(plotdata, hist(global_active_power, xlab="Global Active Power (kilowatts)", col="red", main=""))

#Annotate plot.
title(main="Global Active Power")

#Output plot to graphics device
library(grDevices)
png(filename = "plot1.png", width=480, height=480, units="px") 
with(plotdata, hist(global_active_power, xlab="Global Active Power (kilowatts)", col="red", main=""))
title(main="Global Active Power")

dev.off() 

