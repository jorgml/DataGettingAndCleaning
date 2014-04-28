## Creating a Tidy Data Set
## Submitted for Peer Assigment as instructed in https://class.coursera.org/getdata-002/human_grading/view/courses/972080/assessments/3/submissions
## Data obtained and unzipped in working directory from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Reading the files of UCI HAR Dataset
message("Reading the files.")
subject_test<-read.table("~/UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("~/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("~/UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("~/UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("~/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("~/UCI HAR Dataset/train/y_train.txt")

## Making the 'test' and 'train' data frames and merging them into a single main data frame 'maindf' 
message("Making of data frames.")
test<-data.frame(cbind(subject_test,y_test,X_test))
train<-data.frame(cbind(subject_train,y_train,X_train))
message("Merging the data frames.")
maindf<-data.frame(rbind(test,train))

## Reading the feature names from 'features.txt' file, assign them into a vector 'name_feat' and set the labels "subject" and "activity"
feat<-read.table("~/UCI HAR Dataset/features.txt")
name_feat<-as.vector(feat[,2])
name_feat1<-append(name_feat,"subject",after=FALSE)
name_feat2<-append(name_feat1,"activity",after=1)

## Labelling the data set with descriptive activity names
colnames(maindf)<-name_feat2

## Extracting the 'mean()' and 'standard deviation()' for each measurement into a modified data frame 'main_mn_sd'
message("Extracting the measurements 'mean' and 'sd'. ")
mn<-grep("mean()",colnames(maindf),fixed=TRUE)
sd<-grep("std()",colnames(maindf),fixed=TRUE)
mn_sd<-c(mn,sd)
main_mn_sd<-maindf[,c(1,2,mn_sd)]

## Cleaning the names used to name the variables in the data set to make the labels more readable
names(main_mn_sd)<-gsub("-",".",names(main_mn_sd))
names(main_mn_sd)<-gsub("()","",names(main_mn_sd),fixed=TRUE)

## Creating the independent tidy dataset 'tidydataset' 
message("Creating the tidy dataset.")
library(plyr)
tidydata<-ddply(main_mn_sd,.(subject,activity),numcolwise(mean))

## Inserting the activity labels in the tidy dataset to improve the readability
tidydata[,2]<-mapvalues(tidydata[,2],from = c("1","2","3","4","5","6"), to = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))

## Writing 'tidydata' into a text file "tidy.txt"
write.table(tidydata, file="~/tidy.txt", sep="\t", row.names=FALSE)
message("The file 'tidy.txt' was created in the working directory wuth the tidy dataset.")