# 1127. User Purchase Platform
# Table: Spending
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | user_id     | int     |
# | spend_date  | date    |
# | platform    | enum    |
# | amount      | int     |
# +-------------+---------+
# The table logs the spendings history of users that make purchases from an online shopping
#  website which has a desktop and a mobile application.
# (user_id, spend_date, platform) is the primary key of this table.
# The platform column is an ENUM type of ('desktop', 'mobile').

# Write a solution to find the total number of users and the total amount spent using
# mobile only, desktop only and both mobile and desktop together for each date.

# Spending table:
# +---------+------------+----------+--------+
# | user_id | spend_date | platform | amount |
# +---------+------------+----------+--------+
# | 1       | 2019-07-01 | mobile   | 100    |
# | 1       | 2019-07-01 | desktop  | 100    |
# | 2       | 2019-07-01 | mobile   | 100    |
# | 2       | 2019-07-02 | mobile   | 100    |
# | 3       | 2019-07-01 | desktop  | 100    |
# | 3       | 2019-07-02 | desktop  | 100    |
# +---------+------------+----------+--------+

# Result table:
# +------------+----------+--------------+-------------+
# | spend_date | platform | total_amount | total_users |
# +------------+----------+--------------+-------------+
# | 2019-07-01 | desktop  | 100          | 1           |
# | 2019-07-01 | mobile   | 100          | 1           |
# | 2019-07-01 | both     | 200          | 1           |
# | 2019-07-02 | desktop  | 100          | 1           |
# | 2019-07-02 | mobile   | 100          | 1           |
# | 2019-07-02 | both     | 0            | 0           |
# +------------+----------+--------------+-------------+

import pandas as pd

data = [
    [1, '2019-07-01', 'mobile', 100],
    [1, '2019-07-01', 'desktop', 100],
    [2, '2019-07-01', 'mobile', 100],
    [2, '2019-07-02', 'mobile', 100],
    [3, '2019-07-01', 'desktop', 100],
    [3, '2019-07-02', 'desktop', 100]
]

spending = pd.DataFrame(data, columns=['user_id', 'spend_date', 'platform', 'amount'])
spending['spend_date'] = pd.to_datetime(spending['spend_date'])

df = spending.copy()

agg_df = (
    df.groupby(['spend_date','platform'], as_index = False)['amount']
    .sum()
)

print(agg_df)