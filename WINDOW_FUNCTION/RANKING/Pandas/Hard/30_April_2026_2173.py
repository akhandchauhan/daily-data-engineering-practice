# 2173. Longest Winning Streak
# Description
# Table: Matches
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | player_id   | int  |
# | match_day   | date |
# | result      | enum |
# +-------------+------+
# (player_id, match_day) is the primary key for this table.
# Each row of this table contains the ID of a player, the day of the match they 
# played, and the result of that match.
# The result column is an ENUM type of ('Win', 'Draw', 'Lose').
# The winning streak of a player is the number of consecutive wins uninterrupted
#  by draws or losses.
# Write an  SQL query to count the longest winning streak for each player.
# Return the result table in any order.
# Input: 
# Matches table:
# +-----------+------------+--------+
# | player_id | match_day  | result |
# +-----------+------------+--------+
# | 1         | 2022-01-17 | Win    | 
# | 1         | 2022-01-18 | Win    |
# | 1         | 2022-01-25 | Win    |
# | 1         | 2022-01-31 | Draw   |
# | 1         | 2022-02-08 | Win    |
# | 2         | 2022-02-06 | Lose   |
# | 2         | 2022-02-08 | Lose   |
# | 3         | 2022-03-30 | Win    |
# +-----------+------------+--------+

# Output: 
# +-----------+----------------+
# | player_id | longest_streak |
# +-----------+----------------+
# | 1         | 3              |
# | 2         | 0              |
# | 3         | 1              |
# +-----------+----------------+
# Explanation: 
# Player 1:
# From 2022-01-17 to 2022-01-25, player 1 won 3 consecutive matches.
# On 2022-01-31, player 1 had a draw.
# On 2022-02-08, player 1 won a match.
# The longest winning streak was 3 matches.
# Player 2:
# From 2022-02-06 to 2022-02-08, player 2 lost 2 consecutive matches.
# The longest winning streak was 0 matches.
# Player 3:
# On 2022-03-30, player 3 won a match.
# The longest winning streak was 1 match.

import pandas as pd

matches = pd.DataFrame({
    'player_id': [1, 1, 1, 1, 1, 2, 2, 3],
    'match_day': [
        '2022-01-17', '2022-01-18', '2022-01-25',
        '2022-01-31', '2022-02-08',
        '2022-02-06', '2022-02-08',
        '2022-03-30'
    ],
    'result': ['Win', 'Win', 'Win', 'Draw', 'Win', 'Lose', 'Lose', 'Win']
})

matches['match_day'] = pd.to_datetime(matches['match_day'])

match_df = matches.copy()

match_df = match_df.sort_values(['player_id','match_day'])

match_df['overall_seq'] = match_df.groupby('player_id').cumcount()+1
match_df['result_seq'] = match_df.groupby(['player_id','result']).cumcount() + 1

match_df['diff'] = match_df['overall_seq'] - match_df['result_seq']

match_df = (
            match_df[match_df['result'] == 'Win']
            .groupby(['player_id','diff'], as_index = False)
            .size()
            .assign(
                rank = lambda d: 
                    (d.sort_values(['player_id','size'], ascending = [True, False]))
                    .groupby('player_id').cumcount() + 1
            )
            .loc[lambda d: d['rank'] == 1]
            [['player_id','size']]
            .rename(columns = {'size':'longest_streak'})
)

all_players_df = matches[['player_id']].drop_duplicates()

df_merged = (
    all_players_df.merge(match_df, how = 'left', on ='player_id')
    .fillna(0)
)
print(df_merged)