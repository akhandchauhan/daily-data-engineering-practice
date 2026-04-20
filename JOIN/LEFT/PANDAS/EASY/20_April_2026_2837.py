# 2837. Total Traveled Distance
# Description
# Table: Users

# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | user_id     | int     |
# | name        | varchar |
# +-------------+---------+
# user_id is the primary key for this table.
# Each row of this table contains user id and name.
# Table: Rides

# +--------------+------+
# | Column Name  | Type |
# +--------------+------+
# | ride_id      | int  |
# | user_id      | int  | 
# | distance     | int  |
# +--------------+------+
# ride_id is the primary key for this table.
# Each row of this table contains ride id, user id, and traveled distance.

# Write an  SQL query to calculate the distance traveled by each user. 
# If there is a user who hasn't completed any rides, then their distance 
# should be considered as 0. Output the user_id, name and total traveled distance.

# Return the result table ordered by user_id in ascending order.
# Input: 
# Users table:
# +---------+---------+
# | user_id | name    |
# +---------+---------+
# | 17      | Addison |
# | 14      | Ethan   |
# | 4       | Michael |
# | 2       | Avery   |
# | 10      | Eleanor |
# +---------+---------+
# Rides table:
# +---------+---------+----------+
# | ride_id | user_id | distance |
# +---------+---------+----------+
# | 72      | 17      | 160      |
# | 42      | 14      | 161      |
# | 45      | 4       | 59       |
# | 32      | 2       | 197      |
# | 15      | 4       | 357      |
# | 56      | 2       | 196      |
# | 10      | 14      | 25       |
# +---------+---------+----------+
# Output: 
# +---------+---------+-------------------+
# | user_id | name    | traveled distance |
# +---------+---------+-------------------+
# | 2       | Avery   | 393               |
# | 4       | Michael | 416               |
# | 10      | Eleanor | 0                 |
# | 14      | Ethan   | 186               |
# | 17      | Addison | 160               |
# +---------+---------+-------------------+
# Explanation: 
# -  User id 2 completed two journeys of 197 and 196, resulting in a combined 
# travel distance of 393.
# -  User id 4 completed two journeys of 59 and 357, resulting in a combined 
# travel distance of 416.
# -  User id 14 completed two journeys of 161 and 25, resulting in a combined 
# travel distance of 186.
# -  User id 16 completed only one journey of 160.
# -  User id 10 did not complete any journeys, thus the total travel distance
#  remains at 0.
# Returning the table orderd by user_id in ascending order.

import pandas as pd

# Users DataFrame
users = pd.DataFrame({
    "user_id": [17, 14, 4, 2, 10],
    "name": ["Addison", "Ethan", "Michael", "Avery", "Eleanor"]
})

# Rides DataFrame
rides = pd.DataFrame({
    "ride_id": [72, 42, 45, 32, 15, 56, 10],
    "user_id": [17, 14, 4, 2, 4, 2, 14],
    "distance": [160, 161, 59, 197, 357, 196, 25]
})

df = (
    users.merge(rides, how ='left', on = 'user_id')
    .groupby(['user_id','name'], as_index = False)['distance']
    .sum()
    .rename(columns = {'distance':'traveled_distance'})
    .sort_values("user_id")
)
df['traveled_distance'] = df['traveled_distance'].astype(int)
print(df)