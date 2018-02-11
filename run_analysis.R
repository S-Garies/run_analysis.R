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

