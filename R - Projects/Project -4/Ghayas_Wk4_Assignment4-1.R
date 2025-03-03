---
  Author: "Ghayasudin Ghayas"
title: "Assignment 4"
output: html_notebook
---

#Step 1: Find path of data file and copy path (if using windows)
#Step 2: In the console below, type readClipboard()
#Step 3: Copy and paste R's path to the line below in quotes

#CHANGE BETWEEN QUOTES IN THIS LINE TO REFLECT FILE DIRECTORY OF DATA:
myDataLocation <- "D:/Eductaional/NU/Assignments/Week-04"

#SET WORKING DIRECTORY TO LOCATION OF DATA FILE
setwd(myDataLocation)

#IMPORT DATA AND PUT INTO DATAFRAME
myData <- read.csv(file = "student-mat-1.csv", header = TRUE)

Or 
myData <- read.csv('student-mat-1.csv')

# Read data from the clipboard
#myData <- read.table("clipboard", header = TRUE, sep = ",")

#print(myData)

myData
head(myData,6)
str(myData)
summary(myData)
any(is.na(myData))
dim(myData)

#-------------------------------------------------------------------------
## Load and install required packages
library(mosaic)
library(dplyr) 
library(ggplot2)
library(ggformula)
library(supernova)
library(lsr)
# Any other packages?

# insatll packages 

# Q2. Data Description
    # a. What are the frequencies of the categorical demographic variables?
    # b. What are the five-number summaries of your quantitative demographic variables?
    # c. Provide descriptive statistics of your outcome and explanatory variable.
    # d.Create a histogram of the absences variable. Reference the figure in your report." What do you see? Describe the shape, center, skewness, and weirdness.
    # e. Provide a visualization of the research question. Reference the figure in your report. What do you see?

#Sulotions
#Q2.a. Categorical Demographics:
      #For the categorical demographics, we’ll check the frequency distribution of variables like gender and romantic relationship status.

table(myData$sex) # Frequency table for gender
summary(myData$sex)
# Frequency table for romantic relationship status
table(myData$romantic_relationship)
table(myData$romantic)

library(dplyr)

# Read the dataset
myData <- read.csv(file = "student-mat-1.csv", header = TRUE)

# Create the new column 'romantic_relation' with 1 for 'yes' and 0 for 'no'
myData <- myData %>%
  mutate(romantic_relationship = ifelse(romantic == "yes", 1, 0))

# Display the first 6 rows of the updated dataset
head(myData, 6)

# Frequency table for romantic relationship status
table(myData$romantic_relationship)
table(myData$romantic)

# to shpw in plot 
library(ggplot2)

# Create a bar plot for romantic relationship status
ggplot(myData, aes(x = factor(romantic_relationship, labels = c("Not in a Relationship", "In a Relationship")))) +
  geom_bar(fill = "skyblue") +
  labs(title = "Distribution of Romantic Relationship Status",
       x = "Romantic Relationship Status",
       y = "Number of Students") +
  theme_minimal()

#the Corplot and corrgram of the Data 
# before to work on the questions i would like to check correlation of the numaric data and whole data fram. 
# Num only 
num.cols <- sapply(myData,is.numeric)
#filter
cor.data <- cor(myData[,num.cols])
#
print(cor.data)

# insatll corgram and cor relation packages 
install.packages("corrgram")
install.packages("corrplot")

library(corrgram)
library(corrplot)

print(corrplot(cor.data,method='color'))

print(corrgram(myData, method = "color"))


#Q2.b. Quntative Demograpic:
       # Next, let's calculate the five-number summary (min, 1st quartile, median, 3rd quartile, max) for numeric variables like age or grade.
summary(myData$age)
summary(myData$absences)

#Q2.c.Outcome and Explanatory Variables
#calculate the descriptive statistics for the outcome variable (absences) and the explanatory variable (romantic relationship).
# Descriptive statistics for absences.

summary(myData$absences)

# Mean and standard deviation for absences
mean(myData$absences, na.rm = TRUE)
sd(myData$absences, na.rm = TRUE)

# Proportion of students in a romantic relationship
prop.table(table(myData$romantic_relationship))   


# Q2.d. Histogram for absences
ggplot(myData, aes(x = absences)) +
  geom_histogram(binwidth = 1, fill = "lightblue", color = "black") +
  labs(title = "Distribution of Student Absences", x = "Absences", y = "Frequency")

 #Q2.e. #Visualization of Research Question
#Now create a boxplot to compare absences between students in and out of a romantic relationship.
# Boxplot comparing absences by romantic relationship status
boxplot(absences ~ romantic, data = myData, main = "Absences by Romantic Relationship", xlab = "Romantic Relationship",
        ylab = "Absences", col = "lightgreen")
------------------------------------------------------------------------------------------------------------------------------------------------
       ----------------------------------------------------------------------------------------------------------------------------
                                                -----------------------------------------------------
 """ Q3. Research Question: Absences Explained by Romantic Relationship
Q3.a.Empty Model (baseline model):
  o	Task : Fit an empty model (without explanatory variables) for absences.
Q3.b.	Question: What is the model statement for the empty model, and how do you interpret the estimated parameters?
  •	Explanatory Model (including romantic relationship variable):
  o	Task: Add romantic relationship status (coded as X) to the model.
Q3.c.	Question: How is the explanatory variable (romantic relationship) coded?
Q3.d.	Question: What is the model statement for the explanatory model, and how do you interpret the estimated parameters?
  •	Comparison of Models (empty vs. explanatory):
  o	Task: Create an APA-style table using the supernova() function for model comparison.
Q3.e.	Question: What do the F ratio, degrees of freedom, and difference in parameters between the models tell you?
Q3.f	Question: What is the Proportion Reduction in Error (PRE), and how does it measure the strength of the explanatory model?
Q3.g. Question: What is Cohen’s d, and how does it measure the effect size and strength of the relationship?
  """
-----------------------------------------------------------------------------------------------
#Solution 
#Q3.a Empty Model 
  #o	Task : Fit an empty model (without explanatory variables) for absences.
  #Let’s fit an empty model to predict absences without any explanatory variables

  empty_model <- lm(absences ~ 1, data = myData)
  summary(empty_model)      # The intercept represents the grand mean of absences across all students. This is our baseline prediction.

#Q3.b.	Question: What is the model statement for the empty model, and how do you interpret the estimated parameters?
#•	Explanatory Model (including romantic relationship variable):
 # o	Task: Add romantic relationship status (coded as X) to the model.

explanatory_model <- lm(absences ~ romantic, data = myData)
summary(explanatory_model)

# the basline predication is 

#Q4.	Comparison of Models (empty vs. explanatory):
#Comparison of Models (Empty vs. Explanatory)
#compare the empty model with the model that includes the romantic relationship variable.

# Perform an ANOVA to compare the models
anova(empty_model, explanatory_model)

#F Ratio and Degrees of Freedom: 
#The F ratio will tell you if the model with the romantic relationship variable explains a significant amount of variation in absences compared to the empty model.
#PRE (Proportion Reduction in Error): In R, this can be calculated as 
# Fit the empty model
empty_model <- lm(absences ~ 1, data = myData)
SS_empty <- sum(residuals(empty_model)^2)

# Fit the explanatory model with the romantic relationship variable
explanatory_model <- lm(absences ~ romantic, data = myData)
SS_explanatory <- sum(residuals(explanatory_model)^2)

# Calculate the F ratio
#PRE (Proportion Reduction in Error): In R, this can be calculated as 
(SS_empty - SS_explanatory) / SS_empty.

F_ratio <- ((SS_empty - SS_explanatory) / (length(coef(explanatory_model)) - length(coef(empty_model)))) / (SS_explanatory / (nrow(myData) - length(coef(explanatory_model))))

# Display the F ratio
F_ratio
---------
  # Load necessary libraries
  # library(dplyr)  # Uncomment if using dplyr functions
  
  # Fit the empty model
  empty_model <- lm(absences ~ 1, data = myData)
SS_empty <- sum(residuals(empty_model)^2)  # Calculate sum of squares of residuals for the empty model

# Fit the explanatory model with the romantic relationship variable
explanatory_model <- lm(absences ~ romantic, data = myData)
SS_explanatory <- sum(residuals(explanatory_model)^2)  # Calculate sum of squares of residuals for the explanatory model

# Calculate F ratio
F_ratio <- ((SS_empty - SS_explanatory) / (length(coef(explanatory_model)) - length(coef(empty_model))) / 
  (SS_explanatory / (nrow(myData) - length(coef(explanatory_model)))))


# Display the F ratio
print(F_ratio)

# Calculate the means of absences for the two groups
mean_in_relationship <- mean(myData$absences[myData$romantic == 1], na.rm = TRUE)
mean_not_in_relationship <- mean(myData$absences[myData$romantic == 0], na.rm = TRUE)

# Display the means
print(mean_in_relationship)
print(mean_not_in_relationship)

t_test_result <- t.test(myData$absences ~ myData$romantic)
print(t_test_result)



##############################################

#Code for PRE and Cohen’s d
#Assuming myData is your data frame with absences as the outcome variable and romantic as the explanatory variable:
# 1. Proportion Reduction in Error (PRE)
#Fit the empty model (no predictors).
#Fit the explanatory model (with the romantic predictor).
#Calculate PRE based on the sum of squares of residuals.

# Empty model (no predictors)
empty_model <- lm(absences ~ 1, data = myData)
SS_empty <- sum(residuals(empty_model)^2)

# Explanatory model (with romantic relationship as a predictor)
explanatory_model <- lm(absences ~ romantic, data = myData)
SS_explanatory <- sum(residuals(explanatory_model)^2)

# Calculate PRE
PRE <- (SS_empty - SS_explanatory) / SS_empty
print(PRE)

#2. Cohen’s d
#To calculate Cohen's d, you need the means and standard deviations of absences for each group in the romantic variable.
# Calculate means and standard deviations for each group
mean_no <- mean(myData$absences[myData$romantic == 0], na.rm = TRUE)
mean_yes <- mean(myData$absences[myData$romantic == 1], na.rm = TRUE)
sd_no <- sd(myData$absences[myData$romantic == 0], na.rm = TRUE)
sd_yes <- sd(myData$absences[myData$romantic == 1], na.rm = TRUE)

# Calculate pooled standard deviation
pooled_sd <- sqrt(((sd_no^2 + sd_yes^2) / 2))

# Calculate Cohen's d
cohens_d <- (mean_yes - mean_no) / pooled_sd
print(cohens_d)


