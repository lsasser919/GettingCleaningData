
### Set initial working directory
setwd("/Users/lorenmyers/Desktop/Coursera")

### Load libraries
library(tidyverse)
library(dplyr)
### install.packages("codebook")
library(codebook)
library(reshape2)

### Download the zip file, name it run.zip
runUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(runUrl, destfile = "/Users/lorenmyers/Desktop/Coursera/run.zip")

### Unzip the zip file
runzip <- "/Users/lorenmyers/Desktop/Coursera/run.zip"
runDir <- "/Users/lorenmyers/Desktop/Coursera/runfolder"
unzip(runzip, exdir = runDir)

### Check that the run folder exists
list.files("/Users/lorenmyers/Desktop/Coursera/")

###Check that there are data files in runfolder
list.files("/Users/lorenmyers/Desktop/Coursera/runfolder")

### Set working directory to the unzipped UCI HAR folder
setwd("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset")

### Load and name the Activity labels, check it's first 6 rows
activity_labels <- read.table("activity_labels.txt", col.names = c("code", "activity"))
head(activity_labels)

### Load and name features, check it's first 6 rows
featurenames <- read.table("features.txt", col.names = c("index", "featurename"))
head(featurenames)

### Load the test data sets
xtest <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/test/X_test.txt",
                    col.names = featurenames$featurename)
ytest <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/test/y_test.txt",
                    col.names = "code")
testsubject <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/test/subject_test.txt",
                    col.names = "subject") 
                         
### Load the train data
xtrain<- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/train/X_train.txt",
                    col.names = featurenames$featurename)
ytrain <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/train/y_train.txt", 
                     col.names = "code")
trainsubject<- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/train/subject_train.txt", 
                     col.names = "subject")

### Combine the data tables by rows
xtable <- rbind(xtest, xtrain)
ytable <- rbind(ytest, ytrain)
subject <- rbind(testsubject, trainsubject)

### Combining everything in to one data frame
combine <- cbind(subject, xtable, ytable)

### Make the new subsetted data frame containing only the columns with names found in runnames
subset <- combine %>% select(subject, code, contains("mean"), contains("std"))
head(subset)

### Create descriptive names of the activities
subset$code <- activity_labels[subset$code, 2]

### Label the data set with descriptive variable names, first determine the names that need to be adjusted.
names(subset)[2] = "Activity"
names(subset) <- gsub("^t", "Time", names(subset))
names(subset) <- gsub("^f", "Frequency", names(subset))
names(subset) <- gsub("BodyBody", "Body", names(subset))
names(subset) <- gsub("Acc", "Accelerometer", names(subset))
names(subset) <- gsub("tBody", "TimeBody", names(subset))
names(subset) <- gsub("Gyro", "Gyroscope", names(subset))
names(subset) <- gsub("Mag", "Magnitude", names(subset))
names(subset) <- gsub("-mean()", "Mean", names(subset))
names(subset) <- gsub("std", "STD", names(subset))
names(subset) <- gsub("-freq()", "Frequency", names(subset))
names(subset) <- gsub("-angle", "Angle", names(subset))
head(subset)

###Create a tidy data set with the average of each variable for each activity and subject
melt <- melt(subset, id = c("subject", "Activity"))
tidyrun <- dcast(melt, subject + Activity ~ variable, mean)
head(tidyrun)


### Create a txt with the tidy data
write.table(tidyrun, file = "tidyrundata.csv", sep = "", row.name = FALSE) 






