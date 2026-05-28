# 1083. Sales Analysis II  
# Description
# Table: Product
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | product_id   | int     |
# | product_name | varchar |
# | unit_price   | int     |
# +--------------+---------+
# product_id is the primary key (column with unique values) of this table.
# Each row of this table indicates the name and the price of each product.
# Table: Sales
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | seller_id   | int     |
# | product_id  | int     |
# | buyer_id    | int     |
# | sale_date   | date    |
# | quantity    | int     |
# | price       | int     |
# +-------------+---------+
# This table might have repeated rows.
# product_id is a foreign key (reference column) to the Product table.
# buyer_id is never NULL. 
# sale_date is never NULL. 
# Each row of this table contains some information about one sale.

# Write a solution to report the buyers who have bought S8 but not iPhone.
# Note that S8 and iPhone are products presented in the Product table.
# Return the result table in any order.

# Product table:
# +------------+--------------+------------+
# | product_id | product_name | unit_price |
# +------------+--------------+------------+
# | 1          | S8           | 1000       |
# | 2          | G4           | 800        |
# | 3          | iPhone       | 1400       |
# +------------+--------------+------------+
# Sales table:
# +-----------+------------+----------+------------+----------+-------+
# | seller_id | product_id | buyer_id | sale_date  | quantity | price |
# +-----------+------------+----------+------------+----------+-------+
# | 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
# | 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
# | 2         | 1          | 3        | 2019-06-02 | 1        | 800   |
# | 3         | 3          | 3        | 2019-05-13 | 2        | 2800  |
# +-----------+------------+----------+------------+----------+-------+
# Output: 
# +-------------+
# | buyer_id    |
# +-------------+
# | 1           |
# +-------------+
# Explanation: The buyer with id 1 bought an S8 but did not buy an iPhone. 
# The buyer with id 3 bought both.

import pandas as pd

# Product table
product_df = pd.DataFrame({
    'product_id': [1, 2, 3],
    'product_name': ['S8', 'G4', 'iPhone'],
    'unit_price': [1000, 800, 1400]
})

# Sales table
sales_df = pd.DataFrame({
    'seller_id': [1, 1, 2, 3],
    'product_id': [1, 2, 1, 3],
    'buyer_id': [1, 2, 3, 3],
    'sale_date': ['2019-01-21', '2019-02-17', '2019-06-02', '2019-05-13'],
    'quantity': [2, 1, 1, 2],
    'price': [2000, 800, 800, 2800]
})

# Convert sale_date to datetime (important for most problems)
sales_df['sale_date'] = pd.to_datetime(sales_df['sale_date'])

# m1 
df = (
    sales_df.merge(product_df, on = 'product_id')
    .groupby('buyer_id', as_index= False)
    .agg(
        iphone_count = ('product_name',lambda s : (s=='iPhone').sum()),
        s8_count = ('product_name',lambda s : (s=='S8').sum())
    )
    .loc[lambda d: (d['iphone_count'] == 0) & (d['s8_count'] >0 ) ]
)   [['buyer_id']]
print(df)

#################################################################################
# m2 
df = (
    sales_df.merge(product_df, on = 'product_id')
)
iphone_buyer = df[df['product_name'] == 'iPhone'][['buyer_id']].drop_duplicates()
samsung_buyer = df[df['product_name'] == 'S8'][['buyer_id']].drop_duplicates()

df2 = df[(df['buyer_id'].isin(samsung_buyer['buyer_id'])) & 
         (~df['buyer_id'].isin(iphone_buyer['buyer_id']))][['buyer_id']].drop_duplicates()
print(df2)

#################################################################################
# m3

df = sales_df.merge(product_df, on='product_id')

iphone = set(df.loc[df['product_name'] == 'iPhone', 'buyer_id'])
s8 = set(df.loc[df['product_name'] == 'S8', 'buyer_id'])

result = pd.DataFrame({
    'buyer_id': list(s8 - iphone)
})
print(result)