# 2922. Market Analysis III
# Description
# Table: Users
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | seller_id      | int     |
# | join_date      | date    |
# | favorite_brand | varchar |
# +----------------+---------+
# seller_id is the primary key for this table.
# This table contains seller id, join date, and favorite brand of sellers.
# Table: Items
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | item_id       | int     |
# | item_brand    | varchar |
# +---------------+---------+
# item_id is the primary key for this table.
# This table contains item id and item brand.
# Table: Orders
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | order_id      | int     |
# | order_date    | date    |
# | item_id       | int     |
# | seller_id     | int     |
# +---------------+---------+
# order_id is the primary key for this table.
# item_id is a foreign key to the Items table.
# seller_id is a foreign key to the Users table.
# This table contains order id, order date, item id and seller id.

# Write a solution to find the top seller who has sold the highest number of unique
# items with a different brand than their favorite brand. If there are multiple sellers 
# with the same highest count, return all of them.

# Return the result table ordered by seller_id in ascending order.

# Input: 
# Users table:
# +-----------+------------+----------------+
# | seller_id | join_date  | favorite_brand |
# +-----------+------------+----------------+
# | 1         | 2019-01-01 | Lenovo         |
# | 2         | 2019-02-09 | Samsung        |
# | 3         | 2019-01-19 | LG             |
# +-----------+------------+----------------+
# Orders table:
# +----------+------------+---------+-----------+
# | order_id | order_date | item_id | seller_id |
# +----------+------------+---------+-----------+
# | 1        | 2019-08-01 | 4       | 2         |
# | 2        | 2019-08-02 | 2       | 3         |
# | 3        | 2019-08-03 | 3       | 3         |
# | 4        | 2019-08-04 | 1       | 2         |
# | 5        | 2019-08-04 | 4       | 2         |
# +----------+------------+---------+-----------+
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
# +-----------+-----------+
# | seller_id | num_items |
# +-----------+-----------+
# | 2         | 1         |
# | 3         | 1         |
# +-----------+-----------+
# Explanation: 
# - The user with seller_id 2 has sold three items, but only two of them are not
#  marked as a favorite. We will include a unique count of 1 because both of these 
#  items are identical.
# - The user with seller_id 3 has sold two items, but only one of them is not marked 
# as a favorite. We will include just that non-favorite item in our count.
# Since seller_ids 2 and 3 have the same count of one item each, they both will be
# displayed in the output


import pandas as pd

# Users table
users = pd.DataFrame({
    "seller_id": [1, 2, 3],
    "join_date": pd.to_datetime(["2019-01-01", "2019-02-09", "2019-01-19"]),
    "favorite_brand": ["Lenovo", "Samsung", "LG"]
})

# Items table
items = pd.DataFrame({
    "item_id": [1, 2, 3, 4],
    "item_brand": ["Samsung", "Lenovo", "LG", "HP"]
})

# Orders table
orders = pd.DataFrame({
    "order_id": [1, 2, 3, 4, 5],
    "order_date": pd.to_datetime([
        "2019-08-01",
        "2019-08-02",
        "2019-08-03",
        "2019-08-04",
        "2019-08-04"
    ]),
    "item_id": [4, 2, 3, 1, 4],
    "seller_id": [2, 3, 3, 2, 2]
})

# m1 

item_sell_df = (
                orders.merge(users, on = 'seller_id')
                      .merge(items, on = 'item_id')
                      .query("item_brand != favorite_brand")
                      .groupby('seller_id', as_index = False)['item_id']
                      .nunique()
                      .rename(columns = {'item_id' : 'num_items'})
)
item_sell_df['item_rank'] = (item_sell_df['num_items']
                             .rank(method = 'dense', ascending = False)
                             .astype('int')
)
item_sell_df = (item_sell_df[item_sell_df['item_rank'] == 1]
                .sort_values(by ='seller_id')
                [['seller_id','num_items']]
)
print(item_sell_df)


##############################################################################################

# m2 = using max


item_df = (
                orders.merge(users, on = 'seller_id')
                      .merge(items, on = 'item_id')
                      .query("item_brand != favorite_brand")
                      .groupby('seller_id', as_index = False)['item_id']
                      .nunique()
                      .rename(columns = {'item_id' : 'num_items'})
)

max_num_items = item_df['num_items'].max()

item_df = item_df[item_df['num_items'] == max_num_items].sort_values(by ='seller_id')

print(item_df)

