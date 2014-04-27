## Creating a Tidy Data Set
## Submitted for Peer Assigment as instructed in https://class.coursera.org/getdata-002/human_grading/view/courses/972080/assessments/3/submissions
## Data obtained aun unzipped in working directory from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Reading the files
message("Reading the files")

subject_test<-read.table("~/UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("~/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("~/UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("~/UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("~/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("~/UCI HAR Dataset/train/y_train.txt")

# Making the 'test' and 'train' data frames

test<-data.frame(cbind(subject_test,y_test,X_test))
train<-data.frame(cbind(subject_train,y_train,X_train))

# Merging the data frames 'test' and 'train' into a single main data frame 'maindf'
message("Merging the data frames")
maindf<-data.frame(rbind(test,train))
dim(maindf)

# Reading the variable names from the 'features.txt' file and storing features names into a vector 'name_feat'

feat<-read.table("~/UCI HAR Dataset/features.txt")
name_feat<-as.vector(feat[,2])

# Incorporating the labels "subject" and "activity"

name_feat1<-append(name_feat,"subject",after=FALSE)
name_feat2<-append(name_feat1,"activity",after=1)

# Labelling the data set with descriptive activity names

colnames(maindf)<-name_feat2

# Extracting the measurements on 'mean()' and 'standard deviation()' for each measurement into a modified data frame 'main_mn_sd'
message("Extracting the measurements 'mean' and 'sd'")

mn<-grep("mean()",colnames(maindf),fixed=TRUE)
sd<-grep("std()",colnames(maindf),fixed=TRUE)
mn_sd<-c(mn,sd)
main_mn_sd<-maindf[,c(1,2,mn_sd)]

# Cleaning the names used to name the variables in the data set to make the labels more readable

names(main_mn_sd)<-gsub("-",".",names(main_mn_sd))
names(main_mn_sd)<-gsub("()","",names(main_mn_sd),fixed=TRUE)

# Exploring the essential features of the data set 'main_mn_sd'
names(main_mn_sd)
sum(is.na(main_mn_sd))
dim(main_mn_sd)

# Creating the independent tidy dataset 'tidydataset' 
message("Creating the tidy dataset ")
library(plyr)
tidydata<-ddply(merged.mn.sd,.(subject,activity),numcolwise(mean))

# Inserting the activity labels in place of the numerical factor levels in the tidy dataset 
# to improve the readability of the activity levels the data frame 'tidy.data' 
tidydata[,2]<-mapvalues(tidydata[,2],from = c("1","2","3","4","5","6"),
                        to = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))

# Exploring features of the tidy dataset named 'tidydata'
# e.g. dimensions, names, the subject and activity columns, head
dim(tidydata)
names(tidydata)
tidydata[,1:2]
head(tidydata)

# Writing 'tidydata' into a text file "tidy.txt"

write.table(tidydata, file="~/tidy.txt", sep="\t", row.names=FALSE)

# Getting the tidy datset above ("./tidydata.txt") as the output of the script
read.table("./tidy.txt")


setwd("~/")