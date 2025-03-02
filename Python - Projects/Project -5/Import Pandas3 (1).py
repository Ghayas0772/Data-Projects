import pandas as pd
import numpy as np
import sklearn
print(sklearn.__version__)
import matplotlib_inline
import matplotlib.pyplot as plt
data = {
    'Name': ['Alice', 'Bob', 'Charlie', 'David'],
    'Age': [25, 30, 35, 40],
    'City': ['New York', 'Los Angeles', 'Chicago', 'Houston']
}

# Step 2: Create a DataFrame from the dictionary
# data_analysis.py

# Step 1: Import necessary libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import __version__ as sklearn_version

# Print the version of sklearn
print(f"scikit-learn version: {sklearn_version}")

# Step 2: Create a dictionary with the sample data
data = {
    'Name': ['Alice', 'Bob', 'Charlie', 'David'],
    'Age': [25, 30, 35, 40],
    'City': ['New York', 'Los Angeles', 'Chicago', 'Houston']
}

# Step 3: Create a DataFrame from the dictionary
df = pd.DataFrame(data)

# Step 4: Display the DataFrame
print("Data Set:")
print(df)

# Step 5: Show the statistics from the DataFrame
print("\nStatistics of the Data Set:")
print(df.describe(include='all'))

# Step 6: Calculate statistics for the 'Age' column
age_mean = df['Age'].mean()
age_min = df['Age'].min()
age_max = df['Age'].max()

# Display the calculated statistics
print(f"\nStatistics for Age:\nMean: {age_mean}\nMin: {age_min}\nMax: {age_max}")

# Step 7: Visualize the data using a bar chart
plt.figure(figsize=(10, 6))
plt.bar(df['Name'], df['Age'], color='skyblue')
plt.xlabel('Name')
plt.ylabel('Age')
plt.title('Age of Individuals')
plt.show()



1# libraries
install pandas, numpy, matplotlib, scikit-learn, matplotlib.pyplot

2# name this script data_analysis.py

3# create/Load the data set
Name: Alice,Bob,Charlie,David
Age: 25,30,35,40
City: New York,Los Angeles,Chicago,Houston


4# Display the data set

5# Show the statistics from the data set

6# Calculate statistics Age mean, min, max & Display

7# Visualize Bar Chart the data using Name, Age & Display