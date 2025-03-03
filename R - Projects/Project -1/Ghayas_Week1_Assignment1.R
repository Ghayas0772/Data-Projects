#
# this assignment is to extract the customer_data.csv file using R and resolved below 15 questions
# first insall necessary Library and pakages 

install.packages("nycflights13")
install.packages("dplyr")
install.packages("mosaic")
install.packages("ggplate")
install.packages("ggplot2")

library(nycflights13)
library(mosaic)
library(dplyr)
library(mosaic)
library(ggplate)
if (!require(ggplot2)) {install.packages("ggplot2")}
if (!require(ggformula)) {install.packages("ggformula")}
if (!require(mosaic)) {install.packages("mosaic")}
if (!require(dplyr)) {install.packages("dplyr")}
if (!require(Lock5Data)) {install.packages("Lock5Data")}
if (!require(nycflights13)) {install.packages("nycflights13")}

# Check if ggplot2 package is installed
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

# Load ggplot2 package
library(ggplot2)

# most useable functions during the work 
library(nycflights13)

str(flights)
head(flights)
tail(flights)
head(flihts[5])
head.flights(5)
head(flights,5)
tail(flights,5)
sort(flights$air_time)


# select my Data location and extract the data set " customer_data.csv

# first set the my filepath and then select a data fram and display the dataset

filepath <- "D:/NU/Assignments"
full_path <- file.path(filepath, "consumer_data.csv")  
wk1Data <- read.csv(file = full_path, header = TRUE)
str(wk1Data)  
head(wk1Data)
tail(wk1Data)
summary(wk1Data)
View(wk1Data)


## THE ASSIGNMENT BEGINS HERE

## For each question, write the code you would use to answer the question (some questions have more than one possible answer)
## For questions asking for both code and a short written response, use the # to write a short response to the question 
## Don't forget to save your work directly in this codefile
## Rename this codefile with your name (ex. ANA600_Assignment1_Eric.R)
## Sumbit this codefile with your code to the instructor along with a writeup as described in the instruction document

#Q1. Display the contents of the dataframe.
# Do not display the dataframe, just its contents.
filepath <- "D:/NU/Assignments"
full_path <- file.path(filepath, "consumer_data.csv")  
wk1Data <- read.csv(file = full_path, header = TRUE) 
str(wk1Data)  

#Q2. How many cases were sampled in the dataframe?
num_cases <- nrow(wk1Data)
# Print the number of cases
print(num_cases)

#Q3. How many variables are in the dataframe?
num_variables <- ncol(wk1Data)

# Print the number of variables
print(num_variables)

#Q4. Display the top and bottom six rows of the dataframe.
head(wk1Data,6)
tail(wk1Data,6)

#Q5.(Respond with code and short written response)
#a. Which variables are quantitative?
#b. Which variables are categorical?

# Identify quantitative variables
quantitative_vars <- sapply(wk1Data, is.numeric)
quantitative_vars <- names(quantitative_vars[quantitative_vars])

# Identify categorical variables
categorical_vars <- sapply(wk1Data, is.factor)
categorical_vars <- names(categorical_vars[categorical_vars])

# Display the results
cat("Quantitative Variables:\n")
print(quantitative_vars)

cat("\nCategorical Variables:\n")
print(categorical_vars)

quantitative_vars <- sapply(wk1Data, is.numeric)
print(quantitative_vars)

# List the variables that are quantitative
quantitative_columns <- names(quantitative_vars)[quantitative_vars]

# Print the result
print(quantitative_columns)

#Q6. Create a frequency table per the state and employment sectors variables.
#a. State
#b. Employment Sector

# Create frequency table for the State variable
state_freq <- table(wk1Data$state)
cat("Frequency table for State:\n")
print(state_freq)

# Create frequency table for the Employment Sector variable
sector_freq <- table(wk1Data$employment_sector)
cat("\nFrequency table for Employment Sector:\n")
print(sector_freq)

head(wk1Data) # there is no variable by name of State 

View(wk1Data)
# there is no state in the dataset but can use region instate. 
state_Reg <- table(wk1Data$state)
cat("Region table for region:\n")
print(state_Reg)

#Q7. Create a new variable with categories of the household variable as a factor, and assign levels and labels to its values.  
# Decide on the levels and labels according to what you believe to be interpretable and meaningful for analysis.
# (There's no right or wrong answer, just provide your rationale)

# Total number of missing values in the entire dataset
total_missing_values <- sum(is.na(wk1Data))
print(total_missing_values)

# Number of missing values in each column using sapply
missing_values_per_column <- sapply(wk1Data, function(x) sum(is.na(x)))
print("Missing values in each column (using sapply):")
print(missing_values_per_column)

# to know the variables distinct of the house holde catagory 
# Get distinct values of the household variable
library(dplyr)
distinct_households <- wk1Data %>%
  distinct(household)

cat("\nDistinct values of the Household variable:\n")
print(distinct_households)

# Creating levels and labels for the household variable
breaks <- c(0, 3, 6, Inf)  # Defining the breaks for categorization
labels <- c("Small", "Medium", "Large")  # Labels for each category

# Creating 'household_category' based on 'household'
wk1Data$household_category <- cut(wk1Data$household,
                                  breaks = breaks,
                                  labels = labels,
                                  include.lowest = TRUE)

str(wk1Data$household_category)
summary(wk1Data$household_category)

# if Create a household_category variable based on household size
wk1Data <- wk1Data %>%
  mutate(household_category = case_when(
    household <= 3 ~ "Small",
    household <= 6 ~ "Medium",
    household > 6 ~ "Large"
  ))
View(wk1Data$household_category)



#Viewing the structure of wk1Data to verify changes
str(wk1Data)

# Optionally, view the first few rows to inspect the new variable
head(wk1Data)


#Q8. Filter observations that have missing data on the age variable in a new dataframe. 

# Filter observations with missing data on the age variable
missing_age_data <- wk1Data %>%
  filter(is.na(age))
cat("\nObservations with missing data on the age variable:\n")
print(missing_age_data)

#Q9. How many observations were dropped, based on missing values in the age variable?
original_row_count <- nrow(wk1Data)
filtered_row_count <- nrow(wk1Data %>% filter(!is.na(age)))
dropped_observations <- original_row_count - filtered_row_count
cat("\nNumber of observations dropped due to missing age values: ", dropped_observations, "\n")

#Q10. Create a histogram of the age variable of the filter_dat dataframe.

# Install ggplot2 package if not already installed
# Install ggplot2 package if not already installed
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

# Load ggplot2 package
library(ggplot2)

# Create a histogram of the age variable
age_histogram <- ggplot(filter_dat, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Age Variable", x = "Age", y = "Frequency") +
  theme_minimal()

# Print the plot
print(age_histogram)

#Q11. Draw a random sample of 10 observations from your filter_dat dataframe in a new dataframe.

# Load necessary libraries
library(dplyr)

# Set the file path
filepath <- "D:/NU/Assignments"
full_path <- file.path(filepath, "consumer_data.csv")

# Read in the data
wk1Data <- read.csv(file = full_path, header = TRUE)

# Display the structure and first few rows of the data to understand its structure
str(wk1Data)
head(wk1Data)
tail(wk1Data)

# View the data in a tabular format (this will open the data viewer in RStudio)
View(wk1Data)

# Filter the data to remove observations with missing values for the age variable
filter_dat <- wk1Data %>%
  filter(!is.na(age))

# Draw a random sample of 10 observations from the filtered data
sampled_data <- filter_dat %>%
  sample_n(size = 10)

# Print the sampled data to verify
print(sampled_data)

#Q12. Create a histogram of the age variable from the random sample.

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Set the file path
filepath <- "D:/NU/Assignments"
full_path <- file.path(filepath, "consumer_data.csv")

# Read in the data
wk1Data <- read.csv(file = full_path, header = TRUE)

# Filter the data to remove observations with missing values for the age variable
filter_dat <- wk1Data %>%
  filter(!is.na(age))

# Draw a random sample of 10 observations from the filtered data
sampled_data <- filter_dat %>%
  sample_n(size = 10)

# Print the sampled data to verify
print(sampled_data)

# Create a histogram of the age variable from the random sample
age_histogram <- ggplot(sampled_data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Age Variable from Random Sample", x = "Age", y = "Frequency") +
  theme_minimal()

# Print the plot
print(age_histogram)

#Q13. What do you notice is different between the random sample and dataset histograms? (Respond with code and short written response)
# Load necessary libraries
library(dplyr)
library(ggplot2)

# Set the file path
filepath <- "D:/NU/Assignments"
full_path <- file.path(filepath, "consumer_data.csv")

# Read in the data
wk1Data <- read.csv(file = full_path, header = TRUE)

# Filter the data to remove observations with missing values for the age variable
filter_dat <- wk1Data %>%
  filter(!is.na(age))

# Draw a random sample of 10 observations from the filtered data
sampled_data <- filter_dat %>%
  sample_n(size = 10)

# Print the sampled data to verify
print(sampled_data)

# Create a histogram of the age variable from the random sample
sample_histogram <- ggplot(sampled_data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Age Variable from Random Sample", x = "Age", y = "Frequency") +
  theme_minimal()

# Create a histogram of the age variable from the entire filtered dataset
full_histogram <- ggplot(filter_dat, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Age Variable from Full Dataset", x = "Age", y = "Frequency") +
  theme_minimal()

# Print both plots
print(sample_histogram)
print(full_histogram)

# written Note:
#To compare age histograms from a random sample and the full #dataset, create and inspect both. Load libraries, 
#read the #data, filter out missing ages, draw a random sample of 10, #and plot histograms for both sets.
#The full dataset #histogram shows a smoother, more representative age, distribution, while the sample histogram is more irregular 
#due to the smaller size. The full dataset's higher #frequency counts contrast with the sample's lower counts 
#and greater variability, underscoring the importance of #larger samples for reliable analysis

#Q14. Create a new variable of the income variable, called income3 with 3 levels, and assign levels and labels to its values.
# Load necessary libraries
library(dplyr)

# Set the file path
filepath <- "D:/NU/Assignments"
full_path <- file.path(filepath, "consumer_data.csv")

# Read in the data
wk1Data <- read.csv(file = full_path, header = TRUE)

# Create a new variable income3 with 3 levels
# Decide on the breakpoints for the income levels
breaks <- quantile(wk1Data$income, probs = seq(0, 1, length.out = 4), na.rm = TRUE)

# Assign levels and labels to the new income3 variable
wk1Data <- wk1Data %>%
  mutate(income3 = cut(income, breaks = breaks, labels = c("Low", "Medium", "High"), include.lowest = TRUE))

# Print the first few rows to verify the new variable
head(wk1Data)
#Q15. Use the aggregate() function to compute the mean and standard deviation of three quantitative variables, by one categorical variable

# Assuming you have a dataset 'wk1Data' with necessary variables

# Example dataset with categorical and quantitative variables
# Replace these with your actual dataset and variables
wk1Data <- data.frame(
  category_var = rep(c("A", "B", "C"), each = 5),
  quant_var1 = rnorm(15),
  quant_var2 = rnorm(15),
  quant_var3 = rnorm(15)
)
# Compute mean and standard deviation by categorical variable using aggregate()
agg_result <- aggregate(cbind(quant_var1, quant_var2, quant_var3) ~ category_var, data = wk1Data, FUN = function(x) c(mean = mean(x), sd = sd(x)))

# Print the aggregated results
print(agg_result)