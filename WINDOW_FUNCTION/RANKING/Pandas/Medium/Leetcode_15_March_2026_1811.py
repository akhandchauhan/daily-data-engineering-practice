# 1811. Find Interview Candidates
# SQL Schema
# Table: Contests
# +--------------+------+
# | Column Name  | Type |
# +--------------+------+
# | contest_id   | int  |
# | gold_medal   | int  |
# | silver_medal | int  |
# | bronze_medal | int  |
# +--------------+------+
# contest_id is the primary key for this table.
# This table contains the LeetCode contest ID and the user IDs of the gold,
# silver, and bronze medalists.
# It is guaranteed that any consecutive contests have consecutive IDs and 
# that no ID is skipped.
# Table: Users
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | user_id     | int     |
# | mail        | varchar |
# | name        | varchar |
# +-------------+---------+
# user_id is the primary key for this table.
# This table contains information about the users.
 
# Write an SQL query to report the name and the mail of all interview 
# candidates. A user is an interview candidate if at least one of these two 
# conditions is true:
# The user won any medal in three or more consecutive contests.
# The user won the gold medal in three or more different contests 
# (not necessarily consecutive).
# Return the result table in any order.
# Contests table:
# +------------+------------+--------------+--------------+
# | contest_id | gold_medal | silver_medal | bronze_medal |
# +------------+------------+--------------+--------------+
# | 190        | 1          | 5            | 2            |
# | 191        | 2          | 3            | 5            |
# | 192        | 5          | 2            | 3            |
# | 193        | 1          | 3            | 5            |
# | 194        | 4          | 5            | 2            |
# | 195        | 4          | 2            | 1            |
# | 196        | 1          | 5            | 2            |
# +------------+------------+--------------+--------------+
# Users table:
# +---------+--------------------+-------+
# | user_id | mail               | name  |
# +---------+--------------------+-------+
# | 1       | sarah@leetcode.com | Sarah |
# | 2       | bob@leetcode.com   | Bob   |
# | 3       | alice@leetcode.com | Alice |
# | 4       | hercy@leetcode.com | Hercy |
# | 5       | quarz@leetcode.com | Quarz |
# +---------+--------------------+-------+
# Result table:
# +-------+--------------------+
# | name  | mail               |
# +-------+--------------------+
# | Sarah | sarah@leetcode.com |
# | Bob   | bob@leetcode.com   |
# | Alice | alice@leetcode.com |
# | Quarz | quarz@leetcode.com |
# +-------+--------------------+
# Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
# Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
#     - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
# Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
# Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.


import pandas as pd

contests_df = pd.DataFrame({
    "contest_id": [190, 191, 192, 193, 194, 195, 196],
    "gold_medal": [1, 2, 5, 1, 4, 4, 1],
    "silver_medal": [5, 3, 2, 3, 5, 2, 5],
    "bronze_medal": [2, 5, 3, 5, 2, 1, 2]
})

users_df = pd.DataFrame({
    "user_id": [1, 2, 3, 4, 5],
    "mail": [
        "sarah@leetcode.com",
        "bob@leetcode.com",
        "alice@leetcode.com",
        "hercy@leetcode.com",
        "quarz@leetcode.com"
    ],
    "name": ["Sarah", "Bob", "Alice", "Hercy", "Quarz"]
})


gold_candidate_df = (
                        contests_df
                        .assign(medal_type = 'gold') 
                        .rename(columns = {'gold_medal' :'user_id'})
                        [['contest_id','medal_type','user_id']] 
)
silver_candidate_df = (
                        contests_df
                        .assign(medal_type = 'silver') 
                        .rename(columns = {'silver_medal' :'user_id'})
                        [['contest_id','medal_type','user_id']] 
)
bronze_candidate_df = (
                        contests_df
                        .assign(medal_type = 'bronze')
                        .rename(columns = {'bronze_medal' :'user_id'})
                        [['contest_id','medal_type','user_id']] 
)

df_merged = pd.concat([gold_candidate_df,silver_candidate_df,bronze_candidate_df])

gold_user_df = (
                df_merged
                .query("medal_type == 'gold' ")
                .groupby('user_id', as_index= False)['contest_id']
                .count()
                .rename(columns = {'contest_id':'medal_count'})
                .query("medal_count >= 3")
                [['user_id']]
)

consecutive_users_df =(
                df_merged
                .sort_values('contest_id')
                .assign(
                    user_ranked = lambda d: 
                    d.groupby('user_id')['contest_id']
                    .cumcount()+1
                )
                .assign(
                    rank_diff = lambda d: d['contest_id'] -  d['user_ranked']     
                )
                .groupby(['user_id','rank_diff'])['medal_type']
                .count()
                .reset_index()
                .query("medal_type >= 3")
                [['user_id']]
                .drop_duplicates()
                
)

df_union = pd.concat([gold_user_df,consecutive_users_df ])

final_df = (
            df_union.merge(users_df, on ='user_id')
            [['name','mail']]
)
print(final_df)