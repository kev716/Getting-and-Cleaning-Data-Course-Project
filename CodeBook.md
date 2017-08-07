# Introduction

This project uses text files from the Human Activity Recognition Using Smartphones Data Set project from the UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The text files are combined into a tidy dataset, and then grouped means of a subset of the variables are calculated.

The dataset consists of  a series of measurements taken from smartphone sensors as the 30 subjects participated in 6 different activities such as laying, walking, and climbing stairs. 

# Files and Variables

The data came divided into training and test datasets with identical structures. These were combined for this project.

Each dataset contained the following files, where [a] is "test" or "train":

1. subject_[a].txt - this is a table with one variable, an integer representing the subject who the measurement was obtained from
2. y_[a].txt - this is a table with one variable, an integer representing the activity that the subject was performing when the measurement was obtained
3. X_[a].txt - this is a table with 561 calculated values from the sensor data, such as means, standard deviations, minimums and maximums
4. Inertial Signals files - these contain the raw data from the sensors. They were not used for this project.

The following files describing the data were included:

1. features.txt - this is a 2 column table. Column 1 contains an integer index that links to the column number of the X_test.txt file. Column 2 contains a descriptive name of the column.
2. activity_labels.txt - this is a 2 column table. Column 1 contains an integer index that links to the integer in the y-test.txt file. Column 2 is a character description of the activity.

In addition, README.txt and features_info.txt files describe the experiment and the variables included in the dataset.

# Dataset Tidying and Final Computation
The scripts in run_analysis.R contain the functions that were created for this project. The process was:

 1. Download the HAR files and unzip them

 if(!file.exists("HAR.zip")) {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url,
                  destfile='HAR.zip',
                  method="curl", # for OSX / Linux 
                  mode="wb") # write binary
    unzip(zipfile = "HAR.zip") # unpack the files into subdirectories 

 2. Read the test and train subjects files

 subjects_test <- read_fwf("UCI HAR Dataset/test/subject_test.txt", 
                            fwf_empty("UCI HAR Dataset/test/subject_test.txt"))
 subjects_train <- read_fwf("UCI HAR Dataset/train/subject_train.txt", 
                             fwf_empty("UCI HAR Dataset/train/subject_train.txt"))
  
  3. Combine the test and train subjects tables into a table named subjects
  
  subjects <- rbind(subjects_test, subjects_train)
  
  4. Name the subjects variable "subject"
  
  names(subjects) <- "subject"
  
  5. Read the test and train activities files
  
  activities_test <- read_fwf("UCI HAR Dataset/test/y_test.txt", 
                              fwf_empty("UCI HAR Dataset/test/y_test.txt"))
  activities_train <- read_fwf("UCI HAR Dataset/train/y_train.txt", 
                               fwf_empty("UCI HAR Dataset/train/y_train.txt"))
  
  6. Combine the test and train activities tables into a table named activities
  
  activities <- rbind(activities_test, activities_train)
  
  7. Name the activites column "activity"
  
  names(activities) <- "activity"
  
  8. Read the activity labels into a table named actLabels
  
  actLabels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = " ")
  
 9. Create a vector named actNum from actLabels first column, which contain integers representing each activity
 
  actNum <- as.vector(actLabels$V1)
  
  10. Create a vector from actLabels second column, which contain descriptions of each activity. Use this vector to name the variables in actNum.
  
  names(actNum) <- as.vector(actLabels$V2)
  
 11. Match the activity columns in the activities and actNum tables, and then switch the activities column in the activities table from numbers to the names of the actNum variables
 
  activities$activity <- names(actNum)[match(activities$activity, actNum)]
  
  12. Read the test and train measurements files
  
  measures_test <- read_fwf("UCI HAR Dataset/test/X_test.txt", 
                            fwf_empty("UCI HAR Dataset/test/X_test.txt"))
  measures_train <- read_fwf("UCI HAR Dataset/train/X_train.txt", 
                             fwf_empty("UCI HAR Dataset/train/X_train.txt"))
  
  13. Combine the test and train measurements tables into a table named measures
  
  measures <- rbind(measures_test, measures_train)
  
 14. Read the features file into a table named measureLabels
 
  measureLabels <- read.table("UCI HAR Dataset/features.txt", sep = " ")
  
  15. Create a vector from the 2nd column of the measureLabels, and use this to name the variables in the measures table
  
  names(measures) <- as.vector(measureLabels$V2)
  
  16. Extract only the variables from measures that contain the strings "mean" or "std"
  
  measures <- measures[, grep(paste(c("mean", "std"), collapse = "|"), colnames(measures))]
  
17. Merge the subjects, activities, and measures tables into a table named HarTidyData

HarTidyData <- do.call(cbind, list(subjects, activities, measures))   
  
 18. Group the HarTidyData table by subject and activity into a table named dataGrouped
 
  dataGrouped <- group_by(HarTidyData, subject, activity)
  
  19. Calculate the means of all ungroups varibles in the dataGrouped table into a table named HarMeans
  
  HarMeans <- summarise_all(dataGrouped, mean)
