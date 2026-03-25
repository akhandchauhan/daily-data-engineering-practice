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


##############################################################################################################

#m2 
# country_weather_info = pd.merge(countries_df, weather_df, on = 'country_id', how ='left')
# country_weather_info['day'] = pd.to_datetime(country_weather_info['day'])
# country_weather_info = country_weather_info[(country_weather_info['day'].dt.year == 2019) & (country_weather_info['day'].dt.month == 11)]
# country_weather_info = country_weather_info.groupby('country_name')['weather_state'].mean().reset_index()
# print(country_weather_info)