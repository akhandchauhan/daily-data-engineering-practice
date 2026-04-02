# 1607. Sellers With No Sales
# SQL Schema 
# Table: Customer
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | customer_id   | int     |
# | customer_name | varchar |
# +---------------+---------+
# customer_id is the primary key for this table.
# Each row of this table contains the information of each customer in the WebStore.
# Table: Orders
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | order_id      | int     |
# | sale_date     | date    |
# | order_cost    | int     |
# | customer_id   | int     |
# | seller_id     | int     |
# +---------------+---------+
# order_id is the primary key for this table.
# Each row of this table contains all orders made in the webstore.
# sale_date is the date when the transaction was made between the 
# customer (customer_id) and the seller (seller_id).
# Table: Seller
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | seller_id     | int     |
# | seller_name   | varchar |
# +---------------+---------+
# seller_id is the primary key for this table.
# Each row of this table contains the information of each seller.
# Write an  SQL query to report the names of all sellers who did not
# make any sales in 2020.
# Return the result table ordered by seller_name in ascending order.

# Customer table:
# +--------------+---------------+
# | customer_id  | customer_name |
# +--------------+---------------+
# | 101          | Alice         |
# | 102          | Bob           |
# | 103          | Charlie       |
# +--------------+---------------+
# Orders table:
# +-------------+------------+--------------+-------------+-------------+
# | order_id    | sale_date  | order_cost   | customer_id | seller_id   |
# +-------------+------------+--------------+-------------+-------------+
# | 1           | 2020-03-01 | 1500         | 101         | 1           |
# | 2           | 2020-05-25 | 2400         | 102         | 2           |
# | 3           | 2019-05-25 | 800          | 101         | 3           |
# | 4           | 2020-09-13 | 1000         | 103         | 2           |
# | 5           | 2019-02-11 | 700          | 101         | 2           |
# +-------------+------------+--------------+-------------+-------------+
# Seller table:
# +-------------+-------------+
# | seller_id   | seller_name |
# +-------------+-------------+
# | 1           | Daniel      |
# | 2           | Elizabeth   |
# | 3           | Frank       |
# +-------------+-------------+
# Result table:
# +-------------+
# | seller_name |
# +-------------+
# | Frank       |
# +-------------+
# Daniel made 1 sale in March 2020.
# Elizabeth made 2 sales in 2020 and 1 sale in 2019.
# Frank made 1 sale in 2019 but no sales in 2020.

import pandas as pd
import datetime as dt

# Customer table
customer_df = pd.DataFrame({
    "customer_id": [101, 102, 103],
    "customer_name": ["Alice", "Bob", "Charlie"]
})

# Orders table
orders_df = pd.DataFrame({
    "order_id": [1, 2, 3, 4, 5],
    "sale_date": pd.to_datetime([
        "2020-03-01", "2020-05-25", "2019-05-25", "2020-09-13", "2019-02-11"
    ]),
    "order_cost": [1500, 2400, 800, 1000, 700],
    "customer_id": [101, 102, 101, 103, 101],
    "seller_id": [1, 2, 3, 2, 2]
})

# Seller table
seller_df = pd.DataFrame({
    "seller_id": [1, 2, 3],
    "seller_name": ["Daniel", "Elizabeth", "Frank"]
})


order_filtered_df = (
    orders_df[orders_df['sale_date'].dt.year == 2020]
    [['seller_id']]
    .rename(columns = {'seller_id' : 'order_seller_id'})
    .drop_duplicates()
)

df = (
    seller_df.merge(
        order_filtered_df, 
        how ='left', 
        left_on = 'seller_id', 
        right_on = 'order_seller_id'
    )
    .loc[lambda d : d['order_seller_id'].isna()]
    [['seller_id']]
    .sort_values('seller_id') 
    .reset_index(drop = True)  
)

print(df)


######################################################################################

# m2 

order_filtered_df = (
    orders_df[orders_df['sale_date'].dt.year == 2020]
    ['seller_id']
    .unique()
)

df = (
    seller_df[~(seller_df['seller_id'].isin(order_filtered_df))]
    .loc[lambda d : ~(d['seller_id'].isna())]
    [['seller_id']]
    .sort_values('seller_id') 
    .reset_index(drop = True)  
)

print(df)