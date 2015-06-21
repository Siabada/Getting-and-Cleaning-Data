dir <- "E:/Users/Kasia/Documents/R/Coursera/Getting And Cleaning Data/UCI HAR Dataset"
setwd(dir)
dir <- getwd()

# 1. Merges the training and the test sets to create one data set.

# load training set
setwd("train")
subject_train <- read.table(file="subject_train.txt")
X_train <- read.table(file="X_train.txt")
Y_train <- read.table(file="y_train.txt")
setwd(dir)

# load test set
setwd("test")
subject_test <- read.table(file="subject_test.txt")
X_test <- read.table(file="X_test.txt")
Y_test <- read.table(file="y_test.txt")
setwd(dir)

# merge
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
rm(X_train, X_test, Y_train, Y_test)

setwd(dir)
features <- read.table(file="features.txt")


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
means <- grep("mean", features$V2)
stdevs <- grep("std", features$V2)
index <- sort(c(means, stdevs))
X <- X[,index]
features <- features[index,]

# 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table(file="activity_labels.txt")
Y_activity_labels <- as.character(activity_labels[Y$V1, 2])
Y <- Y_activity_labels
X$Activity <- Y
rm(Y, activity_labels)

# 4. Appropriately labels the data set with descriptive variable names. 
colnames(X) <- c(as.character(features$V2), "Activity")
rm(features)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
X_tidy <- X
r <- dim(X)[1]
c <- dim(X)[2]
X_tidy <- rbind(X_tidy, colMeans(X_tidy[,1:(c-1)]))
rownames(X_tidy)[r+1] <- "Variab_Avg"
X_tidy$Subj_Avg <- rowMeans(X_tidy[,1:(c-1)])

write.table(X_tidy, file="tidy_data_set.txt", row.name=FALSE, quote=FALSE, sep=\t)

