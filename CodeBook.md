# Introduction

This project uses text files from the Human Activity Recognition Using Smartphones Data Set project from the UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The text files are combined into a tidy dataset, and then grouped means of a subset of the variables are calculated.

The dataset consists of  a series of measurements taken from smartphone sensors as the 30 subjects participated in 6 different activities such as laying, walking, and climbing stairs. 

# Files and Variables

The data came divided into training and test datasets with identical structures. These were combined for this project.

Each dataset contained the following files:

1. subject_test.txt - this is a table with one variable, an integer representing the subject who the measurement was obtained from
2. y_test.txt - this is a table with one variable, an integer representing the activity that the subject was performing when the measurement was obtained
3. X_test.txt - this is a table with 561 calculated values from the sensor data, such as means, standard deviations, minimums and maximums
4. Inertial Signals files - these contain the raw data from the sensors. They were not used for this project.

In addition, the following files describing the data were included:

1. features.txt - this is a 2 column table. Column 1 contains an integer index that links to the column number of the X_test.txt file. Column 2 contains a descriptive name of the column.
2. activity_labels.txt - this is a 2 column table. Column 1 contains an integer index that links to the integer in the y-test.txt file. Column 2 is a character description of the activity.

In addition, README.txt and features_info.txt files describe the experiment and the variables included in the dataset.

# Dataset Tidying and Final Computation
The scripts in run_analysis.R contain the functions that were created for this project. The basic steps that they perform are:
1. Read the data from each of the above described text files
2. Combine the test and training tables for subjects, activities, and measures
3. Add variable names and labels as appropriate
4. Extract means and standard deviation variables from the measures table
5. Merge the 3 tables
6. Group the data by subjects and activity
7. Create a new table consisting of grouped means for each of the remaining variables in the original table
