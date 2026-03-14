# -- 2159. Order Two Columns Independently
# -- Description
# -- Table: Data
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | first_col   | int  |
# -- | second_col  | int  |
# -- +-------------+------+
# -- There is no primary key for this table and it may contain duplicates.
# -- Write an SQL query to independently:
# -- order first_col in ascending order.
# -- order second_col in descending order.
# -- The query result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Data table:
# -- +-----------+------------+
# -- | first_col | second_col |
# -- +-----------+------------+
# -- | 4         | 2          |
# -- | 2         | 3          |
# -- | 3         | 1          |
# -- | 1         | 4          |
# -- +-----------+------------+
# -- Output: 
# -- +-----------+------------+
# -- | first_col | second_col |
# -- +-----------+------------+
# -- | 1         | 4          |
# -- | 2         | 3          |
# -- | 3         | 2          |
# -- | 4         | 1          |
# -- +-----------+------------+


import pandas as pd

data = {
    'first_col': [4, 2, 3, 1],
    'second_col': [2, 3, 1, 4]
}

df = pd.DataFrame(data)

df_first = (
    df[['first_col']]
    .sort_values('first_col')
    .reset_index(drop=True)
)

df_first['row_num'] = range(1, len(df_first) + 1)

df_second = (
    df[['second_col']]
    .sort_values('second_col', ascending=False)
    .reset_index(drop=True)
)

df_second['row_num'] = range(1, len(df_second) + 1)

result = (
    df_first
    .merge(df_second, on='row_num')
    .drop(columns='row_num')
)

print(result)

