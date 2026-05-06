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

# -- Leetcode Bank (LCB) helps its coders in making virtual payments. Our bank records all
# -- transactions in the table Transaction, we want to find out the current balance of all users 
# -- and check whether they have breached their credit limit (If their current credit is less than 0).

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
# -- Moustafa paid 400 on "2020-08-01" and received 200 on "2020-08-03", 
# credit (100 -400 +200) = -100
# -- Jonathan received 500 on "2020-08-02" and paid 200 on "2020-08-08", 
# credit (200 +500 -200) = 500
# -- Winston received 400 on "2020-08-01" and paid 500 on "2020-08-03", 
# credit (10000 +400 -500) = 9990
# -- Luis did not received any transfer, credit = 800


import pandas as pd
import numpy as np

users_data = {
    'user_id': [1, 2, 3, 4],
    'user_name': ['Moustafa', 'Jonathan', 'Winston', 'Luis'],
    'credit': [100, 200, 10000, 800]
}
users_df = pd.DataFrame(users_data)

transactions_data = {
    'trans_id': [1, 2, 3],
    'paid_by': [1, 3, 2],
    'paid_to': [3, 2, 1],
    'amount': [400, 500, 200],
    'transacted_on': ['2020-08-01', '2020-08-02', '2020-08-03']
}
transactions_df = pd.DataFrame(transactions_data)

outgoing = transactions_df[['paid_by', 'amount']].copy()
outgoing['amount'] = -outgoing['amount']
incoming = transactions_df[['paid_to', 'amount']].rename(columns={'paid_to': 'paid_by'})

all_transactions = pd.concat([outgoing, incoming])
transaction_totals = all_transactions.groupby('paid_by', as_index=False)['amount'].sum()

result = pd.merge(users_df, transaction_totals, left_on='user_id', right_on='paid_by', how='left')
result['amount'] = result['amount'].fillna(0)
result['credit'] = result['credit'] + result['amount']
result['credit_limit_breached'] = result['credit'].apply(lambda x: 'Yes' if x < 0 else 'No')

result = result[['user_id', 'user_name', 'credit', 'credit_limit_breached']]

print(result)

####################################################################################################
# m2
transactions_df = transactions.copy()

paid_by_trans = (
                transactions_df[['paid_by','amount']]
                .assign(
                    amount = lambda d: - d['amount']
                )
                .rename(columns = {'paid_by' :'user_id'})
)

paid_to_trans = transactions_df[['paid_to','amount']].rename(columns = {'paid_to':'user_id'})


trans_df = pd.concat([paid_by_trans, paid_to_trans])

trans_agg_df = (
    trans_df.groupby("user_id", as_index= False)['amount']
    .sum()
)

print(trans_agg_df)
df_merged = (
    users_df.merge(trans_agg_df,how ='left', on = 'user_id')
    .assign(
        amount=lambda d: d['amount'].fillna(0),
        credit=lambda d: d['credit'] + d['amount'],
        credit_limit_breached=lambda d: np.where(
            d['credit'] < 0,
            'Yes',
            'No'
        )
    )
    [['user_id','user_name','credit','credit_limit_breached']]
)
print(df_merged)
