import pandas as pd
import numpy as np
import matplotlib.pyplot
import matplotlib.pyplot as plt
import pandas as pd

Data = pd.read_csv(r'C:\Users\ghaya\OneDrive\Desktop\Python\QS\Cereal\Cereal.CSV')

print(Data)

print(Data.head())
print(Data.tail())

print(Data.index.unique())

Data.index.unique()

print(Data.cnt())

print(Data.info())

print(Data.describe())
print('\n')
print(Data.describe(exclude=[int]))
import pandas as pd

### ONCE YOU HAVE THE ALL THE ABOVE CODE WORKING, THAN ANSWER THESE QUESTIONS ###

## Question #1 - show me the top 4 records
Data = pd.read_csv(r'C:\Users\ghaya\OneDrive\Desktop\Python\QS\Cereal\Cereal.CSV')
print(Data.head(4))


## Question #2 - write the function to Rank the data
ranked_Data = Data['carbo'].rank()
print(ranked_Data)
    # Rank the specified columns
range_column_name = 'Rank'
   
Data['carbo'] = Data['carbo'].rank(method='min', ascending=False)


## Questions #3 - show the types in attributes
Data.info()
print(Data.dtypes)

## Quesitons #4 - what command is used to get the number of Attributes and Number of records?  Also what are those numbers ?
Data.info()
Data.shape
len(Data)
len(Data.columns),Data.columns
num_attributes,num_records = Data.shape
print ("Number of attributes, number of records: ",num_attributes,num_records)

## Questions #5 -  change the data frame to rankings_pd
Rankings_pd = Data.rank()
Rankings_pd = data.rank()
Rankings_pd.head()
## Question #6 - Before renaming the columns what is the rank
ranked_Data

## Question #7 - rename columns mrf to Manufacurer AND  calories to Calorie AND inplace is true
Rankings_pd = Data.rank()
Rankings_pd.rename(columns={'mrf': 'Manufacturer', 'calories': 'Calorie'}, inplace=True)
## Question #8 - show what the colums are After renaming
print(Rankings_pd.columns)

## Question #9 - In the top 5 records what name and column has as negative value and what is that value
Data.head(5)
negative_rows = Rankings_pd[(Rankings_pd < 0).any(axis=1)]
top_5_negative = negative_rows.head()
print(top_5_negative)

# the negative values
negative_rows = Rankings_pd[(Rankings_pd < 0).any(axis=1)]
top_5_negative = negative_rows.head()
print(top_5_negative)

## Question #10  -  what is sodium / cups for row 0? (code the calculation and answer)
print(Data.iloc[0])
sodium_value = Rankings_pd.loc[0, 'sodium']
cups_value = Rankings_pd.loc[0, 'cups']
sodium_cups_ratio = sodium_value / cups_value
print(f"The ratio of sodium to cups for row 0 is: {sodium_cups_ratio}")

## BONUS QUESTION --  Are all the python libraries needed to run this program ?
 # No only the pandas library is needed to run this program.

