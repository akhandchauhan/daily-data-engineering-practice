# -- 1468. Calculate Salaries
# -- Description
# -- Table Salaries:
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | company_id    | int     |
# -- | employee_id   | int     |
# -- | employee_name | varchar |
# -- | salary        | int     |
# -- +---------------+---------+
# -- In SQL,(company_id, employee_id) is the primary key for this table.
# -- This table contains the company id, the id, the name, and the salary for an employee.
# -- Find the salaries of the employees after applying taxes. Round the salary to the nearest integer.
# -- The tax rate is calculated for each company based on the following criteria:

# -- 0% If the max salary of any employee in the company is less than $1000.
# -- 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
# -- 49% If the max salary of any employee in the company is greater than $10000.
# -- Return the result table in any order.
# -- The result format is in the following example.

# -- Example 1:
# -- Input: 
# -- Salaries table:
# -- +------------+-------------+---------------+--------+
# -- | company_id | employee_id | employee_name | salary |
# -- +------------+-------------+---------------+--------+
# -- | 1          | 1           | Tony          | 2000   |
# -- | 1          | 2           | Pronub        | 21300  |
# -- | 1          | 3           | Tyrrox        | 10800  |
# -- | 2          | 1           | Pam           | 300    |
# -- | 2          | 7           | Bassem        | 450    |
# -- | 2          | 9           | Hermione      | 700    |
# -- | 3          | 7           | Bocaben       | 100    |
# -- | 3          | 2           | Ognjen        | 2200   |
# -- | 3          | 13          | Nyancat       | 3300   |
# -- | 3          | 15          | Morninngcat   | 7777   |
# -- +------------+-------------+---------------+--------+
# -- Output: 
# -- +------------+-------------+---------------+--------+
# -- | company_id | employee_id | employee_name | salary |
# -- +------------+-------------+---------------+--------+
# -- | 1          | 1           | Tony          | 1020   |
# -- | 1          | 2           | Pronub        | 10863  |
# -- | 1          | 3           | Tyrrox        | 5508   |
# -- | 2          | 1           | Pam           | 300    |
# -- | 2          | 7           | Bassem        | 450    |
# -- | 2          | 9           | Hermione      | 700    |
# -- | 3          | 7           | Bocaben       | 76     |
# -- | 3          | 2           | Ognjen        | 1672   |
# -- | 3          | 13          | Nyancat       | 2508   |
# -- | 3          | 15          | Morninngcat   | 5911   |
# -- +------------+-------------+---------------+--------+

# import pandas as pd

# data = {
#     "company_id": [1, 1, 1, 2, 2, 2, 3, 3, 3, 3],
#     "employee_id": [1, 2, 3, 1, 7, 9, 7, 2, 13, 15],
#     "employee_name": ["Tony", "Pronub", "Tyrrox", "Pam", "Bassem", "Hermione", "Bocaben", "Ognjen", "Nyancat", "Morninngcat"],
#     "salary": [2000, 21300, 10800, 300, 450, 700, 100, 2200, 3300, 7777]
# }
# def checksal(maxi,salary):
#     if maxi >= 1000 and maxi <=10000:
#         salary = salary - (0.24*salary)
#     elif maxi > 10000:
#         salary = salary - (0.49*salary)
#     return round(salary)
    
# df = pd.DataFrame(data)
# df['maxi'] = df.groupby('company_id')['salary'].transform('max')
# df['salary'] = df.apply(lambda x :checksal(x['maxi'],x['salary']),axis = 1)
# df = df.drop(columns = ['maxi'])
#print(df)


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

##############################################################################################################

# -- 1294. Weather Type in Each Country
# -- Description
# -- Table: Countries
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | country_id    | int     |
# -- | country_name  | varchar |
# -- +---------------+---------+
# -- country_id is the primary key (column with unique values) for this table.
# -- Each row of this table contains the ID and the name of one country.
# -- Table: Weather
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | country_id    | int  |
# -- | weather_state | int  |
# -- | day           | date |
# -- +---------------+------+
# -- (country_id, day) is the primary key (combination of columns with unique values) for this table.
# -- Each row of this table indicates the weather state in a country for one day.
# -- Write a solution to find the type of weather in each country for November 2019.
# -- The type of weather is:
# -- Cold if the average weather_state is less than or equal 15,
# -- Hot if the average weather_state is greater than or equal to 25, and
# -- Warm otherwise.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Countries table:
# -- +------------+--------------+
# -- | country_id | country_name |
# -- +------------+--------------+
# -- | 2          | USA          |
# -- | 3          | Australia    |
# -- | 7          | Peru         |
# -- | 5          | China        |
# -- | 8          | Morocco      |
# -- | 9          | Spain        |
# -- +------------+--------------+
# -- Weather table:
# -- +------------+---------------+------------+
# -- | country_id | weather_state | day        |
# -- +------------+---------------+------------+
# -- | 2          | 15            | 2019-11-01 |
# -- | 2          | 12            | 2019-10-28 |
# -- | 2          | 12            | 2019-10-27 |
# -- | 3          | -2            | 2019-11-10 |
# -- | 3          | 0             | 2019-11-11 |
# -- | 3          | 3             | 2019-11-12 |
# -- | 5          | 16            | 2019-11-07 |
# -- | 5          | 18            | 2019-11-09 |
# -- | 5          | 21            | 2019-11-23 |
# -- | 7          | 25            | 2019-11-28 |
# -- | 7          | 22            | 2019-12-01 |
# -- | 7          | 20            | 2019-12-02 |
# -- | 8          | 25            | 2019-11-05 |
# -- | 8          | 27            | 2019-11-15 |
# -- | 8          | 31            | 2019-11-25 |
# -- | 9          | 7             | 2019-10-23 |
# -- | 9          | 3             | 2019-12-23 |
# -- +------------+---------------+------------+
# -- Output: 
# -- +--------------+--------------+
# -- | country_name | weather_type |
# -- +--------------+--------------+
# -- | USA          | Cold         |
# -- | Australia    | Cold         |
# -- | Peru         | Hot          |
# -- | Morocco      | Hot          |
# -- | China        | Warm         |
# -- +--------------+--------------+
# -- Explanation: 
# -- Average weather_state in USA in November is (15) / 1 = 15 so weather type is Cold.
# -- Average weather_state in Austraila in November is (-2 + 0 + 3) / 3 = 0.333 so weather type is Cold.
# -- Average weather_state in Peru in November is (25) / 1 = 25 so the weather type is Hot.
# -- Average weather_state in China in November is (16 + 18 + 21) / 3 = 18.333 so weather type is Warm.
# -- Average weather_state in Morocco in November is (25 + 27 + 31) / 3 = 27.667 so weather type is Hot.
# -- We know nothing about the average weather_state in Spain in November so we do not include it in the result table.

#country_weather_info = country_weather_info.apply(country_name,)

import pandas as pd
import datetime as dt
# Creating Countries DataFrame
countries_data = {
    'country_id': [2, 3, 7, 5, 8, 9],
    'country_name': ['USA', 'Australia', 'Peru', 'China', 'Morocco', 'Spain']
}
countries_df = pd.DataFrame(countries_data)

# Creating Weather DataFrame
weather_data = {
    'country_id': [2, 2, 2, 3, 3, 3, 5, 5, 5, 7, 7, 7, 8, 8, 8, 9, 9],
    'weather_state': [15, 12, 12, -2, 0, 3, 16, 18, 21, 25, 22, 20, 25, 27, 31, 7, 3],
    'day': [
        '2019-11-01', '2019-10-28', '2019-10-27', '2019-11-10', '2019-11-11', '2019-11-12',
        '2019-11-07', '2019-11-09', '2019-11-23', '2019-11-28', '2019-12-01', '2019-12-02',
        '2019-11-05', '2019-11-15', '2019-11-25', '2019-10-23', '2019-12-23'
    ]
}
weather_df = pd.DataFrame(weather_data)
weather_df['day'] = pd.to_datetime(weather_df['day'])

def check(weather_avg):
    if weather_avg <= 15:
        return 'Cold'
    elif weather_avg >= 25:
        return 'Hot'
    else:
        return 'Warm'
    
df = pd.merge(weather_df,countries_df,on='country_id',how = 'inner')
df['day_yr'] =df['day'].dt.year
df['day_month'] = df['day'].dt.month
df = df.query("day_yr == 2019 and day_month == 11")
df_avg = df.groupby('country_name')['weather_state'].mean().reset_index()
df_avg['weather_type'] = df_avg['weather_state'].apply(check)
df_avg = df_avg[['country_name', 'weather_type']]
print(df_avg)




#m2 

# country_weather_info = pd.merge(countries_df, weather_df, on = 'country_id', how ='left')
# country_weather_info['day'] = pd.to_datetime(country_weather_info['day'])
# country_weather_info = country_weather_info[(country_weather_info['day'].dt.year == 2019) & (country_weather_info['day'].dt.month == 11)]
# country_weather_info = country_weather_info.groupby('country_name')['weather_state'].mean().reset_index()
# print(country_weather_info)