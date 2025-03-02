import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt
import seaborn as sns

# Load the data
file_path = r'C:\Python\QS\New folder\Quiz05\bank-full.csv'
data = pd.read_csv(file_path, delimiter=';')
print(data.head())
print(data.columns)
print("First 50 rows of the DataFrame:")
print(data.head(50))

# Define features (X) and target (y)
X = data[['age', 'job', 'marital', 'education', 'default', 'housing',
          'loan', 'contact', 'day', 'month', 'duration', 'campaign', 'pdays',
          'previous', 'poutcome', 'balance']]
y = data['balance']
# Convert categorical columns to numeric using one-hot encoding
X = pd.get_dummies(X)

# Split the data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Initialize and train the Linear Regression model
lm = LinearRegression()
lm.fit(x_train, y_train)

# Make predictions and evaluate the model
y_pred = lm.predict(x_test)

# Print model performance metrics
from sklearn.metrics import mean_squared_error, r2_score
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"Mean Squared Error: {mse}")
print(f"R^2 Score: {r2}")

# coeffecient for each colum and intercept
print(lm.intercept_)
# coeffecient for each colum
lm.coef_

# Logistric Regration is matter for classification 

sns.countplot(x= 'loan', data=data)
sns.countplot(x= 'loan', data=data, hue= 'marital')

sns.set_style('whitegrid')
sns.countplot(x= 'loan', data=data, hue= 'marital')

plt.figure(figsize=(12, 8))
sns.heatmap(data.isnull(), yticklabels=False, cbar=False, cmap='viridis')
plt.show()



#############################
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# Step 1: Load the Data
file_path = r'C:\Python\QS\New folder\Quiz05\bank-full.csv'
data = pd.read_csv(file_path, delimiter=';')

# Convert categorical variables to numeric
data = pd.get_dummies(data, drop_first=True)

# Separate features and target variable
X = data.drop('y_yes', axis=1)
y = data['y_yes']

# Step 2: Train/Test Split (80% training, 20% testing)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Step 3: Train Models
logistic_regression = LogisticRegression(max_iter=1000).fit(X_train, y_train)
random_forest = RandomForestClassifier().fit(X_train, y_train)

# Step 4: Evaluate Models
lr_accuracy = accuracy_score(y_test, logistic_regression.predict(X_test))
rf_accuracy = accuracy_score(y_test, random_forest.predict(X_test))

# Print evaluation results
print("Logistic Regression Accuracy:", lr_accuracy)
print("Random Forest Accuracy:", rf_accuracy)

# Plotting the results
models = ['Logistic Regression', 'Random Forest']
accuracies = [lr_accuracy, rf_accuracy]

plt.bar(models, accuracies, color=['blue', 'green'])
plt.xlabel('Models')
plt.ylabel('Accuracy')
plt.title('Model Comparison')
plt.ylim(0, 1)  # Set y-axis range from 0 to 1
plt.show()


#import matplotlib.pyplot as plt
#import seaborn as sns

# Assuming y_test are the actual values and y_pred are the predicted values
#residuals = y_test - y_pred

# Residuals vs. Predicted Values
#plt.figure(figsize=(10, 6))
#plt.scatter(y_pred, residuals, alpha=0.5)
#plt.axhline(y=0, color='r', linestyle='--')
#plt.xlabel('Predicted Values')
#plt.ylabel('Residuals')
#plt.title('Residuals vs. Predicted Values')
#plt.show()

# Histogram of Residuals
#plt.figure(figsize=(10, 6))
#sns.histplot(residuals, bins=30, kde=True)
#plt.xlabel('Residuals')
#plt.title('Distribution of Residuals')
#plt.show()



#Summary:
#The first part of the analysis focused on predicting balance using Linear Regression. The model achieved remarkable performance with a Mean Squared Error #(MSE) close to zero (3.37e-24) and an R-squared score of 1.0, indicating a perfect fit. The coefficients of the model suggest that the feature loan #significantly influences the prediction, while others show very small values, indicating minimal impact.
#The second part shifted to classification using Logistic Regression and Random Forest to predict y_yes (likely to subscribe to a term deposit). Both models #demonstrated high accuracy, with Logistic Regression achieving approximately 89.85% accuracy and Random Forest performing slightly better at around 90.50%.
#Visualizations included a count plot of loan by marital status and a heatmap to visualize missing values in the dataset.
#These findings suggest that while the Linear Regression model for predicting balance performed exceptionally well, the classification models for predicting #y_yes also showed strong accuracy, indicating robust predictive capabilities across different modeling techniques.