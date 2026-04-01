# 613. Shortest Distance in a Line
# Table point holds the x coordinate of some points on x-axis in a plane, which are all integers.
# Write a query to find the shortest distance between two points in these points.
# | x   |
# |-----|
# | -1  |
# | 0   |
# | 2   |
# The shortest distance is '1' obviously, which is from point '-1' to '0'. So the output is as below:
# | shortest|
# |---------|
# | 1       |
# Note: Every point is unique, which means there is no duplicates in table point.

import pandas as pd

# Creating the DataFrame
data = {'x': [-1, 0, 2]}  # Given points
point = pd.DataFrame(data)

def shortest_distance(point: pd.DataFrame) -> pd.DataFrame:
    merged_df = pd.merge(point, point, how='cross')

    # Compute absolute differences, ignoring same points (where x_x == x_y)
    merged_df = merged_df[merged_df['x_x'] != merged_df['x_y']]
    merged_df['distance'] = abs(merged_df['x_x'] - merged_df['x_y'])

    # Get the shortest distance
    min_distance = merged_df['distance'].min()

    return pd.DataFrame({'shortest': [min_distance]})
    
    
#print(shortest_distance(point))


######################################################################################

# m2 

point_df = (
    point
    .sort_values('x')  
    .assign(
        prev_points=lambda d: d['x'].shift(1)
    )
    .dropna()
    .assign(
        diff=lambda d: d['x'] - d['prev_points']
    )
    ['diff']
    .min()
)
final_df = pd.DataFrame({'shortest': [point_df]})
print(final_df)
