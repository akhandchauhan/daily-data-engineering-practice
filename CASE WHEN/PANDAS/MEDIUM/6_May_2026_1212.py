# 1212. Team Scores in Football Tournament 

# Table: Teams
# +--------------+----------+
# | Column Name   | Type     |
# +---------------+----------+
# | team_id       | int      |
# | team_name     | varchar  |
# +---------------+----------+
# team_id is the column with unique values of this table.
# Each row of this table represents a single football team.
 
# Table: Matches
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | match_id      | int     |
# | host_team     | int     |
# | guest_team    | int     | 
# | host_goals    | int     |
# | guest_goals   | int     |
# +---------------+---------+
# match_id is the column of unique values of this table.
# Each row is a record of a finished match between two different teams. 
# Teams host_team and guest_team are represented by their IDs in the 
# Teams table (team_id), and they scored host_goals and guest_goals goals, respectively.
 
# You would like to compute the scores of all teams after all matches. Points are awarded as follows:
# A team receives three points if they win a match (i.e., Scored more goals than the opponent team).
# A team receives one point if they draw a match (i.e., Scored the same number of goals as the
# opponent team).
# A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).

# Write a solution that selects the team_id, team_name and num_points of each team in 
# the tournament after all described matches.

# Return the result table ordered by num_points in decreasing order. In case of a tie, 
# order the records by team_id in increasing order.

# Input: 
# Teams table:
# +-----------+--------------+
# | team_id   | team_name    |
# +-----------+--------------+
# | 10        | Leetcode FC  |
# | 20        | NewYork FC   |
# | 30        | Atlanta FC   |
# | 40        | Chicago FC   |
# | 50        | Toronto FC   |
# +-----------+--------------+
# Matches table:
# +------------+--------------+---------------+-------------+--------------+
# | match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
# +------------+--------------+---------------+-------------+--------------+
# | 1          | 10           | 20            | 3           | 0            |
# | 2          | 30           | 10            | 2           | 2            |
# | 3          | 10           | 50            | 5           | 1            |
# | 4          | 20           | 30            | 1           | 0            |
# | 5          | 50           | 30            | 1           | 0            |
# +------------+--------------+---------------+-------------+--------------+
# Output: 
# +------------+--------------+---------------+
# | team_id    | team_name    | num_points    |
# +------------+--------------+---------------+
# | 10         | Leetcode FC  | 7             |
# | 20         | NewYork FC   | 3             |
# | 50         | Toronto FC   | 3             |
# | 30         | Atlanta FC   | 1             |
# | 40         | Chicago FC   | 0             |
# +------------+--------------+---------------+

import pandas as pd
import numpy as np

teams = pd.DataFrame({
    "team_id": [10, 20, 30, 40, 50],
    "team_name": ["Leetcode FC", "NewYork FC", "Atlanta FC", "Chicago FC", "Toronto FC"]
})
         
matches = pd.DataFrame({
    "match_id": [1, 2, 3, 4, 5],
    "host_team": [10, 30, 10, 20, 50],
    "guest_team": [20, 10, 50, 30, 30],
    "host_goals": [3, 2, 5, 1, 1],
    "guest_goals": [0, 2, 1, 0, 0]
})

# m1 not working overcomplicated
# matches_df = matches.copy()

# matches_df['winner_team_id'] = np.select(
#     [matches_df['host_goals'] > matches_df['guest_goals'],matches_df['host_goals'] < matches_df['guest_goals'] ],
#     [matches_df['host_team'],matches_df['guest_goals']],
#     default = None
# )
# matches_df['draw'] = np.where(matches_df['host_goals'] == matches_df['guest_goals'],[matches_df['host_team'],matches_df['guest_team']],None)
# print(matches_df)


############################################################################################################################
# m2 individual scores

matches_df = matches.copy()

matches_df['host_goals_scores'] = np.select(
    [matches_df['host_goals'] > matches_df['guest_goals'],matches_df['host_goals'] == matches_df['guest_goals']],
    [3,1],
    default = 0
)

matches_df['guest_goals_scores'] = np.select(
    [matches_df['host_goals'] < matches_df['guest_goals'],matches_df['host_goals'] == matches_df['guest_goals']],
    [3,1],
    default = 0
)

host_df = matches_df[['host_team','host_goals_scores']].rename(
            columns  = {'host_team':'team_id', 'host_goals_scores':'scores'}
)

guest_df = matches_df[['guest_team','guest_goals_scores']].rename(
            columns  = {'guest_team':'team_id', 'guest_goals_scores':'scores'}
)

df = pd.concat([host_df,guest_df])

df_agg = (
    df.groupby("team_id", as_index = False)['scores']
    .sum()
    .rename(columns = {'scores':'num_points'})
)

df_merged = (
    teams.merge(df_agg, how = 'left', on = 'team_id')
    .fillna(0)
    .sort_values(by = ['num_points','team_id'], ascending= [False,True])
    [['team_id','team_name','num_points']]
    
)
print(df_merged)