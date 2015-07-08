#The data file is large, so read only a subset into R.
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

#Combine dates of interest and create a data table.
library(data.table)
plotdata <- data.table(rbind(feb01, feb02))

#Clean: Transform dates. 
library(lubridate)
x <- paste(plotdata$date, plotdata$time)
plotdata <- mutate(plotdata, new_datetime=dmy_hms(x))
numdate <- as.numeric(plotdata$new_datetime)

#Initiate plot.
library(graphics)
with(plotdata, plot(numdate, sub_metering_1, type="l", col="black", 
                    xaxt="n" , xlab="", ylab="Energy sub metering"))

#Annotate plot.
##Add more points.
with(plotdata, points(numdate, sub_metering_2, type="l", col="red"))
with(plotdata, points(numdate, sub_metering_3, type="l", col="blue"))
legend("topright", lty=1, lwd=1, col = c("black", "blue","red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

##Label x axis.
xpoints <- c(min(numdate),median(numdate),max(numdate))
axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))

#Output plot to graphics device
library(grDevices)
png(filename = "plot3.png", width=480, height=480, units="px") 
with(plotdata, plot(numdate, sub_metering_1, type="l", col="black", 
                    xaxt="n" , xlab="", ylab="Energy sub metering"))
with(plotdata, points(numdate, sub_metering_2, type="l", col="red"))
with(plotdata, points(numdate, sub_metering_3, type="l", col="blue"))
legend("topright", lty=1, lwd=1, col = c("black", "blue","red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
xpoints <- c(min(numdate),median(numdate),max(numdate))
axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
dev.off() 
