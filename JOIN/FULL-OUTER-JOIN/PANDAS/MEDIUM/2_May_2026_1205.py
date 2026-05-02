# 1205. Monthly Transactions II
# Table: Transactions
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | id             | int     |
# | country        | varchar |
# | state          | enum    |
# | amount         | int     |
# | trans_date     | date    |
# +----------------+---------+
# id is the primary key of this table.
# The table has information about incoming transactions.
# The state column is an enum of type ["approved", "declined"].

# Table: Chargebacks
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | trans_id       | int     |
# | charge_date    | date    |
# +----------------+---------+
# Chargebacks contains basic information regarding incoming chargebacks from some transactions
# placed in Transactions table.
# trans_id is a foreign key to the id column of Transactions table.
# Each chargeback corresponds to a transaction made previously even if they were not approved.

# Write an  SQL query to find for each month and country, the number of approved transactions 
# and their total amount, the number of chargebacks and their total amount.

# Note: In your query, given the month and country, ignore rows with all zeros.
# The query result format is in the following example:
# Transactions table:
# +------+---------+----------+--------+------------+
# | id   | country | state    | amount | trans_date |
# +------+---------+----------+--------+------------+
# | 101  | US      | approved | 1000   | 2019-05-18 |
# | 102  | US      | declined | 2000   | 2019-05-19 |
# | 103  | US      | approved | 3000   | 2019-06-10 |
# | 104  | US      | approved | 4000   | 2019-06-13 |
# | 105  | US      | approved | 5000   | 2019-06-15 |
# +------+---------+----------+--------+------------+
# Chargebacks table:
# +------------+------------+
# | trans_id   | trans_date |
# +------------+------------+
# | 102        | 2019-05-29 |
# | 101        | 2019-06-30 |
# | 105        | 2019-09-18 |
# +------------+------------+
# Result table:
# +----------+---------+----------------+-----------------+-------------------+--------------------+
# | month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
# +----------+---------+----------------+-----------------+-------------------+--------------------+
# | 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
# | 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
# | 2019-09  | US      | 0              | 0               | 1                 | 5000               |
# +----------+---------+----------------+-----------------+-------------------+--------------------+

import pandas as pd
import numpy as np
pd.set_option('display.max_columns', None)

# Transactions table
transactions = pd.DataFrame({
    "id": [101, 102, 103, 104, 105],
    "country": ["US", "US", "US", "US", "US"],
    "state": ["approved", "declined", "approved", "approved", "approved"],
    "amount": [1000, 2000, 3000, 4000, 5000],
    "trans_date": pd.to_datetime([
        "2019-05-18", "2019-05-19", "2019-06-10",
        "2019-06-13", "2019-06-15"
    ])
})

# Chargebacks table
chargebacks = pd.DataFrame({
    "trans_id": [102, 101, 105],
    "trans_date": pd.to_datetime([
        "2019-05-29", "2019-06-30", "2019-09-18"
    ])
})
# m1 wrong
merged_df = (
    transactions.merge(chargebacks, how ='left', 
                       left_on ='id', right_on = 'trans_id'
    )
    .assign(
        month = lambda d: d['trans_date_x'].dt.strftime("%Y-%m"),
        approved_amount = lambda d: np.where(d['state'] == 'approved',d['amount'],0),
        chargback_amount = lambda d: np.where(d['trans_date_y'].isna(),0,d['amount'])
    )
    .groupby(['month', 'country'], as_index= False)
    .agg(
        approved_count = ('state',lambda d: (d == 'approved').sum()),
        approved_amount  = ('approved_amount','sum'),
        chargeback_count = ('trans_date_y',lambda d: (~d.isna()).sum()),
        chargeback_amount = ('chargback_amount','sum')
    )
)

print(merged_df)


############################################################################################
# m2 

import pandas as pd

# Transactions aggregation (ONLY approved)
trans_agg = (
    transactions
    .assign(month = transactions['trans_date'].dt.strftime('%Y-%m'))
    .query("state == 'approved'")
    .groupby(['month', 'country'], as_index=False)
    .agg(
        approved_count = ('id', 'count'),
        approved_amount = ('amount', 'sum')
    )
)

# Chargebacks aggregation (based on charge_date)
charge_agg = (
    chargebacks
    .merge(transactions, left_on='trans_id', right_on='id')
    .assign(month = lambda d: d['trans_date_x'].dt.strftime('%Y-%m'))
    .groupby(['month', 'country'], as_index=False)
    .agg(
        chargeback_count = ('trans_id', 'count'),
        chargeback_amount = ('amount', 'sum')
    )
)

# Combine both
final_df = (
    pd.merge(trans_agg, charge_agg, on=['month', 'country'], how='outer')
    .fillna(0)
    .sort_values(['month', 'country'])
)

print(final_df)