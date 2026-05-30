# 2688. Find Active Users
# Description
# Table: Users
# +-------------+----------+
# | Column Name | Type     |
# +-------------+----------+
# | user_id     | int      |
# | item        | varchar  |
# | created_at  | datetime |
# | amount      | int      |
# +-------------+----------+
# This table may contain duplicate records.
# Each row includes the user ID, the purchased item, the date of purchase, and the purchase amount.
# Write a solution to identify active users. An active user is a user that has
# made a second purchase within 7 days of any other of their purchases.
# Return a list of user_id which denotes the list of active users in any order.
# Input:
# Users table:
# +---------+-------------------+------------+--------+
# | user_id | item              | created_at | amount |
# +---------+-------------------+------------+--------+
# | 5       | Smart Crock Pot   | 2021-09-18 | 698882 |
# | 6       | Smart Lock        | 2021-09-14 | 11487  |
# | 6       | Smart Thermostat  | 2021-09-10 | 674762 |
# | 8       | Smart Light Strip | 2021-09-29 | 630773 |
# | 4       | Smart Cat Feeder  | 2021-09-02 | 693545 |
# | 4       | Smart Bed         | 2021-09-13 | 170249 |
# +---------+-------------------+------------+--------+
# Output:
# +---------+
# | user_id |
# +---------+
# | 6       |
# +---------+
# Explanation:
# - User with user_id 5 has only one transaction, so he is not an active user.
# - User with user_id 6 has two transactions; first on 2021-09-10, second on 2021-09-14.
#   The distance between them is <= 7 days, so he is an active user.
# - User with user_id 8 has only one transaction, so he is not an active user.
# - User with user_id 4 has two transactions; first on 2021-09-02, second on 2021-09-13.
#   The distance is > 7 days, so he is not an active user.

import pandas as pd

users = pd.DataFrame({
    'user_id': [5, 6, 6, 8, 4, 4],
    'item': [
        'Smart Crock Pot',
        'Smart Lock',
        'Smart Thermostat',
        'Smart Light Strip',
        'Smart Cat Feeder',
        'Smart Bed'
    ],
    'created_at': pd.to_datetime([
        '2021-09-18',
        '2021-09-14',
        '2021-09-10',
        '2021-09-29',
        '2021-09-02',
        '2021-09-13'
    ]),
    'amount': [698882, 11487, 674762, 630773, 693545, 170249]
})


users_df = users.copy()

users_df['next_created_at'] = (users_df
                                  .sort_values(['user_id','created_at'])
                                  .groupby('user_id')['created_at']
                                  .shift(-1)
                                )
users_df = users_df[(users_df['next_created_at'] - users_df['created_at']).dt.days <= 7][['user_id']].drop_duplicates()
print(users_df)