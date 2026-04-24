# 1149. Article Views II
# Table: Views
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | article_id    | int     |
# | author_id     | int     |
# | viewer_id     | int     |
# | view_date     | date    |
# +---------------+---------+
# There is no primary key for this table, it may have duplicate rows.
# Each row of this table indicates that some viewer viewed an article 
# (written by some author) on some date.
# Note that equal author_id and viewer_id indicate the same person.

# Write an  SQL query to find all the people who viewed more than one 
# article on the same date, sorted in ascending order by their id.
# The query result format is in the following example:

# Views table:
# +------------+-----------+-----------+------------+
# | article_id | author_id | viewer_id | view_date  |
# +------------+-----------+-----------+------------+
# | 1          | 3         | 5         | 2019-08-01 |
# | 3          | 4         | 5         | 2019-08-01 |
# | 1          | 3         | 6         | 2019-08-02 |
# | 2          | 7         | 7         | 2019-08-01 |
# | 2          | 7         | 6         | 2019-08-02 |
# | 4          | 7         | 1         | 2019-07-22 |
# | 3          | 4         | 4         | 2019-07-21 |
# | 3          | 4         | 4         | 2019-07-21 |
# +------------+-----------+-----------+------------+
# Result table:
# +------+
# | id   |
# +------+
# | 5    |
# | 6    |
# +------+

import pandas as pd

data = [
    [1, 3, 5, '2019-08-01'],
    [3, 4, 5, '2019-08-01'],
    [1, 3, 6, '2019-08-02'],
    [2, 7, 7, '2019-08-01'],
    [2, 7, 6, '2019-08-02'],
    [4, 7, 1, '2019-07-22'],
    [3, 4, 4, '2019-07-21'],
    [3, 4, 4, '2019-07-21']
]

views = pd.DataFrame(data, columns=['article_id', 'author_id', 'viewer_id', 'view_date'])

df = views.copy()
df['view_date'] = pd.to_datetime(df['view_date'])

df = (
    df.groupby(['viewer_id','view_date'], as_index= False)['article_id']
    .nunique()
    .rename(columns = {'article_id':'count'})
    .loc[lambda d: d['count'] >1]
    [['viewer_id']]
    .drop_duplicates()
    .sort_values('viewer_id')
)
print(df)

##########################################################################################
# m2

df = (
    df.groupby(['viewer_id','view_date'], as_index= False)['article_id']
    .nunique()
    .rename(columns = {'article_id':'count'})
    .loc[lambda d: d['count'] >1]
    [['viewer_id']]
    .groupby("viewer_id",as_index = False)['viewer_id']
    .max()
    .sort_values('viewer_id')
)
print(df)

##########################################################################################
# m3
temp = (
    views.groupby(['viewer_id','view_date'])['article_id']
    .nunique()
    .reset_index()
)

df = (
    temp[temp['article_id'] > 1]
    .groupby('viewer_id', as_index=False)
    .size()[['viewer_id']]
    .sort_values('viewer_id')
)