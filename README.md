# Getting and Cleaning Data Course Project

## Viewing the Data

There is a script, "viewTidyData.R" that can be used in order to view the data in the Coursere page.  Feel free to use this script in order to load the tidy dataset to be evaluated into R instead of viewing it in your internet browser, as you wish.

## Description of the script runAnalysis.R

### Step 1. Creating a base dataframe with the X, subject and activity (descriptive names) data

* The script takes the data files in your working directory (after being unzipped keeping the directory structure), merging the features summarizing data and the subject y from the train and test sets into  a dataframe called wearable.data
* Reads the feature names from the feature.txt file accompanying the original dataset, and uses it to name the variables in the wearable.data dataframe
* Creates a dataframe called activity.names with the names from the activity_labels.txt file from the original files
* Creates a dataframe called activity.data with the activity information for each observation in the dataset (with values 1-6)
* Creates a dataframe called activity with the values from the activity.data transformed into the descriptive names (that are stored in the activity.names df)
* Appends the activity information to the wearable.data dataframe (cbind)

 ### Step 2. Extracts only features with the mean and standard deviation for each instance, and creates a second dataframe with only this variables.
 
 * creates a feature.name$use vector, which is meant to indicate TRUE when a feature name has the "mean()" or "std()" strings but not the "meanfreq" string or FALSE if not.
 * creates a second dataframe, wearable.data2 that contains the variables to be used (indicated by the feature.name$use logical vector)
 
### Steps 3 and 4. Labeling the variables with descritive variables.

* Using the following sublabels: domain (time or frequency), function (fn: mean or standard deviation), signal (type of signal), dimension (X-axis, Y-axis, Z-axis and Magnitude), to construct new names for the variables for df wearable.data2.

### Step 5.  Create a data set with the average of each variable from wearable.data2 for each subject and activity

* Using the colmeans function, used in with the sapply function over the data splitted (by subject and activity), tidy.data1 dataframe has the averages for each subject and activity for each of the variables with mean() and std() in their names.
* The output of the sapply function places the results in such a way that you have the results sorted for each variable in rows and the columns are a combination of the activity name and the subjectID (from 1-30).  That is, the data frame has rownames as the variable names and columns represents values for LAYING-1, LAYING-2, ..., LAYING-30, STANDING-1, STANDING-2, ..., STANDING-30, ..., WALKING_UPSTAIRS-30.  Then the transpose function is used to place variables as columns.
* As the transpose, sapply and split functions combined provides a data.frame which rows are sorted first by subject ID number and second, by activity names, it is easy to append this information using the cbind function to create a tidy.data2 dataframe.
* The dataset is written to a file "Means.Of.Wearable.Data.txt" is created with the write.table function.

## Code Book

A code book was created with:

* A description of the variables in the Means.Of.Wearable.Data.txt dataset
* A description of the study design for the dataset. 

The code book is provided in this repository.
