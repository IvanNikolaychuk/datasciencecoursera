pathToResearchData <- NULL

testFolderCache <- NULL
trainFolderCache <- NULL

require(dplyr)
analize <- function(downloadData = TRUE) {
        if (downloadData)
                downloadAndUnzipData()
        else
                pathToResearchData <<-
                        paste('cleaningDataAssignment', 'data', sep = '/')

        initCache()
       
        # Merges the training and the test sets to create one data set.
        # Appropriately labels the data set with descriptive variable names.
        mergedData <- mergeDataAndNormalizeColNames()
        # Use descriptive activity names to name the activities in the data set
        mergedData <- normalizeActivityLabels(mergedData)
        # Extracts only the measurements on the mean and standard deviation for each measurement
        # And normalize it, so as every column is a variable and every row is an observation
        filteredNormalizedData <- extractAndNormazeMeanAndStdData(mergedData)
                
        # Extract vector with only measurements of accelerometer and gyroscope.
        measurements <- names(f)[! names(f) %in% c("activity", "subject", "measure")]
        # Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
        # group our data by activity and subject, applying mean function to every grouped vector of accelerometer and gyroscope 
        # measurements
        result <-
                aggregate(
                        filteredNormalizedData[, measurements],
                        list(
                                filteredNormalizedData$activity,
                                filteredNormalizedData$subject
                        ),
                        mean
                )
        
        result <- rename(result, activity=Group.1, subject=Group.2)
        
        invisible(result)
}



## method is designed to merge training and test data sets and to set
## normalized column names from feature set.
mergeDataAndNormalizeColNames <- function() {
        if (!is.installed('dplyr')){
                install.packages('dplyr')
        }
        
        library(dplyr)
        
        mergedTraingSet <- 
                rbind(trainFolderCache$getTrainingSet(),
                      testFolderCache$getTrainingSet())
        testFolderCache$getTrainingSet()
 
        features <-
                read.table(paste(pathToResearchData, 'features.txt', sep = '/'))

        names(mergedTraingSet) <- as.vector(features$V2)
        
        mergedLabels <- 
                rbind(trainFolderCache$getTrainingLables(), 
                       testFolderCache$getTrainingLables())
        names(mergedLabels) <- c('activity_id')
     
        mergedSubjects <-
                rbind(trainFolderCache$getTrainingSubject(),
                      testFolderCache$getTrainingSubject())
        names(mergedSubjects) <- c('subject')

        # scince we merged sets and labels in the same order (first train, then test) it is a safe
        # operation, and will have a same effect as merging seperatly each trainingSet with each lables
        mergedData <- cbind(mergedTraingSet, mergedLabels, mergedSubjects)
     
        mergedData
}

## This method is designed to replace all numeric-style activities to
## their string-style representation.
normalizeActivityLabels <- function(data) {
        labelNames <- extractLableNames()
        # reasong for orderKeeped is that merge function changes order. We don't want that.
        data$order_keeper <- 1:nrow(data)
        data <- merge(labelNames, data, by='activity_id')
        data <- arrange(data, order_keeper)
        
        # remove all unnesessary columns
        select(data, -c(activity_id, order_keeper))
        
}
## This method is designed to extract text-style labels from {activity_lables} file.
## Guess you saw that file and it's personaly for me it's a triky question to say what 
## is a right way to normalize it. No additinal info was found on this question and 
## I concider that LAYING activity has id=1, so this hacky method reads and reorders activities
## in such pattern: 1-Laying, 2-Walking, 3-Walk_Upstairs, 4-Walk_Downstairs, 5-Sitting, 6-Standing
extractLableNames <- function() {
        labels <- read.table(paste(pathToResearchData, 'activity_labels.txt', sep='/'))
        tmp <- labels[1,2]
        labels[1,2] <- labels[nrow(labels),2]
        labels[nrow(labels),2] <- tmp
        names(labels) <- c('activity_id', 'activity')
        labels
}

## This method is designed to extract all mean, std, subject, activity columns
## from given data and normalize the returnd frame. We want a tidy data to be returned,
## where each column represents a variable, and each row is exectly one observation.
extractAndNormazeMeanAndStdData <- function(data){
        ## select all columns which and on mean(), contain subject and activity
        mean <- select(data, grep("mean\\(\\)$|subject|activity", names(data)))
        ## create a new column "measure", that is "mean" in our case
        mean$measure <- c('mean')
        ## as other column have names it pattern xx-mean(), and we have a seperate
        ## column that stands for performed measurement, we can simplify the name 
        ## of other columns and remove -mean() from them.
        names(mean) <- gsub("-mean\\(\\)$", "", names(mean))
        
        ## same steps for std
        std <- select(data, grep("std\\(\\)$|subject|activity", names(data)))
        std$measure <- c('std')
        names(std) <- gsub("-std\\(\\)$", "", names(std))
        
        mergedNormalizedData <- rbind(mean, std)
      
        return(mergedNormalizedData)
}

## This method is designed to uppload research data to a specified folder, unzip it, rename unziped file.
## And set global pathToReserachData variable, that point to the root of research data folder.
##
## After execution of this function we will get all researched data in our file system, stored in 'cleaningDataAssignment/data' folder.
## By defalult this methods deletes zip archive after unziping. You can controll this behaviour by {deleteZipAfrerUnzip} parameter.
## Specified folder shouldn't exist in clients file system as we wont to keep our research data in a seperate folder and we don't want
## to delete any folders from clients computer. If specified folder exists in clients file system program execution will be stoped
## with an error message
downloadAndUnzipData <-
        function(destDir = 'cleaningDataAssignment',
                 deleteZipAfrerUnzip = TRUE) {
                url <-
                        'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
                
                if (dir.exists(destDir)) {
                        stop(
                                paste(
                                        'Directory',
                                        destDir,
                                        'exists allready. Please delete it or change a destination directory name'
                                )
                        )
                }
                dir.create(destDir)
                
                
                pathToZipFile <-
                        paste(destDir, 'researchData.zip', sep = "/")
                download.file(
                        'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                        pathToZipFile
                )
                unzip(pathToZipFile, exdir = destDir)
                
                downloadedFileName <- 'UCI HAR Dataset'
                file.rename(
                        paste(destDir, downloadedFileName, sep = "/"),
                        paste(destDir, "data", sep = "/")
                )
                
                if (deleteZipAfrerUnzip)
                        file.remove(pathToZipFile)
                
                pathToResearchData <<-
                        paste(destDir, "data", sep = "/")
                
        }

## This method is designed to init all cache data
initCache <- function() {
        if (is.null(testFolderCache))
                testFolderCache <<- getTestFolderCache()
        if (is.null(trainFolderCache))
                trainFolderCache <<- getTrainFolderCache()
}

## This method is designed to check whether package with {packageName}
## is installed.
is.installed <- function(packageName) {
        is.element(packageName, installed.packages()[, 1])
} 