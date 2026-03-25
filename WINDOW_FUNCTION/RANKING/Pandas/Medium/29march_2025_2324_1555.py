# -- 2324. Product Sales Analysis IV
# -- Description
# -- Table: Sales

# -- +-------------+-------+
# -- | Column Name | Type  |
# -- +-------------+-------+
# -- | sale_id     | int   |
# -- | product_id  | int   |
# -- | user_id     | int   |
# -- | quantity    | int   |
# -- +-------------+-------+
# -- sale_id is the primary key of this table.
# -- product_id is a foreign key to Product table.
# -- Each row of this table shows the ID of the product and the quantity purchased by a user.
# -- Table: Product
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | product_id  | int  |
# -- | price       | int  |
# -- +-------------+------+
# -- product_id is the primary key of this table.
# -- Each row of this table indicates the price of each product.
# -- Write an  SQL query that reports for each user the product id on which the user spent the most money. 
# --In case the same user spent the most money on two or more products, report all of them.
# -- Return the resulting table in any order.

# -- Input: 
# -- Sales table:
# -- +---------+------------+---------+----------+
# -- | sale_id | product_id | user_id | quantity |
# -- +---------+------------+---------+----------+
# -- | 1       | 1          | 101     | 10       |
# -- | 2       | 3          | 101     | 7        |
# -- | 3       | 1          | 102     | 9        |
# -- | 4       | 2          | 102     | 6        |
# -- | 5       | 3          | 102     | 10       |
# -- | 6       | 1          | 102     | 6        |
# -- +---------+------------+---------+----------+
# -- Product table:
# -- +------------+-------+
# -- | product_id | price |
# -- +------------+-------+
# -- | 1          | 10    |
# -- | 2          | 25    |
# -- | 3          | 15    |
# -- +------------+-------+
# -- Output: 
# -- +---------+------------+
# -- | user_id | product_id |
# -- +---------+------------+
# -- | 101     | 3          |
# -- | 102     | 1          |
# -- | 102     | 2          |
# -- | 102     | 3          |
# -- +---------+------------+ 
# -- Explanation: 
# -- User 101:
# --     - Spent 10 * 10 = 100 on product 1.
# --     - Spent 7 * 15 = 105 on product 3.
# -- User 101 spent the most money on product 3.
# -- User 102:
# --     - Spent (9 + 7) * 10 = 150 on product 1.
# --     - Spent 6 * 25 = 150 on product 2.
# --     - Spent 10 * 15 = 150 on product 3.
# -- User 102 spent the most money on products 1, 2, and 3.

import pandas as pd
sales_data = {
    'sale_id': [1, 2, 3, 4, 5, 6],
    'product_id': [1, 3, 1, 2, 3, 1],
    'user_id': [101, 101, 102, 102, 102, 102],
    'quantity': [10, 7, 9, 6, 10, 6]
}
sales_df = pd.DataFrame(sales_data)
product_data = {
    'product_id': [1, 2, 3],
    'price': [10, 25, 15]
}
product_df = pd.DataFrame(product_data)

#m1
# df = pd.merge(sales_df,product_df,on='product_id')
# df['tot'] = df['quantity'] * df['price']
# df['total'] = df.groupby(['user_id', 'product_id'])['tot'].transform('sum')
# df['max_total'] = df.groupby(['user_id'])['tot'].transform('max')
# df = df[df['total'] == df['max_total']][['user_id','product_id']].drop_duplicates()
# print(df)

############################################################################################################

#m2

# df = pd.merge(sales_df, product_df, on='product_id')
# df['tot'] = df['quantity'] * df['price']
# df = df.groupby(['user_id', 'product_id'])['tot'].sum().reset_index()
# df['max_total'] = df.groupby('user_id')['tot'].transform('max')
# df = df[df['tot'] == df['max_total']][['user_id', 'product_id']]
# print(df)

############################################################################################################
# m3

sales_product_df = (
             sales_df
            .merge(product_df, on = 'product_id')
            .assign(amount = lambda x: x['quantity']*x['price'])
            .groupby(['user_id','product_id'], as_index = False)['amount']
            .sum()
            .rename(columns = {'amount':'total_amount'})
            .assign(product_ranked = lambda x: x.groupby('user_id')['total_amount']
                                    .rank(method = 'dense', ascending = False)
                                    .astype(int)
            )
            .query("product_ranked == 1")
            .reset_index(drop=True)
            [['user_id','product_id']]
                     
)

print(sales_product_df)

############################################################################################################
#m4

df = (
    sales_df
    .merge(product_df, on='product_id')
    .assign(amount=lambda x: x['quantity'] * x['price'])
    .groupby(['user_id','product_id'], as_index=False)['amount']
    .sum()
)

df = df[df['amount'] == df.groupby('user_id')['amount'].transform('max')]

result = df[['user_id','product_id']]

# -- 1555. Bank Account Summary
# -- Description
# -- Table: Users
# -- +--------------+---------+
# -- | Column Name  | Type    |
# -- +--------------+---------+
# -- | user_id      | int     |
# -- | user_name    | varchar |
# -- | credit       | int     |
# -- +--------------+---------+
# -- user_id is the primary key (column with unique values) for this table.
# -- Each row of this table contains the current credit information for each user.

# -- Table: Transactions
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | trans_id      | int     |
# -- | paid_by       | int     |
# -- | paid_to       | int     |
# -- | amount        | int     |
# -- | transacted_on | date    |
# -- +---------------+---------+
# -- trans_id is the primary key (column with unique values) for this table.
# -- Each row of this table contains information about the transaction in the bank.
# -- User with id (paid_by) transfer money to user with id (paid_to).
# --  
# -- Leetcode Bank (LCB) helps its coders in making virtual payments. Our bank records all
# -- transactions in the table Transaction, we want to find out the current balance of all users 
# --and  check whether they have breached their credit limit (If their current credit is less than 0).

# -- Write a solution to report.

# -- user_id,
# -- user_name,
# -- credit, current balance after performing transactions, and
# -- credit_limit_breached, check credit_limit ("Yes" or "No")
# -- Return the result table in any order.

# -- Input: 
# -- Users table:
# -- +------------+--------------+-------------+
# -- | user_id    | user_name    | credit      |
# -- +------------+--------------+-------------+
# -- | 1          | Moustafa     | 100         |
# -- | 2          | Jonathan     | 200         |
# -- | 3          | Winston      | 10000       |
# -- | 4          | Luis         | 800         | 
# -- +------------+--------------+-------------+
# -- Transactions table:
# -- +------------+------------+------------+----------+---------------+
# -- | trans_id   | paid_by    | paid_to    | amount   | transacted_on |
# -- +------------+------------+------------+----------+---------------+
# -- | 1          | 1          | 3          | 400      | 2020-08-01    |
# -- | 2          | 3          | 2          | 500      | 2020-08-02    |
# -- | 3          | 2          | 1          | 200      | 2020-08-03    |
# -- +------------+------------+------------+----------+---------------+

# -- Output: 
# -- +------------+------------+------------+-----------------------+
# -- | user_id    | user_name  | credit     | credit_limit_breached |
# -- +------------+------------+------------+-----------------------+
# -- | 1          | Moustafa   | -100       | Yes                   | 
# -- | 2          | Jonathan   | 500        | No                    |
# -- | 3          | Winston    | 9900       | No                    |
# -- | 4          | Luis       | 800        | No                    |
# -- +------------+------------+------------+-----------------------+
# -- Explanation: 
# -- Moustafa paid 400 on "2020-08-01" and received 200 on "2020-08-03", credit (100 -400 +200) = -100
# -- Jonathan received 500 on "2020-08-02" and paid 200 on "2020-08-08", credit (200 +500 -200) = 500
# -- Winston received 400 on "2020-08-01" and paid 500 on "2020-08-03", credit (10000 +400 -500) = 9990
# -- Luis did not received any transfer, credit = 800


# import pandas as pd

# users_data = {
#     'user_id': [1, 2, 3, 4],
#     'user_name': ['Moustafa', 'Jonathan', 'Winston', 'Luis'],
#     'credit': [100, 200, 10000, 800]
# }
# users_df = pd.DataFrame(users_data)

# transactions_data = {
#     'trans_id': [1, 2, 3],
#     'paid_by': [1, 3, 2],
#     'paid_to': [3, 2, 1],
#     'amount': [400, 500, 200],
#     'transacted_on': ['2020-08-01', '2020-08-02', '2020-08-03']
# }
# transactions_df = pd.DataFrame(transactions_data)

# outgoing = transactions_df[['paid_by', 'amount']].copy()
# outgoing['amount'] = -outgoing['amount']
# incoming = transactions_df[['paid_to', 'amount']].rename(columns={'paid_to': 'paid_by'})

# all_transactions = pd.concat([outgoing, incoming])
# transaction_totals = all_transactions.groupby('paid_by', as_index=False)['amount'].sum()

# result = pd.merge(users_df, transaction_totals, left_on='user_id', right_on='paid_by', how='left')
# result['amount'] = result['amount'].fillna(0)
# result['credit'] = result['credit'] + result['amount']
# result['credit_limit_breached'] = result['credit'].apply(lambda x: 'Yes' if x < 0 else 'No')

# result = result[['user_id', 'user_name', 'credit', 'credit_limit_breached']]
# result = result.rename(columns={'credit': 'balance'})

# print(result)