# Required
> You should create one R script called run_analysis.R that does the following.

> Merges the training and the test sets to create one data set.
> Extracts only the measurements on the mean and standard deviation for each measurement.
> Uses descriptive activity names to name the activities in the data set
> Appropriately labels the data set with descriptive variable names.
> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# How it was done, proccess overview
run_analisis.R - performes analysis. 

cache_data.R - implements caching mechanism for huge and often used files.

_run_analisis.R_ overview:

**`analize`** function is a place to start. It is responsible for the whole analize process. Boolean flag downloadData can be passed there and

**`downloadData`** function will download all the data and unzip if flag is passed as TRUE.

**`initCache`** function will read all data from files that we will need mostely and will put this data in cache objects. Cache is seperate for two folders. Please watch overview of cache_data.R for more information.

**`mergeDataAndNormalizeColNames`** function gets seperately training set data from training and test folders, merges this data into one data.frame, takes all lables from feature list and sets this labels as headers for newly merged data.frame.

**`normalizeActivityLabels`** function replaces all activity ids to it's string representation.

**`extractAndNormazeMeanAndStdData`** function extracts only mean and std measurements from a merged data.frame. It also normalizes a data.frame by creating a seperate 'measure' column (that can be either 'mean' or 'std' in our case) and normalizing column names (we can remove measurement postfix - like '-mean()' from columns scince we have a special column for this).

After that we simply agregate the result we have by activity and subject, and apply mean function to all groups. 
At the end we have a tidy data with: mean for each column, where column stands for some measure of unique activity, subject combination.
This is a kind of data satisfies all 4 tidy-data principles.

_cache_data.R_ overview:

When implementing this assignment I had to read data-files something about 100 times. Files are really huge - it takes me about 2,5 minutes to read full content of data-folders. 250 minutes is not that time I'd like to spent for this :) So I designed cache mechanism for this. It's not really flexible and fits only this task. I won't dig into details - it has explisit comments.  
