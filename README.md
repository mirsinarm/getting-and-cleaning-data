# getting-and-cleaning-data
---
title: "README.md"
output: pdf_document
---

The script run_analysis.R contains

The instructions suggested five steps to the analysis, so I followed those steps (more or less).

(1)  Merge the training and the test sets to create one data set.

I included some sanity checking to make sure that the results gave what they were supposed to give.

```{r}
summary(cars)
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```


There are some column names that include just -mean() and some that say -meanFreq().  I included both types of means.  The original code book for the data says that they applied the functions mean() and sd() to the data; these names have been appended to the different variables (although sd() has been converted to std()).  Since -meanFreq() was appended in the same way, I assumed that they applied some sort of mean function to those variables, and hence included them.