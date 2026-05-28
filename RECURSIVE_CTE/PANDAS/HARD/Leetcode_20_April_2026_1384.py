# 1384. Total Sales Amount by Year
# SQL Schema 
# Table: Product
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | product_id    | int     |
# | product_name  | varchar |
# +---------------+---------+
# product_id is the primary key for this table.
# product_name is the name of the product.

# Table: Sales
# +---------------------+---------+
# | Column Name         | Type    |
# +---------------------+---------+
# | product_id          | int     |
# | period_start        | varchar |
# | period_end          | date    |
# | average_daily_sales | int     |
# +---------------------+---------+
# product_id is the primary key for this table.
# period_start and period_end indicates the start and end date for sales period,
# both dates are inclusive.
# The average_daily_sales column holds the average daily sales amount of the 
# items for the period.

# Write an SQL query to report the Total sales amount of each item for each year,
# with corresponding product name, product_id, product_name and report_year.
# Dates of the sales years are between 2018 to 2020. Return the result 
# table ordered by product_id  and report_year.

# Product table:
# +------------+--------------+
# | product_id | product_name |
# +------------+--------------+
# | 1          | LC Phone     |
# | 2          | LC T-Shirt   |
# | 3          | LC Keychain  |
# +------------+--------------+
# Sales table:
# +------------+--------------+-------------+---------------------+
# | product_id | period_start | period_end  | average_daily_sales |
# +------------+--------------+-------------+---------------------+
# | 1          | 2019-01-25   | 2019-02-28  | 100                 |
# | 2          | 2018-12-01   | 2020-01-01  | 10                  |
# | 3          | 2019-12-01   | 2020-01-31  | 1                   |
# +------------+--------------+-------------+---------------------+
# Result table:
# +------------+--------------+-------------+--------------+
# | product_id | product_name | report_year | total_amount |
# +------------+--------------+-------------+--------------+
# | 1          | LC Phone     |    2019     | 3500         |
# | 2          | LC T-Shirt   |    2018     | 310          |
# | 2          | LC T-Shirt   |    2019     | 3650         |
# | 2          | LC T-Shirt   |    2020     | 10           |
# | 3          | LC Keychain  |    2019     | 31           |
# | 3          | LC Keychain  |    2020     | 31           |
# +------------+--------------+-------------+--------------+
# LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there 
# are 35 days for this period. Total amount 35*100 = 3500. 
# LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, 
# and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
# LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there 
# are 31, 31 days for years 2019 and 2020 respectively.

import pandas as pd
import datetime as dt
import numpy as np
# Product DataFrame
product = pd.DataFrame({
    "product_id": [1, 2, 3],
    "product_name": ["LC Phone", "LC T-Shirt", "LC Keychain"]
})

# Sales DataFrame
sales = pd.DataFrame({
    "product_id": [1, 2, 3],
    "period_start": pd.to_datetime(["2019-01-25", "2018-12-01", "2019-12-01"]),
    "period_end": pd.to_datetime(["2019-02-28", "2020-01-01", "2020-01-31"]),
    "average_daily_sales": [100, 10, 1]
})

# m1 chatgpt sol

# Merge product name
df = sales.merge(product, on="product_id")

result = []

for _, row in df.iterrows():
    start = row['period_start']
    end = row['period_end']
    
    for year in range(start.year, end.year + 1):
        
        # year boundaries
        year_start = pd.Timestamp(f"{year}-01-01")
        year_end = pd.Timestamp(f"{year}-12-31")
        
        # overlap range
        actual_start = max(start, year_start)
        actual_end = min(end, year_end)
        
        # compute days
        days = (actual_end - actual_start).days + 1
        
        total = days * row['average_daily_sales']
        
        result.append([
            row['product_id'],
            row['product_name'],
            year,
            total
        ])
# Final DataFrame
res_df = pd.DataFrame(result, columns=[
    "product_id", "product_name", "report_year", "total_amount"
])

res_df = res_df.sort_values(["product_id", "report_year"])

print(res_df)