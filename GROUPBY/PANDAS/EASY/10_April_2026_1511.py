# 1511. Customer Order Frequency
# Description
# Table: Customers
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | customer_id   | int     |
# | name          | varchar |
# | country       | varchar |
# +---------------+---------+
# customer_id is the primary key for this table.
# This table contains information about the customers in the company.
# Table: Product
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | product_id    | int     |
# | description   | varchar |
# | price         | int     |
# +---------------+---------+
# product_id is the primary key for this table.
# This table contains information on the products in the company.
# price is the product cost.
# Table: Order
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | order_id      | int     |
# | customer_id   | int     |
# | product_id    | int     |
# | order_date    | date    |
# | quantity      | int     |
# +---------------+---------+
# order_id is the primary key for this table.
# This table contains information on customer orders.
# customer_id is the id of the customer who bought "quantity" products with id "product_id".
# Order_date is the date in format ('YYYY-MM-DD') when the order was shipped.
# Write an  SQL query to report the customer_id and customer_name of customers
# who have spent at least 100 in each month of June and July 2020.
# Return the result table in any order.
# Input: 
# Customers table:
# +--------------+-----------+-------------+
# | customer_id  | name      | country     |
# +--------------+-----------+-------------+
# | 1            | Winston   | USA         |
# | 2            | Jonathan  | Peru        |
# | 3            | Moustafa  | Egypt       |
# +--------------+-----------+-------------+
# Product table:
# +--------------+-------------+-------------+
# | product_id   | description | price       |
# +--------------+-------------+-------------+
# | 10           | LC Phone    | 300         |
# | 20           | LC T-Shirt  | 10          |
# | 30           | LC Book     | 45          |
# | 40           | LC Keychain | 2           |
# +--------------+-------------+-------------+
# Orders table:
# +--------------+-------------+-------------+-------------+-----------+
# | order_id     | customer_id | product_id  | order_date  | quantity  |
# +--------------+-------------+-------------+-------------+-----------+
# | 1            | 1           | 10          | 2020-06-10  | 1         |
# | 2            | 1           | 20          | 2020-07-01  | 1         |
# | 3            | 1           | 30          | 2020-07-08  | 2         |
# | 4            | 2           | 10          | 2020-06-15  | 2         |
# | 5            | 2           | 40          | 2020-07-01  | 10        |
# | 6            | 3           | 20          | 2020-06-24  | 2         |
# | 7            | 3           | 30          | 2020-06-25  | 2         |
# | 9            | 3           | 30          | 2020-05-08  | 3         |
# +--------------+-------------+-------------+-------------+-----------+

# Output: 
# +--------------+------------+
# | customer_id  | name       |  
# +--------------+------------+
# | 1            | Winston    |
# +--------------+------------+
# Explanation: 
# Winston spent 300 (300 * 1) in June and 100 ( 10 * 1 + 45 * 2) in July 2020.
# Jonathan spent 600 (300 * 2) in June and 20 ( 2 * 10) in July 2020.

import pandas as pd
import datetime as dt

# Customers DataFrame
customers = pd.DataFrame({
    "customer_id": [1, 2, 3],
    "name": ["Winston", "Jonathan", "Moustafa"],
    "country": ["USA", "Peru", "Egypt"]
})

# Product DataFrame
product = pd.DataFrame({
    "product_id": [10, 20, 30, 40],
    "description": ["LC Phone", "LC T-Shirt", "LC Book", "LC Keychain"],
    "price": [300, 10, 45, 2]
})

# Orders DataFrame
orders = pd.DataFrame({
    "order_id": [1, 2, 3, 4, 5, 6, 7, 9],
    "customer_id": [1, 1, 1, 2, 2, 3, 3, 3],
    "product_id": [10, 20, 30, 10, 40, 20, 30, 30],
    "order_date": [
        "2020-06-10", "2020-07-01", "2020-07-08",
        "2020-06-15", "2020-07-01", "2020-06-24",
        "2020-06-25", "2020-05-08"
    ],
    "quantity": [1, 1, 2, 2, 10, 2, 2, 3]
})

orders["order_date"] = pd.to_datetime(orders["order_date"])

orders_df = orders.copy()
product_df = product.copy()

df = (
    orders_df[(orders_df['order_date'] >= '2020-06-01') & 
              (orders_df['order_date'] <'2020-08-01')
            ]
    .merge(product_df, on = 'product_id')
    .assign(
        total_price = lambda d: d['price']*d['quantity'],
        order_month = lambda d: d['order_date'].dt.month
    )
    .groupby(['customer_id','order_month'], as_index = False)['total_price']
    .sum()
    .loc[lambda d: d['total_price'] >= 100]
    .groupby('customer_id', as_index = False)['order_month']
    .nunique()
    .rename(columns = {'order_month':'unique_order_count'})
    .query("unique_order_count == 2")
    .merge(customers[['customer_id','name']], on ='customer_id')
    [['customer_id','name']]
    
)
print(df)

#####################################################################################
#m2

df = (
    orders_df
    .merge(product_df, on='product_id')
    .assign(total=lambda d: d.price * d.quantity,
            m=lambda d: d.order_date.dt.month)
    .query("order_date >= '2020-06-01' and order_date < '2020-08-01'")
)

agg = df.groupby(['customer_id','m'])['total'].sum().reset_index()

valid = agg[agg['total'] >= 100]

result = (
    valid.groupby('customer_id')['m'].nunique()
    .loc[lambda s: s == 2]
    .reset_index()
    .merge(customers[['customer_id','name']], on='customer_id')
)

#############################################################################################
#m3
agg = (
    orders_df
    .merge(product_df, on='product_id')
    .assign(total=lambda d: d.price * d.quantity,
            m=lambda d: d.order_date.dt.month)
    .query("'2020-06-01' <= order_date < '2020-08-01'")
    .groupby(['customer_id','m'])['total'].sum()
    .unstack(fill_value=0)
)

result = agg[(agg[6] >= 100) & (agg[7] >= 100)]