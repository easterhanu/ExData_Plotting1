# plot4.R
#
# Coursera Exploratory Data Analysis Course Project 1:
# Reads in electric power consumption data and draws plot 4.
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

# Create plot 4 (a panel of four graphs) on current graphics device.
#
createPlot4 <- function() {
    par(mfcol = c(2, 2))
    with(pwrdata, {
        # Top left plot
        plot(Date, Global_active_power, type = "l",
             xlab = "", ylab = "Global Active Power")
        
        # Bottom left plot
        plot(Date, Sub_metering_1, type = "l",
             xlab = "", ylab = "Energy sub metering")
        lines(Date, Sub_metering_2, col = "red")
        lines(Date, Sub_metering_3, col = "blue")
        legend("topright", legend = names(pwrdata)[6:8],
               col = c("black", "red", "blue"), lty = 1, bty = "n")
        
        # Top right plot
        plot(Date, Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
        
        # Bottom right plot
        plot(Date, Global_reactive_power, type = "l", xlab = "datetime")
    })
}

# Get power data.
pwrdata <- getPowerData()

# Set time format in locale system settings to POSIX C to make sure
# we get English weekday titles.
Sys.setlocale("LC_TIME", "C")

# Draw plot 4 on screen.
createPlot4()

# Save plot 4 as a PNG file.
png(filename = "plot4.png", width = 480, height = 480, units = "px")
createPlot4()
dev.off()
