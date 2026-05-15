# 2985. Calculate Compressed Mean

# Table: Orders
# +-------------------+------+
# | Column Name       | Type |
# +-------------------+------+
# | order_id          | int  |
# | item_count        | int  |
# | order_occurrences | int  |
# +-------------------+------+
# order_id is column of unique values for this table.
# This table contains order_id, item_count, and order_occurrences.

# Write a solution to calculate the average number of items per order, rounded to 2 decimal places.

# Return the result table in any order.

# Orders table:
# +----------+------------+-------------------+
# | order_id | item_count | order_occurrences | 
# +----------+------------+-------------------+
# | 10       | 1          | 500               | 
# | 11       | 2          | 1000              |     
# | 12       | 3          | 800               |  
# | 13       | 4          | 1000              | 
# +----------+------------+-------------------+
# Output
# +-------------------------+
# | average_items_per_order | 
# +-------------------------+
# | 2.70                    |
# +-------------------------+
# Explanation
# The calculation is as follows:
#  - Total items: (1 * 500) + (2 * 1000) + (3 * 800) + (4 * 1000) = 8900 
#  - Total orders: 500 + 1000 + 800 + 1000 = 3300 
#  - Therefore, the average items per order is 8900 / 3300 = 2.70

import pandas as pd

orders = pd.DataFrame({
    "order_id": [10, 11, 12, 13],
    "item_count": [1, 2, 3, 4],
    "order_occurrences": [500, 1000, 800, 1000]
})

df = pd.DataFrame({
    "total_items": [
        (orders['item_count'] * orders['order_occurrences']).sum()
    ],
    "total_orders": [
        orders['order_occurrences'].sum()
    ]
})

df['average_items_per_order'] = ((df['total_items']/df['total_orders']) + 1e-9).round(2)
df = df[['average_items_per_order']]
print(df)


###########################################################################################################
# m2

result = (
    orders
    .assign(
        weighted_items=lambda d:
        d['item_count'] * d['order_occurrences']
    )
)

avg = round(
    result['weighted_items'].sum()
    /
    result['order_occurrences'].sum(),
    2
)
df = pd.DataFrame({
    "average_items_per_order": [avg]
})
print(df)