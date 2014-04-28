Peer Assignment Codebook
=
Getting and Cleaning Data : 
====================================================

```
INDEX
-----
1. DATA PROCESSING 
2. TIDY DATA
3. EXPLAINING VARIABLE NAMES
4. REFERENCES

```
```

### 1. DATA PROCESSING

The UCI HAR dataset was first downloaded into the working directory.
The data set has a number of text files as enumerated in the 'readme.md'. [1]
The original data had been subset into test (30% data) and train (70% data) subgroups. 
The original data had variables obtained by processing the acceleration, gyroscope measurements 
using time and frequency domain and stored as various text files (as listed below) [2].

For the purpose of this project, the following files have been referred from the UCI HAR Dataset [2] :
* 'README.txt'
* 'features_info.txt':   Shows information about the variables used on the feature vector.
* 'features.txt':        List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt':   Training set.
* 'train/y_train.txt':   Training labels.
* 'test/X_test.txt':     Test set.
* 'test/y_test.txt':     Test labels.
```
```{r}
## Reading the files of UCI HAR Dataset
message("Reading the files.")
subject_test<-read.table("~/UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("~/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("~/UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("~/UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("~/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("~/UCI HAR Dataset/train/y_train.txt")
```
```
Making the "test"" and "train" data frames and merging them into a single main data frame 'maindf' 
```
```{r}
# Making the 'test' and 'train' data frames and merging them into a single main data frame 'maindf' 
message("Making of data frames.")
test<-data.frame(cbind(subject_test,y_test,X_test))
train<-data.frame(cbind(subject_train,y_train,X_train))
message("Merging the data frames.")
maindf<-data.frame(rbind(test,train))
```
```
This 'merged' dataset has 10299 rows and 563 columns (variables), but does not have proper 
descriptive names for the variables. Next read the variable names from 'features.txt' file [2] 
and append the variables 'subject' and 'activity'.
```
```{r}
## Reading the feature names from 'features.txt' file, assign them into a vector 'name_feat' 
## and set the labels "subject" and "activity"
feat<-read.table("~/UCI HAR Dataset/features.txt")
name_feat<-as.vector(feat[,2])
name_feat1<-append(name_feat,"subject",after=FALSE)
name_feat2<-append(name_feat1,"activity",after=1)

## Labelling the data set with descriptive activity names
colnames(maindf)<-name_feat2
```
```
Is required only to extract those cases that include "measurements on the mean and standard 
deviation for each measurement". So subset the maindf dataset suitably and also include the 
variables 'subject' and 'activity'.
```
```{r}
## Extracting the 'mean()' and 'standard deviation()' for each measurement into a modified data frame 'main_mn_sd'
message("Extracting the measurements 'mean' and 'sd'. ")
mn<-grep("mean()",colnames(maindf),fixed=TRUE)
sd<-grep("std()",colnames(maindf),fixed=TRUE)
mn_sd<-c(mn,sd)
main_mn_sd<-maindf[,c(1,2,mn_sd)]
```
```
Cleaning the names used to name the variables in the data set to make the labels more readable
```
```{r}
names(main_mn_sd)<-gsub("-",".",names(main_mn_sd))
names(main_mn_sd)<-gsub("()","",names(main_mn_sd),fixed=TRUE)
```
```
### 2. TIDY DATA

Create an independent tidy dataset (ordered by 'subject' and 'activity' labels), with the average 
of each variable for each activity and each subject.  Then "Use descriptive activity names to name 
the activities in the data set" and "appropriately labels the data set with descriptive activity names",
the descriptive factors for activity labels (as in the file "activity_labels.txt") in place of the earlier 
given numeric factors.
```
```{r}
## Creating the independent tidy dataset 'tidydataset' 
message("Creating the tidy dataset.")
library(plyr)
tidydata<-ddply(main_mn_sd,.(subject,activity),numcolwise(mean))

## Inserting the activity labels in the tidy dataset to improve the readability
tidydata[,2]<-mapvalues(tidydata[,2],from = c("1","2","3","4","5","6"), 
    to = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
```
```
Save this tidy data set as 'tidy.txt'.
```
```{r}
## Writing 'tidydata' into a text file "tidy.txt"
write.table(tidydata, file="~/tidy.txt", sep="\t", row.names=FALSE)
message("The file 'tidy.txt' was created in the working directory with the tidy dataset.")
```
```
### 3. EXPLAINING VARIABLE NAMES

The experiments were conducted on 30 subjects
pertaining to 6 activities :
1.WALKING, 
2.WALKING_UPSTAIRS, 
3.WALKING_DOWNSTAIRS, 
4.SITTING, 
5.STANDING, 
6.LAYING
 
   The features selected for this database come from the accelerometer and gyroscope 3-axial 
raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) 
were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and 
a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 
Similarly, the acceleration signal was then separated into body and gravity acceleration 
signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a 
corner frequency of 0.3 Hz. Subsequently, the body linear acceleration and angular velocity 
were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). 
   Also the magnitude of these three-dimensional signals were calculated using the Euclidean 
norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing 
fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. 


These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions. 
The 't' to indicate the time domain and 'f' the frequency domain signals.

tBodyAcc-XYZ          (3)
tGravityAcc-XYZ       (3)
tBodyAccJerk-XYZ      (3)
tBodyGyro-XYZ         (3)
tBodyGyroJerk-XYZ     (3)
tBodyAccMag           (1)
tGravityAccMag        (1)
tBodyAccJerkMag       (1)
tBodyGyroMag          (1)
tBodyGyroJerkMag      (1)
fBodyAcc-XYZ          (3)
fBodyAccJerk-XYZ      (3)
fBodyGyro-XYZ         (3)
fBodyAccMag           (1)
fBodyAccJerkMag       (1)
fBodyGyroMag          (1)
fBodyGyroJerkMag      (1)

The set of variables that were estimated from these signals are: 
    mean(): Mean value
    std(): Standard deviation" [2]
This has been explained as in the UCI HAR dataset "features_info.txt" file. [2]
i.e. a total of 68 variables 
= 1 (for subject) + 1 (for activity) + 33 (for mean) + 33 (for standard deviation)

The names of  variables of the tidy data set have been enlisted below :

 [1] "subject"                   "activity"                  "tBodyAcc.mean.X"          
 [4] "tBodyAcc.mean.Y"           "tBodyAcc.mean.Z"           "tGravityAcc.mean.X"       
 [7] "tGravityAcc.mean.Y"        "tGravityAcc.mean.Z"        "tBodyAccJerk.mean.X"      
[10] "tBodyAccJerk.mean.Y"       "tBodyAccJerk.mean.Z"       "tBodyGyro.mean.X"         
[13] "tBodyGyro.mean.Y"          "tBodyGyro.mean.Z"          "tBodyGyroJerk.mean.X"     
[16] "tBodyGyroJerk.mean.Y"      "tBodyGyroJerk.mean.Z"      "tBodyAccMag.mean"         
[19] "tGravityAccMag.mean"       "tBodyAccJerkMag.mean"      "tBodyGyroMag.mean"        
[22] "tBodyGyroJerkMag.mean"     "fBodyAcc.mean.X"           "fBodyAcc.mean.Y"          
[25] "fBodyAcc.mean.Z"           "fBodyAccJerk.mean.X"       "fBodyAccJerk.mean.Y"      
[28] "fBodyAccJerk.mean.Z"       "fBodyGyro.mean.X"          "fBodyGyro.mean.Y"         
[31] "fBodyGyro.mean.Z"          "fBodyAccMag.mean"          "fBodyBodyAccJerkMag.mean" 
[34] "fBodyBodyGyroMag.mean"     "fBodyBodyGyroJerkMag.mean" "tBodyAcc.std.X"           
[37] "tBodyAcc.std.Y"            "tBodyAcc.std.Z"            "tGravityAcc.std.X"        
[40] "tGravityAcc.std.Y"         "tGravityAcc.std.Z"         "tBodyAccJerk.std.X"       
[43] "tBodyAccJerk.std.Y"        "tBodyAccJerk.std.Z"        "tBodyGyro.std.X"          
[46] "tBodyGyro.std.Y"           "tBodyGyro.std.Z"           "tBodyGyroJerk.std.X"      
[49] "tBodyGyroJerk.std.Y"       "tBodyGyroJerk.std.Z"       "tBodyAccMag.std"          
[52] "tGravityAccMag.std"        "tBodyAccJerkMag.std"       "tBodyGyroMag.std"         
[55] "tBodyGyroJerkMag.std"      "fBodyAcc.std.X"            "fBodyAcc.std.Y"           
[58] "fBodyAcc.std.Z"            "fBodyAccJerk.std.X"        "fBodyAccJerk.std.Y"       
[61] "fBodyAccJerk.std.Z"        "fBodyGyro.std.X"           "fBodyGyro.std.Y"          
[64] "fBodyGyro.std.Z"           "fBodyAccMag.std"           "fBodyBodyAccJerkMag.std"  
[67] "fBodyBodyGyroMag.std"      "fBodyBodyGyroJerkMag.std" 


### 4. REFERENCES :
[1] 'readme.md' : also in this project
[2] UCI HAR Dataset : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
```
