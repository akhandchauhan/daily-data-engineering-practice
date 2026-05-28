# 1194. Tournament Winners
# Table: Players
# +-------------+-------+
# | Column Name | Type  |
# +-------------+-------+
# | player_id   | int   |
# | group_id    | int   |
# +-------------+-------+
# player_id is the primary key of this table.
# Each row of this table indicates the group of each player.
# Table: Matches
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | match_id      | int     |
# | first_player  | int     |
# | second_player | int     |
# | first_score   | int     |
# | second_score  | int     |
# +---------------+---------+
# match_id is the primary key of this table.
# Each row is a record of a match, first_player and second_player contain the 
# player_id of each match.
# first_score and second_score contain the number of points of the first_player 
# and second_player respectively.
# You may assume that, in each match, players belongs to the same group.

# The winner in each group is the player who scored the maximum total points 
# within the group.
# In the case of a tie, the lowest player_id wins.
# Write an  SQL query to find the winner in each group.
# Players table:
# +-----------+------------+
# | player_id | group_id   |
# +-----------+------------+
# | 15        | 1          |
# | 25        | 1          |
# | 30        | 1          |
# | 45        | 1          |
# | 10        | 2          |
# | 35        | 2          |
# | 50        | 2          |
# | 20        | 3          |
# | 40        | 3          |
# +-----------+------------+
# Matches table:
# +------------+--------------+---------------+-------------+--------------+
# | match_id   | first_player | second_player | first_score | second_score |
# +------------+--------------+---------------+-------------+--------------+
# | 1          | 15           | 45            | 3           | 0            |
# | 2          | 30           | 25            | 1           | 2            |
# | 3          | 30           | 15            | 2           | 0            |
# | 4          | 40           | 20            | 5           | 2            |
# | 5          | 35           | 50            | 1           | 1            |
# +------------+--------------+---------------+-------------+--------------+
# Result table:
# +-----------+------------+
# | group_id  | player_id  |
# +-----------+------------+
# | 1         | 15         |
# | 2         | 35         |
# | 3         | 40         |
# +-----------+------------+


import pandas as pd

# Players DataFrame
players_df = pd.DataFrame({
    "player_id": [15, 25, 30, 45, 10, 35, 50, 20, 40],
    "group_id":  [1,  1,  1,  1,  2,  2,  2,  3,  3]
})

# Matches DataFrame
matches_df = pd.DataFrame({
    "match_id":     [1, 2, 3, 4, 5],
    "first_player": [15, 30, 30, 40, 35],
    "second_player":[45, 25, 15, 20, 50],
    "first_score":  [3, 1, 2, 5, 1],
    "second_score": [0, 2, 0, 2, 1]
})


first_player_df =(
    matches_df[['match_id','first_player','first_score']]
    .rename(columns = {'first_player':'player_id',
                        'first_score':'score'})
)
second_player_df = (
    matches_df[['match_id','second_player','second_score']]
    .rename(columns = {'second_player':'player_id',
                        'second_score':'score'})
)

merge_matches_df = pd.concat([first_player_df, second_player_df])

df = (
    players_df
    .merge(merge_matches_df, how ='left', on ='player_id')
    .groupby(['group_id', 'player_id'], as_index = False)['score']
    .sum()
    .sort_values(by = ['group_id','score','player_id'],
                 ascending= [True, False, True]
    )
    .assign(
        player_rank = (
            lambda d : d.groupby(['group_id']).cumcount() + 1
        )
    )
    .loc[lambda d: d['player_rank'] == 1]
    [['group_id','player_id']]
    
)
print(df)


#######################################################################################
# m2 

import pandas as pd

# Normalize (UNION ALL equivalent)
scores_df = pd.concat([
    matches_df[['first_player', 'first_score']]
        .rename(columns={'first_player': 'player_id', 'first_score': 'score'}),
    matches_df[['second_player', 'second_score']]
        .rename(columns={'second_player': 'player_id', 'second_score': 'score'})
])

# Compute total score per player (including players with no matches)
df = (
    players_df
    .merge(scores_df, how='left', on='player_id')
    .assign(score=lambda d: d['score'].fillna(0))  # 🔥 explicit handling
    .groupby(['group_id', 'player_id'], as_index=False)['score']
    .sum()
)

# Rank within each group (tie → smaller player_id wins)
result = (
    df.sort_values(['group_id', 'score', 'player_id'], ascending=[True, False, True])
      .assign(rnk=lambda d: d.groupby('group_id').cumcount() + 1)
      .query("rnk == 1")[['group_id', 'player_id']]
)

print(result)


#######################################################################################
# m3

scores_df = pd.concat([
    matches_df[['first_player', 'first_score']]
        .rename(columns={'first_player': 'player_id', 'first_score': 'score'}),
    matches_df[['second_player', 'second_score']]
        .rename(columns={'second_player': 'player_id', 'second_score': 'score'})
])

df = (
    players_df
    .merge(scores_df, how='left', on='player_id')
    .assign(score=lambda d: d['score'].fillna(0))
    .groupby(['group_id', 'player_id'], as_index=False)['score']
    .sum()
)

df = df.sort_values(['group_id','score','player_id'], ascending=[True, False, True])

df['max_score'] = df.groupby('group_id')['score'].transform('max')

result = (
    df[df['score'] == df['max_score']]
    .sort_values(['group_id','player_id'])
    .drop_duplicates('group_id')[['group_id','player_id']]
)