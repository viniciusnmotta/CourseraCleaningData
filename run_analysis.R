###################################################################################################
###################################################################################################
##' The study consisted of measurements in 30 subjects that were divided in the test and training
##' groups.
##' To be able to run this script correctly you need to download and unzip the file from:
##' https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##' After unzipping the file, move the folder "UCI HAR Dataset" into your working directory
###################################################################################################
###################################################################################################

###################################################################################################
###################################################################################################
##'READ TABLES
##'This part of the scrip will read the tables separately from the test and train groups, and the 
##'feature table (containing the variable names)
###################################################################################################
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
sub_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")
sub_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

###################################################################################################
###################################################################################################
##' GIVING NAMES TO COLUMNS
##' This part of the scrip will give column names to the tables
###################################################################################################
colnames(sub_test)<-"SubjectID"
colnames(y_test)<-"ActivityID"
colnames(x_test)<-features[,2]
colnames(sub_train)<-"SubjectID"
colnames(y_train)<-"ActivityID"
colnames(x_train)<-features[,2]

###################################################################################################
###################################################################################################
##' 01. MERGING THE TRAINING AND TEST INTO A SINGLE DATA FRAME
##' With all the individual tables read and with column names assigned, the tables will now be 
##' grouped into a single data.frame (df) containing all the information of the study.
##' Firstly, tables from the test and train group will be consolidated into single dataframes. 
##' Then the test and train dataframes will be consolidated into the final dataframe (df)
###################################################################################################
dftest<-cbind(sub_test,y_test,x_test)
dftrain<-cbind(sub_train,y_train,x_train)
df<-rbind(dftest,dftrain)

###################################################################################################
###################################################################################################
##' 02. EXTRACT COLUMNS WITH MEAN AND STANDARD DEVIATION
##' The columns for measurments on mean and standard deviation (std) will be extracted by subsetting 
##' the data.frame (df).
##' A vector with all column names containing either mean or std will be created. This vector will
##' be used to subset the df data frame based on the columns containing mean and std.
###################################################################################################
colmean_std<-c(grep("mean",names(df),value = TRUE),grep("std",names(df),value = TRUE))
df<-df[,c("SubjectID","ActivityID",colmean_std)]

###################################################################################################
###################################################################################################
##' 03. NAMING ACTIVITIES IN THE DATASET
##' First the table "activity_labes.txt" will be read, then column names will be assigned to it.
##' Finally, the df dataframe will be merged with activity names (actlabel) data frame using a 
##' reference column from each each data set, which is the common ActivityID column. 
###################################################################################################
actlabel<-read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
colnames(actlabel)<-c("ActivityID","Activity")
df<-merge(df,actlabel,by.x = "ActivityID",by.y="ActivityID",all=TRUE)

###################################################################################################
###################################################################################################
##' 04. CREATING FINAL TIDY DATA WITH DESCRIPTIVE VARIABLE NAMES
##' Columns of the df data frame containing the results for each measured variable in the study
##' will be consolidated into a single column called "Measurement" and their respective results 
##' into the "value" column.
##' New columns will be created for each parameter used to define a variable. For instance, 
##' the variable tBodyAcc-mean()-X was generated by the analysis of the following parameter: 
##' time,Body,Acceleration,Mean
###################################################################################################
require(data.table)
df<-melt(df,id=c("ActivityID","Activity","SubjectID"),variable.name = "Variable")

df$STATS<-ifelse(grepl("mean\\(\\)",df$Variable),"Mean",
                ifelse(grepl("std\\(\\)",df$Variable),"STD",
                       ifelse(grepl("meanFreq\\(\\)",df$Variable),"MeanFreq",NA)))

df$Mode<-ifelse(grepl("^t",df$Variable),"Time",
                  ifelse(grepl("^f",df$Variable),"FastFurier",NA))
                        
df$AccelerationSignal<-ifelse(grepl("Body",df$Variable),"Body",
                 ifelse(grepl("Gravity",df$Variable),"Gravity",NA))

df$Type<-ifelse(grepl("Acc",df$Variable),"Acceleration",
                               ifelse(grepl("Gyro",df$Variable),"Gyroscope",NA))

df$AxialSignal<-ifelse(grepl("-X",df$Variable),"X",
                             ifelse(grepl("-Y",df$Variable),"Y",
                                    ifelse(grepl("-Z",df$Variable),"Z",NA)))

df$SignalDerivedTime<-ifelse(grepl("Jerk-",df$Variable),"Jerk",
                  ifelse(grepl("JerkMag-",df$Variable),"JerkMagnitude",
                         ifelse(grepl("Mag-",df$Variable),"Magnitude",NA)))

write.table(df,file="HumanActivityMeasure.txt",sep="\t",row.names = FALSE)

###################################################################################################
###################################################################################################
##' 05. INDEPENDENT TIDY DATA WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY FOR EACH SUBJECT
##' The final tidy df data set will be grouped by Subject,Activity and Variable. Then a column named
##' average will be created containing the average for each variable, for each activity, 
##' for each subject 
###################################################################################################
require(dplyr)
newtidy<-group_by(df,SubjectID,Activity,Variable)
newtidy<-summarise(newtidy,count=n(),mean=mean(value))
newtidy<-data.frame(newtidy)
write.table(newtidy,file="Summarised_HumActMea.txt",sep="\t",row.names = FALSE)


#temp
t<-names(df)
newtidy2<-group_by(df,ActivityID,Activity,SubjectID,Variable,STATS,Mode,AccelerationSignal,Type,SignalDerivedTime,AxialSignal)
newtidy2<-summarise(newtidy2,count=n(),mean=mean(value))
newtidy2<-data.frame(newtidy2)
write.table(newtidy,file="Summarised_HumActMea.txt",sep="\t",row.names = FALSE)