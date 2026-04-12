# 512. Game Play Analysis II
# Description
# Table: Activity
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | player_id    | int     |
# | device_id    | int     |
# | event_date   | date    |
# | games_played | int     |
# +--------------+---------+
# (player_id, event_date) is the primary key (combination of columns with unique 
# values) of this table.
# This table shows the activity of players of some games.
# Each row is a record of a player who logged in and played a number of games
# (possibly 0) before logging out on someday using some device.
 
# Write a solution to report the device that is first logged in for each player.
# Return the result table in any order.

# Input: 
# Activity table:
# +-----------+-----------+------------+--------------+
# | player_id | device_id | event_date | games_played |
# +-----------+-----------+------------+--------------+
# | 1         | 2         | 2016-03-01 | 5            |
# | 1         | 2         | 2016-05-02 | 6            |
# | 2         | 3         | 2017-06-25 | 1            |
# | 3         | 1         | 2016-03-02 | 0            |
# | 3         | 4         | 2018-07-03 | 5            |
# +-----------+-----------+------------+--------------+
# Output: 
# +-----------+-----------+
# | player_id | device_id |
# +-----------+-----------+
# | 1         | 2         |
# | 2         | 3         |
# | 3         | 1         |
# +-----------+-----------+


import pandas as pd

activity_df = pd.DataFrame({
    "player_id": [1, 1, 2, 3, 3],
    "device_id": [2, 2, 3, 1, 4],
    "event_date": [
        "2016-03-01",
        "2016-05-02",
        "2017-06-25",
        "2016-03-02",
        "2018-07-03"
    ],
    "games_played": [5, 6, 1, 0, 5]
})

activity_df["event_date"] = pd.to_datetime(activity_df["event_date"])

# m1 

df = (
    activity_df.groupby('player_id')['event_date']
    .min()
    .reset_index()
    .rename(columns = {'event_date':'min_event_date'})
    .merge(activity_df,left_on=['player_id','min_event_date'],
       right_on=['player_id','event_date']
    )
    [['player_id_x','device_id']]
    .rename(columns = {'player_id_x':"player_id"})
)


#####################################################################################
# m2

df = (
    activity_df.assign(
        min_event_date = lambda d: d.groupby('player_id')['event_date'].transform('min')
    )
    .loc[lambda d: d['event_date'] == d['min_event_date']]
    [['player_id','device_id']]
)

#####################################################################################
# m3

df = (
    activity_df.sort_values(['player_id','event_date'])
    .assign(
        player_event_ranked = lambda d: d.groupby('player_id')['event_date'].cumcount()+1
    )
    .loc[lambda d: d['player_event_ranked'] == 1]
    [['player_id','device_id']]
)
print(df)