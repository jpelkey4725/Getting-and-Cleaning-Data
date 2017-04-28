install.packages("dtplyr")
library(dtplyr)


# This is the file run_analysis.R which perform the following required steps:  
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.

#Set working directory for location of all data files for assignment

setwd("~/R/Getting and cleaning data week 4/UCI HAR Dataset")

#***********************************************************************************************************************
#
# Read column names from features.txt file. This provides column names (561 column names) for X_train and X_test data sets. 
# Use grepl function to identify which columns contain "mean" and "std". Store that information in data table Mean_Std_Locations
#
#************************************************************************************************************************

Column.Names <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
Mean_Std_Locations <-grepl("*Mean*|*Std*", Column.Names[,2], ignore.case = TRUE)



#***********************************************************************************************************************
#
# Read X_train and X_test with column names from Column.Names above.  
# Concatenate X_train and X-test using rbind function
# Remove all columns from data table by keeping those columns identified by Mean_Std_Locations above 
#
# Output data table based on steps outlined above:  Mean_Std_Data_Subset
#
#**********************************************************************************************************************


X_train <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/train/X_train.txt", col.names=Column.Names[,2], quote="\"", comment.char="")
X_test <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/test/X_test.txt", col.names=Column.Names[,2], quote="\"", comment.char="")
Merged_X_data_table<-rbind(X_train,X_test)

Mean_Std_Data_Subset <-Merged_X_data_table[,Mean_Std_Locations]


#**********************************************************************************************************************
#
# Read subject data sets for train and test data sets and merge together using rbind function. 
#
# Output data table based on steps outlined above:  subject
#
#************************************************************************************************************************

subject_train <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/train/subject_train.txt", col.names="Subject_No", quote="\"", comment.char="")
subject_test <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/test/subject_test.txt", col.names="Subject_No", quote="\"", comment.char="")
subject <-rbind(subject_train,subject_test)


#***********************************************************************************************************************
#
# Read y_test and y_test data sets into data frame. Both data sets have 1 variable in a column per data frame. 
# Merge y_train and y_test to a single data frame using rbind function.
#
# Output data table based on steps outlined above:  Merged_Y_data_table
#
#************************************************************************************************************************  

y_train <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/train/y_train.txt",  col.names="Activity_No.", quote="\"", comment.char="")
y_test <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/test/y_test.txt", col.names="Activity_No.", quote="\"", comment.char="")
Y_data_table <-rbind(y_train,y_test)

#***********************************************************************************************************************
#
# Merge subject data table and Merged_Y_data_table using cbind function. 
#
# Output data table based on steps outlined above:  Merged_Y_data_table
#
#************************************************************************************************************************  

Y_and_subjects <- cbind(subject, Y_data_table )


#***********************************************************************************************************************
#
# Read Activity number and labels into a data frame called "activity_labels". These values will be used to recode 
# the "Y" data to define the activity set for each subject and activity. Store the final merged data columns into 
# data table Y_activities_subjects. Also drop the redundant column with the activity code 1-6.
#
#  Output data frame:  Y_activities_subjects
#
#************************************************************************************************************************

Activity_column_names<-c("Activity_No.", "Activity_Name")

activity_labels <- read.table("~/R/Getting and cleaning data week 4/UCI HAR Dataset/activity_labels.txt", col.names=Activity_column_names, quote="\"", comment.char="")

Y_activities_subjects <- merge(Y_and_subjects, activity_labels)
Y_activities_subjects$Activity_No.<-NULL


#***********************************************************************************************************************
#
# Create Combined_data_table that includes Mean_Std_Data_Subset and Y_activities_subjects.   
#  This data.frame has 89 columns and 10299 rows. 
#
#  Output data frame:  Combined_data_table
#
#************************************************************************************************************************

Combined_data_table <-cbind(Y_activities_subjects, Mean_Std_Data_Subset)
head(Combined_data_table)
dim(Combined_data_table)

#***********************************************************************************************************************
#
# Clean up column names and make them descriptive of activity.  
#
#************************************************************************************************************************

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


#***********************************************************************************************************************
#
# Final step in code - compute mean of data by Subject and by Activity Name 
# Clean up column names by replacing any abbreviations with full names and save the resulting data table in Tidy_data_means.txt 
#
#  Output data file:  Tidy_data_means.txt
#
#************************************************************************************************************************

Tidy_data_means <-aggregate(. ~Activity_Name + Subject_No, Combined_data_table,mean)


write.table(Tidy_data_means, file = "TidyData.txt", row.names = FALSE)



