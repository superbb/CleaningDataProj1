##  Description: 
##  The following code reads in the UCI HAR Dataset, 
##  merges data from train and test data set
##  filters data for variables with mean, std
##  rebuilds the table so it's more readable
##  finally it makes the table tidy
##  and pulls the average for each subject, activity, and variable

##  To make calling the files easier, I've set the working 
##  directory to the data set:
##  setwd(dir = "../Desktop/r-dir/cleaning/")
##  This file is set to run with the data set as a subfolder.


##  According to the README.txt, the data is stored as follows:
##  Training and Test Sets: 'train/X_train.txt' and 'test/X_test.txt'
##  Training and Test Labels: 'train/Y_train.txt' and 'test/Y_test.txt' 
##  Subjects: 'train/subject_train.txt' and 'test/subject_test.txt'

##  Leaving cleanup off to help graders see how things work.
runcleanup <- FALSE

##
##  1. Merge the training and the test sets to create one data set.
##   

##	Grab test and training data, then combine it:
X_test <- read.table(file = "UCI HAR Dataset/test/X_test.txt", 
                     header = FALSE, sep = "")
X_train <- read.table(file = "UCI HAR Dataset/train/X_train.txt", 
                      header = FALSE, sep = "")
sets_merged <- rbind(X_test, X_train)

##  cleanup
if(runcleanup) { rm(X_test, X_train)}


##
##  2. Extracts only the measurements on the mean and standard 
##     deviation for each measurement. 

##  Grab features names
features <- read.table(file = "UCI HAR Dataset/features.txt", header = FALSE, col.names = c("feature_id", "feature"), sep="")
		
##  Make list of features that have mean or std in them. 
##  I am not including the angle means because those are 
##  operations on something with a mean, not means on an 
##  operation.
features_mean <- grep("mean", features$feature)
features_std <- grep("std", features$feature)	
features_filtered <- features[unique(c(features_mean, features_std)),]

	
	
##  Filter merged sets to only show measurements for mean and stdev.
##  Note, unlike the rows with features above, here 
##  we're filtering the columns.
sets_merged_filtered <- sets_merged[,features_filtered$feature_id]
	
##  Cleanup
if(runcleanup) {rm(features_mean, features_std, sets_merged)}
	
##	
##  3. Uses descriptive activity names to name the 
##     activities in the data set.

##  Grab activity labels
activity_names <- read.table(file = "UCI HAR Dataset/activity_labels.txt", 
                             header = FALSE, 
                             col.names = c("activity_id", "activity"),
                             sep = " ", strip.white = TRUE,
                             stringsAsFactors = FALSE)
		
##  Grab the activity labels for each activity
Y_test <- read.table(file = "UCI HAR Dataset/test/Y_test.txt", 
                     header = FALSE, sep = "")
Y_train <- read.table(file = "UCI HAR Dataset/train/Y_train.txt", 
                     header = FALSE, sep = "")	
labels_merged <- rbind(Y_test, Y_train)
		
##	Return activity name when given a number
activity_name <- function(mykey) {
	return(activity_names$activity[
	       which(activity_names$activity_id == mykey)])
}

labels_merged_named <- sapply(labels_merged$V1,activity_name)
	
##  Add the activity names to the data set
sets_merged_filtered_named <- cbind(labels_merged_named, sets_merged_filtered)

##  Cleanup
if(runcleanup) {rm(Y_test, Y_train, labels_merged_named, sets_merged_filtered)}


##
##  4. Appropriately labels the data set with descriptive variable names. 
##		
##  The names are ready in features_filtered:
names(sets_merged_filtered_named) <- c("Activity",
      as.character(features_filtered$feature))
	

##  Cleanup
if(runcleanup) {rm(labels_merged, features_filtered)}
	
##  
##  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##

##	Grab Subject id's:
subject_test <- read.table(file = "UCI HAR Dataset/test/subject_test.txt", 
                           header = FALSE, sep = "")
subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt", 
                           header = FALSE, sep = "")
subjects_merged <- rbind(subject_test, subject_train)
	
##  Since our main table is now well-named, make sure the new column is named too
names(subjects_merged)<- "Subject"
	
##  Append them to our table
full_table <- cbind(subjects_merged, sets_merged_filtered_named)


##  Load appropriate libraries:
library(dplyr)
library(tidyr)
		
bigdf <- tbl_df(full_table)

##  Make Data Tidy 
ndf <- gather(bigdf, Measurement, Value, 3:length(bigdf))
ndf <- mutate(ndf, Measurement = gsub(Measurement, pattern="\\(\\)\\-", replacement="."))		
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="Acc",replacement=".Accelerometer."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="Gyro",replacement=".Gyroscope."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="Mag",replacement=".Magnitude."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="Jerk",replacement=".Jerk."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="fBody",replacement=".Frequency.Body.")) 
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="tBody",replacement=".Time.Body."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="tGravity",replacement=".Time.Gravity."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="Body",replacement=".Body."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="mean",replacement=".Mean."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="std",replacement=".StDev."))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="\\-",replacement=""))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="...",replacement=".",fixed=TRUE)) 
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="..",replacement=".", ,fixed=TRUE))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="()",replacement="", ,fixed=TRUE))
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="^\\.",replacement="",fixed=FALSE)) 
ndf <- mutate(ndf, Measurement = gsub(Measurement,pattern="\\.$",replacement="",fixed=FALSE)) 

##  Cleanup
## Cleanup
if(runcleanup) {rm(subject_test, sets_merged_filtered_named, subject_train, subjects_merged, full_table, bigdf)}


##  We could cut each Measurement even more, for example into
##  frequency/time, acc/gyro, and mean/std, and even X/Y/Z/unspec, 
##  however the assignment said to give the average Measurement by 
##  Subject, Activity, so for this task, breaking up the data will not 
##  offer any additional help. Furthermore, there are Measurement names 
##  that have both freq and time and MEasurement names without a 
##  direction which will add additional "unspec." Given the extra mess t
##  his creates, I don't see a reason	to cut the data any farther. I 
##  have the same reasoning for not splitting (Walking 
##  (blank)/Upstairs/Downstairs).
	
##  Now we grab the averages:
ndf2 <- ndf %>% group_by(Subject, Activity, Measurement) %>% summarize(average = mean(Value)) 
	
##  Data Set Must Be Tidy:
##	1. Each variable forms a column.
##	2. Each observation forms a row.
##	3. Each type of observational unit forms a table.
	
##  1. Does each variable for a column? Yes: we have subject, 
##  activity, unique measurement, and value
##	2. Does each observation form a row? Yes: observations are sorted
##  by subject, activity, and unique measurement, with corresponding 
##  value
##	3. Does each type of observational unit form a table? Yes: there ##  are no repeating values.

##  Write to a file in case someone wants to take a look.
write.table(ndf2,file="final_results.txt",row.names = FALSE)