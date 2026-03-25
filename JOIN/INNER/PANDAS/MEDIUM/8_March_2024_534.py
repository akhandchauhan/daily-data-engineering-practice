# -- 534. Game Play Analysis III
# -- Description
# -- Table: Activity
# -- +--------------+---------+
# -- | Column Name  | Type    |
# -- +--------------+---------+
# -- | player_id    | int     |
# -- | device_id    | int     |
# -- | event_date   | date    |
# -- | games_played | int     |
# -- +--------------+---------+
# -- (player_id, event_date) is the primary key (column with unique values) of this table.
# -- This table shows the activity of players of some games.
# -- Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out 
# --on someday using some device.
# -- Write a solution to report for each player and date, how many games played so far by the player.
# -- That is, the total number of games played by the player until that date. Check the example for clarity.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Activity table:
# -- +-----------+-----------+------------+--------------+
# -- | player_id | device_id | event_date | games_played |
# -- +-----------+-----------+------------+--------------+
# -- | 1         | 2         | 2016-03-01 | 5            |
# -- | 1         | 2         | 2016-05-02 | 6            |
# -- | 1         | 3         | 2017-06-25 | 1            |
# -- | 3         | 1         | 2016-03-02 | 0            |
# -- | 3         | 4         | 2018-07-03 | 5            |
# -- +-----------+-----------+------------+--------------+
# -- Output: 
# -- +-----------+------------+---------------------+
# -- | player_id | event_date | games_played_so_far |
# -- +-----------+------------+---------------------+
# -- | 1         | 2016-03-01 | 5                   |
# -- | 1         | 2016-05-02 | 11                  |
# -- | 1         | 2017-06-25 | 12                  |
# -- | 3         | 2016-03-02 | 0                   |
# -- | 3         | 2018-07-03 | 5                   |
# -- +-----------+------------+---------------------+
# -- Explanation: 
# -- For the player with id 1, 5 + 6 = 11 games played by 2016-05-02, and 5 + 6 + 1 = 12 games
# played by 2017-06-25.
# -- For the player with id 3, 0 + 5 = 5 games played by 2018-07-03.
# -- Note that for each player we only care about the days when the player logged in.


# import pandas as pd

# data = {
#     'player_id': [1, 1, 1, 3, 3],
#     'device_id': [2, 2, 3, 1, 4],
#     'event_date': ['2016-03-01', '2016-05-02', '2017-06-25', '2016-03-02', '2018-07-03'],
#     'games_played': [5, 6, 1, 0, 5]
# }

# df = pd.DataFrame(data)
# df['event_date'] = pd.to_datetime(df['event_date'])



# m1 using cumsum

# df['games_played_so_far'] = df.groupby('player_id')['games_played'].transform('cumsum')
# df = df[['player_id','event_date','games_played_so_far']]
# print(df)


# m2 using self join
# df = df.merge(df,on='player_id',how ='inner')
# df = df.query('event_date_x >= event_date_y')
# df['games_played_so_far'] = df.groupby(['player_id','event_date_x'])['games_played_y'].transform('cumsum')
# df = df.groupby(['player_id','event_date_x'])['games_played_so_far'].last()
# print(df)


# using gpt


# result = (
#     df.merge(df, on='player_id', how='inner')
#     .query('event_date_x >= event_date_y')
#     .groupby(['player_id', 'event_date_x'])['games_played_y']
#     .sum()
#     .reset_index()
#     .rename(columns={'event_date_x': 'event_date', 'games_played_y': 'games_played_so_far'})
#     .sort_values(by=['player_id', 'event_date'])
# )

# print(result)