# 1132. Reported Posts II

# Table: Actions
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | user_id       | int     |
# | post_id       | int     |
# | action_date   | date    | 
# | action        | enum    |
# | extra         | varchar |
# +---------------+---------+
# This table may have duplicate rows.
# The action column is an ENUM (category) type of ('view', 'like', 'reaction', 'comment', 'report', 
# 'share').
# The extra column has optional information about the action, such as a reason for the report or a 
# type of reaction.
 

# Table: Removals
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | post_id       | int     |
# | remove_date   | date    | 
# +---------------+---------+
# post_id is the primary key (column with unique values) of this table.
# Each row in this table indicates that some post was removed due to being reported or as a 
# result of an admin review.
 
# Write a solution to find the average daily percentage of posts that got removed after 
# being reported as spam, rounded to 2 decimal places.

# Actions table:
# +---------+---------+-------------+--------+--------+
# | user_id | post_id | action_date | action | extra  |
# +---------+---------+-------------+--------+--------+
# | 1       | 1       | 2019-07-01  | view   | null   |
# | 1       | 1       | 2019-07-01  | like   | null   |
# | 1       | 1       | 2019-07-01  | share  | null   |
# | 2       | 2       | 2019-07-04  | view   | null   |
# | 2       | 2       | 2019-07-04  | report | spam   |
# | 3       | 4       | 2019-07-04  | view   | null   |
# | 3       | 4       | 2019-07-04  | report | spam   |
# | 4       | 3       | 2019-07-02  | view   | null   |
# | 4       | 3       | 2019-07-02  | report | spam   |
# | 5       | 2       | 2019-07-03  | view   | null   |
# | 5       | 2       | 2019-07-03  | report | racism |
# | 5       | 5       | 2019-07-03  | view   | null   |
# | 5       | 5       | 2019-07-03  | report | racism |
# +---------+---------+-------------+--------+--------+

# Removals table:
# +---------+-------------+
# | post_id | remove_date |
# +---------+-------------+
# | 2       | 2019-07-20  |
# | 3       | 2019-07-18  |
# +---------+-------------+
# Output: 
# +-----------------------+
# | average_daily_percent |
# +-----------------------+
# | 75.00                 |
# +-----------------------+
# Explanation: 
# The percentage for 2019-07-04 is 50% because only one post of two spam reported posts were removed.
# The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
# The other days had no spam reports so the average is (50 + 100) / 2 = 75%
# Note that the output is only one number and that we do not care about the remove dates.


import pandas as pd

actions = pd.DataFrame({
    'user_id': [1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5],
    'post_id': [1, 1, 1, 2, 2, 4, 4, 3, 3, 2, 2, 5, 5],
    'action_date': [
        '2019-07-01', '2019-07-01', '2019-07-01',
        '2019-07-04', '2019-07-04',
        '2019-07-04', '2019-07-04',
        '2019-07-02', '2019-07-02',
        '2019-07-03', '2019-07-03',
        '2019-07-03', '2019-07-03'
    ],
    'action': [
        'view', 'like', 'share',
        'view', 'report',
        'view', 'report',
        'view', 'report',
        'view', 'report',
        'view', 'report'
    ],
    'extra': [
        None, None, None,
        None, 'spam',
        None, 'spam',
        None, 'spam',
        None, 'racism',
        None, 'racism'
    ]
})

removals = pd.DataFrame({
    'post_id': [2, 3],
    'remove_date': ['2019-07-20', '2019-07-18']
})

actions['action_date'] = pd.to_datetime(actions['action_date'])
removals['remove_date'] = pd.to_datetime(removals['remove_date'])


merged_df =(
    actions.loc[lambda d: (d['action'] == 'report') & (d['extra'] == 'spam')]
    .merge(removals, how ='left', on = 'post_id')
    .groupby('action_date', as_index = False)
    .agg(
        spam_count = ('post_id', 'nunique'),
        remove_count = ('remove_date','nunique')
    )
    .assign(
        daily_percent = lambda d: d['remove_count']*100.0/d['spam_count']
    )
    ['daily_percent']
)

final_df = pd.DataFrame({
    'average_daily_percent': [round(merged_df.mean(), 2)]
})

print(final_df)