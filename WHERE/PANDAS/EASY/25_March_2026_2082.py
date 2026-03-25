# -- 2082. The Number of Rich Customers
# -- Description
# -- Table: Store
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | bill_id     | int  |
# -- | customer_id | int  |
# -- | amount      | int  |
# -- +-------------+------+
# -- bill_id is the primary key for this table.
# -- Each row contains information about the amount of one bill and the customer associated with it.
# -- Write an  SQL query to report the number of customers who had at least one bill
# -- with an amount strictly greater than 500.
# -- Example 1:
# -- Input: 
# -- Store table:
# -- +---------+-------------+--------+
# -- | bill_id | customer_id | amount |
# -- +---------+-------------+--------+
# -- | 6       | 1           | 549    |
# -- | 8       | 1           | 834    |
# -- | 4       | 2           | 394    |
# -- | 11      | 3           | 657    |
# -- | 13      | 3           | 257    |
# -- +---------+-------------+--------+
# -- Output: 
# -- +------------+
# -- | rich_count |
# -- +------------+
# -- | 2          |
# -- +------------+
# -- Explanation: 
# -- Customer 1 has two bills with amounts strictly greater than 500.
# -- Customer 2 does not have any bills with an amount strictly greater than 500.
# -- Customer 3 has one bill with an amount strictly greater than 500.


import pandas as pd
data = {
    'bill_id': [6, 8, 4, 11, 13],
    'customer_id': [1, 1, 2, 3, 3],
    'amount': [549, 834, 394, 657, 257]
}

df2 = pd.DataFrame(data)


# df1 = df1.query('amount > 500')[['customer_id']]
# df1 = df1.drop_duplicates().shape[0]
# print(df1)  # problem not giving row

rich_count = df2.query('amount > 500')['customer_id'].nunique()
result_df = pd.DataFrame({'rich_count': [rich_count]})

print(result_df)


