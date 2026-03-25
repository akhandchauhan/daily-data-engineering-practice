# -- 1596. The Most Frequently Ordered Products for Each Customer
# -- SQL Schema 
# -- Table: Customers
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | customer_id   | int     |
# -- | name          | varchar |
# -- +---------------+---------+
# -- customer_id is the primary key for this table.
# -- This table contains information about the customers.
# -- Table: Orders
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | order_id      | int     |
# -- | order_date    | date    |
# -- | customer_id   | int     |
# -- | product_id    | int     |
# -- +---------------+---------+
# -- order_id is the primary key for this table.
# -- This table contains information about the orders made by customer_id.
# -- No customer will order the same product more than once in a single day.
# -- Table: Products
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | product_id    | int     |
# -- | product_name  | varchar |
# -- | price         | int     |
# -- +---------------+---------+
# -- product_id is the primary key for this table.
# -- This table contains information about the products.
# -- Write an  SQL query to find the most frequently ordered product(s) for each customer.
# -- The result table should have the product_id and product_name for each customer_id who 
# --ordered at least one order. Return the result table in any order.
# -- The query result format is in the following example:
# -- Customers
# -- +-------------+-------+
# -- | customer_id | name  |
# -- +-------------+-------+
# -- | 1           | Alice |
# -- | 2           | Bob   |
# -- | 3           | Tom   |
# -- | 4           | Jerry |
# -- | 5           | John  |
# -- +-------------+-------+
# -- Orders
# -- +----------+------------+-------------+------------+
# -- | order_id | order_date | customer_id | product_id |
# -- +----------+------------+-------------+------------+
# -- | 1        | 2020-07-31 | 1           | 1          |
# -- | 2        | 2020-07-30 | 2           | 2          |
# -- | 3        | 2020-08-29 | 3           | 3          |
# -- | 4        | 2020-07-29 | 4           | 1          |
# -- | 5        | 2020-06-10 | 1           | 2          |
# -- | 6        | 2020-08-01 | 2           | 1          |
# -- | 7        | 2020-08-01 | 3           | 3          |
# -- | 8        | 2020-08-03 | 1           | 2          |
# -- | 9        | 2020-08-07 | 2           | 3          |
# -- | 10       | 2020-07-15 | 1           | 2          |
# -- +----------+------------+-------------+------------+

# -- Products
# -- +------------+--------------+-------+
# -- | product_id | product_name | price |
# -- +------------+--------------+-------+
# -- | 1          | keyboard     | 120   |
# -- | 2          | mouse        | 80    |
# -- | 3          | screen       | 600   |
# -- | 4          | hard disk    | 450   |
# -- +------------+--------------+-------+
# -- Result table:
# -- +-------------+------------+--------------+
# -- | customer_id | product_id | product_name |
# -- +-------------+------------+--------------+
# -- | 1           | 2          | mouse        |
# -- | 2           | 1          | keyboard     |
# -- | 2           | 2          | mouse        |
# -- | 2           | 3          | screen       |
# -- | 3           | 3          | screen       |
# -- | 4           | 1          | keyboard     |
# -- +-------------+------------+--------------+


import pandas as pd

customers_data = {
    'customer_id': [1, 2, 3, 4, 5],
    'name': ['Alice', 'Bob', 'Tom', 'Jerry', 'John']
}
customers_df = pd.DataFrame(customers_data)

orders_data = {
    'order_id': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    'order_date': ['2020-07-31', '2020-07-30', '2020-08-29', '2020-07-29', '2020-06-10', '2020-08-01', '2020-08-01', '2020-08-03', '2020-08-07', '2020-07-15'],
    'customer_id': [1, 2, 3, 4, 1, 2, 3, 1, 2, 1],
    'product_id': [1, 2, 3, 1, 2, 1, 3, 2, 3, 2]
}
orders_df = pd.DataFrame(orders_data)


products_data = {
    'product_id': [1, 2, 3, 4],
    'product_name': ['keyboard', 'mouse', 'screen', 'hard disk'],
    'price': [120, 80, 600, 450]
}
products_df = pd.DataFrame(products_data)

# m1 
# df = pd.merge(customers_df, orders_df, how = 'inner', on ='customer_id')
# df = df.groupby(['customer_id','product_id'])['name'].count().reset_index().rename(columns = {'name':'cnt'})
# df_max = df.groupby('customer_id')['cnt'].max().reset_index().rename(columns = {'cnt':'max_cnt'})
# df = pd.merge(df,df_max, how ='inner', on ='customer_id')
# df = df[df['cnt'] == df['max_cnt']]
# df = pd.merge(df,products_df,  how='inner',on ='product_id')
# df = df[['customer_id','product_id','product_name']]
# print(df)

orders_df = pd.merge(customers_df, orders_df, how = 'inner', on ='customer_id')
orders_df['cnt'] = orders_df.groupby(['customer_id','product_id'])['product_id'].transform('size')
orders_df['cnt_rnk'] = orders_df.groupby('customer_id')['cnt'].rank(method= 'dense',ascending=False)
df = pd.merge(orders_df,products_df,on ='product_id',how ='left')
df = df.query('cnt_rnk == 1')[['customer_id','product_id','product_name']].drop_duplicates()
# print(orders_df)
print(df)
