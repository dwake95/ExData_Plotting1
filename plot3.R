# Code to access and unzip the data from the UCI Study
# Download the file to a Temporary folder 
if (!file.exists("data")) {
        dir.create("data")
}

if (!file.exists("./data/household_power_consumption.txt")) {
        Dataset.zip = tempfile(tmpdir ="./data", fileext=".zip")
        
        zipURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(zipURL, Dataset.zip, mode="wb")
        dateDownloaded = date()
        
        # Unzip the file within the ./data directory
        unzip(Dataset.zip, exdir = "./data")
}

# You should have a file called, "./data/household_power_consumption.txt" which 
# contains the raw data

# Read the *.txt file into a data frame, making all columns numeric except 
# Date and Time.

pdat = read.delim("./data/household_power_consumption.txt", sep=";", 
                  na.strings = "?", colClasses = c("character", "character", 
                                                   "numeric", "numeric", 
                                                   "numeric", "numeric", 
                                                   "numeric", "numeric",
                                                   "numeric"
                  )
)

# Convert the Date column from a Character Class to a Date Class
pdat$Date=as.Date(pdat$Date, "%d/%m/%Y")

# Load the dplyr library
library("dplyr", lib.loc="~/R/win-library/3.1")

# Extract out the dates of interest for the project from the total data set
pdat2 = filter(pdat, Date >="2007-02-01" & Date <= "2007-02-02")

# Convert the Date and Time columns to a Single Date Time column
pdat3 = mutate(pdat2, datetime = as.POSIXct(paste(pdat2$Date, pdat2$Time), 
                                            format="%Y-%m-%d %H:%M:%S"
)
)

# Create a final file which will removes old Date and Time columns for the 
# combined column.
pdat4 = select(pdat3, datetime, Global_active_power:Sub_metering_3)

# Discard intermediate files to save memory
rm(pdat, pdat2, pdat3)

# Plot X-Y of Global Active Power vs. datetime to the screen

plot(pdat4$datetime, pdat4$Sub_metering_1, ylab = "Energy sub metering", xlab = "", 
     main = "", type = "l", col="black")
lines(pdat4$datetime, pdat4$Sub_metering_2, type="l", col="red")
lines(pdat4$datetime, pdat4$Sub_metering_3, type="l", col="blue")


# This didn't work, as the lines that were added were only black.  I believe that
# the with function is creating an environment which does not inherit colors well.
# with(pdat4, plot(Sub_metering_1 ~ DT, ylab = "Energy sub metering", xlab = "", main = "", type = "l", col="black"))
# lines(with(pdat4, Sub_metering_2 ~ DT, type="l", col="red")
# lines(with(pdat4, Sub_metering_3 ~ DT, type="l", col=c("blue")))

legend("topright", legend = c("Sub_metering_1","Sub_metering_2", 
                              "Sub_metering_3"
                              ), lwd=2, col=c("black", "red", "blue")
       )

# Copy the resultant plot to a .png file
dev.copy(png, file = "plot3.png")
dev.off()




