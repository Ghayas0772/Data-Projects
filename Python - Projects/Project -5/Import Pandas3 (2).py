python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib_inline
import seaborn as sns
from sklearn import __version__ as sklearn_version
print(f"scikit-learn version: {sklearn_version}")

url = 'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-DA0101EN-SkillsNetwork/labs/Data%20files/automobileEDA.csv'
df = pd.read_csv(url)

df.head()
df.describe
df.info()
df.columns
column_data_types = df.dtypes
print(column_data_types)

peak_rpm_data_types = df['peak-rpm'].dtypes
peak_rpm_data_types 

import pandas as pd


column_data_types = df.dtypes
print(column_data_types)

# corelation of the the 
url = 'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-DA0101EN-SkillsNetwork/labs/Data%20files/automobileEDA.csv'
df = pd.read_csv(url)
sns.pairplot(df)
df.corr()
sns.heatmap(df.corr)


import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


url = 'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-DA0101EN-SkillsNetwork/labs/Data%20files/automobileEDA.csv'
df = pd.read_csv(url)

#Create a scater plot
sns.scatterplot(df)
plt.title('scatterplot of Automobile Dataset')
plt.show()

#  Calculate the correlation matrix
numeric_df = df.select_dtypes(include=['float64', 'int64'])
correlation_matrix = numeric_df.corr()
numeric_df.corr()
sns.heatmap(numeric_df.corr())



# Select the columns of interest
selected_columns = ['bore', 'stroke', 'compression-ratio', 'horsepower']
selected_df = df[selected_columns]

# Calculate the correlation matrix for the selected columns
correlation_matrix = selected_df.corr()
print("Correlation between selected variables:")
print(correlation_matrix)


# Create a scatter plot of 'engine-size' and 'price'
plt.figure(figsize=(10, 6))
sns.scatterplot(data=df, x='engine-size', y='price')
plt.title('Scatter Plot of Engine Size vs. Price')
plt.xlabel('Engine Size')
plt.ylabel('Price')
plt.show()

plt.figure(figsize=(10, 6))
sns.scatterplot(data=df, x='highway-mpg', y='price')
plt.title('Scatter Plot of highway-mpg vs. Price')
plt.xlabel('highway-mpg')
plt.ylabel('Price')
plt.show()


if 'peak-rpm' in df.columns and 'price' in df.columns:
    plt.figure(figsize=(10, 6))
    sns.regplot(data=df, x='peak-rpm', y='price', scatter_kws={'s': 10}, line_kws={'color': 'red'})
    plt.title('Linear Relationship between Peak RPM and Price')
    plt.xlabel('Peak RPM')
    plt.ylabel('Price')
    plt.show()
else:
    print("\n'peak-rpm' and/or 'price' columns are not available in the dataset.")



# Visualize the correlation matrix using a heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt=".2f")
plt.title('Correlation Matrix of Selected Variables')
plt.show()

# Step 9: Linear relationship between 'peak-rpm' and 'price'
if 'peak-rpm' in df.columns and 'price' in df.columns:
    # Calculate the correlation between 'peak-rpm' and 'price'
    peak_rpm_price_correlation = df[['peak-rpm', 'price']].corr().iloc[0, 1]
    print(f"\nCorrelation between 'peak-rpm' and 'price': {peak_rpm_price_correlation:.2f}")

    # Create a scatter plot with a regression line
    plt.figure(figsize=(10, 6))
    sns.regplot(data=df, x='peak-rpm', y='price', scatter_kws={'s': 10}, line_kws={'color': 'red'})
    plt.title('Linear Relationship between Peak RPM and Price')
    plt.xlabel('Peak RPM')
    plt.ylabel('Price')
    plt.show()
else:
    print("\n'peak-rpm' and/or 'price' columns are not available in the dataset.")

# Step 10: Create a box plot of 'body-style' and 'price'
if 'body-style' in df.columns and 'price' in df.columns:
    plt.figure(figsize=(12, 6))
    sns.boxplot(x='body-style', y='price', data=df)
    plt.title('Box Plot of Body Style vs. Price')
    plt.xlabel('Body Style')
    plt.ylabel('Price')
    plt.show()
else:
    print("\n'body-style' and/or 'price' columns are not available in the
          
# Step 11: Create a box plot of 'engine-location' and 'price'
if 'engine-location' in df.columns and 'price' in df.columns:
    plt.figure(figsize=(12, 6))
    sns.boxplot(x='engine-location', y='price', data=df)
    plt.title('Box Plot of Engine Location vs. Price')
    plt.xlabel('Engine Location')
    plt.ylabel('Price')
    plt.show()

# Step 12: Create a box plot of 'drive-wheels' and 'price'
if 'drive-wheels' in df.columns and 'price' in df.columns:
    plt.figure(figsize=(12, 6))
    sns.boxplot(x='drive-wheels', y='price', data=df)
    plt.title('Box Plot of Drive Wheels vs. Price')
    plt.xlabel('Drive Wheels')
    plt.ylabel('Price')
    plt.show()
    
    
    
1# import library
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
##Note: %matplotlib inline is a magic command used in Jupyter Notebooks to display matplotlib plots directly below the code cell that generates them. It’s a convenient way to visualize data without needing to open separate windows or use different backends.
%matplotlib inline 
from scipy import stats

2# Ignore Warnings: Ignore the warning message to keep EDL notebook clean


3# Load the data and store it in dataframe df
https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-DA0101EN-SkillsNetwork/labs/Data%20files/automobileEDA.csv


4# head


5# list the data types for each columns

6# show the dataype of peak-rpm

7# Show correlation between all variables

8# Correlation between selected variables 'bore','stroke','compression-ratio','horsepower'

9# Find the scatterplot of 'engine-size' and 'price'


10#Let’s find the scatterplot of “highway-mpg” and “price”.

11#Linear Relationship of  peak-rpm and price

12# Also, the correlation between ‘peak-rpm’ and ‘price’ is approximately?

13# create boxplot of body type and price

14# create boxplot of engine-location and price

15# create boxplot of drive-wheels and price

16# describe the basic statistics for all continuous variables

17# describe the basic statistics for all continuous variables on the variables of type ‘object'

18# convert the series to a dataframe

19# drive-wheels value counts

20# engine-location as variable

21# After examining the value counts of the engine location, we see that engine location would not be a good predictor variable for the price. This is because we only have three cars with a rear engine and 198 with an engine in the front, so this result is skewed. Thus, we are not able to draw any conclusions about the engine location.

