# 1565. Unique Orders and Customers Per Month
# Description
# Table: Orders
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | order_id      | int     |
# | order_date    | date    |
# | customer_id   | int     |
# | invoice       | int     |
# +---------------+---------+
# order_id is the primary key for this table.
# This table contains information about the orders made by customer_id.

# Write an  SQL query to find the number of unique orders and the number of unique 
# customers with invoices > $20 for each different month.

# Return the result table sorted in any order.
# The query result format is in the following example.
# Example 1:
# Input: 
# Orders table:
# +----------+------------+-------------+------------+
# | order_id | order_date | customer_id | invoice    |
# +----------+------------+-------------+------------+
# | 1        | 2020-09-15 | 1           | 30         |
# | 2        | 2020-09-17 | 2           | 90         |
# | 3        | 2020-10-06 | 3           | 20         |
# | 4        | 2020-10-20 | 3           | 21         |
# | 5        | 2020-11-10 | 1           | 10         |
# | 6        | 2020-11-21 | 2           | 15         |
# | 7        | 2020-12-01 | 4           | 55         |
# | 8        | 2020-12-03 | 4           | 77         |
# | 9        | 2021-01-07 | 3           | 31         |
# | 10       | 2021-01-15 | 2           | 20         |
# +----------+------------+-------------+------------+
# Output: 
# +---------+-------------+----------------+
# | month   | order_count | customer_count |
# +---------+-------------+----------------+
# | 2020-09 | 2           | 2              |
# | 2020-10 | 1           | 1              |
# | 2020-12 | 2           | 1              |
# | 2021-01 | 1           | 1              |
# +---------+-------------+----------------+
# Explanation: 
# In September 2020 we have two orders from 2 different customers with invoices > 20.
# In October 2020 we have two orders from 1 customer, and only one of the two orders 
# has invoice > 20.
# In November 2020 we have two orders from 2 different customers but invoices < 20, 
# so we don't include that month.
# In December 2020 we have two orders from 1 customer both with invoices > 20.
# In January 2021 we have two orders from 2 different customers, but only 
# one of them with invoice > 20.


import pandas as pd

orders = pd.DataFrame({
    "order_id": [1,2,3,4,5,6,7,8,9,10],
    "order_date": [
        "2020-09-15","2020-09-17","2020-10-06","2020-10-20",
        "2020-11-10","2020-11-21","2020-12-01","2020-12-03",
        "2021-01-07","2021-01-15"
    ],
    "customer_id": [1,2,3,3,1,2,4,4,3,2],
    "invoice": [30,90,20,21,10,15,55,77,31,20]
})

orders["order_date"] = pd.to_datetime(orders["order_date"])

df = orders.copy()
df['year_month'] = df['order_date'].dt.strftime('%Y-%m')

df = (
    df[df['invoice'] > 20]
    .groupby('year_month', as_index= False)
    .agg(
        order_count = ('order_id','count'),
        customer_count = ('customer_id','nunique')
    )
)
print(df)