# Loading library necessary to manipulate data

library(data.table)

# Setting working directory

setwd("~/Data_Science_class/Getting_Cleaning_Data/UCI HAR Dataset")

# Creating a file list containing training and test datasets to read them further into a table and join them to get
# one big dataset
#Measurements dataset
files_list <- list.files(c("C:\\Users\\Olga\\Documents\\Data_Science_class\\Getting_Cleaning_Data\\UCI HAR Dataset\\train\\", 
                           "C:\\Users\\Olga\\Documents\\Data_Science_class\\Getting_Cleaning_Data\\UCI HAR Dataset\\test\\"),
                         pattern="*X_.*\\.txt$", full.names=TRUE, ignore.case=TRUE)
dataset <- do.call("rbind",lapply(files_list, FUN=function(files){read.table(files)}))

# Activity dataset

files_listY <- list.files(c("C:\\Users\\Olga\\Documents\\Data_Science_class\\Getting_Cleaning_Data\\UCI HAR Dataset\\train\\", 
                            "C:\\Users\\Olga\\Documents\\Data_Science_class\\Getting_Cleaning_Data\\UCI HAR Dataset\\test\\"),
                          pattern="*y_.*\\.txt$", full.names=TRUE, ignore.case=TRUE)
datasetY <- do.call("rbind",lapply(files_listY, FUN=function(files){read.table(files)}))

#Subjects dataset

files_listS <- list.files(c("C:\\Users\\Olga\\Documents\\Data_Science_class\\Getting_Cleaning_Data\\UCI HAR Dataset\\train\\", 
                            "C:\\Users\\Olga\\Documents\\Data_Science_class\\Getting_Cleaning_Data\\UCI HAR Dataset\\test\\"),
                          pattern="*subject_.*\\.txt$", full.names=TRUE, ignore.case=TRUE)
subject <- do.call("rbind",lapply(files_listS, FUN=function(files){read.table(files)}))
names(subject) <- "subject"
                                                                   
# Loading file with the names of variables, which will be joined with measurements dataset

columnNames <- read.table("C:\\Users\\Olga\\Documents\\Data_Science_class\\Getting_Cleaning_Data\\UCI HAR Dataset\\features.txt")
columnNames <- as.character(columnNames[, 2])
colnames(dataset) <-columnNames

# Selection of columns, containing mean and std values

dataSelected <- dataset[, grep("mean()|std()", colnames(dataset))]

# Loading file with activity labels

activityLabels <- read.table("activity_labels.txt")
activity <- activityLabels[datasetY[, 1], 2]

# Joining together subjects, activities and measurements datasets

allData <- data.table(cbind(subject, activity, dataSelected))

# Sorting dataset by subject and activity

keycols <- c("subject", "activity")
setkeyv(allData, keycols)

# Calculating average value of each variable for each activity and each subject

dataFinal <- allData[, lapply(.SD, mean), by = key(allData)]
# Writing final dataset to .txt file

write.table(dataFinal, "FinalDataset.txt", row.names=FALSE, col.names=TRUE)