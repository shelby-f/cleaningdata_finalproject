## run_analysis 

## download data 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "final_data.zip")
unzip("final_data.zip")

## Merge the training and the test sets to create one data set
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
## rename columns
features <- read.table("UCI HAR Dataset/features.txt")
names(features) <- c("ID", "Feature")
names(test_data) <- as.character(features$Feature)

train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
names(train_data) <- as.character(features$Feature)

## merge data and labels 
library(dplyr)
test <- bind_cols(test_labels, test_data)
train <- bind_cols(train_labels, train_data)

## merge train and test
data <- bind_rows(test, train)

## rename activities (step 3)
activities <- data %>%
  mutate(V1 = replace(V1, V1 == "1","WALKING")) %>%
  mutate(V1 = replace(V1, V1 == "2","WALKING_UPSTAIRS")) %>%
  mutate(V1 = replace(V1, V1 == "3","WALKING_DOWNSTAIRS")) %>%
  mutate(V1 = replace(V1, V1 == "4","SITTING")) %>%
  mutate(V1 = replace(V1, V1 == "5","STANDING")) %>%
  mutate(V1 = replace(V1, V1 == "6","LAYING"))

## Extracts only the measurements on the mean and standard deviation for each measurement.
stdmean_data <- select(activities, contains ("V1"), contains("std()"), contains("mean()"))

## From the data set in step 4, creates a second, 
##  independent tidy data set with the average of each 
##  variable for each activity and each subject

average_data <- stdmean_data %>%
  group_by(V1) %>%
  summarise_all(list(mean = mean))



