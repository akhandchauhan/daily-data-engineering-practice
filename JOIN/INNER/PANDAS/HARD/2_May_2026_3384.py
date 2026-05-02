# 3384. Team Dominance by Pass Success 
# Table: Teams
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | player_id   | int     |
# | team_name   | varchar | 
# +-------------+---------+
# player_id is the unique key for this table.
# Each row contains the unique identifier for player and the name of one of 
# the teams participating in that match.

# Table: Passes
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | pass_from   | int     |
# | time_stamp  | varchar |
# | pass_to     | int     |
# +-------------+---------+
# (pass_from, time_stamp) is the primary key for this table.
# pass_from is a foreign key to player_id from Teams table.

# Each row represents a pass made during a match, time_stamp represents the time in
# minutes (00:00-90:00) when the pass was made,
# pass_to is the player_id of the player receiving the pass.

# Write a solution to calculate the dominance score for each team in both
# halves of the match. The rules are as follows:

# A match is divided into two halves: first half (00:00-45:00 minutes) and second
# half (45:01-90:00 minutes)

# The dominance score is calculated based on successful and intercepted passes:
# When pass_to is a player from the same team: +1 point
# When pass_to is a player from the opposing team (interception): -1 point
# A higher dominance score indicates better passing performance

# Return the result table ordered by team_name and half_number in ascending order.

# Teams table:
# +------------+-----------+
# | player_id  | team_name |
# +------------+-----------+
# | 1          | Arsenal   |
# | 2          | Arsenal   |
# | 3          | Arsenal   |
# | 4          | Chelsea   |
# | 5          | Chelsea   |
# | 6          | Chelsea   |
# +------------+-----------+
# Passes table:
# +-----------+------------+---------+
# | pass_from | time_stamp | pass_to |
# +-----------+------------+---------+
# | 1         | 00:15      | 2       |
# | 2         | 00:45      | 3       |
# | 3         | 01:15      | 1       |
# | 4         | 00:30      | 1       |
# | 2         | 46:00      | 3       |
# | 3         | 46:15      | 4       |
# | 1         | 46:45      | 2       |
# | 5         | 46:30      | 6       |
# +-----------+------------+---------+
# Output:
# +-----------+-------------+-----------+
# | team_name | half_number | dominance |
# +-----------+-------------+-----------+
# | Arsenal   | 1           | 3         |
# | Arsenal   | 2           | 1         |
# | Chelsea   | 1           | -1        |
# | Chelsea   | 2           | 1         |
# +-----------+-------------+-----------+

import pandas as pd
import numpy as np
pd.set_option('display.max_columns', None)
# Teams table
teams = pd.DataFrame({
    "player_id": [1, 2, 3, 4, 5, 6],
    "team_name": ["Arsenal", "Arsenal", "Arsenal", "Chelsea", "Chelsea", "Chelsea"]
})

# Passes table
passes = pd.DataFrame({
    "pass_from": [1, 2, 3, 4, 2, 3, 1, 5],
    "time_stamp": ["00:15", "00:45", "01:15", "00:30", "46:00", "46:15", "46:45", "46:30"],
    "pass_to": [2, 3, 1, 1, 3, 4, 2, 6]
})

df_merged = (
    passes
    .assign(time_stamp = pd.to_timedelta("00:" + passes["time_stamp"]))
    .merge(teams, left_on='pass_from', right_on='player_id', suffixes=("_from","_from"))
    .merge(teams, left_on='pass_to', right_on='player_id', suffixes=("_from","_to"))
    .assign(
        half_number = lambda d: np.where(
            d['time_stamp'] <= pd.to_timedelta("00:45:00"),1, 2),
        dominance = lambda d: np.where(d['team_name_from'] != d['team_name_to'],-1,1)
    )
    .groupby(['team_name_from','half_number'], as_index= False)['dominance']
    .sum()
    .rename(columns = {'team_name_from':'team_name'})
)
print(df_merged)