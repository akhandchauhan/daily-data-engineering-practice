# 2377. Sort the Olympic Table

# Table: Olympic
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | country       | varchar |
# | gold_medals   | int     |
# | silver_medals | int     |
# | bronze_medals | int     |
# +---------------+---------+
# country is the primary key for this table.
# Each row in this table shows a country name and the number of gold, silver, and 
# bronze medals it won in the Olympic games.

# The Olympic table is sorted according to the following rules:

# The country with more gold medals comes first.
# If there is a tie in the gold medals, the country with more silver medals comes first.
# If there is a tie in the silver medals, the country with more bronze medals comes first.
# If there is a tie in the bronze medals, the countries with the tie are sorted in 
# ascending order lexicographically.
# Write an  SQL query to sort the Olympic table

# Input: 
# Olympic table:
# +-------------+-------------+---------------+---------------+
# | country     | gold_medals | silver_medals | bronze_medals |
# +-------------+-------------+---------------+---------------+
# | China       | 10          | 10            | 20            |
# | South Sudan | 0           | 0             | 1             |
# | USA         | 10          | 10            | 20            |
# | Israel      | 2           | 2             | 3             |
# | Egypt       | 2           | 2             | 2             |
# +-------------+-------------+---------------+---------------+
# Output: 
# +-------------+-------------+---------------+---------------+
# | country     | gold_medals | silver_medals | bronze_medals |
# +-------------+-------------+---------------+---------------+
# | China       | 10          | 10            | 20            |
# | USA         | 10          | 10            | 20            |
# | Israel      | 2           | 2             | 3             |
# | Egypt       | 2           | 2             | 2             |
# | South Sudan | 0           | 0             | 1             |
# +-------------+-------------+---------------+---------------+
# Explanation: 
# The tie between China and USA is broken by their lexicographical names. Since 
# "China" is lexicographically smaller than "USA", it comes first.
# Israel comes before Egypt because it has more bronze medals.

import pandas as pd
pd.set_option("display.max_columns",None)
olympic_data = {
    'country': ['China', 'South Sudan', 'USA', 'Israel', 'Egypt'],
    'gold_medals': [10, 0, 10, 2, 2],
    'silver_medals': [10, 0, 10, 2, 2],
    'bronze_medals': [20, 1, 20, 3, 2]
}

olympic_df = pd.DataFrame(olympic_data)

df = olympic_df.sort_values(by = ['gold_medals','silver_medals','bronze_medals','country'],
                            ascending= [False, False, False, True])
print(df)