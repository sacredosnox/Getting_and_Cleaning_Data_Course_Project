library(plyr)
library(dplyr)

#Get the data from train and test data sets

train_data_x<-read.table("./UCI HAR Dataset/train/X_train.txt")

train_data_y<-read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

test_data_x<-read.table("./UCI HAR Dataset/test/X_test.txt")

test_data_y<-read.table("./UCI HAR Dataset/test/y_test.txt")

subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#get the activity labels

activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")

#Get the features

features<-read.table("./UCI HAR Dataset/features.txt")

#Steps for getting tidy data:
#Add the variable name to the head of the test and train x data

varnames<-as.character(features[,2])

names(test_data_x)<-varnames

names(train_data_x)<-varnames

#Add the variable name to the head of subject_test and subject_train data

subject_test_labeled<-rename(subject_test,subjects=V1)
subject_train_labeled<-rename(subject_train,subjects=V1)

#Add the variable name to the head of test and train y data

test_data_y_labeled<-rename(test_data_y,activity_labels=V1)
train_data_y_labeled<-rename(train_data_y,activity_labels=V1)

#bind test_data_x and train_data_x together

test_and_train_data_x <- rbind(test_data_x,train_data_x)

#grep only mean() and std()

means_and_std<-test_and_train_data_x[grep("((mean|std){1}(freq){0,}[(][)])",names(test_and_train_data_x))]

#bind subject_test_labeled and subject_train_labeled together

subject_data<-rbind(subject_test_labeled,subject_train_labeled)

#bind test_data_x_labeled and train_data_y_labeled together

test_and_train_data_y <- rbind(test_data_y_labeled,train_data_y_labeled)


#Uses descriptive activity names to name the activities in the data set
# I replaced the values in test_and_train_data_y with the Activity_Labels

activity_labels1 <-mapvalues(test_and_train_data_y$activity_labels,1,"WALKING")
# Now activity_labesl1 is no data.frame, so I chagen this
activity_labels1 <-data.frame(activity_labels1)
# Now I have and data.frame with a variable activity_labels1, now I use mapvalues again
# I repeat that, until I have all activitys
activity_labels2 <-mapvalues(activity_labels1$activity_labels1,2,"WALKING_UPSTAIRS")
activity_labels2 <-data.frame(activity_labels2)
activity_labels3 <-mapvalues(activity_labels2$activity_labels2,3,"WALKING_DOWNSTAIRS")
activity_labels3 <-data.frame(activity_labels3)
activity_labels4 <-mapvalues(activity_labels3$activity_labels3,4,"SITTING")
activity_labels4<-data.frame(activity_labels4)
activity_labels5 <-mapvalues(activity_labels4$activity_labels4,5,"STANDING")
activity_labels5<-data.frame(activity_labels5)
activity_labels <-mapvalues(activity_labels5$activity_labels5,6,"LAYING")
activity_labels<-data.frame(activity_labels)

#merge Datasets together

merged_test_and_train<-bind_cols(subject_data,activity_labels,means_and_std)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# I make two groups, and then I calculate the mean

tidy_dataset <-group_by(merged_test_and_train, subjects, activity_labels) %>% summarise_each(funs(mean))



