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

import pandas as pd

data = {
    'followee': ['Alice', 'Bob', 'Bob', 'Donald'],
    'follower': ['Bob', 'Cena', 'Donald', 'Edward']
}

follow_df = pd.DataFrame(data)
df = (
    follow_df.groupby('followee', as_index = False)['follower']
    .count()
    .rename(columns = {'follower' : 'num', 'followee':'follower'})
    .loc[lambda d: d['followee'].isin(follow_df['follower'])]
    .sort_values('followee')
)
print(df)