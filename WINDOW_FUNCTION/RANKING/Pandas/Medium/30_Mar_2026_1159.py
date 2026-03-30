# 1159. Market Analysis II
# Description
# Table: Users
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | user_id        | int     |
# | join_date      | date    |
# | favorite_brand | varchar |
# +----------------+---------+
# user_id is the primary key (column with unique values) of this table.
# This table has the info of the users of an online shopping website where users can sell and buy items.

# Table: Orders
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | order_id      | int     |
# | order_date    | date    |
# | item_id       | int     |
# | buyer_id      | int     |
# | seller_id     | int     |
# +---------------+---------+
# order_id is the primary key (column with unique values) of this table.
# item_id is a foreign key (reference column) to the Items table.
# buyer_id and seller_id are foreign keys to the Users table.

# Table: Items
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | item_id       | int     |
# | item_brand    | varchar |
# +---------------+---------+
# item_id is the primary key (column with unique values) of this table.

# Write an  SQL query to find for each user, whether the brand of the second item (by date)
# they sold is their favorite brand. If a user sold less than two items, report the answer for 
# that user as no.

# It is guaranteed that no seller sold more than one item on a day.
# The result format is in the following example.

# Example 1:

# Input: 
# Users table:
# +---------+------------+----------------+
# | user_id | join_date  | favorite_brand |
# +---------+------------+----------------+
# | 1       | 2019-01-01 | Lenovo         |
# | 2       | 2019-02-09 | Samsung        |
# | 3       | 2019-01-19 | LG             |
# | 4       | 2019-05-21 | HP             |
# +---------+------------+----------------+
# Orders table:
# +----------+------------+---------+----------+-----------+
# | order_id | order_date | item_id | buyer_id | seller_id |
# +----------+------------+---------+----------+-----------+
# | 1        | 2019-08-01 | 4       | 1        | 2         |
# | 2        | 2019-08-02 | 2       | 1        | 3         |
# | 3        | 2019-08-03 | 3       | 2        | 3         |
# | 4        | 2019-08-04 | 1       | 4        | 2         |
# | 5        | 2019-08-04 | 1       | 3        | 4         |
# | 6        | 2019-08-05 | 2       | 2        | 4         |
# +----------+------------+---------+----------+-----------+
# Items table:
# +---------+------------+
# | item_id | item_brand |
# +---------+------------+
# | 1       | Samsung    |
# | 2       | Lenovo     |
# | 3       | LG         |
# | 4       | HP         |
# +---------+------------+
# Output: 
# +-----------+--------------------+
# | seller_id | 2nd_item_fav_brand |
# +-----------+--------------------+
# | 1         | no                 |
# | 2         | yes                |
# | 3         | yes                |
# | 4         | no                 |
# +-----------+--------------------+
# Explanation: 
# The answer for the user with id 1 is no because they sold nothing.
# The answer for the users with id 2 and 3 is yes because the brands of their second sold items 
# are their favorite brands.
# The answer for the user with id 4 is no because the brand of their second sold item is not the


import pandas as pd
import numpy as np

# Users table
users = pd.DataFrame({
    "user_id": [1, 2, 3, 4],
    "join_date": ["2019-01-01", "2019-02-09", "2019-01-19", "2019-05-21"],
    "favorite_brand": ["Lenovo", "Samsung", "LG", "HP"]
})

# Orders table
orders = pd.DataFrame({
    "order_id": [1, 2, 3, 4, 5, 6],
    "order_date": ["2019-08-01", "2019-08-02", "2019-08-03", "2019-08-04", "2019-08-04", "2019-08-05"],
    "item_id": [4, 2, 3, 1, 1, 2],
    "buyer_id": [1, 1, 2, 4, 3, 2],
    "seller_id": [2, 3, 3, 2, 4, 4]
})

# Items table
items = pd.DataFrame({
    "item_id": [1, 2, 3, 4],
    "item_brand": ["Samsung", "Lenovo", "LG", "HP"]
})

users["join_date"] = pd.to_datetime(users["join_date"])
orders["order_date"] = pd.to_datetime(orders["order_date"])


df_merged = (
    users
    .merge(orders, how ='left', left_on ='user_id', right_on ='seller_id')
    .merge(items, how ='left', on ='item_id')
    .assign(
        user_order_rank = lambda d: d.groupby('user_id')['order_date'].rank(method = 'dense')
    )
    .loc[lambda d: d['user_order_rank'] == 2]
    [['user_id','item_brand']]
)

final_df = (
    users.merge(df_merged, how = 'left',on ='user_id')
    .rename(columns= {'user_id':'seller_id'})
)

final_df['2nd_item_fav_brand'] = np.where(
                                    final_df['favorite_brand']==final_df['item_brand'],
                                    'yes',
                                    'no'
                                )

final_df = final_df[['seller_id','2nd_item_fav_brand']]

print(final_df)



###################################################################################################

# m2

df = (
    orders
    .merge(items, on='item_id')
    .sort_values(['seller_id','order_date'])
    .assign(
        rn=lambda d: d.groupby('seller_id').cumcount() + 1
    )
    .query("rn == 2")
    [['seller_id','item_brand']]
)

final_df = (
    users
    .merge(df, how='left', left_on='user_id', right_on='seller_id')
)

final_df['2nd_item_fav_brand'] = np.where(
    final_df['favorite_brand'] == final_df['item_brand'],
    'yes',
    'no'
)

final_df = final_df[['user_id','2nd_item_fav_brand']]\
            .rename(columns={'user_id':'seller_id'})