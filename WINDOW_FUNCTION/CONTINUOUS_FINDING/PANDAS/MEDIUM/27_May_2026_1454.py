# 1454. Active Users

# Table Accounts:
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | id            | int     |
# | name          | varchar |
# +---------------+---------+
# the id is the primary key for this table.
# This table contains the account id and the user name of each account.

# Table Logins:
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | id            | int     |
# | login_date    | date    |
# +---------------+---------+
# There is no primary key for this table, it may contain duplicates.
# This table contains the account id of the user who logged in and the login date.
# A user may log in multiple times in the day.

# Write an SQL query to find the id and the name of active users.
# Active users are those who logged in to their accounts for 5 or more consecutive days.
# Return the result table ordered by the id.

# Accounts table:
# +----+----------+
# | id | name     |
# +----+----------+
# | 1  | Winston  |
# | 7  | Jonathan |
# +----+----------+
# Logins table:
# +----+------------+
# | id | login_date |
# +----+------------+
# | 7  | 2020-05-30 |
# | 1  | 2020-05-30 |
# | 7  | 2020-05-31 |
# | 7  | 2020-06-01 |
# | 7  | 2020-06-02 |
# | 7  | 2020-06-02 |
# | 7  | 2020-06-03 |
# | 1  | 2020-06-07 |
# | 7  | 2020-06-10 |
# +----+------------+
# Result table:
# +----+----------+
# | id | name     |
# +----+----------+
# | 7  | Jonathan |
# +----+----------+
# User Winston with id = 1 logged in 2 times only in 2 different days, 
# so, Winston is not an active user.
# User Jonathan with id = 7 logged in 7 times in 6 different days, 
# five of them were consecutive days, so, Jonathan is an active user.

import pandas as pd

accounts = pd.DataFrame({
    'id': [1, 7],
    'name': ['Winston', 'Jonathan']
})

logins = pd.DataFrame({
    'id': [7, 1, 7, 7, 7, 7, 7, 1, 7],
    'login_date': [
        '2020-05-30',
        '2020-05-30',
        '2020-05-31',
        '2020-06-01',
        '2020-06-02',
        '2020-06-02',
        '2020-06-03',
        '2020-06-07',
        '2020-06-10'
    ]
})

logins['login_date'] = pd.to_datetime(logins['login_date'])

logins = logins.drop_duplicates()

logins_df = (
    logins.sort_values(['id','login_date'])
    .assign(
        login_rnk = lambda d: d.groupby('id')['login_date'].cumcount()+1,
        streak_group = lambda d: d['login_date'] - pd.to_timedelta(d['login_rnk'], unit= 'D')
    )
    .groupby(['id','streak_group'], as_index = False)['streak_group'].count()
    .loc[lambda d: d['streak_group'] >= 5]
    [['id']]
    .drop_duplicates()
)
merged_df = (
    logins_df.merge(accounts, on ='id')
    .sort_values('id')
)
print(merged_df)