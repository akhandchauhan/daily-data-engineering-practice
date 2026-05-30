# 2978. Symmetric Coordinates

# Table: Coordinates
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | X           | int  |
# | Y           | int  |
# +-------------+------+
# Each row includes X and Y, where both are integers. Table may contain duplicate 
# values.
# Two coordindates (X1, Y1) and (X2, Y2) are said to be symmetric coordintes 
# if X1 == Y2 and X2 == Y1.

# Write a solution that outputs, among all these symmetric coordintes, 
# only those unique coordinates that satisfy the condition X1 <= Y1.

# Return the result table ordered by X and Y (respectively) in ascending order.

# Example 1:

# Coordinates table:
# +----+----+
# | X  | Y  |
# +----+----+
# | 20 | 20 |
# | 20 | 20 |
# | 20 | 21 |
# | 23 | 22 |
# | 22 | 23 |
# | 21 | 20 |
# +----+----+
# Output: 
# +----+----+
# | x  | y  |
# +----+----+
# | 20 | 20 |
# | 20 | 21 |
# | 22 | 23 |
# +----+----+
# Explanation: 
# - (20, 20) and (20, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. 
# This results in displaying (20, 20) as a distinctive coordinates.
# - (20, 21) and (21, 20) are symmetric coordinates because, X1 == Y2 and 
# X2 == Y1. However, only (20, 21) will be displayed because X1 <= Y1.
# - (23, 22) and (22, 23) are symmetric coordinates because, X1 == Y2 and X2 == Y1.
# However, only (22, 23) will be displayed because X1 <= Y1.
# The output table is sorted by X and Y in ascending order.

import pandas as pd

coordinates = pd.DataFrame({
    'X': [20, 20, 20, 23, 22, 21],
    'Y': [20, 20, 21, 22, 23, 20]
})

coordinates_df = coordinates.copy()
coordinates_df['rnk'] = range(1,len(coordinates_df)+1)

c2 = coordinates_df.rename(columns = {'X':'x2', 'Y':'y2'})
df = (
    coordinates_df.merge(c2, left_on = ['X','Y'], right_on = ['y2','x2'])
    
    .loc[lambda d: (d['rnk_x'] != d['rnk_y']) & (d['X'] <= d['Y'])]
    .sort_values(['X','Y'])
    .rename(columns = {'X':'x', 'Y':'y'})
    [['x','y']]
    .drop_duplicates()
)
print(df)