### Introduction

The data set is broken up as follows:
Training and Test Sets: 'train/X_train.txt' and 'test/X_test.txt'
Training and Test Labels: 'train/Y_train.txt' and 'test/Y_test.txt' 
Subjects: 'train/subject_train.txt' and 'test/subject_test.txt'

## The tasks are:
1. 	Merge the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## My approach is as follows:
1. 	Merge the training and the test sets to create one data set.
	Grab test and training data, then combine it:
	
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
	Grab features names
	Make list of features that have mean or std in them. 
	I am not including the angle means because those are operations on something with a mean, not means on an operation.
	
	Filter merged sets to only show measurements for mean and stdev.
	Note, unlike the rows with features above, here we're filtering the columns.
	
## 3. Uses descriptive activity names to name the activities in the data set.
	Grab activity labels
	Grab the activity labels for each activity
	Return activity name when given a number
	Add the activity names to the data set

## 4. Appropriately labels the data set with descriptive variable names. 
	The names are ready in features_filtered:
	
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	Grab Subject id's:
		subject_test <- read.table(file = "test/subject_test.txt", header = FALSE, sep = "")
		subject_train <- read.table(file = "train/subject_train.txt", header = FALSE, sep = "")
		subjects_merged <- rbind(subject_test, subject_train)
	
	Since our main table is now well-named, make sure the new column is named too

	Append them to our table
	Load appropriate libraries:
		library(dplyr)
		library(tidyr)
	Make Data Tidy 

	We could cut each Measurement even more, for example into frequency/time, acc/gyro, and mean/std, and even X/Y/Z/unspec,
	however the assignment said to give the average Measurement by Subject, Activity, so for this task, breaking up the
	data will not offer any additional help. Furthermore, there are Measurement names that have both freq and time and MEasurement names without a direction which will add additional "unspec." Given the extra mess this creates, I don't see a reason
	to cut the data any farther. I have the same reasoning for not splitting (Walking (blank)/Upstairs/Downstairs).
		
	Now we grab the using a group by and summarize
	
	Data Set Must Be Tidy:
	1. Each variable forms a column.
	2. Each observation forms a row.
	3. Each type of observational unit forms a table.
	
	Does each variable for a column? Yes: we have subject, activity, unique measurement, and value
	Does each observation form a row? Yes: observations are sorted by subject, activity, and unique measurement, with corresponding value
	Does each type of observational unit form a table? Yes: there are no repeating values.


Credits:
Thank you to the forums, especially these two threads:
https://class.coursera.org/getdata-009/forum/thread?thread_id=58
https://class.coursera.org/getdata-009/forum/thread?thread_id=192	
Also the swirl tutorial and the tidy data article were really helpful.
http://swirlstats.com/
http://vita.had.co.nz/papers/tidy-data.pdf



	
	
Original Sources:
Descirption
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Dataset:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip



License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.