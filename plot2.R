library(data.table)
filepath <- "household_power_consumption.txt"
# download only if file doesn`t exist
if (!file.exists(filepath)) {
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
    unzip(temp)
    unlink(temp)
}
# obtain colnames before
colNames <- names(fread(filepath, header=TRUE, sep=";", nrows=0))
# as far as we need only data for tow days. Data consists of per minute steps
numberRows = 60 * 24 *2
# strip all values before 2007-02-01. It reduces memory requirements and increase speed
exData <- fread(filepath, sep=";", na.strings="?", header=TRUE, skip= "31/1/2007;23:59:00", nrows = numberRows)
setnames(exData, colNames)
# add data and time and convert to POSIX
datetime <- paste(exData$Date, exData$Time)
posixDateTime <- strptime(datetime, "%d/%m/%Y %H:%M:%S")
# to ensure days would be printed in English
Sys.setlocale("LC_TIME", "English")
# draw to png directly
png(file="plot2.png", width=480, height=480)
plot(posixDateTime, exData$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()