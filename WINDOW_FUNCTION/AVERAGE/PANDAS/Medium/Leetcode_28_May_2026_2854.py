# 2854. Rolling Average Steps

# Table: Steps
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | user_id     | int  |
# | steps_count | int  |
# | steps_date  | date |
# +-------------+------+
# (user_id, steps_date) is the primary key for this table.
# Each row of this table contains user_id, steps_count, and steps_date.

# Write a solution to calculate 3-day rolling averages of steps for each user.
# For each day, we calculate the average of 3 consecutive days of step
# counts ending on that day
# if available, otherwise the rolling average is not defined for it.
# Output the user_id, steps_date, and rolling average rounded to two decimal places.
# Return the result table ordered by user_id, steps_date in ascending order.
# Example 1:
# Input:
# Steps table:
# +---------+-------------+------------+
# | user_id | steps_count | steps_date |
# +---------+-------------+------------+
# | 1       | 687         | 2021-09-02 |
# | 1       | 395         | 2021-09-04 |
# | 1       | 499         | 2021-09-05 |
# | 1       | 712         | 2021-09-06 |
# | 1       | 576         | 2021-09-07 |
# | 2       | 153         | 2021-09-06 |
# | 2       | 171         | 2021-09-07 |
# | 2       | 530         | 2021-09-08 |
# | 3       | 945         | 2021-09-04 |
# | 3       | 120         | 2021-09-07 |
# | 3       | 557         | 2021-09-08 |
# | 3       | 840         | 2021-09-09 |
# | 3       | 627         | 2021-09-10 |
# +---------+-------------+------------+
# Output:
# +---------+------------+-----------------+
# | user_id | steps_date | rolling_average |
# +---------+------------+-----------------+
# | 1       | 2021-09-06 | 535.33          |
# | 1       | 2021-09-07 | 595.67          |
# | 2       | 2021-09-08 | 284.67          |
# | 3       | 2021-09-09 | 505.67          |
# | 3       | 2021-09-10 | 674.67          |
# +---------+------------+-----------------+


import pandas as pd

steps = pd.DataFrame({
    'user_id': [1,1,1,1,1,2,2,2,3,3,3,3,3],
    'steps_count': [687,395,499,712,576,153,171,530,945,120,557,840,627],
    'steps_date': [
        '2021-09-02',
        '2021-09-04',
        '2021-09-05',
        '2021-09-06',
        '2021-09-07',
        '2021-09-06',
        '2021-09-07',
        '2021-09-08',
        '2021-09-04',
        '2021-09-07',
        '2021-09-08',
        '2021-09-09',
        '2021-09-10'
    ]
})

steps['steps_date'] = pd.to_datetime(steps['steps_date'])

df = (
    steps.sort_values(['user_id', 'steps_date'])
         .assign(
             rolling_average = lambda d:
             d.groupby('user_id')['steps_count']
              .rolling(3)
              .mean()
              .reset_index(level=0, drop=True)
              .round(2)
         )
         .dropna(subset=['rolling_average'])
         [['user_id', 'steps_date', 'rolling_average']]
)
print(df)