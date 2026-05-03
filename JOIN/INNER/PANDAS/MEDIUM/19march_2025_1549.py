# -- 1459. Rectangles Area
# -- Description
# -- Table: Points
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | id            | int     |
# -- | x_value       | int     |
# -- | y_value       | int     |
# -- +---------------+---------+
# -- id is the column with unique values for this table.
# -- Each point is represented as a 2D coordinate (x_value, y_value).
# -- Write a solution to report all possible axis-aligned rectangles with a non-zero area 
# -- that can be formed by any two points from the Points table.
# -- Each row in the result should contain three columns (p1, p2, area) where:
# -- p1 and p2 are the id's of the two points that determine the opposite corners of a rectangle.
# -- area is the area of the rectangle and must be non-zero.
# -- Return the result table ordered by area in descending order. If there is a tie, order them by
# -- p1 in ascending order.
# -- If there is still a tie, order them by p2 in ascending order.
# -- The result format is in the following table.
# -- Example 1:
# -- Input: 
# -- Points table:
# -- +----------+-------------+-------------+
# -- | id       | x_value     | y_value     |
# -- +----------+-------------+-------------+
# -- | 1        | 2           | 7           |
# -- | 2        | 4           | 8           |
# -- | 3        | 2           | 10          |
# -- +----------+-------------+-------------+
# -- Output: 
# -- +----------+-------------+-------------+
# -- | p1       | p2          | area        |
# -- +----------+-------------+-------------+
# -- | 2        | 3           | 4           |
# -- | 1        | 2           | 2           |
# -- +----------+-------------+-------------+
# -- Explanation: 
# -- The rectangle formed by p1 = 2 and p2 = 3 has an area equal to |4-2| * |8-10| = 4.
# -- The rectangle formed by p1 = 1 and p2 = 2 has an area equal to |2-4| * |7-8| = 2.
# -- Note that the rectangle formed by p1 = 1 and p2 = 3 is invalid because the area is 0.


import pandas as pd
data = {
    'id': [1, 2, 3],
    'x_value': [2, 4, 2],
    'y_value': [7, 8, 10]
}
points_df = pd.DataFrame(data)
df = pd.merge(points_df,points_df, how ='cross')
df = df.query('x_value_x != x_value_y and y_value_x != y_value_y and id_x < id_y')
df['area'] = abs(df['x_value_x'] - df['x_value_y']) * abs(df['y_value_x'] - df['y_value_y'])
df = df.rename(columns ={'id_x':'p1','id_y':'p2'})
df = df.sort_values(by =['area','p1','p2'], ascending= [False,True,True])
df =df[['p1','p2','area']]
print(df)