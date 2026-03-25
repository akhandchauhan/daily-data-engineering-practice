# -- 612. Shortest Distance in a Plane
# -- Description
# -- Table: Point2D
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | x           | int  |
# -- | y           | int  |
# -- +-------------+------+
# -- (x, y) is the primary key column (combination of columns with unique values) for this table.
# -- Each row of this table indicates the position of a point on the X-Y plane.
# -- The distance between two points p1(x1, y1) and p2(x2, y2) is sqrt((x2 - x1)2 + (y2 - y1)2).
# -- Write a solution to report the shortest distance between any two points from the Point2D table.
# -- Round the distance to two decimal points.
# -- Input: 
# -- Point2D table:
# -- +----+----+
# -- | x  | y  |
# -- +----+----+
# -- | -1 | -1 |
# -- | 0  | 0  |
# -- | -1 | -2 |
# -- +----+----+
# -- Output: 
# -- +----------+
# -- | shortest |
# -- +----------+
# -- | 1.00     |
# -- +----------+
# -- Explanation: The shortest distance is 1.00 from point (-1, -1) to (-1, 2).

# import pandas as pd
# import numpy as np

# data = {'x': [-1, 0, -1],
#         'y': [-1, 0, -2]}

# df = pd.DataFrame(data)
# df = pd.merge(df, df, how='cross')
# df = df.query('x_x != x_y or y_x != y_y')
# df['dist'] = np.sqrt(np.power(df['x_x'] - df['x_y'], 2) + np.power(df['y_x'] - df['y_y'], 2))

# shortest_distance = df['dist'].min()
# print(f"Shortest distance: {shortest_distance:.2f}")
