# 2474. Customers With Strictly Increasing Purchases

# Table: Orders
# +--------------+------+
# | Column Name  | Type |
# +--------------+------+
# | order_id     | int  |
# | customer_id  | int  |
# | order_date   | date |
# | price        | int  |
# +--------------+------+
# order_id is the primary key for this table.
# Each row contains the id of an order, the id of customer that ordered it,
# the date of the order, and its price.

# Write an SQL query to report the IDs of the customers with the total purchases
# strictly increasing yearly.
# The total purchases of a customer in one year is the sum of the prices of
# their orders in that year.
# If for some year the customer did not make any order, we consider the total
# purchases 0.
# The first year to consider for each customer is the year of their first order.
# The last year to consider for each customer is the year of their last order.
# Return the result table in any order.
# The query result format is in the following example.
# Example 1:
# Input:
# Orders table:
# +----------+-------------+------------+-------+
# | order_id | customer_id | order_date | price |
# +----------+-------------+------------+-------+
# | 1        | 1           | 2019-07-01 | 1100  |
# | 2        | 1           | 2019-11-01 | 1200  |
# | 3        | 1           | 2020-05-26 | 3000  |
# | 4        | 1           | 2021-08-31 | 3100  |
# | 5        | 1           | 2022-12-07 | 4700  |
# | 6        | 2           | 2015-01-01 | 700   |
# | 7        | 2           | 2017-11-07 | 1000  |
# | 8        | 3           | 2017-01-01 | 900   |
# | 9        | 3           | 2018-11-07 | 900   |
# +----------+-------------+------------+-------+
# Output:
# +-------------+
# | customer_id |
# +-------------+
# | 1           |
# +-------------+
# Explanation:
# Customer 1: The first year is 2019 and the last year is 2022
#   - 2019: 1100 + 1200 = 2300
#   - 2020: 3000
#   - 2021: 3100
#   - 2022: 4700
#   We can see that the total purchases are strictly increasing yearly,
# so we include customer 1 in the answer.

# Customer 2: The first year is 2015 and the last year is 2017
#   - 2015: 700
#   - 2016: 0
#   - 2017: 1000
#   We do not include customer 2 in the answer because the total
# purchases are not strictly increasing. Note that customer 2 did not
# make any purchases in 2016.

# Customer 3: The first year is 2017, and the last year is 2018
#   - 2017: 900
#   - 2018: 900
#   We do not include customer 3 in the answer because the total purchases
# are not strictly increasing (equal values are not strictly increasing).

import pandas as pd
import numpy as np
pd.set_option("display.max_columns", None)

orders = pd.DataFrame({
    "order_id":    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    "customer_id": [1, 1, 1, 1, 1, 2, 2, 3, 3],
    "order_date":  [
        "2019-07-01", "2019-11-01", "2020-05-26",
        "2021-08-31", "2022-12-07", "2015-01-01",
        "2017-11-07", "2017-01-01", "2018-11-07"
    ],
    "price": [1100, 1200, 3000, 3100, 4700, 700, 1000, 900, 900]
})

orders["order_date"] = pd.to_datetime(orders["order_date"])

df = (
    orders.assign(
        order_year = lambda d: d['order_date'].dt.year
    )
    .groupby(['customer_id','order_year'], as_index = False)['price']
    .sum()
    .rename(columns = {'price' : 'total_price'})
)

year_range = (
    df.groupby('customer_id')['order_year']
    .agg(min_year='min', max_year='max')
    .reset_index()
)
all_years  = year_range.apply(
    lambda r: np.arange(r['min_year'], r['max_year'] + 1), axis=1
)

print(all_years)