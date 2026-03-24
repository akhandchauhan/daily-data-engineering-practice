# 3140. Consecutive Available Seats II 
# Description
# Table: Cinema
# \| Column Name \| Type \|
# \| seat_id     \| int  \|
# \| free        \| bool \|
# seat_id is an auto-increment column for this table.
# Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.
# Write a solution to find the length of longest consecutive sequence of available seats in the cinema.

# Note:
# There will always be at most one longest consecutive sequence.
# If there are multiple consecutive sequences with the same length, include all of them in the output.
# Return the result table ordered by first_seat_id in ascending order.
# \|seat_id  \| free \|
# \| 1       \| 1    \|
# \| 2       \| 0    \|
# \| 3       \| 1    \|
# \| 4       \| 1    \|
# \| 5       \| 1    \|
# Output:
# +-----------------+----------------+-----------------------+
# | first_seat_id   | last_seat_id   | consecutive_seats_len |
# +-----------------+----------------+-----------------------+
# | 3               | 5              | 3                     |
# +-----------------+----------------+-----------------------+
# Explanation:
# Longest consecutive sequence of available seats starts from seat 3 and ends at seat 5 with a length of 3.
# Output table is ordered by first_seat_id in ascending order.


import pandas as pd

data = {
    "seat_id": [1, 2, 3, 4, 5],
    "free": [1, 0, 1, 1, 1]
}

df = pd.DataFrame(data)

df = (
    df[df['free'] == 1].sort_values('seat_id')
    .assign(
        seat_rank = lambda d: range(len(d)),
        grouped = lambda d : d['seat_id'] - d['seat_rank']
    )
    .groupby('grouped')
    .agg(
        first_seat_id = ('seat_id', 'min'),
        last_seat_id = ('seat_id','max'),
        consecutive_seats_len = ('free','count')
    )
    .reset_index()
)

max_consecutive_seat_len = df['consecutive_seats_len'].max()

df = (
    df[df['consecutive_seats_len'] == max_consecutive_seat_len]
    [['first_seat_id','last_seat_id','consecutive_seats_len']]
    .sort_values('first_seat_id')
    .reset_index(drop=True)
)

print(df)
