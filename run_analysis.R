
#1)Merges the training and the test sets to create one data set.
#2)Extracts only the measurements on the mean and standard deviation for each measurement. 
#3)Uses descriptive activity names to name the activities in the data set
#4)Appropriately labels the data set with descriptive variable names. 
#5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Reading the data
testData <- read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE)
Test_Act <- read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE)
Test_Sub <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainData <- read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)
Train_Act <- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)
Train_Sub <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)


activities <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
Test_Act$V1 <- factor(Test_Act$V1,levels=activities$V1,labels=activities$V2)
Train_Act$V1 <- factor(Train_Act$V1,levels=activities$V1,labels=activities$V2)

#Uses descriptive activity names to name the activities in the data set
features <- read.table("UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(Test_Act)<-c("Activity")
colnames(Train_Act)<-c("Activity")
colnames(Test_Sub)<-c("Subject")
colnames(Train_Sub)<-c("Subject")


#Merging the data
testData<-cbind(testData,Test_Act)
testData<-cbind(testData,Test_Sub)
trainData<-cbind(trainData,Train_Act)
trainData<-cbind(trainData,Train_Sub)
DataSet<-rbind(testData,trainData)

# Extract only the measurements on the mean and standard deviation for each measurement.
DataSet_mean<-apply(DataSet,FUN=mean,MARGIN=1,na.omit=TRUE)
DataSet_sd<-sapply(DataSet,sd,na.rm=TRUE)


DT <- data.table(DataSet)
#Below code describes about the independent tidy data set with the average of each variable for each activity and each subject.
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]

#Below code gives the consolidated dataset 
write.table(tidy,file="tidy.txt",sep=",",row.names = FALSE)
