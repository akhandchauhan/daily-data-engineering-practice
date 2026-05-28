# 2991. Top Three Wineries 
# Description
# Table: Wineries
# +-------------+----------+
# | Column Name | Type     |
# +-------------+----------+
# | id          | int      |
# | country     | varchar  |
# | points      | int      |
# | winery      | varchar  |
# +-------------+----------+
# id is column of unique values for this table.
# This table contains id, country, points, and winery.

# Write a solution to find the top three wineries in each country based on 
# their total points. If multiple wineries have the same total points, 
# order them by winery name in ascending order. If there's no second winery,
# output 'No Second Winery,' and if there's no third winery, output 'No Third Winery.'
# Return the result table ordered by country in ascending order.
# The result format is in the following example.
 
# Example 1:
# Input: 
# Wineries table:
# +-----+-----------+--------+-----------------+
# | id  | country   | points | winery          | 
# +-----+-----------+--------+-----------------+
# | 103 | Australia | 84     | WhisperingPines | 
# | 737 | Australia | 85     | GrapesGalore    |    
# | 848 | Australia | 100    | HarmonyHill     | 
# | 222 | Hungary   | 60     | MoonlitCellars  | 
# | 116 | USA       | 47     | RoyalVines      | 
# | 124 | USA       | 45     | Eagle'sNest     | 
# | 648 | India     | 69     | SunsetVines     | 
# | 894 | USA       | 39     | RoyalVines      |  
# | 677 | USA       | 9      | PacificCrest    |  
# +-----+-----------+--------+-----------------+
# Output: 
# +-----------+---------------------+-------------------+----------------------+
# | country   | top_winery          | second_winery     | third_winery         |
# +-----------+---------------------+-------------------+----------------------+
# | Australia | HarmonyHill (100)   | GrapesGalore (85) | WhisperingPines (84) |
# | Hungary   | MoonlitCellars (60) | No second winery  | No third winery      | 
# | India     | SunsetVines (69)    | No second winery  | No third winery      |  
# | USA       | RoyalVines (86)     | Eagle'sNest (45)  | PacificCrest (9)     | 
# +-----------+---------------------+-------------------+----------------------+
# Explanation
# For Australia
#  - HarmonyHill Winery accumulates the highest score of 100 points in Australia.
#  - GrapesGalore Winery has a total of 85 points, securing the second-highest position
# in Australia.
#  - WhisperingPines Winery has a total of 80 points, ranking as the third-highest.
# For Hungary
#  - MoonlitCellars is the sole winery, accruing 60 points, automatically making it the
# highest. There is no second or third winery.
# For India
#  - SunsetVines is the sole winery, earning 69 points, making it the top winery.
# There is no second or third winery.
# For the USA
#  - RoyalVines Wines accumulates a total of 47 + 39 = 86 points, claiming the highest
# position in the USA.
#  - Eagle'sNest has a total of 45 points, securing the second-highest position in 
# the USA.
#  - PacificCrest accumulates 9 points, ranking as the third-highest winery in the USA
# Output table is ordered by country in ascending order.


import pandas as pd
import numpy as np


pd.set_option('display.max_rows', None)        # show all rows
pd.set_option('display.max_columns', None)    # show all columns
pd.set_option('display.width', None)          # no line wrap
pd.set_option('display.max_colwidth', None) 

data = {
    "id": [103, 737, 848, 222, 116, 124, 648, 894, 677],
    "country": [
        "Australia", "Australia", "Australia",
        "Hungary",
        "USA", "USA",
        "India",
        "USA", "USA"
    ],
    "points": [84, 85, 100, 60, 47, 45, 69, 39, 9],
    "winery": [
        "WhisperingPines", "GrapesGalore", "HarmonyHill",
        "MoonlitCellars",
        "RoyalVines", "Eagle'sNest",
        "SunsetVines",
        "RoyalVines", "PacificCrest"
    ]
}

wineries_df = pd.DataFrame(data)

df = wineries_df.copy()

# Step 1: Aggregate
df = (
    df.groupby(['country', 'winery'], as_index=False)['points']
    .sum()
    .rename(columns={'points': 'total_points'})
)

# Step 2: Sort properly
df = df.sort_values(
    by=['country', 'total_points', 'winery'],
    ascending=[True, False, True]
)

# Step 3: Rank within country
df['rank'] = df.groupby('country').cumcount() + 1

# Step 4: Keep top 3
df = df[df['rank'] <= 3]

# Step 5: Format string
df['formatted'] = df['winery'] + ' (' + df['total_points'].astype(str) + ')'

# Step 6: Pivot
result = (
    df.pivot(index='country', columns='rank', values='formatted')
    .rename(columns={
        1: 'top_winery',
        2: 'second_winery',
        3: 'third_winery'
    })
    .reset_index()
)

# Step 7: Fill missing
result['second_winery'] = result['second_winery'].fillna('No second winery')
result['third_winery'] = result['third_winery'].fillna('No third winery')

print(result)