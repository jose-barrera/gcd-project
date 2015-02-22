
# Project Guidelines

The script run_analysis.R for the project, works with the zip file, to make sure that all files needed are in the right place. The code implements the following steps:


## STEP 0. Check if zip file exists in the working directory, if not, download it.

The idea of using the zip file is avoid possible erros due to non-existing files, so unzip the file garanties that all files are going to e present. In this step, I verify that zip file exists in the current work directory, if not, download it. Once I assure the zip file exists, unzip it. Of course, there is the assumption that zip file is not corrupted and it may be downloaded (working Internet connection available) if needed.

## STEP 1. Merges the training set and the test set to create one data set.

In this step, beggining with test information, I read the correspondig 3 files (**subject_test.txt**, **y_test.txt**, **X_test.txt**) into 3 dataset variables (**subject.test**, **y.test**, **x.test**), after that I create a new dataset (**data.test**) combining the previous ones; finally, to avoid use of innecesary memory, I remove from memory the 3 dataset variables read from files. The same actions are performed with the train information to obtaing its corresponding dataset (**data.train**).

With **data.test** and **data.train**, I combine them with rbind() function into the **data** dataset variable, and removes **data.test** and **data.train** from memory.

At the end of this step, I have one dataset variable, **data**, which contain all information from files. This data frame contains 263 columns:

DATA columns
[1] - Subject
[2] - Activity (class code at this point)
[3-263] - Features


## STEP 2. Extracts only the measurements on the mean and standard deviation for each measurement.

In this step, I read the features file into a dataset, identifies all rows that contains the word *mean()* or *std()* in their names, the result of this analysis are 66 features. I'm using only the names containing *mean()* and *std()* because altough there are other names containing *Mean* word, they does not correspond to the actual operation of mean, so they are not what is asked for in the instructions. 

The position of any row feature found matching the criteria would be in the range of 1 to 261, but the corresponding columns in the dataset form step 1 are in the positions 3 to 263, so for extracting the selected columns I use a vector with value 1 (subject column), value 2 (activity column) and the row numbers found plus 2.

At the end of this step, I have one more data set, **seldata**, which contain only the subject, activity and features data matching the criteria indicated in the project instructions.

SELDATA columns
[1] - Subject
[2] - Activity (class code at this point)
[3-68] - Features


## STEP 3. Uses descriptive activity names to name the activities in the data set.

In this step, I read the activity labels file into a dataset. At this point, the second column of **seldata** dataset contains the class code for the activity, so using these codes I match them with the corresponding labels. The resulting vector contains the activity labels and I use it to replace the actual second column of **seldata** in order to store descripting labels instead of class codes.

I remove the dataset of activity labels and the **data** dataset to optimize memory.

At the end of this step, **seldata** contains only the subject, activity and features data matching the criteria indicated in the project instructions.

SELDATA columns
[1] - Subject
[2] - Activity (labels at this point)
[3-68] - Features


## STEP 4. Appropriately labels the data set with descriptive variable names.

In this step, all columns names in **seldata** dataset are named with standard values, so I replace them with the more descriptive variable names: **Subject**, **Activity** and the corresponding names obtained from the **features** dataset from step 2 filtered to those features matching the project criteria.


## STEP 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In this step, I use the plyr library to aggregate data according to project instructions, obtaining the mean for every subject, activity and feature. I am using the long form of data and the result is a dataset named **tidydata** consisting of 180 rows and 68 columns. To have more adequate names for the features columns, I replace each feature name with the same name preceded by the words *"Mean of"* to indicate that the value correspond to mean of all corresponding observations.

Finally, I write the **tidydata** into the file **result.txt** as instructed.