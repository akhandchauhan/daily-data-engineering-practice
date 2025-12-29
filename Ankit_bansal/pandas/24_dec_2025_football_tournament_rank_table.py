# Question 1
# In a football tournament, some data is recorded. Every winning team gets a point and the losing team loses a point. 
# At the end of the tournament, a ranking is given to all the teams based on their total points. The total points of a 
# team can be negative.
# You are given two tables: Matches Record and Team Details.
# The ranking should be calculated according to the following rules:
# The total points should be ranked from highest to lowest.
# If two teams have the same total points, then the team with the higher number of winning goals should be ranked higher.

import pandas as pd

data = [
    (1, 1001, 1007, 1),
    (2, 1007, 1001, 2),
    (3, 1006, 1003, 3),
    (4, 1001, 1003, 1),
    (5, 1007, 1001, 1),
    (6, 1006, 1003, 2),
    (7, 1006, 1001, 3),
    (8, 1007, 1003, 5),
    (9, 1001, 1003, 1),
    (10, 1007, 1006, 2),
    (11, 1006, 1003, 3),
    (12, 1001, 1003, 4),
    (13, 1001, 1006, 2),
    (14, 1007, 1001, 4),
    (15, 1006, 1007, 3),
    (16, 1001, 1003, 3),
    (17, 1001, 1007, 3),
    (18, 1006, 1007, 2),
    (19, 1003, 1001, 1),
    (20, 1001, 1007, 3),
    (21, 1001, 1003, 3)
]

df = pd.DataFrame(
    data,
    columns=["match_id", "winning_team_id", "losing_team_id", "goals_won"]
)

print(df)

winning_team = df.rename(columns = {'winning_team_id' :'team_id'})
winning_team['points_scored'] = 1
winning_team = winning_team[['team_id','goals_won','points_scored']]


losing_team = df[['losing_team_id']].rename(columns = {'losing_team_id' :'team_id'})
losing_team['points_scored'] = -1
losing_team['goals_won'] = 0
losing_team = losing_team[['team_id','goals_won','points_scored']]

team_merged = pd.concat([winning_team,losing_team])
team_merged = (team_merged.groupby('team_id')
               .agg(
                   total_goals_won = ('goals_won','sum'),
                   total_points_scored = ('points_scored','sum')
                
               )
               .reset_index())
team_merged = team_merged.sort_values(
    ['total_points_scored', 'total_goals_won'],
    ascending=[False, False]
)

team_merged['rnk'] = team_merged[['total_points_scored','total_goals_won']] \
    .apply(tuple, axis=1) \
    .rank(method='min', ascending=False)
print(team_merged)