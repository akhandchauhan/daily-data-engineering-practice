# -- 1843. Suspicious Bank Accounts
# -- SQL Schema
# -- Table: Accounts
# -- +----------------+------+
# -- | Column Name    | Type |
# -- +----------------+------+
# -- | account_id     | int  |
# -- | max_income     | int  |
# -- +----------------+------+
# -- account_id is the primary key for this table.
# -- Each row contains information about the maximum monthly income for one bank account.
# -- Table: Transactions
# -- +----------------+----------+
# -- | Column Name    | Type     |
# -- +----------------+----------+
# -- | transaction_id | int      |
# -- | account_id     | int      |
# -- | type           | ENUM     |
# -- | amount         | int      |
# -- | day            | datetime |
# -- +----------------+----------+
# -- transaction_id is the primary key for this table.
# -- Each row contains information about one transaction.
# -- type is ENUM ('Creditor','Debtor') where 'Creditor' means the user deposited money 
# --into their account and 'Debtor' means the user withdrew money from their account.
# -- amount is the amount of money depositied/withdrawn during the transaction.
# -- Write an  SQL query to report the IDs of all suspicious bank accounts.
# -- A bank account is suspicious if the total income exceeds the max_income for this account
# -- for two or more consecutive months. The total income of an account in 
# -- some month is the sum of all its deposits in that month (i.e., transactions of the type 'Creditor').
# -- Return the result table in ascending order by transaction_id.
# -- The query result format is in the following example:
# -- Accounts table:
# -- +------------+------------+
# -- | account_id | max_income |
# -- +------------+------------+
# -- | 3          | 21000      |
# -- | 4          | 10400      |
# -- +------------+------------+
# -- Transactions table:
# -- +----------------+------------+----------+--------+---------------------+
# -- | transaction_id | account_id | type     | amount | day                 |
# -- +----------------+------------+----------+--------+---------------------+
# -- | 2              | 3          | Creditor | 107100 | 2021-06-02 11:38:14 |
# -- | 4              | 4          | Creditor | 10400  | 2021-06-20 12:39:18 |
# -- | 11             | 4          | Debtor   | 58800  | 2021-07-23 12:41:55 |
# -- | 1              | 4          | Creditor | 49300  | 2021-05-03 16:11:04 |
# -- | 15             | 3          | Debtor   | 75500  | 2021-05-23 14:40:20 |
# -- | 10             | 3          | Creditor | 102100 | 2021-06-15 10:37:16 |
# -- | 14             | 4          | Creditor | 56300  | 2021-07-21 12:12:25 |
# -- | 19             | 4          | Debtor   | 101100 | 2021-05-09 15:21:49 |
# -- | 8              | 3          | Creditor | 64900  | 2021-07-26 15:09:56 |
# -- | 7              | 3          | Creditor | 90900  | 2021-06-14 11:23:07 |
# -- +----------------+------------+----------+--------+---------------------+
# -- Result table:
# -- +------------+
# -- | account_id |
# -- +------------+
# -- | 3          |
# -- +------------+
# -- For account 3:
# -- - In 6-2021, the user had an income of 107100 + 102100 + 90900 = 300100.
# -- - In 7-2021, the user had an income of 64900.
# -- We can see that the income exceeded the max income of 21000 for two consecutive months, 
# -- so we include 3 in the result table.
# -- For account 4:
# -- - In 5-2021, the user had an income of 49300.
# -- - In 6-2021, the user had an income of 10400.
# -- - In 7-2021, the user had an income of 56300.
# -- We can see that the income exceeded the max income in May and July, but not in June. Since the account 
# -- did not exceed the max income for two consecutive months, we do not include it in the result table.

import pandas as pd
from datetime import datetime
import datetime as dt


accounts_data = {
    'account_id': [3, 4],
    'max_income': [21000, 10400]
}
accounts = pd.DataFrame(accounts_data)

transactions_data = {
    'transaction_id': [2, 4, 11, 1, 15, 10, 14, 19, 8, 7],
    'account_id': [3, 4, 4, 4, 3, 3, 4, 4, 3, 3],
    'type': ['Creditor', 'Creditor', 'Debtor', 'Creditor', 'Debtor', 'Creditor', 'Creditor', 'Debtor', 'Creditor', 'Creditor'],
    'amount': [107100, 10400, 58800, 49300, 75500, 102100, 56300, 101100, 64900, 90900],
    'day': [
        datetime(2021, 6, 2, 11, 38, 14),
        datetime(2021, 6, 20, 12, 39, 18),
        datetime(2021, 7, 23, 12, 41, 55),
        datetime(2021, 5, 3, 16, 11, 4),
        datetime(2021, 5, 23, 14, 40, 20),
        datetime(2021, 6, 15, 10, 37, 16),
        datetime(2021, 7, 21, 12, 12, 25),
        datetime(2021, 5, 9, 15, 21, 49),
        datetime(2021, 7, 26, 15, 9, 56),
        datetime(2021, 6, 14, 11, 23, 7)
    ]
}
transactions = pd.DataFrame(transactions_data)
print(accounts)
print(transactions)

# transactions['month'] = transactions['day'].dt.to_period('M')
# credits = transactions[transactions['type'] == 'Creditor']
# monthly_totals = credits.groupby(['account_id', 'month'])['amount'].sum().reset_index()

# merged = pd.merge(monthly_totals, accounts, on='account_id')
# merged['exceeds'] = merged['amount'] > merged['max_income']

# merged = merged.sort_values(['account_id', 'month'])
# merged['group'] = (merged['exceeds'] != merged['exceeds'].shift()).cumsum()
# consecutive = merged[merged['exceeds']].groupby(['account_id', 'group']).size().reset_index(name='count')
# suspicious = consecutive[consecutive['count'] >= 2]['account_id'].unique()

# result = pd.DataFrame({'account_id': suspicious})
# print(result)


#############################################################################################################################

# m2

# transactions['day'] = pd.to_datetime(transactions['day'])
# transactions['date_format'] = str(transactions['day'].dt.year) + '-' + str(transactions['day'].dt.month) + '-' + str('-01')
# print(transactions)
# df = (  accounts.merge(
#         transactions,
#         on = 'account_id'
#         )
#         .query("type == 'Creditor'")
#         .groupby(['account_id','max_income','date_format'])['amount']
#         .sum()
#         .reset_index(name = 'Credited_total')
#         .query("Credited_total > max_income")
#         )
#     )
# df['nxt_date_format'] = df.groupby('account')['date_format'].shift(-1)
# df = df[df['nxt_date_format'] - df['date_format'] == 1]
# df = df[['account_id']].drop_duplicates().sort_values(by = 'account_id')
# print(df)

#############################################################################################################################


# m3 

result = (
    transactions
        .assign(
            day=lambda d: pd.to_datetime(d['day']),
            month=lambda d: d['day'].dt.to_period('M').dt.to_timestamp()
        )
        .query("type == 'Creditor'")
        .groupby(['account_id', 'month'], as_index=False)
        .agg(amount=('amount', 'sum'))
        .merge(accounts, on='account_id')
        .query("amount > max_income")
        .assign(
            month_num=lambda d: d['month'].dt.year * 12 + d['month'].dt.month,
            prev_month_num=lambda d: d.groupby('account_id')['month_num'].shift()
        )
        .query("month_num - prev_month_num == 1")
        [['account_id']]
        .drop_duplicates()
        .sort_values('account_id')
)

print(result)