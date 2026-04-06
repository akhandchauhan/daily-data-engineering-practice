# 1495. Friendly Movies Streamed Last Month
# Online movie streaming services
# SQL Schema 
# Table: TVProgram
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | program_date  | date    |
# | content_id    | int     |
# | channel       | varchar |
# +---------------+---------+
# (program_date, content_id) is the primary key for this table.
# This table contains information of the programs on the TV.
# content_id is the id of the program in some channel on the TV.
# Table: Content
# +------------------+---------+
# | Column Name      | Type    |
# +------------------+---------+
# | content_id       | varchar |
# | title            | varchar |
# | Kids_content     | enum    |
# | content_type     | varchar |
# +------------------+---------+
# content_id is the primary key for this table.
# Kids_content is an enum that takes one of the values ('Y', 'N') where:
# 'Y' means is content for kids otherwise 'N' is not content for kids.
# content_type is the category of the content as movies, series, etc.

# Write an  SQL query to report the distinct titles of the kid-friendly movies
# streamed in June 2020.Online movie streaming services.

# Return the result table in any order.
# The query result format is in the following example.
# TVProgram table:
# +--------------------+--------------+-------------+
# | program_date       | content_id   | channel     |
# +--------------------+--------------+-------------+
# | 2020-06-10 08:00   | 1            | LC-Channel  |
# | 2020-05-11 12:00   | 2            | LC-Channel  |
# | 2020-05-12 12:00   | 3            | LC-Channel  |
# | 2020-05-13 14:00   | 4            | Disney Ch   |
# | 2020-06-18 14:00   | 4            | Disney Ch   |
# | 2020-07-15 16:00   | 5            | Disney Ch   |
# +--------------------+--------------+-------------+
# Content table:
# +------------+----------------+---------------+---------------+
# | content_id | title          | Kids_content  | content_type  |
# +------------+----------------+---------------+---------------+
# | 1          | Leetcode Movie | N             | Movies        |
# | 2          | Alg. for Kids  | Y             | Series        |
# | 3          | Database Sols  | N             | Series        |
# | 4          | Aladdin        | Y             | Movies        |
# | 5          | Cinderella     | Y             | Movies        |
# +------------+----------------+---------------+---------------+
# Result table:
# +--------------+
# | title        |
# +--------------+
# | Aladdin      |
# +--------------+
# "Leetcode Movie" is not a content for kids.
# "Alg. for Kids" is not a movie.
# "Database Sols" is not a movie
# "Alladin" is a movie, content for kids and was streamed in June 2020.
# "Cinderella" was not streamed in June 2020.

import pandas as pd
import datetime as dt

tv_data = {
    "program_date": [
        "2020-06-10 08:00",
        "2020-05-11 12:00",
        "2020-05-12 12:00",
        "2020-05-13 14:00",
        "2020-06-18 14:00",
        "2020-07-15 16:00"
    ],
    "content_id": [1, 2, 3, 4, 4, 5],
    "channel": [
        "LC-Channel",
        "LC-Channel",
        "LC-Channel",
        "Disney Ch",
        "Disney Ch",
        "Disney Ch"
    ]
}

tv_program_df = pd.DataFrame(tv_data)

tv_program_df["program_date"] = pd.to_datetime(tv_program_df["program_date"])

content_data = {
    "content_id": [1, 2, 3, 4, 5],
    "title": [
        "Leetcode Movie",
        "Alg. for Kids",
        "Database Sols",
        "Aladdin",
        "Cinderella"
    ],
    "Kids_content": ["N", "Y", "N", "Y", "Y"],
    "content_type": [
        "Movies",
        "Series",
        "Series",
        "Movies",
        "Movies"
    ]
}

content_df = pd.DataFrame(content_data)

# m1 using datetime methods

df = (
    tv_program_df.merge(content_df, on = 'content_id')
    .loc[lambda d: (d['program_date'].dt.year == 2020) & (d['program_date'].dt.month == 6)]
    .query("content_type == 'Movies' and Kids_content == 'Y'")
    [['title']].drop_duplicates()
)

print(df)


####################################################################################################################################
# m2 

final_df = (
    tv_program_df.merge(content_df, on = 'content_id')
    .loc[lambda d: 
        (d['program_date'] >= '2020-06-01') & 
        (d['program_date'] < '2020-07-01') &
        (d["content_type"] == 'Movies') &
        (d['Kids_content'] == 'Y')
        ]
    [['title']].drop_duplicates()
)

####################################################################################################################################
# m3

# Step 1: Filter early 
filtered_tv = tv_program_df[
    (tv_program_df['program_date'] >= '2020-06-01') &
    (tv_program_df['program_date'] < '2020-07-01')
]

filtered_content = content_df[
    (content_df['Kids_content'] == 'Y') &
    (content_df['content_type'] == 'Movies')
]

# Step 2: Reduce columns before join
filtered_tv = filtered_tv[['content_id']]
filtered_content = filtered_content[['content_id', 'title']]

# Step 3: Merge smaller datasets
df = filtered_tv.merge(filtered_content, on='content_id')[['title']].drop_duplicates()

print(df)