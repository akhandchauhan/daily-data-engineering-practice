# 1355. Activity Participants

# Table: Friends
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | id            | int     |
# | name          | varchar |
# | activity      | varchar |
# +---------------+---------+
# id is the id of the friend and the primary key for this table in SQL.
# name is the name of the friend.
# activity is the name of the activity which the friend takes part in.

# Table: Activities
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | id            | int     |
# | name          | varchar |
# +---------------+---------+
# In SQL, id is the primary key for this table.
# name is the name of the activity

# Find the names of all the activities with neither the maximum nor the 
# minimum number of participants.
# Each activity in the Activities table is performed by any person in the 
# table Friends.
# Return the result table in any order.
# The result format is in the following example.
# Example 1:
# Input:
# Friends table:
# +------+--------------+---------------+
# | id   | name         | activity      |
# +------+--------------+---------------+
# | 1    | Jonathan D.  | Eating        |
# | 2    | Jade W.      | Singing       |
# | 3    | Victor J.    | Singing       |
# | 4    | Elvis Q.     | Eating        |
# | 5    | Daniel A.    | Eating        |
# | 6    | Bob B.       | Horse Riding  |
# +------+--------------+---------------+
# Activities table:
# +------+--------------+
# | id   | name         |
# +------+--------------+
# | 1    | Eating       |
# | 2    | Singing      |
# | 3    | Horse Riding |
# +------+--------------+
# Output:
# +--------------+
# | activity     |
# +--------------+
# | Singing      |
# +--------------+
# Explanation:
# Eating activity is performed by 3 friends (maximum).
# Horse Riding activity is performed by 1 friend (minimum).
# Singing is performed by 2 friends.

import pandas as pd

# Friends table
friends = pd.DataFrame({
    "id": [1, 2, 3, 4, 5, 6],
    "name": [
        "Jonathan D.",
        "Jade W.",
        "Victor J.",
        "Elvis Q.",
        "Daniel A.",
        "Bob B."
    ],
    "activity": [
        "Eating",
        "Singing",
        "Singing",
        "Eating",
        "Eating",
        "Horse Riding"
    ]
})

# Activities table
activities = pd.DataFrame({
    "id": [1, 2, 3],
    "name": ["Eating", "Singing", "Horse Riding"]
})

# m1

merged_df = activities.merge(friends, how = 'left', left_on = 'name', right_on ='activity')

activity_agg_df = merged_df.groupby('name_x', as_index = False)['id_x'].count().rename(columns = {'name_x' :'activity', 'id_x':'cnt'})

max_cnt = activity_agg_df['cnt'].max()
min_cnt = activity_agg_df['cnt'].min()

final = activity_agg_df[(activity_agg_df['cnt'] != max_cnt) & (activity_agg_df['cnt'] != min_cnt)][['activity']]
print(final)