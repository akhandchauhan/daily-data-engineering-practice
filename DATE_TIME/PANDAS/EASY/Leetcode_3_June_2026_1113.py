# 1113. Reported Posts
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
# The action column is an ENUM type of ('view','like','reaction','comment','report','share').
# The extra column has optional information about the action, such as a reason for the report.
# extra is never NULL.
#
# Write a solution to report the number of posts reported yesterday for each report reason.
# Assume today is 2019-07-05.
# Return the result table in any order.
#
# Actions table:
# +---------+---------+-------------+--------+--------+
# | user_id | post_id | action_date | action | extra  |
# +---------+---------+-------------+--------+--------+
# | 1       | 1       | 2019-07-01  | view   | null   |
# | 2       | 4       | 2019-07-04  | view   | null   |
# | 2       | 4       | 2019-07-04  | report | spam   |
# | 3       | 4       | 2019-07-04  | view   | null   |
# | 3       | 4       | 2019-07-04  | report | spam   |
# | 4       | 3       | 2019-07-02  | report | spam   |
# | 5       | 2       | 2019-07-04  | report | racism |
# | 5       | 5       | 2019-07-04  | report | racism |
# +---------+---------+-------------+--------+--------+
# Output:
# +---------------+--------------+
# | report_reason | report_count |
# +---------------+--------------+
# | spam          | 1            |
# | racism        | 2            |
# +---------------+--------------+
# Explanation: Note that post 4 is reported twice but counted 
# only once in the spam category.

import pandas as pd
import datetime as dt

actions = pd.DataFrame({
    'user_id':      [1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5],
    'post_id':      [1, 1, 1, 4, 4, 4, 4, 3, 3, 2, 2, 5, 5],
    'action_date':  pd.to_datetime([
        '2019-07-01', '2019-07-01', '2019-07-01',
        '2019-07-04', '2019-07-04',
        '2019-07-04', '2019-07-04',
        '2019-07-02', '2019-07-02',
        '2019-07-04', '2019-07-04',
        '2019-07-04', '2019-07-04',
    ]),
    'action':       [
        'view', 'like', 'share',
        'view', 'report',
        'view', 'report',
        'view', 'report',
        'view', 'report',
        'view', 'report',
    ],
    'extra':        [
        None, None, None,
        None, 'spam',
        None, 'spam',
        None, 'spam',
        None, 'racism',
        None, 'racism',
    ]
})

today_date = pd.to_datetime("2019-07-05")
yesterday_date = (today_date - pd.Timedelta(days=1)).date()

df = (
    actions.loc[lambda d: (yesterday_date == d['action_date'].dt.date) & 
                (d['action'] == 'report')]
            .groupby('extra', as_index = False)['post_id']
            .nunique()
            .rename(columns = {'extra':'report_reason','post_id':'report_count' })
)
print(df)
