#################################################################################################
# Assignment:
# You should create one R script called run_analysis.R that does the following.

#   1) Merges the training and the test sets to create one data set.
#   2) Extracts only the measurements on the mean and standard deviation for each measurement.
#   3) Uses descriptive activity names to name the activities in the data set
#   4) Appropriately labels the data set with descriptive variable names.
#   5) From the data set in step 4, creates a second, independent tidy data set with the 
#      average of each variable for each activity and each subject.
#################################################################################################

#--------------------------------------------
# Install packages and load libraries
#--------------------------------------------
install.packages("readr")
library(readr)
install.packages("dplyr")
library(dplyr)

#--------------------------------------------
# Set data file location & download file
#--------------------------------------------
zipfileloc <- "C:/temp/UCI HAR Data.zip"
unzipfileloc <- "C:/temp"
dir.create(unzipfileloc)

zipfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipfile, zipfileloc)
unzip(zipfileloc, exdir = unzipfileloc)

#--------------------------------------------
# Read in column names and activity labels
#--------------------------------------------
fileloc <- paste0(unzipfileloc,"/UCI HAR Dataset")

# Features.txt - Read in column names
features <- read.delim(paste0(fileloc,"/features.txt"), header = FALSE, sep = " ")
names(features)[names(features) == "V1"] <- "variablenumber"
names(features)[names(features) == "V2"] <- "variablenames"

# Manipulate column names to remove some special characters
columnnames <- gsub("\\(","",features$variablenames)
columnnames <- gsub("\\)","",columnnames)
columnnames <- gsub("\\-","",columnnames)
# Replace commas with periods
columnnames <- gsub("\\,","\\.",columnnames)
#bandsEnergy columns have duplicate column names, this will make these unique
columnnames <- make.names(columnnames, unique = TRUE) 

# Read in activity_labels data
activity_labels <- read.delim(paste0(fileloc,"/activity_labels.txt"), header = FALSE, sep = " ")
names(activity_labels)[names(activity_labels) == "V1"] <- "activitynumber"
names(activity_labels)[names(activity_labels) == "V2"] <- "activityname"

#-----------------------------
# Read in Test Data
#-----------------------------
# Test Data
## X_test.txt - measurement data (2947 x 561)
## y_test.txt - activity # that the measurements were taken for (2947 x 1)
###   Activity list from activity_labels.txt
###     1 WALKING
###     2 WALKING_UPSTAIRS
###     3 WALKING_DOWNSTAIRS
###     4 SITTING
###     5 STANDING
###     6 LAYING
## subject_test.txt - participant number (2947 x 1)

# Read in x_test, y_test, and subject_test data
x_test <- read.table(paste0(fileloc,"/test/X_test.txt"), header = FALSE)
for(i in 1:length(columnnames)) {    # Rename x_test columns with column names from features.txt
  names(x_test)[i] <- columnnames[i]
}

y_test <- read.table(paste0(fileloc,"/test/y_test.txt"), header = FALSE)
names(y_test)[names(y_test) == "V1"] <- "activitynumber"

subject_test <- read.table(paste0(fileloc,"/test/subject_test.txt"), header = FALSE)
names(subject_test)[names(subject_test) == "V1"] <- "subjectnumber"

# Read in inertial signals (2947 x 128) for test data and rename columns
body_acc_x_test <- read.table(paste0(fileloc,"/test/Inertial Signals/body_acc_x_test.txt"), header = FALSE)
body_acc_y_test <- read.table(paste0(fileloc,"/test/Inertial Signals/body_acc_y_test.txt"), header = FALSE)
body_acc_z_test <- read.table(paste0(fileloc,"/test/Inertial Signals/body_acc_z_test.txt"), header = FALSE)
body_gyro_x_test <- read.table(paste0(fileloc,"/test/Inertial Signals/body_gyro_x_test.txt"), header = FALSE)
body_gyro_y_test <- read.table(paste0(fileloc,"/test/Inertial Signals/body_gyro_y_test.txt"), header = FALSE)
body_gyro_z_test <- read.table(paste0(fileloc,"/test/Inertial Signals/body_gyro_z_test.txt"), header = FALSE)
total_acc_x_test <- read.table(paste0(fileloc,"/test/Inertial Signals/total_acc_x_test.txt"), header = FALSE)
total_acc_y_test <- read.table(paste0(fileloc,"/test/Inertial Signals/total_acc_y_test.txt"), header = FALSE)
total_acc_z_test <- read.table(paste0(fileloc,"/test/Inertial Signals/total_acc_z_test.txt"), header = FALSE)

for(i in 1:ncol(body_acc_x_test)) names(body_acc_x_test)[i] <- paste0("bodyaccx",i)
for(i in 1:ncol(body_acc_y_test)) names(body_acc_y_test)[i] <- paste0("bodyaccy",i)
for(i in 1:ncol(body_acc_z_test)) names(body_acc_z_test)[i] <- paste0("bodyaccz",i)
for(i in 1:ncol(body_gyro_x_test)) names(body_gyro_x_test)[i] <- paste0("bodygyrox",i)
for(i in 1:ncol(body_gyro_y_test)) names(body_gyro_y_test)[i] <- paste0("bodygyroy",i)
for(i in 1:ncol(body_gyro_z_test)) names(body_gyro_z_test)[i] <- paste0("bodygyroz",i)
for(i in 1:ncol(total_acc_x_test)) names(total_acc_x_test)[i] <- paste0("totalaccx",i)
for(i in 1:ncol(total_acc_y_test)) names(total_acc_y_test)[i] <- paste0("totalaccy",i)
for(i in 1:ncol(total_acc_z_test)) names(total_acc_z_test)[i] <- paste0("totalaccz",i)

# Left join y_test and acitivity_labels, so y_test has the corresponding activity names
y_test <- left_join(y_test, activity_labels, by="activitynumber")
y_test <- select(y_test, activityname)

# Join x_test, y_test, subject_test
test_data <- cbind(x_test, y_test, subject_test)

# Join body_acc_XYZ, body_gyro_XYZ, and total_acc_XYZ vector data to test_data
test_data <- cbind(test_data, body_acc_x_test, body_acc_y_test, body_acc_z_test)
test_data <- cbind(test_data, body_gyro_x_test, body_gyro_y_test, body_gyro_z_test)
test_data <- cbind(test_data, total_acc_x_test, total_acc_y_test, total_acc_z_test)

# Clean up workspace
rm(list=setdiff(ls(), c("fileloc", "unzipfileloc", "columnnames", "activity_labels", "test_data")))

#-----------------------------
# Read in Train Data
#-----------------------------
# Train Data
## X_train.txt - measurement data (7352 x 561)
## y_train.txt - activity # that the measurements were taken for (7352 x 1)
###   Activity list from activity_labels.txt
###     1 WALKING
###     2 WALKING_UPSTAIRS
###     3 WALKING_DOWNSTAIRS
###     4 SITTING
###     5 STANDING
###     6 LAYING
## subject_train.txt - participant number (7352 x 1)

# Read in x_test, y_test, and subject_test data
x_train <- read.table(paste0(fileloc,"/train/X_train.txt"), header = FALSE)
for(i in 1:length(columnnames)) {   # Rename x_train columns with column names from features.txt
  names(x_train)[i] <- columnnames[i]
}

y_train <- read.table(paste0(fileloc,"/train/y_train.txt"), header = FALSE)
names(y_train)[names(y_train) == "V1"] <- "activitynumber"

subject_train <- read.table(paste0(fileloc,"/train/subject_train.txt"), header = FALSE)
names(subject_train)[names(subject_train) == "V1"] <- "subjectnumber"

# Read in inertial signals (7352 x 128) for train data and rename columns
body_acc_x_train <- read.table(paste0(fileloc,"/train/Inertial Signals/body_acc_x_train.txt"), header = FALSE)
body_acc_y_train <- read.table(paste0(fileloc,"/train/Inertial Signals/body_acc_y_train.txt"), header = FALSE)
body_acc_z_train <- read.table(paste0(fileloc,"/train/Inertial Signals/body_acc_z_train.txt"), header = FALSE)
body_gyro_x_train <- read.table(paste0(fileloc,"/train/Inertial Signals/body_gyro_x_train.txt"), header = FALSE)
body_gyro_y_train <- read.table(paste0(fileloc,"/train/Inertial Signals/body_gyro_y_train.txt"), header = FALSE)
body_gyro_z_train <- read.table(paste0(fileloc,"/train/Inertial Signals/body_gyro_z_train.txt"), header = FALSE)
total_acc_x_train <- read.table(paste0(fileloc,"/train/Inertial Signals/total_acc_x_train.txt"), header = FALSE)
total_acc_y_train <- read.table(paste0(fileloc,"/train/Inertial Signals/total_acc_y_train.txt"), header = FALSE)
total_acc_z_train <- read.table(paste0(fileloc,"/train/Inertial Signals/total_acc_z_train.txt"), header = FALSE)

for(i in 1:ncol(body_acc_x_train)) names(body_acc_x_train)[i] <- paste0("bodyaccx",i)
for(i in 1:ncol(body_acc_y_train)) names(body_acc_y_train)[i] <- paste0("bodyaccy",i)
for(i in 1:ncol(body_acc_z_train)) names(body_acc_z_train)[i] <- paste0("bodyaccz",i)
for(i in 1:ncol(body_gyro_x_train)) names(body_gyro_x_train)[i] <- paste0("bodygyrox",i)
for(i in 1:ncol(body_gyro_y_train)) names(body_gyro_y_train)[i] <- paste0("bodygyroy",i)
for(i in 1:ncol(body_gyro_z_train)) names(body_gyro_z_train)[i] <- paste0("bodygyroz",i)
for(i in 1:ncol(total_acc_x_train)) names(total_acc_x_train)[i] <- paste0("totalaccx",i)
for(i in 1:ncol(total_acc_y_train)) names(total_acc_y_train)[i] <- paste0("totalaccy",i)
for(i in 1:ncol(total_acc_z_train)) names(total_acc_z_train)[i] <- paste0("totalaccz",i)

# Left join y_train and acitivity_labels, so y_train has the corresponding activity names
y_train <- left_join(y_train, activity_labels, by="activitynumber")
y_train <- select(y_train, activityname)

# Join x_train, y_train, subject_train
train_data <- cbind(x_train, y_train, subject_train)

# Join body_acc_XYZ, body_gyro_XYZ, and total_acc_XYZ vector data to train_data
train_data <- cbind(train_data, body_acc_x_train, body_acc_y_train, body_acc_z_train)
train_data <- cbind(train_data, body_gyro_x_train, body_gyro_y_train, body_gyro_z_train)
train_data <- cbind(train_data, total_acc_x_train, total_acc_y_train, total_acc_z_train)

# Clean up workspace
rm(list=setdiff(ls(), c("fileloc", "unzipfileloc", "test_data", "train_data")))

#----------------------------------
# Merge test_data and train_data
#----------------------------------
dt_all <- rbind(test_data, train_data)

# Clean up workspace
rm(list=setdiff(ls(), c("fileloc", "unzipfileloc", "dt_all")))

#----------------------------------------------------------
# Extract mean and std columns from the complete dataset
#----------------------------------------------------------
dt_subset <- select(dt_all, c(starts_with("subject"), starts_with("activity"), contains("mean"), contains("std")))

#----------------------------------------------------------
# Take mean of all columns by subject and activity
#----------------------------------------------------------
measurement_means <- dt_subset %>% group_by(subjectnumber, activityname) %>% summarize_all(funs(mean))
# Rename columns to it is clear these are the mean values
for(i in 3:ncol(measurement_means)) {
  names(measurement_means)[i] <- paste0(names(measurement_means)[i],".mean")
}

#-----------------------------------------------------------
# Save data sets to parent directory of the original data
#-----------------------------------------------------------
write.table(dt_all, file = paste0(unzipfileloc,"/full_dataset.txt"), row.names = FALSE)
write.table(dt_subset, file = paste0(unzipfileloc,"/dataset_means_and_stds.txt"), row.names = FALSE)
write.table(measurement_means, file = paste0(unzipfileloc,"/means_by_subject_activity.txt"), row.names = FALSE)

