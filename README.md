---
title: "README"
author: "Jean Pelkey"
date: "April 26, 2017"
output: html_document
---

## Getting and Cleaning Data Course Project {#css_id}

#### The purpose of the project is to demonstrate the ability to collect, work with, and clean a large data set. The goal is to prepare tidy data that can be used for later analysis.  

#### One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

#### http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Here are the data for the project:

#### https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


## run_Analysis.R {#css_id}

#### run_Analysis.R does the the following. 

#### 1. Merges the training and the test sets to create one data set.
#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#### 3. Uses descriptive activity names to name the activities in the data set
#### 4. Appropriately labels the data set with descriptive variable names.
#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#### See CodeBook.md in repository for explanation of the variables in the script. 


## How this script works {#css_id}


### Libraries Used:  {.css_class} 

#### This script uses dtplyr library as it includes both data.table and dplyr libraries combined. The script will install and load the library needed to run the script. 

### File locations/working directory  {.css_class} 

#### This script assumes the data has been downloaded and unzipped in the same directory that holds the script.  
#### The tidy data file output will be saved in this directory. 


#### *Instruction to User:  edit the script to set your working directory that contains unzipped data files. *


### How this script works - Explain the steps in script {.css_class} 


#### 1.  Read column names from *features.txt* into a data.table called Column.Names and identify locations of those column names that include "mean" and "std". 
#### This is done first in order to assign column names as part of reading data tables X_train and X_test and tp immediately reduce the data table to remove unneeded colums. 
<br>

```{r}
Column.Names <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
Mean_Std_Locations <-grepl("*Mean*|*Std*", Column.Names[,2], ignore.case = TRUE)
```
<br>

#### 2. Read X_train, X-test, assign Column.Names.  Merge training and test data set together into Merged_X_data_table using rbind() function. Then subset the Merged X_data_table to retain all columns that have "mean" or "std" in the column name. 

<br>

```{r}
X_train <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/train/X_train.txt", col.names=Column.Names[,2], quote="\"", comment.char="")
X_test <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/test/X_test.txt", col.names=Column.Names[,2], quote="\"", comment.char="") 
Merged_X_data_table<-rbind(X_train,X_test)
Mean_Std_Data_Subset <-Merged_X_data_table[,Mean_Std_Locations]
```
<br>

#### 3. Read subject train and test information and merge using rbind() function.  
<br>


```{r} 
subject_train <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/train/subject_train.txt", col.names="Subject_No", quote="\"", comment.char="")<br>
subject_test <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/test/subject_test.txt", col.names="Subject_No", quote="\"", comment.char="")
subject <-rbind(subject_train,subject_test)
```
<br>

#### 4. Read Y train and test information and merge using rbind() function.
<br>

```{r} 
y_train <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/train/y_train.txt",  col.names="Activity_No.", quote="\"", comment.char="")
y_test <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/test/y_test.txt", col.names="Activity_No.", quote="\"", comment.char="")
Y_data_table <-rbind(y_train,y_test)
```
<br>

#### 5. Merge subject and Y data tables using the cbind() function
<br>


```{r} 
Y_and_subjects <- cbind(subject, Y_data_table )
```
<br>

#### 6. Read Activity Labels into a data frame and merge with Y_and_subjects 
<br>


```{r} 
Activity_column_names<-c("Activity_No.", "Activity_Name")
activity_labels <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/activity_labels.txt", col.names=Activity_column_names, quote="\"", comment.char="")
Y_activities_subjects <- merge(Y_and_subjects, activity_labels)
```
<br>

#### 7. Merge Y, Activity names and subject information with the X data set that includes only columns with "mean" and "std" in column names. 
<br>

```{r} 
Combined_data_table <-cbind(Y_activities_subjects, Mean_Std_Data_Subset)
```
<br>

#### 8. Clean up names of columns to make them clear. Remove abbreviations to make the activity names descriptive and clearly defined. 
<br>
```{r} 
names(Combined_data_table)<-gsub("Acc", "Accelerometer", names(Combined_data_table))
names(Combined_data_table)<-gsub("Gyro", "Gyroscope", names(Combined_data_table))
names(Combined_data_table)<-gsub("BodyBody", "Body", names(Combined_data_table))
names(Combined_data_table)<-gsub("Mag", "Magnitude", names(Combined_data_table))
names(Combined_data_table)<-gsub("^t", "Time", names(Combined_data_table))
names(Combined_data_table)<-gsub("^f", "Frequency", names(Combined_data_table))
names(Combined_data_table)<-gsub("tBody", "TimeBody", names(Combined_data_table))
names(Combined_data_table)<-gsub("-mean()", "Mean", names(Combined_data_table), ignore.case = TRUE)
names(Combined_data_table)<-gsub("-std()", "STD", names(Combined_data_table), ignore.case = TRUE)
names(Combined_data_table)<-gsub("-freq()", "Frequency", names(Combined_data_table), ignore.case = TRUE)
names(Combined_data_table)<-gsub("angle", "Angle", names(Combined_data_table))
names(Combined_data_table)<-gsub("gravity", "Gravity", names(Combined_data_table))
```
<br>

#### 9. Final step is to calculate means of each column grouping by subject and activity type and write to "TidyData.txt" that is saved to the working directory.
<br>

```{r} 
Tidy_data_means <-aggregate(. ~Activity_Name + Subject_No, Combined_data_table,mean)

write.table(Tidy_data_means, file = "TidyData.txt", row.names = FALSE)
```

* end of file 