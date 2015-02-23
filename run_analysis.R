##
## NOTE: The script works with the zip file, to make sure that all files needed
## are in the right place.

##
## STEP 0. Check if zip file exists in the working directory, if not, download
## it. After that, unzip it.
##

filename <- "getdata-projectfiles-UCI HAR Dataset.zip"
if (!file.exists(filename)) {
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, destfile=filename)
}
unzip(filename, overwrite=TRUE)


##
## STEP 1. Merges the training set and the test set to create one data set.
##

## Creates a dataset from test data  
filepath <- "UCI HAR Dataset/test/"
subject.test <- read.table(paste(filepath,"subject_test.txt",sep=""))
y.test <- read.table(paste(filepath,"y_test.txt",sep=""))
x.test <- read.table(paste(filepath,"X_test.txt",sep=""))
data.test <- data.frame(subject.test, y.test, x.test)

## Creates a dataset from training data  
filepath <- "UCI HAR Dataset/train/"
subject.train <- read.table(paste(filepath,"subject_train.txt",sep=""))
y.train <- read.table(paste(filepath,"y_train.txt",sep=""))
x.train <- read.table(paste(filepath,"X_train.txt",sep=""))
data.train <- data.frame(subject.train, y.train, x.train)

## Combines test and train into just one dataset

data <- rbind(data.test, data.train)


##
## STEP 2. Extracts only the measurements on the mean and standard deviation
##         for each measurement.
##

## Reads the features
filepath <- "UCI HAR Dataset/"
features <- read.table(paste(filepath,"features.txt",sep=""), 
                       stringsAsFactors=FALSE, col.names=c("Code","Name"))

## Identify row numbers of rows that include mean() or std() in their names 
fcols <- grep("(mean|std)\\(\\)",features$Name,ignore.case=TRUE)

## Extracts the selected data including column 1 and 2 (Subject and Activity).
## In data the features columns begin in 3rd columns, so we have to add 2 to
## every value in fcol.
seldata <- data[c(1,2,fcols+2)]


##
## STEP 3. Uses descriptive activity names to name the activities in the 
##         data set.
##

## Reads the activity labels
filepath <- "UCI HAR Dataset/"
act.labels <- read.table(paste(filepath,"activity_labels.txt",sep=""),
                         stringsAsFactors=FALSE, col.names=c("Class","Name"))

## Column 2 contains the class code for activity
seldata[,2] <- act.labels$Name[match(seldata[,2],act.labels$Class)]


##
## STEP 4. Appropriately labels the data set with descriptive variable names.
##

## Assign proper names to variables
names(seldata) <- c("Subject","Activity",features$Name[fcols])


##
## STEP 5. From the data set in step 4, creates a second, independent tidy
##         data set with the average of each variable for each activity and 
##         each subject.
##

## Agregate data
library(plyr)
tidydata <- ddply(seldata, .(Subject, Activity), 
                  function(x) colMeans(x[, 3:68]))

## Update proper names to indicate aggregate operation
names(tidydata) <- c("Subject", "Activity", paste ("Mean of",
                                                   names(tidydata[,3:68])))
## Write result file
write.table(tidydata, "result.txt", row.name=FALSE)


## EOF