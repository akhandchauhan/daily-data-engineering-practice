# -- 1783. Grand Slam Titles
# -- Level
# -- Medium
# -- Description
# -- Table: Players
# -- +----------------+---------+
# -- | Column Name    | Type    |
# -- +----------------+---------+
# -- | player_id      | int     |
# -- | player_name    | varchar |
# -- +----------------+---------+
# -- player_id is the primary key for this table.
# -- Each row in this table contains the name and the ID of a tennis player.
# -- Table: Championships
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | year          | int     |
# -- | Wimbledon     | int     |
# -- | Fr_open       | int     |
# -- | US_open       | int     |
# -- | Au_open       | int     |
# -- +---------------+---------+
# -- year is the primary key for this table.
# -- Each row of this table containts the IDs of the players who won one each tennis tournament 
# --of the grand slam.
# -- Write an  SQL query to report the number of grand slam tournaments won by each player. 
# --Do not include the players who did not win any tournament.
# -- Return the result table in any order.
# -- The query result format is in the following example:
# -- Players table:
# -- +-----------+-------------+
# -- | player_id | player_name |
# -- +-----------+-------------+
# -- | 1         | Nadal       |
# -- | 2         | Federer     |
# -- | 3         | Novak       |
# -- +-----------+-------------+
# -- Championships table:
# -- +------+-----------+---------+---------+---------+
# -- | year | Wimbledon | Fr_open | US_open | Au_open |
# -- +------+-----------+---------+---------+---------+
# -- | 2018 | 1         | 1       | 1       | 1       |
# -- | 2019 | 1         | 1       | 2       | 2       |
# -- | 2020 | 2         | 1       | 2       | 2       |
# -- +------+-----------+---------+---------+---------+

import pandas as pd

players_data = {
    'player_id': [1, 2, 3],
    'player_name': ['Nadal', 'Federer', 'Novak']
}
players_df = pd.DataFrame(players_data)

championships_data = {
    'year': [2018, 2019, 2020],
    'Wimbledon': [1, 1, 2],
    'Fr_open': [1, 1, 1],
    'US_open': [1, 2, 2],
    'Au_open': [1, 2, 2]
}
championships_df = pd.DataFrame(championships_data)

unpivoted_df = pd.melt(
    championships_df,
    id_vars=['year'],
    value_vars=['Wimbledon', 'Fr_open', 'US_open', 'Au_open'],
    var_name='tournament',
    value_name='player_id'
)

df = pd.merge(unpivoted_df,players_df,on ='player_id',how='left')

df_refined = df.groupby(['player_id', 'player_name']).size().reset_index()
df_refined = df_refined.rename(columns={0: 'grand_slam_count'})

print(df_refined[['player_id', 'player_name', 'grand_slam_count']])




# -- 1308. Running Total for Different Genders
# -- Description
# -- Table: Scores
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | player_name   | varchar |
# -- | gender        | varchar |
# -- | day           | date    |
# -- | score_points  | int     |
# -- +---------------+---------+
# -- (gender, day) is the primary key (combination of columns with unique values) for this table.
# -- A competition is held between the female team and the male team.
# -- Each row of this table indicates that a player_name and with gender has scored score_point in someday.
# -- Gender is 'F' if the player is in the female team and 'M' if the player is in the male team.
# -- Write a solution to find the total score for each gender on each day.
# -- Return the result table ordered by gender and day in ascending order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Scores table:
# -- +-------------+--------+------------+--------------+
# -- | player_name | gender | day        | score_points |
# -- +-------------+--------+------------+--------------+
# -- | Aron        | F      | 2020-01-01 | 17           |
# -- | Alice       | F      | 2020-01-07 | 23           |
# -- | Bajrang     | M      | 2020-01-07 | 7            |
# -- | Khali       | M      | 2019-12-25 | 11           |
# -- | Slaman      | M      | 2019-12-30 | 13           |
# -- | Joe         | M      | 2019-12-31 | 3            |
# -- | Jose        | M      | 2019-12-18 | 2            |
# -- | Priya       | F      | 2019-12-31 | 23           |
# -- | Priyanka    | F      | 2019-12-30 | 17           |
# -- +-------------+--------+------------+--------------+
# -- Output: 
# -- +--------+------------+-------+
# -- | gender | day        | total |
# -- +--------+------------+-------+
# -- | F      | 2019-12-30 | 17    |
# -- | F      | 2019-12-31 | 40    |
# -- | F      | 2020-01-01 | 57    |
# -- | F      | 2020-01-07 | 80    |
# -- | M      | 2019-12-18 | 2     |
# -- | M      | 2019-12-25 | 13    |
# -- | M      | 2019-12-30 | 26    |
# -- | M      | 2019-12-31 | 29    |
# -- | M      | 2020-01-07 | 36    |
# -- +--------+------------+-------+

import pandas as pd

# Create the Scores DataFrame
scores_data = {
    'player_name': ['Aron', 'Alice', 'Bajrang', 'Khali', 'Slaman', 'Joe', 'Jose', 'Priya', 'Priyanka'],
    'gender': ['F', 'F', 'M', 'M', 'M', 'M', 'M', 'F', 'F'],
    'day': ['2020-01-01', '2020-01-07', '2020-01-07', '2019-12-25', '2019-12-30', '2019-12-31', '2019-12-18', '2019-12-31', '2019-12-30'],
    'score_points': [17, 23, 7, 11, 13, 3, 2, 23, 17]
}
scores_df = pd.DataFrame(scores_data)
scores_df['day'] = pd.to_datetime(scores_df['day'])
scores_df['total'] = scores_df.groupby('gender')['score_points'].cumsum()
print(scores_df[['gender', 'day', 'total']].sort_values(by ='gender'))


