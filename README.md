# getting-and-cleaning-data
---
title: "README.md"
output: pdf_document
---

The script run_analysis.R analyzes data from the smartphone accelerometers and gyroscopes.  See CodeBook.Rmd for more information about the data, the variables, and the tranformations on the variables.

The instructions suggested five steps to the analysis, so I followed those steps (more or less in order).

#### (1)  Merge the training and the test sets to create one data set.

I included some sanity checking to make sure that the results gave what they were supposed to give.  This is just to make sure that I read the data in correctly and that it looks roughly how I expect (i.e., has the correct number of subjects, etc.).

I included some renaming of the variables here in order to make it more user-friendly later on.

Using dplyr-like operations was not necessary here, because the column names are all the same; so, I just used rbind().  I did create an extra column for the condition (testing vs. training) because that is useful information.

#### (2)  Extract only the measurements on the mean and standard deviation for each measurement. 

I used regular expressions because that seemed simplest.  There are some column names that include just -mean() and some that say -meanFreq().  I included both types of means.  The original code book for the data says that they applied the functions mean() and sd() to the data; these names have been appended to the different variables (although sd() has been converted to std()).  Since -meanFreq() was appended in the same way, I assumed that they applied some sort of mean function to those variables, and hence included them.

#### (3)  Use descriptive activity names to name the activities in the data set

I used regular expressions again to improve readability of the values in the Activity variable.

#### (4)  Appropriately label the data set with descriptive variable names.

The variable names were already relatively descriptive.  I made a few modifications, but I don't think that these were really necessary.  The main challenge here was avoiding having extremely long variable names, which also would not have been very human-friendly.  I hence did not modify the prefix t- or f- because there were only two options (t or f) and any substition would have been extremely long (i.e., "freqDomSig" or something to that effect) and thus counterproductive.

#### (5)  From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

The data was already in "wide" format, but I thought it would be more useful to change it to "long" format largely because that made the calculation of averages much easier.  Using dplyr and tidyr made this simple.
