# JHU-Data-Project
Final project submission for JHU Getting and Cleaning Data Course

#### Data set source:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## Repository files include:
- _README.md_
- _CodeBook.md_: Provides information on all the variables in the data set
- _run_analysis.R_ script: This script downloads the data provided by [1] and manipulates the data according to the course assignment
- _full_dataset.txt_: A merged dataset of the train and test data from [1], output by _run_analysis.R_. This includes data from X_test.txt, X_train.txt, and all the Inertial Signals data for both test and train data set. Each measurement includes the corresponding test subject number (from the subject_test.txt and subject_train.txt data) and activity (y_test.txt, y_train.txt, and activity_labels.txt) for which the measurement was taken.
- _dataset_means_and_stds.txt_: A subset of _full_dataset.txt_ that only includes mean and standard deviation variables (as well as the corresponding test subject and activity that the measurement was taken for). This is output by _run_analysis.R_.
- _means_by_subject_activity.txt_: A summary of _dataset_means_and_stds.txt_ where the mean was taken for each variable by test subject and activity. This is output by _run_analysis.R_. 

## What run_analysis.R does:
- This R script downloads the [data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) to the user's C:/temp/ directory (directory is created if it doesn't already exist) and then unzips the file to the same directory. The features.txt file is read in, which provides the variable names for the X_test.txt and X_train.txt files, and the variable names are manipulated so as to be proper R column names. The activity_labels.txt file is read into R next, which provides the key for activity number and corresponding activity name, which will be used to interpret the y_test.txt and y_train.txt files. 
- The folloing procedure was executed for both the test and train data sets (here test is used as an example)
  + The X_test.txt, y_test.txt, subject_test.txt are read into R as well as all nine of the Inertial Signals data files. 
  + X_test column names were renamed with the manipulated strings found in the features.txt file.
  + y_test.txt data was joined with the activity_labels.txt data so that y_test has the corresponding activity names for the activity numbers. 
  + Inertial Signals data (ex. body_acc_x_test.txt) columns were renamed to be the measured signal name (for this example, "bodyaccx") and a number (1 - 128, as these are 128 element vectors, according to the README.txt from [1]).
  + All the test data is then joined together with cbind (X_test, y_test, subject_test, and all nine Inertial Signals).
- Once the test data and train data were completely assembled as detailed above, these two data sets were merged with rbind. The output of this is the _full_dataset.txt_ file.
- The full dataset was then subset by looking for variables with "mean" and "std" in the name (as well as including the test subject number and the activity name for each of the measurements). The output of this is the _dataset_means_and_std.txt_ file.
- The above data set was then summarized, for we are only interested in the average value of each of the variables by the test subject and the activity. The output of this is the _means_by_subject_activity.txt_ file. Note that ".mean" has been added to all column names from _dataset_means_and_stds.txt_ to make it clear that the average was taken.
- Lastly, the script writes the _full_dataset.txt_, the _dataset_means_and_std.txt_, and the _means_by_subject_activity.txt_ datasets to the user's directory.

***

### From the README.txt provided with the data set from [1], we are provided the following information about the dataset:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

#### For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 
