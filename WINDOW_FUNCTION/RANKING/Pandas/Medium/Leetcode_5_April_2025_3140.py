# -- 3140. Consecutive Available Seats II 
# -- Description
# -- Table: Cinema
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | seat_id     | int  |
# -- | free        | bool |
# -- +-------------+------+
# -- seat_id is an auto-increment column for this table.
# -- Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.
# -- Write a solution to find the length of longest consecutive sequence of available seats in the cinema.
# -- Note:
# -- There will always be at most one longest consecutive sequence.
# -- If there are multiple consecutive sequences with the same length, include all of them in the output.
# -- Return the result table ordered by first_seat_id in ascending order.
# -- The result format is in the following example.
# -- Example:
# -- Input:
# -- Cinema table:
# -- +---------+------+
# -- | seat_id | free |
# -- +---------+------+
# -- | 1       | 1    |
# -- | 2       | 0    |
# -- | 3       | 1    |
# -- | 4       | 1    |
# -- | 5       | 1    |
# -- +---------+------+
# -- Output:
# -- +-----------------+----------------+-----------------------+
# -- | first_seat_id   | last_seat_id   | consecutive_seats_len |
# -- +-----------------+----------------+-----------------------+
# -- | 3               | 5              | 3                     |
# -- +-----------------+----------------+-----------------------+
# -- Explanation:
# -- Longest consecutive sequence of available seats starts from seat 3 and ends at seat 5 with a length of 3.
# -- Output table is ordered by first_seat_id in ascending order.

import pandas as pd
data = {
    'seat_id': [1, 2, 3, 4, 5],
    'free': [1, 0, 1, 1, 1]
}
cinema_df = pd.DataFrame(data)

cinema_df = cinema_df[cinema_df['free'] != 0]
cinema_df = cinema_df.sort_values(by= 'seat_id')
cinema_df['rnk'] = cinema_df['free'].rank(method ='first')
cinema_df['diff'] = cinema_df['seat_id'] - cinema_df['rnk'] 
df = cinema_df.groupby('diff').agg(maxi = ('seat_id','max'),mini = ('seat_id','min'),cnt =('seat_id','count') ).reset_index()
df['rnk'] = df['cnt'].rank(method ='max',ascending= False)
df = df[df['rnk'] == 1]
df = df[['mini','maxi','cnt']].rename(columns = {'maxi':'last_seat_id','mini':'first_seat_id','cnt':'consecutive_seats_len'})
print(df)
