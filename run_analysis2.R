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
activity_labels <- read.table("activity_labels.txt", col.names = c("ActivityLabels", "ActivityName"))
head(activity_labels)

### Load and name features, check it's first 6 rows
featurenames <- read.table("features.txt")

### Load the test data sets
xtest <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/test/y_test.txt")
testsubject <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/test/subject_test.txt") 
                         
### Load the train data
xtrain<- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/train/y_train.txt")
trainsubject<- read.table("/Users/lorenmyers/Desktop/Coursera/runfolder/UCI HAR Dataset/train/subject_train.txt")

### Combine the data tables by rows
Subjecttable <- rbind(testsubject, trainsubject)
Activitytable <- rbind(ytest, ytrain)
Featurestable <- rbind(xtest, xtrain)
head(Featurestable)

### Naming the variables
names(Subjecttable) <- c("ID")
names(Activitytable) <- c("activity")
names(Featurestable) <- featurenames$V2

### Combining everything in to one data frame
combine <- cbind(Subjecttable, Activitytable)
rundata <- cbind(Featurestable, combine)
head(rundata)

### Locate measurements with mean and std
runnames <- featurenames$V2[grep("mean\\(\\)|std\\(\\)", featurenames$V2)]
runnames

### Make the new subsetted data frame containing only the columns with names found in runnames
runandid <- c(as.character(runnames), "ID", "activity")
subsetrun <- subset(rundata, select = runandid)
head(subsetrun)

### Create descriptive names of the activities
names(subsetrun$activity = activity_labels)
colnames(subsetrun)

### Label the data set with descriptive variable names, first determine the names that need to be adjusted.
names(subsetrun)
names(subsetrun) <- gsub("^t", "time", names(subsetrun))
names(subsetrun) <- gsub("^f", "frequency", names(subsetrun))
names(subsetrun) <- gsub("BodyBody", "Body", names(subsetrun))
names(subsetrun) <-gsub("()-X", "", names(subsetrun))
names(subsetrun) <-gsub("()-Y", "", names(subsetrun))
names(subsetrun) <-gsub("()-Z", "", names(subsetrun))
names(subsetrun)

###Create a tidy data set with the average of each variable for each activity and subject
tidyrun <- melt(subsetrun, id = c("ID", "activity"))
tidyrun    

### Create a codebook
new_codebook_rmd("codebook")

### Create a txt with the tidy data
write.table(tidyrun, file = "tidyrundata", sep = "", row.name = FALSE) 






