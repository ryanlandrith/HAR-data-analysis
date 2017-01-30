#1--------------------------------------------------------------------------
library(dplyr)
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt",colClasses = "character")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt",colClasses = "character")
subject_train <- read.table("train/subject_train.txt",colClasses = "factor")
subject_test <- read.table("test/subject_test.txt",colClasses = "factor")
features <- read.table("features.txt")
#2--------------------------------------------------------------------------
colnames(x_test) <- as.character(features[,2])
colnames(x_train) <- as.character(features[,2])
#3--------------------------------------------------------------------------
train <- cbind(subject_train,y_train,x_train)
test <- cbind(subject_test,y_test,x_test)
combined <- rbind(train,test)
#4--------------------------------------------------------------------------
combined[combined[,2]=="1",2] <- "walking"
combined[combined[,2]=="2",2] <- "walking_upstairs"
combined[combined[,2]=="3",2] <- "walking_downstairs"
combined[combined[,2]=="4",2] <- "sitting"
combined[combined[,2]=="5",2] <- "standing"
combined[combined[,2]=="6",2] <- "laying"
#5--------------------------------------------------------------------------
combined[,1] <- as.factor(combined[,1])
combined[,2] <- as.factor(combined[,2])
#6--------------------------------------------------------------------------
colnames(combined)[1] <- "subject"
colnames(combined)[2] <- "activity"
#7--------------------------------------------------------------------------
combined <- combined[,!duplicated(colnames(combined))] %>% 
  select(matches("subject|activity|mean|std"))
#8--------------------------------------------------------------------------
avg_by_subject_and_activity <- combined %>% group_by(subject,activity) %>%
  summarise_each("mean")
#9--------------------------------------------------------------------------
write.table(avg_by_subject_and_activity,file = "HAR data.txt",row.names = F)
rm(combined,test,train,features,subject_test,subject_train,y_test,x_test,y_train
   ,x_train)