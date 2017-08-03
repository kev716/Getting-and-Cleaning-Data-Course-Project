# This script downloads and unzips the UCI HAR Dataset and then:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#   of each variable for each activity and each subject.

Wk4Assign <- function() {
    library(dplyr)
    library(readr)
    library(curl)
    
  # Check if directory exists and downloads it if it doesn't
    if(!file.exists("HAR.zip")) {
      url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(url,
        destfile='HAR.zip',
        method="curl", # for OSX / Linux 
        mode="wb") # "wb" means "write binary," and is used for binary files
      unzip(zipfile = "HAR.zip") # unpack the files into subdirectories 
    }

  # Read test & train subject files
    subjects_test <- read_fwf("UCI HAR Dataset/test/subject_test.txt", 
                             fwf_empty("UCI HAR Dataset/test/subject_test.txt"))
    subjects_train <- read_fwf("UCI HAR Dataset/train/subject_train.txt", 
                              fwf_empty("UCI HAR Dataset/train/subject_train.txt"))
    
    # Combine subject files and name its only column
    subjects <- rbind(subjects_test, subjects_train)
    names(subjects) <- "subject"

    # Read y test & train files, which contain activities performed
    activities_test <- read_fwf("UCI HAR Dataset/test/y_test.txt", 
                             fwf_empty("UCI HAR Dataset/test/y_test.txt"))
    activities_train <- read_fwf("UCI HAR Dataset/train/y_train.txt", 
                       fwf_empty("UCI HAR Dataset/train/y_train.txt"))
    
    # Combine 2 y files and name its only column activity
    activities <- rbind(activities_test, activities_train)
    names(activities) <- "activity"
    
    # Read activity labels
    actLabels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = " ")
    
    # First column of actLabels contains numeric code that matches activities column
    # second column contains description of activity
    actNum <- as.vector(actLabels$V1)
    names(actNum) <- as.vector(actLabels$V2)
    
    # Match actNum variables with activities & substitute descriptions
    activities$activity <- names(actNum)[match(activities$activity, actNum)]
  
    # Read X test & train files, which contain sensor measures, and combine
    measures_test <- read_fwf("UCI HAR Dataset/test/X_test.txt", 
                       fwf_empty("UCI HAR Dataset/test/X_test.txt"))
    measures_train <- read_fwf("UCI HAR Dataset/train/X_train.txt", 
                        fwf_empty("UCI HAR Dataset/train/X_train.txt"))
    
    measures <- rbind(measures_test, measures_train)
    
    # read features file which has measures variables names, and use 2nd column to name 
    #  measure variables
    measureLabels <- read.table("UCI HAR Dataset/features.txt", sep = " ")
    names(measures) <- as.vector(measureLabels$V2)
    
    # Extract columns from measures that contin mean or standard deviation
    measuresSel <- measures[, grep(paste(c("mean", "std"), collapse = "|"), colnames(measures))]
    
    # Combine subjects, activities & measuresSel data tables
    HarTidyData <- do.call(cbind, list(subjects, activities, measuresSel))   
    
    # Remove temporary objects
    rm(activities, activities_test, activities_train, actLabels, measureLabels, measures, 
       measures_test, measures_train, measuresSel, subjects, subjects_test, subjects_train, 
       actNum)

    # Create 2nd table by grouping HarTidyData by subjects & activities, then find
    #  means for all ungrouped columns
    dataGrouped <- group_by(HarTidyData, subject, activity)
    HarMeans <- summarise_all(dataGrouped, mean)
    
    #Remove temporary table
    rm(dataGrouped)
}