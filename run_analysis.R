setwd("~/Dropbox/Yale/Courses/2015-Summer/DataSpecialization/3_GettingCleaningData/getting-and-cleaning-data/")

library(dplyr)
library(tidyr)

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
#              destfile = "CourseProject/getdata_projecfiles.zip",
#              method="curl")
# 
# unzip("CourseProject/getdata_projecfiles.zip", files = NULL, list = FALSE, overwrite = TRUE,
#       junkpaths = FALSE, exdir = "./CourseProject/", unzip = "internal",
#       setTimes = FALSE)

##################################################################
# Project specifications:
##################################################################
### (1)  Merge the training and the test sets to create one data set.
X_test <- read.table("UCI HAR Dataset/test/X_test.txt") # feature vectors for test data
y_test <- read.table("UCI HAR Dataset/test/y_test.txt") # activity labels for test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt") # subject IDs
X_train <- read.table("UCI HAR Dataset/train/X_train.txt") # feature vectors for training data
y_train <- read.table("UCI HAR Dataset/train/y_train.txt") # activity labels for training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt") # subject IDs
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") # activity label names
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE) # column names for the test and train datasets

# verify that the datasets are similar
nrow(X_train)/(nrow(X_train) + nrow(X_test)) # gives 71% ... that's close enough, I guess
ncol(X_train) == ncol(X_test) # yields TRUE
sum(!colnames(X_test) == colnames(X_train)) # yields TRUE for all columns, so should output 0 (meaning no conflict in column names between the test and train data sets)
length(table(subject_train)) + length(table(subject_test)) # yields 30, the number of subjects

# merge the data sets and rename some columns to be more useful
colnames(subject_test) <- "SubjectID"
colnames(subject_train) <- "SubjectID"
colnames(y_test) <- "Activity"
colnames(y_train) <- "Activity"
colnames(X_test) <- features[,2]
colnames(X_train) <- features[,2]
test_dat <- cbind(subject_test, Condition="test", y_test, X_test)
train_dat <- cbind(subject_train, Condition="train", y_train, X_train)
dat <- rbind(train_dat, test_dat) # merged data set

### (2)  Extract only the measurements on the mean and standard deviation for each measurement. 
# It looks like -mean and -std indicate which column names contain the means and standard deviations for the measurements.
# There are also some column names that say "meanFreq()".  
std <- grep("-std", features[,2])
means <- grep("-mean", features[,2])

# sanity check:  do these look right?  I.e., do they yield a list of names that include -st() and -mean()
features[std, 2]
features[means,2]

# cols_to_keep <- sort(c("SubjectID", "Condition", "Activity", features[means+3, 2], features[std+3, 2])) 

# It would probably be better to use the names of the columns, BUT I like that the below
# lets me keep the columns in their original order much more easily than the above
# commented out version.
cols_to_keep <- sort(c(1, 2, 3, means+3, std + 3)) # the 1,2,3 at the beginning includes the SubjectID, Condition, and Activity columns
tidy_dat <- dat[,cols_to_keep]


### (3)  Use descriptive activity names to name the activities in the data set
tidy_dat[tidy_dat$Activity == "1", "Activity"] <- as.character(activity_labels[1,2])
tidy_dat[tidy_dat$Activity == "2", "Activity"] <- as.character(activity_labels[2,2])
tidy_dat[tidy_dat$Activity == "3", "Activity"] <- as.character(activity_labels[3,2])
tidy_dat[tidy_dat$Activity == "4", "Activity"] <- as.character(activity_labels[4,2])
tidy_dat[tidy_dat$Activity == "5", "Activity"] <- as.character(activity_labels[5,2])
tidy_dat[tidy_dat$Activity == "6", "Activity"] <- as.character(activity_labels[6,2])


### (4)  Appropriately label the data set with descriptive variable names.
# Fix up the names of the variables:
cleaner_names <- colnames(tidy_dat)
cleaner_names <- gsub("-std\\(\\)", "StandDev", cleaner_names)
cleaner_names <- gsub("-mean\\(\\)", "Average", cleaner_names)
cleaner_names <- gsub("-", "_", cleaner_names)
cleaner_names <- gsub("_meanFreq\\(\\)", "AverageFreq", cleaner_names)

colnames(tidy_dat) <- cleaner_names

# I didn't modify any other parts of the variable names because, frankly, they seemed 
# relatively explanatory (not abbreviated in mysterious ways).  Except I actually have
# no idea what any of those things are.

write.table(tidy_dat, "step4_tidy_data.txt", sep="\t")


### (5)  From the data set in step 4, create a second, independent tidy data set with the
# average of each variable for each activity and each subject.

# convert to long form:
tidy_summarized <- gather(tidy_dat, Dimension, Value, -c(SubjectID:Activity)) %>% # converts to "long" format
                   group_by(Activity, SubjectID, Dimension) %>% # groups include measurement type
                   summarize(Averages = mean(Value)) # summarizes across all three groups

write.table(tidy_summarized, "step5_tidy_summarized.txt", sep="\t", row.name=FALSE)

