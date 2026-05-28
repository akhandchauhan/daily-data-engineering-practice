# 1479. Sales by Day of the Week
# SQL Schema 
# Table: Orders
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | order_id      | int     |
# | customer_id   | int     |
# | order_date    | date    |
# | item_id       | varchar |
# | quantity      | int     |
# +---------------+---------+
# (order_id, item_id) is the primary key for this table.
# This table contains information of the orders placed.
# order_date is the date when item_id was ordered by the customer with id customer_id.
# Table: Items
# +---------------------+---------+
# | Column Name         | Type    |
# +---------------------+---------+
# | item_id             | varchar |
# | item_name           | varchar |
# | item_category       | varchar |
# +---------------------+---------+
# item_id is the primary key for this table.
# item_name is the name of the item.
# item_category is the category of the item.
# You are the business owner and would like to obtain a sales report for category items and day of the week.
# Write an  SQL query to report how many units in each category have been ordered on each day of the week.
# Return the result table ordered by category.
# The query result format is in the following example:
# Orders table:
# +------------+--------------+-------------+--------------+-------------+
# | order_id   | customer_id  | order_date  | item_id      | quantity    |
# +------------+--------------+-------------+--------------+-------------+
# | 1          | 1            | 2020-06-01  | 1            | 10          |
# | 2          | 1            | 2020-06-08  | 2            | 10          |
# | 3          | 2            | 2020-06-02  | 1            | 5           |
# | 4          | 3            | 2020-06-03  | 3            | 5           |
# | 5          | 4            | 2020-06-04  | 4            | 1           |
# | 6          | 4            | 2020-06-05  | 5            | 5           |
# | 7          | 5            | 2020-06-05  | 1            | 10          |
# | 8          | 5            | 2020-06-14  | 4            | 5           |
# | 9          | 5            | 2020-06-21  | 3            | 5           |
# +------------+--------------+-------------+--------------+-------------+
# Items table:
# +------------+----------------+---------------+
# | item_id    | item_name      | item_category |
# +------------+----------------+---------------+
# | 1          | LC Alg. Book   | Book          |
# | 2          | LC DB. Book    | Book          |
# | 3          | LC SmarthPhone | Phone         |
# | 4          | LC Phone 2020  | Phone         |
# | 5          | LC SmartGlass  | Glasses       |
# | 6          | LC T-Shirt XL  | T-Shirt       |
# +------------+----------------+---------------+
# Result table:
# +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
# | Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
# +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
# | Book       | 20        | 5         | 0         | 0         | 10        | 0         | 0         |
# | Glasses    | 0         | 0         | 0         | 0         | 5         | 0         | 0         |
# | Phone      | 0         | 0         | 5         | 1         | 0         | 0         | 10        |
# | T-Shirt    | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
# +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
# On Monday (2020-06-01, 2020-06-08) were sold a total of 20 units (10 + 10) in the category Book (ids: 1, 2).
# On Tuesday (2020-06-02) were sold a total of 5 units  in the category Book (ids: 1, 2).
# On Wednesday (2020-06-03) were sold a total of 5 units in the category Phone (ids: 3, 4).
# On Thursday (2020-06-04) were sold a total of 1 unit in the category Phone (ids: 3, 4).
# On Friday (2020-06-05) were sold 10 units in the category Book (ids: 1, 2) and 5 units in Glasses (ids: 5).
# On Saturday there are no items sold.
# On Sunday (2020-06-14, 2020-06-21) were sold a total of 10 units (5 +5) in the category Phone (ids: 3, 4).
# There are no sales of T-Shirt.


import pandas as pd
import datetime as dt

# Orders DataFrame
orders = pd.DataFrame({
    "order_id": [1, 2, 3, 4, 5, 6, 7, 8, 9],
    "customer_id": [1, 1, 2, 3, 4, 4, 5, 5, 5],
    "order_date": [
        "2020-06-01", "2020-06-08", "2020-06-02",
        "2020-06-03", "2020-06-04", "2020-06-05",
        "2020-06-05", "2020-06-14", "2020-06-21"
    ],
    "item_id": [1, 2, 1, 3, 4, 5, 1, 4, 3],
    "quantity": [10, 10, 5, 5, 1, 5, 10, 5, 5]
})

# Convert order_date to datetime
orders["order_date"] = pd.to_datetime(orders["order_date"])

# Items DataFrame
items = pd.DataFrame({
    "item_id": [1, 2, 3, 4, 5, 6],
    "item_name": [
        "LC Alg. Book",
        "LC DB. Book",
        "LC SmarthPhone",
        "LC Phone 2020",
        "LC SmartGlass",
        "LC T-Shirt XL"
    ],
    "item_category": [
        "Book",
        "Book",
        "Phone",
        "Phone",
        "Glasses",
        "T-Shirt"
    ]
})

weekday_order = [
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday'
]

df = pd.merge(items, orders, on ='item_id',how ='left')

df['order_day'] = df['order_date'].dt.day_name()

df = (
        df.groupby(['item_category','order_day'])
        ['quantity']
        .sum()
        .reset_index()
        .pivot(
            columns= 'order_day',
            values = 'quantity',
            index = 'item_category'
        )
        .reindex(columns=weekday_order) 
        .fillna(0)
        .astype(int)
        .sort_values('item_category')
        .rename(columns={'item_category': 'Category'})
)
print(df)