# -- 1445. Apples & Oranges
# -- Description
# -- Table: Sales
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | sale_date     | date    |
# -- | fruit         | enum    | 
# -- | sold_num      | int     | 
# -- +---------------+---------+
# -- (sale_date, fruit) is the primary key (combination of columns with unique values) of this table.
# -- This table contains the sales of "apples" and "oranges" sold each day.
# -- Write a solution to report the difference between the number of  apples and  oranges sold each day.
# -- Return the result table ordered by sale_date.
# -- Inpt: 
# -- Sales table:
# -- +------------+------------+-------------+
# -- | sale_date  | fruit      | sold_num    |
# -- +------------+------------+-------------+
# -- | 2020-05-01 | apples     | 10          |
# -- | 2020-05-01 | oranges    | 8           |
# -- | 2020-05-02 | apples     | 15          |
# -- | 2020-05-02 | oranges    | 15          |
# -- | 2020-05-03 | apples     | 20          |
# -- | 2020-05-03 | oranges    | 0           |
# -- | 2020-05-04 | apples     | 15          |
# -- | 2020-05-04 | oranges    | 16          |
# -- +------------+------------+-------------+
# -- Output: 
# -- +------------+--------------+
# -- | sale_date  | diff         |
# -- +------------+--------------+
# -- | 2020-05-01 | 2            |
# -- | 2020-05-02 | 0            |
# -- | 2020-05-03 | 20           |
# -- | 2020-05-04 | -1           |
# -- +------------+--------------+
# -- Explanation: 
# -- Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
# -- Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
# -- Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
# -- Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).
import pandas as pd

data = {
    'sale_date': ['2020-05-01', '2020-05-01', '2020-05-02', '2020-05-02', '2020-05-03', '2020-05-03', '2020-05-04', '2020-05-04'],
    'fruit': ['apples', 'oranges', 'apples', 'oranges', 'apples', 'oranges', 'apples', 'oranges'],
    'sold_num': [10, 8, 15, 15, 20, 0, 15, 16]
}
df = pd.DataFrame(data)

df_pivot = df.pivot(index = 'sale_date', columns = 'fruit',values = 'sold_num').reset_index()
df_pivot['diff'] = df_pivot['apples'] - df_pivot['oranges']
print(df_pivot[['sale_date','diff']])