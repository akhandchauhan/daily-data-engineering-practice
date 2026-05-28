# -- 1264. Page Recommendations
# -- SQL Schema 
# -- Table: Friendship
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | user1_id      | int     |
# -- | user2_id      | int     |
# -- +---------------+---------+
# -- (user1_id, user2_id) is the primary key for this table.
# -- Each row of this table indicates that there is a friendship relation between user1_id and user2_id.

# -- Table: Likes
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | user_id     | int     |
# -- | page_id     | int     |
# -- +-------------+---------+
# -- (user_id, page_id) is the primary key for this table.
# -- Each row of this table indicates that user_id likes page_id.

# -- Write an  SQL query to recommend pages to the user with user_id = 1 using the pages that your 
# --friends liked. It should not recommend pages you already liked.
# -- Return result table in any order without duplicates.
# -- Friendship table:
# -- +----------+----------+
# -- | user1_id | user2_id |
# -- +----------+----------+
# -- | 1        | 2        |
# -- | 1        | 3        |
# -- | 1        | 4        |
# -- | 2        | 3        |
# -- | 2        | 4        |
# -- | 2        | 5        |
# -- | 6        | 1        |
# -- +----------+----------+

# -- Likes table:
# -- +---------+---------+
# -- | user_id | page_id |
# -- +---------+---------+
# -- | 1       | 88      |
# -- | 2       | 23      |
# -- | 3       | 24      |
# -- | 4       | 56      |
# -- | 5       | 11      |
# -- | 6       | 33      |
# -- | 2       | 77      |
# -- | 3       | 77      |
# -- | 6       | 88      |
# -- +---------+---------+

# -- Result table:
# -- +------------------+
# -- | recommended_page |
# -- +------------------+
# -- | 23               |
# -- | 24               |
# -- | 56               |
# -- | 33               |
# -- | 77               |
# -- +------------------+
# -- User one is friend with users 2, 3, 4 and 6.
# -- Suggested pages are 23 from user 2, 24 from user 3, 56 from user 3 and 33 from user 6.
# -- Page 77 is suggested from both user 2 and user 3.
# -- Page 88 is not suggested because user 1 already likes it.

# import pandas as pd

# friendship_data = {
#     'user1_id': [1, 1, 1, 2, 2, 2, 6],
#     'user2_id': [2, 3, 4, 3, 4, 5, 1]
# }

# likes_data = {
#     'user_id': [1, 2, 3, 4, 5, 6, 2, 3, 6],
#     'page_id': [88, 23, 24, 56, 11, 33, 77, 77, 88]
# }
# friendship_df = pd.DataFrame(friendship_data)
# likes_df = pd.DataFrame(likes_data)

# friendship_df2 = friendship_df[['user2_id','user1_id']]
# df = pd.concat([friendship_df,friendship_df2])
# df = df[(df['user1_id'] == 1) | (df['user2_id'] == 1)]
# print(df)

# df = pd.merge(df,likes_df,left_on='user2_id',right_on ='user_id',how ='inner')
# df2 = likes_df.query('user_id == 1')[['page_id']]
# df = df[['page_id']].drop_duplicates()
# df = df[~df['page_id'].isin(df2['page_id'])]
# print(df)






