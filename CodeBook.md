---
title: "CodeBook"
author: "Jean Pelkey"
date: "April 28, 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

### Code book for Getting and Cleaning Data student project

#### The analysis in this student project are based on a study with data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained.  

#### http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Here are the data for the project:

#### https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip



#### The original data set included the following information provided by the README.TXT file on the website. Each record includes:

####- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
####- Triaxial Angular velocity from the gyroscope. 
####- A 561-feature vector with time and frequency domain variables. 
####- Its activity label. 
####- An identifier of the subject who carried out the experiment.

<br>


### Contents of raw data file:

<br>

####1. features.txt: List of all features.  

####2. activity_labels.txt: Links the class labels with their activity name.

####3. X_train.txt': Training data set.

####4. y_train.txt': Training label corresponding to observations in X_train.txt

####5. X_test.txt': Test data set.

####6. y_test.txt': Test labels corresponding to observations in X_test.txt

####7. subject_train.txt: Each row identifies the subject who performed the activity for each data point in X_train.txt. 

####8. subject_test.txt: Each row identifies the subject who performed the activity for each data point in X_test.txt. 

<br>

###The following describes the data frames and how they were used to complete the assignment:

<br>

####Column.Names - read all column heading names from features.txt
####activity_labels - contains all 6 names of activities performed by subject
####X_test - read in X_test.txt, 2947 x561 entries of data testing model
####X_train - read in X_train.txt, 7352 x 561 variables entries of data for training model. 
####y_test - read in y_test.txt 
####y_train - read in y_train.txt

<br>

###Transformation activities in script:

<br>

 * ####Mean_Std_Locations - Data table of True/False entries associated with Column.Names data table which are column headers for X_test & X_train datafiles
 * ####Merged_X_data_table - Data table that merges X_train and X_test using rbind() function.
 * ####Mean_Std_Data_Subset - Data table that contains a subset of columns from Merged_X_data_table that contain "mean" and "std" in column names
 * ####subject - Data table of subject_train & subject_test merged using rbind() function.
 * ####Y_data_table - Data Table of combined Y_train and Y_test using rbind() function.
 * ####Y_and_subjects  - Data table combining Y_data_table and subject data using cbind() function. 
 * ####Y_activities_subjects - Data table combining Y_and_subjects and activity_labels using cbind() function. 
 * ####Combined_data_table - Data table combining Y_activities_subjects and Mean_Std_Data_Subset, the full data set with only columns with Mean and std in column titles. 
 * ####Tidy_data_means - Final data set computing mean of columns by subject and by activity type. 
 
 <br>

###Column header cleanup to make titles descriptive and self explanatory. 
 
 <br>

* ####Replace "Acc" with "Accelerometer"
* ####Replace "Gyro" with "Gyroscope"
* ####Replace "BodyBody" with "Body"
* ####Replace "Mag" with "Magnitude"
* ####Replace "^t"with "Time""
* ####Replace "^f" with "Frequency"
* ####Replace "tBody" with "TimeBody"
* ####Replace "-mean()", "Mean"
* ####Replace "-std()" with "STD"
* ####Replace "-freq()" with "Frequency"
* ####Replace "angle"with "Angle"
* ####Replace "gravity" with "Gravity"

###Output Data set - Script will output a tidy data set to file:  "TidyData.txt""

<br>

####Reference:  Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

