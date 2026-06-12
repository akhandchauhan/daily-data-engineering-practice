# 2994. Friday Purchases II
# Table: Purchases
# +---------------+------+
# | Column Name   | Type |
# +---------------+------+
# | user_id       | int  |
# | purchase_date | date |
# | amount_spend  | int  |
# +---------------+------+
# (user_id, purchase_date, amount_spend) is the primary key for this table.
# purchase_date will range from November 1, 2023, to November 30, 2023, inclusive of both dates.
# Each row contains user id, purchase date, and amount spend.

# Write a solution to calculate the total spending by users on each
# Friday of every week in November 2023. If there are no purchases on a
# particular Friday of a week, it will be considered as 0.
# Return the result table ordered by week of month in ascending order.

# Input:
# +---------+---------------+--------------+
# | user_id | purchase_date | amount_spend |
# +---------+---------------+--------------+
# | 11      | 2023-11-07    | 1126         |
# | 15      | 2023-11-30    | 7473         |
# | 17      | 2023-11-14    | 2414         |
# | 12      | 2023-11-24    | 9692         |
# | 8       | 2023-11-03    | 5117         |
# | 1       | 2023-11-16    | 5241         |
# | 10      | 2023-11-12    | 8266         |
# | 13      | 2023-11-24    | 12000        |
# +---------+---------------+--------------+

# Output:
# +---------------+---------------+--------------+
# | week_of_month | purchase_date | total_amount |
# +---------------+---------------+--------------+
# | 1             | 2023-11-03    | 5117         |
# | 2             | 2023-11-10    | 0            |
# | 3             | 2023-11-17    | 0            |
# | 4             | 2023-11-24    | 21692        |
# +---------------+---------------+--------------+

import pandas as pd
import numpy as np
# import datetime as dt   # ❌ dead import — never used
pd.set_option("display.max_columns", None)

purchases = pd.DataFrame({
    "user_id":       [11, 15, 17, 12, 8,  1,  10, 13],
    "purchase_date": ["2023-11-07", "2023-11-30", "2023-11-14", "2023-11-24",
                      "2023-11-03", "2023-11-16", "2023-11-12", "2023-11-24"],
    "amount_spend":  [1126, 7473, 2414, 9692, 5117, 5241, 8266, 12000]
})
# purchases = purchases.copy()  # ❌ redundant — no views exist after a fresh DataFrame constructor

purchases["purchase_date"] = pd.to_datetime(purchases["purchase_date"])

df = np.arange('2023-11-01', '2023-12-01', dtype='datetime64[D]')  # ✓ end is exclusive so Dec 1 includes Nov 30

november_dates_df = pd.DataFrame({'purchase_date':df})

merged_df = (
    november_dates_df.loc[lambda d: d['purchase_date'].dt.day_name() == 'Friday']  # ❌ locale-dependent; use dt.dayofweek == 4
    .merge(purchases, on = 'purchase_date', how = 'left')  # ✓ filter-before-join: calendar is 4 rows, not 30
    .groupby('purchase_date', as_index = False)['amount_spend']
    .sum()
    .assign(
        week_of_month = lambda d: np.ceil(d['purchase_date'].dt.day / 7).astype(int),
        amount_spend = lambda d: d['amount_spend'].fillna(0).astype(int)  # ✓ explicit fillna before cast
    )
    .rename(columns = {'amount_spend':'total_amount'})
    [['week_of_month','purchase_date','total_amount']]
    .sort_values('week_of_month')
)

print(merged_df)
