# Ver esto como una lista de instrucciones para obtener el tidy data set del
# raw data set

# step 0: 

# get the data from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Unzip it in your working directory keeping the directory structure.


# step 1: Merges the training and the test sets to create one data set.
# The train and test data sets are separated

# the X data contains the measures for each window (1-561) for 2,947 instances
# for the test data and 7352 instances for the train data for a total of 10,299
# instances

# the y data contains the corresponding activity (1-6), whose labels are listed
# in the activity_labels.txt file.

# the subject data contains the subject who performed the activity (1-30) 


# the inertial signals contain data for each of the accelerometer and gyroscopic
# for body and tota, for each of the 10,299  instances (128 columns times 3 dims
# -XYZ- times each acc, gyro and total measurements).  This data is not used.

# each of the columns corresponds to a feature describe in the features.txt and
# features_info.txt files



# reading the subject and features data and merging

wearable.data <- rbind(
        cbind(read.table("UCI HAR Dataset/test/subject_test.txt"),
              read.table("UCI HAR Dataset/test/X_test.txt")),
        cbind(read.table("UCI HAR Dataset/train/subject_train.txt"),
              read.table("UCI HAR Dataset/train/X_train.txt")))

# reading the feature names

feature.names <- read.table("UCI HAR Dataset/features.txt", 
                            col.names = c("feature.ID.Number","feature.Name"))

# givint column names to the Subjct and features

colnames(wearable.data)<-c("SubjectID",as.character(feature.names$feature.Name))



# Givint descriptive names to activities in data


activity.names <- read.table("UCI HAR Dataset/activity_labels.txt",
                             colClasses=c("integer","character"))[,2]

activity.data <- rbind(read.table("UCI HAR Dataset/test/y_test.txt",
                                  colClasses=c("integer")),
                       read.table("UCI HAR Dataset/train/y_train.txt",
                                  colClasses=c("integer")))

activity <- as.character()

for(i in 1:length(activity.data[,1])) {
        activity[i] <- activity.names[activity.data[i,1]]
}

wearable.data <- cbind(activity, wearable.data )


# step 2: Extracts only the measurements on the mean and standard deviation for
# each measurement.


feature.names$use <- ifelse(grepl("meanFreq",feature.names$feature.Name,
                                  ignore.case = TRUE), FALSE, 
                            ifelse(grepl("mean()", feature.names$feature.Name, 
                                         ignore.case = FALSE), TRUE, 
                                   ifelse(grepl("std()", 
                                                feature.names$feature.Name, 
                                                ignore.case = FALSE), 
                                          TRUE, FALSE)))

feature.namesToUse <- feature.names[feature.names$use,c(1,2)]




wearable.data2 <- wearable.data[,c(1,2,feature.namesToUse$feature.ID.Number+2)]




# step 4: Appropriately labels the data set with descriptive variable names.


feature.namesToUse$domain <- substring(feature.namesToUse$feature.Name,1,1)

feature.namesToUse$domain <-ifelse(feature.namesToUse$domain == "t","Time.Domain", 
                                "Frequency.Domain")


feature.namesToUse$fn <- ifelse(grepl("mean()", feature.namesToUse$feature.Name, ignore.case = T), 
                                "Mean.Of", "Standard.Deviation.Of")

feature.namesToUse$signal<-c(rep("Body.Linear.Acceleration.Signal",6), 
                             rep("Gravity.Linear.Acceleration.Signal",6),
                             rep("Body.Linear.Acceleration.Jerk.Signal",6),
                             rep("Body.Angular.Velocity.Signal",6),
                             rep("Body.Angular.Velocity.Jerk.Signal",6),
                             rep("Body.Linear.Acceleration.Signal",2),
                             rep("Gravity.Linear.Acceleration.Signal",2),
                             rep("Body.Linear.Acceleration.Jerk.Signal",2),
                             rep("Body.Angular.Velocity.Signal",2),
                             rep("Body.Angular.Velocity.Jerk.Signal",2),
                             rep("Body.Linear.Acceleration.Signal",6),
                             rep("Body.Linear.Acceleration.Jerk.Signal",6),
                             rep("Body.Angular.Velocity.Signal",6),
                             rep("Body.Linear.Acceleration.Signal",2),
                             rep("Body.Linear.Acceleration.Jerk.Signal",2),
                             rep("Body.Angular.Velocity.Signal",2),
                             rep("Body.Angular.Velocity.Jerk.Signal",2))


feature.namesToUse$dimension <- ifelse(grepl("Mag", feature.namesToUse$feature.Name, 
                                             ignore.case = F), "Magnitude",
                                       ifelse(grepl("-X", feature.namesToUse$feature.Name,
                                                    ignore.case=F), "X.Axis",
                                              ifelse(grepl("-Y",feature.namesToUse$feature.Name,
                                                           ignore.case=F),
                                                     "Y.Axis", "Z.Axis")))


Variable.Name<-character()

for(i in 1:length(feature.namesToUse$feature.ID.Number)){
        Variable.Name[i] <- paste(feature.namesToUse$fn[i],
                feature.namesToUse$domain[i],
                feature.namesToUse$signal[i],
                feature.namesToUse$dimension[i], sep = ".")         
}

feature.namesToUse$Variable.Name <- paste(feature.namesToUse$fn, 
                                          feature.namesToUse$domain, 
                                          feature.namesToUse$signal,
                                          feature.namesToUse$dimension, sep = ".")         



# step 5: From the data set in step 4, creates a second, independent tidy 
# data set with the average of each variable for each activity and each subject.


splwear<-split(wearable.data2, interaction(wearable.data2$activity,
                                          wearable.data2$SubjectID, drop = TRUE))

tidy.data1<-t(data.frame(sapply(splwear,function(x) colMeans(x[,3:68]))))

tidy.data2 <- cbind(rep(1:30,each=6), rep(sort(activity.names),30) ,tidy.data1)


colnames(tidy.data2)<-c("Subject","Activity",feature.namesToUse$Variable.Name)


write.table(tidy.data2,"Means.Of.Wearable.Data.txt",row.names=FALSE)
