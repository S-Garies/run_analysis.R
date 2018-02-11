Coursera "Getting and Cleaning Data" Week 4 Assignment
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================
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

Activity Labels
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

#Read data from UCI HAR File.
dfXtest <- read.table("test/X_test.txt")
dfytest <- read.table("test/y_test.txt")
dfsubjecttest <- read.table("test/subject_test.txt")
dfXtrain <- read.table("train/X_train.txt")
dfytrain <- read.table("train/y_train.txt")
dfsubjecttrain <- read.table("train/subject_train.txt")
activitylabels <- read.table("activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

#Extract only the measurements on the mean and SD for each measurement.
featuresMeanSD <- grep(".*mean.*|.*std.*", features[,2])
featuresMeanSDnames <- features[featuresMeanSD,2]
featuresMeanSDnames = gsub('-mean', 'Mean', featuresMeanSDnames)
featuresMeanSDnames = gsub('-std', 'Std', featuresMeanSDnames)
featuresMeanSDnames <- gsub('[-()]', '', featuresMeanSDnames)

#Merge data sets.
test <- dfXtest[featuresMeanSD]
test <- cbind(dfsubjecttest, dfytest, test)
train <- dfXtrain[featuresMeanSD]
train <- cbind(dfsubjecttrain, dfytrain, train)
mergeddata <- rbind(train, test)

#Use descriptive activity names to name the activities in the data set.
colnames(mergeddata) <- c("subject", "activity", featuresMeanSDnames)
mergeddata$activity <- factor(mergeddata$activity, levels = activitylabels[,1], labels = activitylabels[,2])
mergeddata$subject <- as.factor(mergeddata$subject)
meltmergeddata <- melt(mergeddata, id = c("subject", "activity"))

#Create second, independent tidy data set with the average of each variable for each activity and each subject.
tidymean <- dcast(meltmergeddata, subject + activity ~ variable, mean)
write.table(tidymean, "tidymean.txt", row.names = FALSE, quote = FALSE)

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
