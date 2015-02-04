# Code to access and unzip the data from the UCI Study
# Download the file to a Temporary folder 
if (!file.exists("data")) {
        dir.create("data")
}
Dataset.zip = tempfile(tmpdir ="./data", fileext=".zip")

zipURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(zipURL, Dataset.zip, mode="wb")
dateDownloaded = date()

# Unzip the file within the ./data directory
unzip(Dataset.zip, exdir = "./data")

# At this point you should have a directory called, ".data/UCI HAR Dataset" which 
# contains the raw data
