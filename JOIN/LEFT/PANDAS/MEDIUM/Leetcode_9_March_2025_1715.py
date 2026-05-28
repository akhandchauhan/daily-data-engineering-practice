# 1715. Count Apples and Oranges
# -- Level
# -- Medium
# -- Description
# -- Table: Boxes
# -- +--------------+------+
# -- | Column Name  | Type |
# -- +--------------+------+
# -- | box_id       | int  |
# -- | chest_id     | int  |
# -- | apple_count  | int  |
# -- | orange_count | int  |
# -- +--------------+------+
# -- box_id is the primary key for this table.
# -- chest_id is a foreign key of the chests table.
# -- This table contains information about the boxes and the number of oranges and apples they contain.
# -- Each box may contain a chest, which also can contain oranges and apples.
# -- Table: Chests
# -- +--------------+------+
# -- | Column Name  | Type |
# -- +--------------+------+
# -- | chest_id     | int  |
# -- | apple_count  | int  |
# -- | orange_count | int  |
# -- +--------------+------+
# -- chest_id is the primary key for this table.
# -- This table contains information about the chests we have, and the corresponding number if oranges and apples they contain.
# -- Write an  SQL query to count the number of  apples and oranges in all the boxes.
# -- If a box contains a chest, you should also include the number of apples and oranges it has.
# -- Return the result table in any order.
# -- The query result format is in the following example:
# -- Boxes table:
# -- +--------+----------+-------------+--------------+
# -- | box_id | chest_id | apple_count | orange_count |
# -- +--------+----------+-------------+--------------+
# -- | 2      | null     | 6           | 15           |
# -- | 18     | 14       | 4           | 15           |
# -- | 19     | 3        | 8           | 4            |
# -- | 12     | 2        | 19          | 20           |
# -- | 20     | 6        | 12          | 9            |
# -- | 8      | 6        | 9           | 9            |
# -- | 3      | 14       | 16          | 7            |
# -- +--------+----------+-------------+--------------+
# -- Chests table:
# -- +----------+-------------+--------------+
# -- | chest_id | apple_count | orange_count |
# -- +----------+-------------+--------------+
# -- | 6        | 5           | 6            |
# -- | 14       | 20          | 10           |
# -- | 2        | 8           | 8            |
# -- | 3        | 19          | 4            |
# -- | 16       | 19          | 19           |
# -- +----------+-------------+--------------+
# -- Result table:
# -- +-------------+--------------+
# -- | apple_count | orange_count |
# -- +-------------+--------------+
# -- | 151         | 123          |
# -- +-------------+--------------+

import pandas as pd

# Sample data
boxes_data = {
    "box_id": [2, 18, 19, 12, 20, 8, 3],
    "chest_id": [None, 14, 3, 2, 6, 6, 14],
    "apple_count": [6, 4, 8, 19, 12, 9, 16],
    "orange_count": [15, 15, 4, 20, 9, 9, 7]
}

chests_data = {
    "chest_id": [6, 14, 2, 3, 16],
    "apple_count": [5, 20, 8, 19, 19],
    "orange_count": [6, 10, 8, 4, 19]
}

# Create DataFrames
boxes_df = pd.DataFrame(boxes_data)
chests_df = pd.DataFrame(chests_data)


# m1 

# merged_df = boxes_df.merge(chests_df, on="chest_id", how="left", suffixes=("_box", "_chest"))

# # Fill NaN values with 0 where there is no chest
# total_apples = (merged_df["apple_count_box"] + merged_df["apple_count_chest"].fillna(0)).sum()
# total_oranges = (merged_df["orange_count_box"] + merged_df["orange_count_chest"].fillna(0)).sum()

# # Create result DataFrame
# result_df = pd.DataFrame({"apple_count": [total_apples], "orange_count": [total_oranges]})

# # Display result
# print(result_df)


# m2 

# df= pd.merge(boxes_df, chests_df, how ='left', on ='chest_id').fillna(0)
# df['apple_count'] = df['apple_count_x'] + df['apple_count_y']
# df['orange_count'] = df['orange_count_x'] + df['orange_count_y']
# df = df[['apple_count','orange_count']]
# new_df = pd.DataFrame({
#     'apple_count': [df['apple_count'].sum()],
#     'orange_count': [df['orange_count'].sum()]
# })

