# -- 1421. NPV Queries
# -- Description
# -- Table: NPV
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | id            | int     |
# -- | year          | int     |
# -- | npv           | int     |
# -- +---------------+---------+
# -- (id, year) is the primary key (combination of columns with unique values) of this table.
# -- The table has information about the id and the year of each inventory and the corresponding net present value.
# -- Table: Queries
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | id            | int     |
# -- | year          | int     |
# -- +---------------+---------+
# -- (id, year) is the primary key (combination of columns with unique values) of this table.
# -- The table has information about the id and the year of each inventory query.
# -- Write a solution to find the npv of each query of the Queries table.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- NPV table:
# -- +------+--------+--------+
# -- | id   | year   | npv    |
# -- +------+--------+--------+
# -- | 1    | 2018   | 100    |
# -- | 7    | 2020   | 30     |
# -- | 13   | 2019   | 40     |
# -- | 1    | 2019   | 113    |
# -- | 2    | 2008   | 121    |
# -- | 3    | 2009   | 12     |
# -- | 11   | 2020   | 99     |
# -- | 7    | 2019   | 0      |
# -- +------+--------+--------+
# -- Queries table:
# -- +------+--------+
# -- | id   | year   |
# -- +------+--------+
# -- | 1    | 2019   |
# -- | 2    | 2008   |
# -- | 3    | 2009   |
# -- | 7    | 2018   |
# -- | 7    | 2019   |
# -- | 7    | 2020   |
# -- | 13   | 2019   |
# -- +------+--------+
# -- Output: 
# -- +------+--------+--------+
# -- | id   | year   | npv    |
# -- +------+--------+--------+
# -- | 1    | 2019   | 113    |
# -- | 2    | 2008   | 121    |
# -- | 3    | 2009   | 12     |
# -- | 7    | 2018   | 0      |
# -- | 7    | 2019   | 0      |
# -- | 7    | 2020   | 30     |
# -- | 13   | 2019   | 40     |
# -- +------+--------+--------+
# -- Explanation: 
# -- The npv value of (7, 2018) is not present in the NPV table, we consider it 0.
# -- The npv values of all other queries can be found in the NPV table.


import pandas as pd
npv_data = {
    'id': [1, 7, 13, 1, 2, 3, 11, 7],
    'year': [2018, 2020, 2019, 2019, 2008, 2009, 2020, 2019],
    'npv': [100, 30, 40, 113, 121, 12, 99, 0]
}
npv_df = pd.DataFrame(npv_data)
queries_data = {
    'id': [1, 2, 3, 7, 7, 7, 13],
    'year': [2019, 2008, 2009, 2018, 2019, 2020, 2019]
}
queries_df = pd.DataFrame(queries_data)

# m1 
# df = pd.merge(queries_df, npv_df, how ='left', on =['id','year']).fillna(0)
# print(df)


# m2
df = pd.merge(queries_df,npv_df,on =['id','year'], how ='left')
df['npv'] = df['npv'].fillna(0)
print(df)
