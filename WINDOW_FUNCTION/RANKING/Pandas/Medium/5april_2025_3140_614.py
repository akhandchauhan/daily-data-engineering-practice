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



# -- 614. Second Degree Follower
# -- Description
# -- Table: Follow
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | followee    | varchar |
# -- | follower    | varchar |
# -- +-------------+---------+
# -- (followee, follower) is the primary key (combination of columns with unique values) for this table.
# -- Each row of this table indicates that the user follower follows the user followee on a social network.
# -- There will not be a user following themself.
# -- A second-degree follower is a user who:
# -- follows at least one user, and
# -- is followed by at least one user.
# -- Write a solution to report the second-degree users and the number of their followers.
# -- Return the result table ordered by follower in alphabetical order.
# -- The result format is in the following example.
# -- Input: 
# -- Follow table:
# -- +----------+----------+
# -- | followee | follower |
# -- +----------+----------+
# -- | Alice    | Bob      |
# -- | Bob      | Cena     |
# -- | Bob      | Donald   |
# -- | Donald   | Edward   |
# -- +----------+----------+
# -- Output: 
# -- +----------+-----+
# -- | follower | num |
# -- +----------+-----+
# -- | Bob      | 2   |
# -- | Donald   | 1   |
# -- +----------+-----+
# -- Explanation: 
# -- User Bob has 2 followers. Bob is a second-degree follower because he follows Alice, so we include him 
# -- in the result table.
# -- User Donald has 1 follower. Donald is a second-degree follower because he follows Bob, so we include him
# --  in the result table.
# -- User Alice has 1 follower. Alice is not a second-degree follower because she does not follow anyone, s


data = {
    'followee': ['Alice', 'Bob', 'Bob', 'Donald'],
    'follower': ['Bob', 'Cena', 'Donald', 'Edward']
}
follow_df = pd.DataFrame(data)

df = pd.merge(follow_df, follow_df, left_on ='follower',right_on ='followee')
df = df.groupby('follower_x',as_index = False)['followee_y'].count().\
        rename(columns = {'follower_x': 'follower','followee_y' :'num'}).sort_values('follower')
print(df)