# Human Activity Measurement
The data set results from manipulation and analysis of data sets obtained originally from the link:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Information on the the data set can be found in this document as shown bellow:

Variable Name|Description
-------------|------------
ActivityID| Activity Identification Number
Activity| Activity Name
SubjectID| Subject Identification Number
Variable| Unique Code for Each Variable
STATS| Statistical Method Applied to the Raw Measurements of Each Unique Variable
Mode|Method used for Each Variable
AccelerationSignal| Origin of the Acceleration Signal Obtained
Type| Type of Acceleration Signal, either from Gyroscope or time
AxialSignal| one of the 3-axial raw signals
SignalDerivedTime| Method Used to Derived Signal in Time
count|Number of measures for each variable
mean|Average of the mean or standard deviation transformed measures for each variable, for each activity and for each individual

#Variables details
Activity ID: ranges from 1 to 6
  
Activity: Names of the activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING,LAYING
  
Subject ID: ranges from 1 to 30

Variables: complex code names derived from abreviations of multiple parameters names

Value: Units of time domain signals.

STATS: statistical method applied to the raw data to generate the values

Mode: Time (time domain signals captured at a constant rate of 50 Hz); FastFurier (Fast Fourier Transform (FFT) of time domain signals)

AccelerationSignal: Body (body linear acceleration) or Gravity (angular velocity)

Type: Information obtained from the Accelerometer or the Gyroscope

AxialSignal: 3-axial raw signals: X, Y or Z

SignalDerivedTime: Jerk (the body linear acceleration and angular velocity were derived in time to obtain Jerk signals); JerkMagnitude or Magnitude (the magnitude of three-dimensional signals were calculated using the Euclidean norm)


#Steps to produce the tidy dataset
(detailed information is embeded in the run_analysis.R script)

1.The original dataset consisted of 3 tables for the test subject group, 3 tables for the train subject group, 1 table with activity labels and 1 table with the features labels 

2.The 3 tables for each group (test and train) were combined separately. Then, they were merged together into a single data table.

3.Columns for mean and standard deviations were selected. 

4.All variable columns were compiled into a single column called Variable and their values into a new column called Value

5.New columns were created for each parameter used to define each variable.

6.A final data set was created independently with the average of each variable for each activity and each subject.





