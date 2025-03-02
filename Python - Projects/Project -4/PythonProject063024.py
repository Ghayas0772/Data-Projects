# Import necessary libraries for data manipulation and analysis
# Library for data manipulation and analysis
import pandas as pd  
# Library for numerical computations
import numpy as np  
# Library for creating visualizations
import matplotlib.pyplot as plt  
%matplotlib inline  # Ensure plots appear inline within Jupyter notebooks
# Library for statistical data visualization
import seaborn as sns  
# Import necessary libraries for machine learning
from sklearn.model_selection import train_test_split  # Function to split data into training and testing sets
from sklearn.linear_model import LinearRegression  # Linear regression model
from sklearn.metrics import mean_squared_error, r2_score  # Metrics to evaluate model performance

# Load the dataset
file_path = r'C:\Python\QS\New folder\Quiz05\bank-full.csv'
data = pd.read_csv(file_path)
print(data.columns)
print(data.head(50))

# Strip any leading/trailing whitespace from column names
data.columns = data.columns.str.strip()

# Display the cleaned column names
print(data.columns)
# Step 1: Load the CSV file with semicolon delimiter
file_path = r'C:\Python\QS\New folder\Quiz05\bank-full.csv'
data = pd.read_csv(file_path, delimiter=';')
print(data.head())
print(data.columns)
print("First 50 rows of the DataFrame:")
print(data.head(50))

# Strip any leading/trailing whitespace from column names
data.columns = data.columns.str.strip()
print("Cleaned column names:")
print(data.columns)
print(data.info)

# Step 4: Save the cleaned data to a new CSV file with comma delimiter
cleaned_file_path = r'C:\Python\QS\New folder\Quiz05\bank-full-cleaned.csv'
data.to_csv(cleaned_file_path, index=False, sep=',')

print(f"Cleaned data saved to: {cleaned_file_path}")

null_counts = data.isnull().sum()
print(null_counts)

# to chcek missing values in all columns 
def find_null_values(data):
    for column in data.columns:
        null_count = data[column].isnull().sum()
        if null_count > 0:
            print(f"Column '{column}' has {null_count} null values.")
        else:
            print(f"Column '{column}' has no null values.")

# Find and print null values for each column
find_null_values(data)

# Check for duplicates
duplicates = data.duplicated()

# Display the count of duplicate rows
print("Number of duplicate rows:", duplicates.sum())

# Display the duplicate rows
print("Duplicate rows:")
print(data[duplicates])

# duplicate values for all columns
def find_duplicates(data):
    for column in data.columns:
        duplicates = data[column][data[column].duplicated()].unique()
        if len(duplicates) > 0:
            print(f"Column '{column}' has the following duplicate values: {duplicates}")
        else:
            print(f"Column '{column}' has no duplicate values.")

# Find and print duplicate values for each column
find_duplicates(data)

#	Provide comprehensive data descriptions and calculations (mean, median, mode).
# Generate descriptive statistics for numerical columns
descriptive_stats = data.describe()

print("Descriptive statistics for numerical columns:")
print(descriptive_stats)

print(data.info())

#Categorical Binning: Group numerical data into categories for better interpretability and analysis.
# Add an 'Age Group' column
bins = [0, 18, 25, 35, 45, 55, 65, 100]
labels = ['<18', '18-25', '26-35', '36-45', '46-55', '56-65', '65+']
data['age_group'] = pd.cut(data['age'], bins=bins, labels=labels)

# Assuming 'age' column is present, create age groups
bins = [0, 18, 25, 35, 45, 55, 65, 100]
labels = ['<18', '18-25', '26-35', '36-45', '46-55', '56-65', '65+']

# Create age groups and add them to the DataFrame
data['age_group'] = pd.cut(data['age'], bins=bins, labels=labels)

print(data['age_group'])
print(data.head(50))
data

# Add a 'Balance Category' column
balance_bins = [-float('inf'), 0, 1000, 5000, 10000, float('inf')]
balance_labels = ['Negative', 'Low', 'Medium', 'High', 'Very High']
data['balance_category'] = pd.cut(data['balance'], bins=balance_bins, labels=balance_labels)

print(data['balance_category'])
print(data.head(50))
data

plt.figure(figsize=(10, 10))
sns.scatterplot(x='age', y='balance', data= data, color='red')
plt.title('Scatter Plot of Age vs Balance')
plt.xlabel('Age')
plt.ylabel('Balance')
plt.show()

plt.figure(figsize=(10, 10))
sns.jointplot(x='age', y='balance', hue= 'marital', data= data, color='red')
plt.title('Scatter Plot of Age vs Balance')
plt.xlabel('Age')
plt.ylabel('Balance')
plt.show()

plt.figure(figsize=(10, 10))
sns.jointplot(x='age', y='balance', hue= 'balance_category', data = data, color='red')
plt.title('Scatter Plot of Age vs Balance')
plt.xlabel('Age')
plt.ylabel('Balance')
plt.show()

print(data['balance_category'])
#pariplot 
#sns.pairplot(data)
#sns.pairplot(data,hue='marital')
#sns.pairplot(data,hue='marital', palette='coolwarm')
#Display the DataFrame to verify the column order
#print(data.head())

#5. Pair Plot to Visualize Relationships Between Multiple Variables
# Select a subset of the data for the pair plot
data2 = data[['age', 'balance', 'duration', 'campaign', 'pdays', 'previous', 'housing', 'loan']]
sns.pairplot(data2, hue='housing')
plt.show()

# Final inspection of the cleaned data


# correlation of the data
#non_numeric_columns = data.select_dtypes(include=['object']).columns
#print(f"Non-numeric columns: {non_numeric_columns}")

# Convert non-numeric columns to numeric using label encoding
#for column in non_numeric_columns:
 #   data2[column] = data2[column].astype('category').cat.codes

# this need to be check before
# Load your dataset (assuming 'data' is already defined)
data2 = data[['age', 'balance', 'duration', 'campaign', 'pdays', 'previous', 'housing', 'loan']]

# Convert categorical variables to numeric
data2['housing'] = data2['housing'].apply(lambda x: 1 if x == 'yes' else 0)
data2['loan'] = data2['loan'].apply(lambda x: 1 if x == 'yes' else 0)

# Compute the correlation matrix
correlation_matrix = data2.corr()
print("Correlation matrix:")
print(correlation_matrix)

# Optional: Visualize the correlation matrix
plt.figure(figsize=(10, 8))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', vmin=-1, vmax=1)
plt.title('Correlation Matrix')
plt.show()
data2.head()

# Note interprate the correlation matrix
# Optional: Visualize the correlation matrix

plt.figure(figsize=(10, 8))
sns.heatmap(correlation_matrix)
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt='.2f')
plt.show()
data.head()

# Note ( Passen number of calumnes )
# Note ( interprate the plot based on the disply)


# 6. Heatmap for Correlation Matrix for datasets numeric calumnes
# Select only the numeric columns
numeric_columns = data.select_dtypes(include='number').columns
numeric_data = data[numeric_columns]

# Calculate the correlation matrix
correlation_matrix = numeric_data.corr()

# Plot the heatmap
plt.figure(figsize=(12, 10))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt='.2f')
plt.title('Correlation Matrix')
plt.show()




# to find outliers in Dataset and remove unnecessary outliers from the dataset
#from scipy import stats

# Function to detect outliers using Z-score
#def detect_outliers_zscore(data, column, threshold=3):
  #  z_scores = stats.zscore(data[column])
  #  return data[(z_scores > threshold) | (z_scores < -threshold)]

# Detect outliers for each column
#for col in columns:
   # outliers = detect_outliers_zscore(data, col)
   # print(f'Outliers in {col} using Z-score:')
   # print(outliers)
    
# Remove outliers if needed
#def remove_outliers_zscore(data, column, threshold=3):
  #  z_scores = stats.zscore(data[column])
   # return data[(z_scores <= threshold) & (z_scores >= -threshold)]

# Remove outliers for each column
#for col in columns:
  #  df = remove_outliers_zscore(df, col)
  
# Summary :
# Based on the analysis of the dataset from bank-full.csv, 
# several key findings were observed. The dataset was cleaned by removing leading/trailing whitespaces from column names and saved as bank-full-cleaned.csv.
# Null values and duplicates were checked, revealing no null values but identifying duplicate rows which were then addressed. Descriptive statistics were #calculated for numerical columns, providing insights into the distribution and central tendencies of the data. Age groups and balance categories were created #to bin numerical data into meaningful categories. Visualizations such as scatter plots and a correlation matrix heatmap were generated to explore #relationships and correlations between variables like age, balance, and housing/loan status, revealing some interesting patterns and associations within the dataset.