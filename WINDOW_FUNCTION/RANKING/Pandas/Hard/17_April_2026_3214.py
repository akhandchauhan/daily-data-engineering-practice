# 3214. Year on Year Growth Rate 
# Description
# Table: user_transactions

# +------------------+----------+
# | Column Name      | Type     | 
# +------------------+----------+
# | transaction_id   | integer  |
# | product_id       | integer  |
# | spend            | decimal  |
# | transaction_date | datetime |
# +------------------+----------+
# The transaction_id column uniquely identifies each row in this table.
# Each row of this table contains the transaction ID, product ID, the spend amount,
#  and the transaction date.
# Write a solution to calculate the year-on-year growth rate for the total spend
#  for each product.

# The result table should include the following columns:

# year: The year of the transaction.
# product_id: The ID of the product.
# curr_year_spend: The total spend for the current year.
# prev_year_spend: The total spend for the previous year.
# yoy_rate: The year-on-year growth rate percentage, rounded to 2 decimal places.
# Return the result table ordered by product_id,year in ascending order.

# user_transactions table:
# +----------------+------------+---------+---------------------+
# | transaction_id | product_id | spend   | transaction_date    |
# +----------------+------------+---------+---------------------+
# | 1341           | 123424     | 1500.60 | 2019-12-31 12:00:00 |
# | 1423           | 123424     | 1000.20 | 2020-12-31 12:00:00 |
# | 1623           | 123424     | 1246.44 | 2021-12-31 12:00:00 |
# | 1322           | 123424     | 2145.32 | 2022-12-31 12:00:00 |
# +----------------+------------+---------+---------------------+
# Output:
# +------+------------+----------------+----------------+----------+
# | year | product_id | curr_year_spend| prev_year_spend| yoy_rate |
# +------+------------+----------------+----------------+----------+
# | 2019 | 123424     | 1500.60        | NULL           | NULL     |
# | 2020 | 123424     | 1000.20        | 1500.60        | -33.35   |
# | 2021 | 123424     | 1246.44        | 1000.20        | 24.62    |
# | 2022 | 123424     | 2145.32        | 1246.44        | 72.12    |
# +------+------------+----------------+----------------+----------+
# Explanation:
# For product ID 123424:
# In 2019:
# Current year's spend is 1500.60
# No previous year's spend recorded
# YoY growth rate: NULL
# In 2020:
# Current year's spend is 1000.20
# Previous year's spend is 1500.60
# YoY growth rate: ((1000.20 - 1500.60) / 1500.60) * 100 = -33.35%
# In 2021:
# Current year's spend is 1246.44
# Previous year's spend is 1000.20
# YoY growth rate: ((1246.44 - 1000.20) / 1000.20) * 100 = 24.62%
# In 2022:
# Current year's spend is 2145.32
# Previous year's spend is 1246.44
# YoY growth rate: ((2145.32 - 1246.44) / 1246.44) * 100 = 72.12%
# Note: Output table is ordered by product_id and year in ascending order.


import pandas as pd
import datetime as dt
data = {
    "transaction_id": [1341, 1423, 1623, 1322],
    "product_id": [123424, 123424, 123424, 123424],
    "spend": [1500.60, 1000.20, 1246.44, 2145.32],
    "transaction_date": [
        "2019-12-31 12:00:00",
        "2020-12-31 12:00:00",
        "2021-12-31 12:00:00",
        "2022-12-31 12:00:00"
    ]
}

df = pd.DataFrame(data)

df["transaction_date"] = pd.to_datetime(df["transaction_date"])
df['year'] = df["transaction_date"].dt.year

# m1 
df_grouped = (
    df.groupby(['year','product_id'], as_index = False)['spend']
    .sum()
    .rename(columns = {'spend' : 'curr_year_spend'})
)

df_lag = (
        df_grouped
        .sort_values(['year','product_id'])
        .assign(
            prev_year_spend = lambda d : (
                                    d.groupby(['product_id'])['curr_year_spend']
                                     .shift(1)
            ),
            yoy_rate = lambda d: (
            (d['curr_year_spend'] - d['prev_year_spend']) * 100
            / d['prev_year_spend']
        ).round(2)
        )
    
)

print(df_lag)

########################################################################################################

# m2 
df_grouped = (
    df.groupby(['year','product_id'], as_index = False)['spend']
    .sum()
    .rename(columns = {'spend' : 'curr_year_spend'})
)
df_prev = df_grouped.copy()
df_prev['year'] = df_prev['year'] + 1  # shift forward

df_merged = df_grouped.merge(
    df_prev,
    on=['product_id', 'year'],
    how='left',
    suffixes=('_curr', '_prev')
)

df_lag = (
        df_merged
        .sort_values(['year','product_id'])
        .rename(columns = {'curr_year_spend_curr':'curr_year_spend',
                           'curr_year_spend_prev':'prev_year_spend'})
        .assign(
            yoy_rate = lambda d: (
            (d['curr_year_spend'] - d['prev_year_spend']) * 100
            / d['prev_year_spend']
        ).round(2)
        )
    
)

print(df_lag)
