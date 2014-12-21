##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement. 
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Load: activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
feat <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard dev for each measure.
ext_features <- grepl("mean|std", feat)

# Load  X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = feat

# Extract only the measurements on the mean and standard dev for each variable
X_test = X_test[,ext_features]

# Load act labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load  X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = feat

X_train = X_train[,ext_features]

# Load act data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test &train data
Fdata = rbind(test_data, train_data)

Final_id_labels   = c("subject", "Activity_ID", "Activity_Label")
Final_data_labels = setdiff(colnames(Fdata), Final_id_labels)
Final_melt_data      = melt(data, id = Final_id_labels, measure.vars = Final_data_labels)
Finaltidy_data   = dcast(Final_melt_data, subject + Activity_Label ~ variable, mean)

write.table(Finaltidy_data, file = "./Ftidy_data.txt")