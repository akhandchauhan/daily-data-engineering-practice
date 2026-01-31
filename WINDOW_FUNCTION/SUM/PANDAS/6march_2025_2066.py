# -- 2066. Account Balance
# -- Description
# -- Table: Transactions
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | account_id  | int  |
# -- | day         | date |
# -- | type        | ENUM |
# -- | amount      | int  |
# -- +-------------+------+
# -- (account_id, day) is the primary key for this table.
# -- Each row contains information about one transaction, including the transaction type, the day
# -- it occurred on, and the amount.
# -- type is an ENUM of the type ('Deposit','Withdraw') 
# -- Write an  SQL query to report the balance of each user after each transaction. 
# -- You may assume that the balance of each account before any transaction is 0 and that
# -- the balance will never be below 0 at any moment.
# -- Return the result table in ascending order by account_id, then by day in case of a tie.
# -- The query result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Transactions table:
# -- +------------+------------+----------+--------+
# -- | account_id | day        | type     | amount |
# -- +------------+------------+----------+--------+
# -- | 1          | 2021-11-07 | Deposit  | 2000   |
# -- | 1          | 2021-11-09 | Withdraw | 1000   |
# -- | 1          | 2021-11-11 | Deposit  | 3000   |
# -- | 2          | 2021-12-07 | Deposit  | 7000   |
# -- | 2          | 2021-12-12 | Withdraw | 7000   |
# -- +------------+------------+----------+--------+
# -- Output: 
# -- +------------+------------+---------+
# -- | account_id | day        | balance |
# -- +------------+------------+---------+
# -- | 1          | 2021-11-07 | 2000    |
# -- | 1          | 2021-11-09 | 1000    |
# -- | 1          | 2021-11-11 | 4000    |
# -- | 2          | 2021-12-07 | 7000    |
# -- | 2          | 2021-12-12 | 0       |
# -- +------------+------------+---------+

import pandas as pd

data = {
    "account_id": [1, 1, 1, 2, 2],
    "day": ["2021-11-07", "2021-11-09", "2021-11-11", "2021-12-07", "2021-12-12"],
    "type": ["Deposit", "Withdraw", "Deposit", "Deposit", "Withdraw"],
    "amount": [2000, 1000, 3000, 7000, 7000]
}

transactions_df = pd.DataFrame(data)
transactions_df['day'] = pd.to_datetime(transactions_df['day'])

transactions_df['act_amt'] = transactions_df.apply(lambda x: -1* x['amount'] if x['type'] == 'Withdraw' else x['amount'],axis = 1)

transactions_df['balance'] = transactions_df.groupby('account_id')['act_amt'].transform('cumsum')
transactions_df = transactions_df[['account_id','day','balance']]
#print(transactions_df)



