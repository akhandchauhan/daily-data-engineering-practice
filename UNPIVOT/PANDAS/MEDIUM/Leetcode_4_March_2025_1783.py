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
# -- Result table:
# -- +-----------+-------------+-------------------+
# -- | player_id | player_name | grand_slams_count |
# -- +-----------+-------------+-------------------+
# -- | 2         | Federer     | 5                 |
# -- | 1         | Nadal       | 7                 |
# -- +-----------+-------------+-------------------+
# -- Player 1 (Nadal) won 7 titles: Wimbledon (2018, 2019), Fr_open (2018, 2019, 2020),
# -- US_open (2018), and Au_open (2018).
# -- Player 2 (Federer) won 5 titles: Wimbledon (2020), US_open (2019, 2020), and Au_open (2019, 2020).
# -- Player 3 (Novak) did not win anything, we did not include them in the result table.

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
df = pd.merge(unpivoted_df,players_df,on ='player_id')

df_refined = df.groupby(['player_id', 'player_name']).size().reset_index()
df_refined = df_refined.rename(columns={0: 'grand_slam_count'})

print(df_refined[['player_id', 'player_name', 'grand_slam_count']])

########################################################################################################

# m2
all_player_info_df = pd.DataFrame({
    'player_id': pd.concat([
        championships_df['Wimbledon'],
        championships_df['Fr_open'],
        championships_df['US_open'],
        championships_df['Au_open']
    ], ignore_index=True)
})

df = (
    all_player_info_df.groupby('player_id', as_index=False)
    .size()
    .merge(players_df,on ='player_id')
    .rename(columns = {'size':'grand_slam_count'})
    [['player_id','player_name',"grand_slam_count"]]
    
)
print(df)