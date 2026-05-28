# 1841. League Statistics
# Description
# Table: Teams
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | team_id        | int     |
# | team_name      | varchar |
# +----------------+---------+
# team_id is the column with unique values for this table.
# Each row contains information about one team in the league.
# Table: Matches
# +-----------------+---------+
# | Column Name     | Type    |
# +-----------------+---------+
# | home_team_id    | int     |
# | away_team_id    | int     |
# | home_team_goals | int     |
# | away_team_goals | int     |
# +-----------------+---------+
# (home_team_id, away_team_id) is the primary key (combination of columns with unique values) for this table.
# Each row contains information about one match.
# home_team_goals is the number of goals scored by the home team.
# away_team_goals is the number of goals scored by the away team.
# The winner of the match is the team with the higher number of goals.

# Write a solution to report the  statistics of the league. The statistics
# should be built using the played matches where the winning team gets three points and 
# the losing team gets no points.
#  If a match ends with a draw, both teams get one point.
# Each row of the result table should contain:

# team_name - The name of the team in the Teams table.
# matches_played - The number of matches played as either a home or away team.
# points - The total points the team has so far.
# goal_for - The total number of goals scored by the team across all matches.
# goal_against - The total number of goals scored by opponent teams against this team
# - across all matches.
# goal_diff - The result of goal_for - goal_against.

# Return the result table ordered by points in descending order. If two or more teams 
# have the same points, order them by goal_diff in descending order. 
# If there is still a tie, order them by team_name in lexicographical order.
# The result format is in the following example.
# Example 1:
# Input: 
# Teams table:
# +---------+-----------+
# | team_id | team_name |
# +---------+-----------+
# | 1       | Ajax      |
# | 4       | Dortmund  |
# | 6       | Arsenal   |
# +---------+-----------+
# Matches table:
# +--------------+--------------+-----------------+-----------------+
# | home_team_id | away_team_id | home_team_goals | away_team_goals |
# +--------------+--------------+-----------------+-----------------+
# | 1            | 4            | 0               | 1               |
# | 1            | 6            | 3               | 3               |
# | 4            | 1            | 5               | 2               |
# | 6            | 1            | 0               | 0               |
# +--------------+--------------+-----------------+-----------------+
# Output: 
# +-----------+----------------+--------+----------+--------------+-----------+
# | team_name | matches_played | points | goal_for | goal_against | goal_diff |
# +-----------+----------------+--------+----------+--------------+-----------+
# | Dortmund  | 2              | 6      | 6        | 2            | 4         |
# | Arsenal   | 2              | 2      | 3        | 3            | 0         |
# | Ajax      | 4              | 2      | 5        | 9            | -4        |
# +-----------+----------------+--------+----------+--------------+-----------+
# Explanation: 
# Ajax (team_id=1) played 4 matches: 2 losses and 2 draws. Total points = 0 + 0 + 1 + 1 = 2.
# Dortmund (team_id=4) played 2 matches: 2 wins. Total points = 3 + 3 = 6.
# Arsenal (team_id=6) played 2 matches: 2 draws. Total points = 1 + 1 = 2.
# Dortmund is the first team in the table. Ajax and Arsenal have the same points, but since Arsenal has a 


import pandas as pd
import numpy as np
pd.set_option('display.max_columns', None)
teams = pd.DataFrame({
    'team_id': [1, 4, 6],
    'team_name': ['Ajax', 'Dortmund', 'Arsenal']
})

matches = pd.DataFrame({
    'home_team_id': [1, 1, 4, 6],
    'away_team_id': [4, 6, 1, 1],
    'home_team_goals': [0, 3, 5, 0],
    'away_team_goals': [1, 3, 2, 0]
})

home_team_df = matches.copy()

# home team df
home_team_df['points'] = np.select(
    [home_team_df['home_team_goals'] > home_team_df['away_team_goals'],home_team_df['home_team_goals'] == home_team_df['away_team_goals']],
    [3,1],
    default= 0 
)
home_team_df = (
            home_team_df.rename(columns = {'home_team_id' : 'team_id'})
            [['team_id','points','home_team_goals','away_team_goals']]
)

# away team df
away_team_df = matches.copy()
away_team_df['points'] = np.select(
    [away_team_df['home_team_goals'] < away_team_df['away_team_goals'],away_team_df['home_team_goals'] == away_team_df['away_team_goals']],
    [3,1],
    default= 0 
)
away_team_df = (
                away_team_df.rename(columns = {'away_team_id':'team_id',
                                               'home_team_goals':'away_team_goals',
                                               'away_team_goals' : 'home_team_goals'})
                [['team_id','points','home_team_goals','away_team_goals']]
)

union_df = pd.concat([home_team_df, away_team_df])

agg_df = (
    union_df.groupby(['team_id'], as_index = False)
    .agg(
        matches_played = ('team_id','count'),
        points = ('points', 'sum'), 
        goal_for = ('home_team_goals','sum'),
        goal_against = ('away_team_goals','sum')
    )
    .assign(
        goal_diff = lambda d: d['goal_for'] - d['goal_against']
    )
)

merged_df = (
    teams.merge(agg_df, how ='left', on = 'team_id')
    [['team_name','matches_played','points','goal_for','goal_against','goal_diff']]
    .fillna(0)
    .sort_values(by = ['points','goal_diff','team_name'],
                 ascending= [False, False, True])
)
print(merged_df)
