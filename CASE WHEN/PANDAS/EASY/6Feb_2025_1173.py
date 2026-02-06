# 1173. Immediate Food Delivery I
# Description
# Table: Delivery
# +-----------------------------+---------+
# | Column Name                 | Type    |
# +-----------------------------+---------+
# | delivery_id                 | int     |
# | customer_id                 | int     |
# | order_date                  | date    |
# | customer_pref_delivery_date | date    |
# +-----------------------------+---------+
# delivery_id is the primary key (column with unique values) of this table.
# The table holds information about food delivery to customers that make orders at some date 
# and specify a preferred delivery date (on the same order date or after it).
# If the customer's preferred delivery date is the same as the order date, then the order 
# is called immediate; otherwise, it is called scheduled.
# Write a solution to find the percentage of immediate orders in the table, rounded to 2 decimal places.
# The result format is in the following example.
# Input: 
# Delivery table:
# +-------------+-------------+------------+-----------------------------+
# | delivery_id | customer_id | order_date | customer_pref_delivery_date |
# +-------------+-------------+------------+-----------------------------+
# | 1           | 1           | 2019-08-01 | 2019-08-02                  |
# | 2           | 5           | 2019-08-02 | 2019-08-02                  |
# | 3           | 1           | 2019-08-11 | 2019-08-11                  |
# | 4           | 3           | 2019-08-24 | 2019-08-26                  |
# | 5           | 4           | 2019-08-21 | 2019-08-22                  |
# | 6           | 2           | 2019-08-11 | 2019-08-13                  |
# +-------------+-------------+------------+-----------------------------+
# Output: 
# +----------------------+
# | immediate_percentage |
# +----------------------+
# | 33.33                |
# +----------------------+
# Explanation: The orders with delivery id 2 and 3 are immediate while the others are scheduled.


import pandas as pd
import numpy as np

delivery_df = pd.DataFrame({
    "delivery_id": [1, 2, 3, 4, 5, 6],
    "customer_id": [1, 5, 1, 3, 4, 2],
    "order_date": pd.to_datetime([
        "2019-08-01",
        "2019-08-02",
        "2019-08-11",
        "2019-08-24",
        "2019-08-21",
        "2019-08-11"
    ]),
    "customer_pref_delivery_date": pd.to_datetime([
        "2019-08-02",
        "2019-08-02",
        "2019-08-11",
        "2019-08-26",
        "2019-08-22",
        "2019-08-13"
    ])
})

# m1

final = delivery_df.copy()
final['same_day_delivery'] = np.where(final['order_date'] == final['customer_pref_delivery_date'],1,0)

df = (final['same_day_delivery'].sum() * 100.0/
      (final['order_date'].count())).round(2)
print(df)

#########################################################################################################

df = (
    (delivery_df['order_date'] == delivery_df['customer_pref_delivery_date'])
    .sum() * 100.0 /
    delivery_df['order_date'].count()
).round(2)

print(df)

