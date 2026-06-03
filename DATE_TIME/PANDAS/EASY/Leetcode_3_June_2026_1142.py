# 1142. User Activity for the Past 30 Days II
# Table: Activity
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | user_id       | int     |
# | session_id    | int     |
# | activity_date | date    |
# | activity_type | enum    |
# +---------------+---------+
# This table may have duplicate rows.
# The activity_type column is an ENUM of type ('open_session', 'end_session',
# 'scroll_down', 'send_message').
# Each session belongs to exactly one user.
#
# Write a solution to find the average number of sessions per user
# for a period of 30 days ending 2019-07-27 inclusively, rounded to 2 decimal places.
# Only count sessions with at least one activity in that time period.
#
# Activity table:
# +---------+------------+---------------+---------------+
# | user_id | session_id | activity_date | activity_type |
# +---------+------------+---------------+---------------+
# | 1       | 1          | 2019-07-20    | open_session  |
# | 1       | 1          | 2019-07-20    | scroll_down   |
# | 1       | 1          | 2019-07-20    | end_session   |
# | 2       | 4          | 2019-07-20    | open_session  |
# | 2       | 4          | 2019-07-21    | send_message  |
# | 2       | 4          | 2019-07-21    | end_session   |
# | 3       | 2          | 2019-07-21    | open_session  |
# | 3       | 2          | 2019-07-21    | send_message  |
# | 3       | 2          | 2019-07-21    | end_session   |
# | 3       | 5          | 2019-07-21    | open_session  |
# | 3       | 5          | 2019-07-21    | scroll_down   |
# | 3       | 5          | 2019-07-21    | end_session   |
# | 4       | 3          | 2019-06-25    | open_session  |
# | 4       | 3          | 2019-06-25    | end_session   |
# +---------+------------+---------------+---------------+
# Output:
# +---------------------------+
# | average_sessions_per_user |
# +---------------------------+
# | 1.33                      |
# +---------------------------+
# Explanation: User 1 and 2 each had 1 session, user 3 had 2 sessions
# → (1 + 1 + 2) / 3 = 1.33

import pandas as pd

activity = pd.DataFrame({
    'user_id':       [1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4],
    'session_id':    [1, 1, 1, 4, 4, 4, 2, 2, 2, 5, 5, 5, 3, 3],
    'activity_date': pd.to_datetime([
        '2019-07-20', '2019-07-20', '2019-07-20',
        '2019-07-20', '2019-07-21', '2019-07-21',
        '2019-07-21', '2019-07-21', '2019-07-21',
        '2019-07-21', '2019-07-21', '2019-07-21',
        '2019-06-25', '2019-06-25',
    ]),
    'activity_type': [
        'open_session', 'scroll_down', 'end_session',
        'open_session', 'send_message', 'end_session',
        'open_session', 'send_message', 'end_session',
        'open_session', 'scroll_down', 'end_session',
        'open_session', 'end_session',
    ]
})

avg_duration = (
    activity.loc[lambda d : 
                    (pd.to_datetime('2019-07-27') - d['activity_date']).dt.days.between(0,29)]
    .groupby('user_id', as_index = False)['session_id'].nunique()
    ['session_id']
    .mean()
    .round(2)
)
result = pd.DataFrame({'average_sessions_per_user':[avg_duration]})
print(result)