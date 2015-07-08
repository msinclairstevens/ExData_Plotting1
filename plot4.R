#The data file is large, so read only a subset into R.
data <- read.table("./data/household_power_consumption.txt",
                   header=FALSE,
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


#Initiate plot.
library(graphics)
par(mfcol = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0)) 
with(plotdata, {
  plot(new_datetime, global_active_power, ylab="Global Active Power", type="l", xaxt="n", xlab="")
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
  
  plot(new_datetime, sub_metering_1, ylab="Energy sub metering", type="l", xaxt="n", xlab="")
  with(plotdata, points(new_datetime, sub_metering_2, type="l", col="red"))
  with(plotdata, points(new_datetime, sub_metering_3, type="l", col="blue"))
  legend("topright", bty="n",lty=1, lwd=1, col = c("black", "red","blue"), 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
  
  plot(new_datetime, voltage, ylab="Voltage", type="l", xaxt="n", xlab="datetime")
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
  
  plot(new_datetime, global_reactive_power, ylab="Global_reactive_power", type="l", xaxt="n", xlab="datetime") 
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
})

#Output plot to graphics device
library(grDevices)
png(filename = "plot4.png", width=480, height=480, units="px") 

par(mfcol = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0)) 
with(plotdata, {
  plot(new_datetime, global_active_power, ylab="Global Active Power", type="l", xaxt="n", xlab="")
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
  
  plot(new_datetime, sub_metering_1, ylab="Energy sub metering", type="l", xaxt="n", xlab="")
  with(plotdata, points(new_datetime, sub_metering_2, type="l", col="red"))
  with(plotdata, points(new_datetime, sub_metering_3, type="l", col="blue"))
  legend("topright", box.lwd=0,lty=1, lwd=1, col = c("black", "blue","red"), 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
  
  plot(new_datetime, voltage, ylab="Voltage", type="l", xaxt="n", xlab="datetime")
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
  
  plot(new_datetime, global_reactive_power, ylab="Global_reactive_power", type="l", xaxt="n", xlab="datetime") 
  xpoints <- c(min(new_datetime),median(new_datetime),max(new_datetime))
  axis(1, at=c(xpoints),labels=c('Thu','Fri','Sat'))
})
dev.off() 
