# -- 2292. Products With Three or More Orders in Two Consecutive Years
# -- Description
# -- Table: Orders
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | order_id      | int  |
# -- | product_id    | int  |
# -- | quantity      | int  |
# -- | purchase_date | date |
# -- +---------------+------+
# -- order_id is the primary key for this table.
# -- Each row in this table contains the ID of an order, the id of the product purchased,
# -- the quantity, and the purchase date.
# -- Write an SQL query to report the IDs of all the products that were ordered three 
# --or more times in two consecutive years.

# -- Input: 
# -- Orders table:
# -- +----------+------------+----------+---------------+
# -- | order_id | product_id | quantity | purchase_date |
# -- +----------+------------+----------+---------------+
# -- | 1        | 1          | 7        | 2020-03-16    |
# -- | 2        | 1          | 4        | 2020-12-02    |
# -- | 3        | 1          | 7        | 2020-05-10    |
# -- | 4        | 1          | 6        | 2021-12-23    |
# -- | 5        | 1          | 5        | 2021-05-21    |
# -- | 6        | 1          | 6        | 2021-10-11    |
# -- | 7        | 2          | 6        | 2022-10-11    |
# -- +----------+------------+----------+---------------+
# -- Output: 
# -- +------------+
# -- | product_id |
# -- +------------+
# -- | 1          |
# -- +------------+
# -- Explanation: 
# -- Product 1 was ordered in 2020 three times and in 2021 three times. Since it was ordered 
# --three times in two consecutive years, we include it in the answer.
# -- Product 2 was ordered one time in 2022. We do not include it in the answer.

import pandas as pd
data = {
    'order_id': [1, 2, 3, 4, 5, 6, 7],
    'product_id': [1, 1, 1, 1, 1, 1, 2],
    'quantity': [7, 4, 7, 6, 5, 6, 6],
    'purchase_date': ['2020-03-16', '2020-12-02', '2020-05-10', '2021-12-23', '2021-05-21', '2021-10-11', '2022-10-11']
}
df = pd.DataFrame(data)
df['purchase_date'] = pd.to_datetime(df['purchase_date'])


# df['year'] = df['purchase_date'].dt.year
# df = df.groupby(['product_id','year'], as_index = False)['order_id'].count()
# df = df.query("order_id >= 3") 
# df = df.sort_values(['product_id','year'])
# df['nxt_yr'] = df.groupby('product_id')['year'].shift(-1)
# df = df.query('nxt_yr-year == 1')
# df = df[['product_id']].drop_duplicates()
# print(df)



#############################################################################################################################

#m2

df['year'] = df['purchase_date'].dt.year
df = df.groupby(['product_id','year'], as_index = False)['order_id'].count()
df = df.query("order_id >= 3") 
df = df.merge(df,how = 'cross').query('year_x + 1 == year_y')[['product_id_x']].drop_duplicates().rename(columns = {'product_id_x':'product_id'})
print(df)