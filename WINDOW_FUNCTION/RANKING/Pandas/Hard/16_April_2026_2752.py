# 2752. Customers with Maximum Number of Transactions on Consecutive Days
# Description
# Table: Transactions
# +------------------+------+
# | Column Name      | Type |
# +------------------+------+
# | transaction_id   | int  |
# | customer_id      | int  |
# | transaction_date | date |
# | amount           | int  |
# +------------------+------+
# transaction_id is the column with unique values of this table.
# Each row contains information about transactions that includes unique 
# (customer_id, transaction_date) along with the corresponding customer_id and amount.   
# Write a solution to find all customer_id who made the maximum number of 
# transactions on consecutive days.

# Return all customer_id with the maximum number of consecutive transactions.
# Order the result table by customer_id in ascending order.

# Input: 
# Transactions table:
# +----------------+-------------+------------------+--------+
# | transaction_id | customer_id | transaction_date | amount |
# +----------------+-------------+------------------+--------+
# | 1              | 101         | 2023-05-01       | 100    |
# | 2              | 101         | 2023-05-02       | 150    |
# | 3              | 101         | 2023-05-03       | 200    |
# | 4              | 102         | 2023-05-01       | 50     |
# | 5              | 102         | 2023-05-03       | 100    |
# | 6              | 102         | 2023-05-04       | 200    |
# | 7              | 105         | 2023-05-01       | 100    |
# | 8              | 105         | 2023-05-02       | 150    |
# | 9              | 105         | 2023-05-03       | 200    |
# +----------------+-------------+------------------+--------+
# Output: 
# +-------------+
# | customer_id | 
# +-------------+
# | 101         | 
# | 105         | 
# +-------------+
# Explanation: 
# - customer_id 101 has a total of 3 transactions, and all of them are consecutive.
# - customer_id 102 has a total of 3 transactions, but only 2 of them are consecutive. 
# - customer_id 105 has a total of 3 transactions, and all of them are consecutive.
# In total, the highest number of consecutive transactions is 3, achieved by 
# customer_id 101 and 105. The customer_id are sorted in ascending order.

import pandas as pd
import datetime as dt
import numpy as np

transactions = pd.DataFrame({
    "transaction_id": [1,2,3,4,5,6,7,8,9],
    "customer_id": [101,101,101,102,102,102,105,105,105],
    "transaction_date": [
        '2023-05-01','2023-05-02','2023-05-03',
        '2023-05-01','2023-05-03','2023-05-04',
        '2023-05-01','2023-05-02','2023-05-03'
    ],
    "amount": [100,150,200,50,100,200,100,150,200]
})

transactions["transaction_date"] = pd.to_datetime(transactions["transaction_date"])


df = (
    transactions.sort_values(['customer_id','transaction_date'])
    .assign(
        transactions_ranked = lambda d: d.groupby('customer_id').cumcount()+1,
        transaction_ranked_date = lambda d: d['transaction_date'] - pd.to_timedelta(d['transactions_ranked'], unit='D')
    )
    .groupby(['customer_id','transaction_ranked_date'], as_index = False)['transaction_id']
    .count()
    .rename(columns = {'transaction_id':'grouped_count'})
    .loc[lambda d:d['grouped_count'] == d['grouped_count'].max()]
    .reset_index(drop = True)
    .sort_values('customer_id')
    .drop_duplicates()
    [['customer_id']]
    
)   

print(df)

############################################################################################
#m2 

df = (
    transactions
    .sort_values(['customer_id','transaction_date'])
    .assign(
        prev_transaction_date = lambda d: (
                                        d.groupby('customer_id')['transaction_date']
                                        .shift(1)),
        date_subtracted = lambda d: (
            np.where((d.transaction_date - d.prev_transaction_date).dt.days== 1,0,1)
        ),
        date_summed = lambda d: d.groupby('customer_id')['date_subtracted'].cumsum()
    )
    .groupby(['customer_id','date_summed'], as_index = False)['transaction_id']
    .count()
    .rename(columns = {'transaction_id':'grouped_count'})
    .loc[lambda d:d['grouped_count'] == d['grouped_count'].max()]
    .reset_index(drop = True)
    .sort_values('customer_id')
    .drop_duplicates()
    [['customer_id']]
)
print(df)