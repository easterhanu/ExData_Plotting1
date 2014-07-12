# plot3.R
#
# Coursera Exploratory Data Analysis Course Project 1:
# Reads in electric power consumption data and draws plot 3.
#

# Read power data from file and return it as a data frame, suitable for
# plotting.
#
getPowerData <- function() {
    # Read power consumption data from a file. Just read first 75 000
    # lines (out of over 2 million) to speed up the process, as we are only
    # interested in two days (February 1 and 2, 2007) within those lines.
    #
    # Example line in household_power_consumption.txt:
    # 16/12/2006;17:32:00;3.668;0.510;233.990;15.800;0.000;1.000;17.000
    #
    rawlines <- readLines("household_power_consumption.txt", n = 75000)
    
    # Use grep and a regular expression to pick just the heading line and
    # data lines starting with desired dates "1/2/2007" or "2/2/2007".
    #
    rawlines <- grep("(Global|[12]/2/2007)", rawlines, value = TRUE)
    
    # Parse the character vector returned by grep into a data frame.
    #
    df <- read.table(textConnection(rawlines), header = TRUE,
                     sep = ";", na.strings = "?")
    
    # Merge separate Date and Time text columns and convert them into
    # proper R date objects. Overwrite Date column with the new objects
    # and drop old Time column as it is not needed anymore.
    #
    df$Date <- strptime(paste(df$Date, df$Time), format = "%d/%m/%Y %H:%M:%S")
    df$Time <- NULL
    
    # Return power data as a data frame.
    df
}

# Create plot 3 (line graph of energy sub metering) on current graphics device.
#
createPlot3 <- function() {
    plot(pwrdata$Date, pwrdata$Sub_metering_1, type = "l",
         xlab = "", ylab = "Energy sub metering")
    lines(pwrdata$Date, pwrdata$Sub_metering_2, col = "red")
    lines(pwrdata$Date, pwrdata$Sub_metering_3, col = "blue")
    legend("topright", legend = names(pwrdata)[6:8],
           col = c("black", "red", "blue"), lty = 1)
}

# Get power data.
pwrdata <- getPowerData()

# Set time format in locale system settings to POSIX C to make sure
# we get English weekday titles.
Sys.setlocale("LC_TIME", "C")

# Draw plot 3 on screen.
createPlot3()

# Save plot 3 as a PNG file.
png(filename = "plot3.png", width = 480, height = 480, units = "px")
createPlot3()
dev.off()
