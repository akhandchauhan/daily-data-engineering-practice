# 603. Consecutive Available Seats 

# Table: Cinema
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | seat_id     | int  |
# | free        | bool |
# +-------------+------+
# seat_id is an auto-increment column for this table.
# Each row of this table indicates whether the ith seat is free or not. 
# 1 means free while 0 means occupied.
 
# Find all the consecutive available seats in the cinema.
# Return the result table ordered by seat_id in ascending order.

# The test cases are generated so that more than two seats are consecutively available.

# The result format is in the following example.

# Example 1:

# Input: 
# Cinema table:
# +---------+------+
# | seat_id | free | lag | lead
# +---------+------+
# | 1       | 1    | NULL - 0
# | 2       | 0    | 1 - 1
# | 3       | 1    | 0 - 1
# | 4       | 1    | 1 - 1
# | 5       | 1    | 1 - NULL
# +---------+------+
# Output: 
# +---------+
# | seat_id |
# +---------+
# | 3       |
# | 4       |
# | 5       |
# +---------+

import pandas as pd

cinema = pd.DataFrame({
    "seat_id": [1, 2, 3, 4, 5],
    "free": [1, 0, 1, 1, 1]
})

cinema_df = cinema.copy()

cinema_df = cinema_df.sort_values('seat_id')
cinema_df['next'] = cinema_df['free'].shift(-1)
cinema_df['prev'] = cinema_df['free'].shift(1)

cinema_df = cinema_df[(cinema_df['free'] == 1) &
                     ((cinema_df['next'] == 1) | (cinema_df['prev'] == 1))
                    ][['seat_id']].sort_values('seat_id')
print(cinema_df)