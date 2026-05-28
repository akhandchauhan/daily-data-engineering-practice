# 2339. All the Matches of the League 
# Description
# Table: Teams
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | team_name   | varchar |
# +-------------+---------+
# team_name is the column with unique values of this table.
# Each row of this table shows the name of a team.

# Write a solution to report all the possible matches of the league. 
# Note that every two teams play two matches with each other, with one 
# team being the home_team once and the other time being the away_team.

# Return the result table in any order.

# Input: 
# Teams table:
# +-------------+
# | team_name   |
# +-------------+
# | Leetcode FC |
# | Ahly SC     |
# | Real Madrid |
# +-------------+
# Output: 
# +-------------+-------------+
# | home_team   | away_team   |
# +-------------+-------------+
# | Real Madrid | Leetcode FC |
# | Real Madrid | Ahly SC     |
# | Leetcode FC | Real Madrid |
# | Leetcode FC | Ahly SC     |
# | Ahly SC     | Real Madrid |
# | Ahly SC     | Leetcode FC |
# +-------------+-------------+
# Explanation: All the matches of the league are shown in the table.

import pandas as pd

Teams = pd.DataFrame(
    {'team_name': ['Leetcode FC','Ahly SC','Real Madrid'] }
)

df = (
    Teams.merge(Teams, how = 'cross')
    .rename(columns = {'team_name_x':'home_team', 'team_name_y':'away_team'})
    .loc[lambda d : d['home_team'] != d['away_team']]
)
print(df)