# # -- 1126. Active Businesses
# # -- Table: Events
# # -- +---------------+---------+
# # -- | Column Name   | Type    |
# # -- +---------------+---------+
# # -- | business_id   | int     |
# # -- | event_type    | varchar |
# # -- | occurences    | int     |
# # -- +---------------+---------+
# # -- (business_id, event_type) is the primary key of this table.
# # -- Each row in the table logs the info that an event of some type occured at some business for
# # -- a number of times.
# # -- Write an  SQL query to find all active businesses.
# # -- An active business is a business that has more than one event type with occurences greater 
# # --than the average occurences of that event type among all businesses.
# # -- Events table:
# # -- +-------------+------------+------------+
# # -- | business_id | event_type | occurences |
# # -- +-------------+------------+------------+
# # -- | 1           | reviews    | 7          |
# # -- | 3           | reviews    | 3          |
# # -- | 1           | ads        | 11         |
# # -- | 2           | ads        | 7          |
# # -- | 3           | ads        | 6          |
# # -- | 1           | page views | 3          |
# # -- | 2           | page views | 12         |
# # -- +-------------+------------+------------+
# # -- Result table:
# # -- +-------------+
# # -- | business_id |
# # -- +-------------+
# # -- | 1           |
# # -- +-------------+
# # -- Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
# # -- Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an 
# # --active business.

# import pandas as pd

# # Create a pandas DataFrame to represent the Events table
# data = {
#     'business_id': [1, 3, 1, 2, 3, 1, 2],
#     'event_type': ['reviews', 'reviews', 'ads', 'ads', 'ads', 'page views', 'page views'],
#     'occurences': [7, 3, 11, 7, 6, 3, 12]
# }

# events_df = pd.DataFrame(data)
# events_df['avg_occ'] = events_df.groupby('event_type')['occurences'].transform('mean')
# events_df = events_df[events_df['occurences'] > events_df['avg_occ']]
# events_df = events_df.groupby('business_id')['event_type'].agg(count='count').reset_index()
# events_df =  events_df.query('count > 1')[['business_id']]
# print(events_df)


# -- 2175. The Change in Global Rankings 
# -- Description
# -- Table: TeamPoints
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | team_id     | int     |
# -- | name        | varchar |
# -- | points      | int     |
# -- +-------------+---------+
# -- team_id contains unique values.
# -- Each row of this table contains the ID of a national team, the name of the country it 
# --represents, and the points it has in the global rankings. No two teams will represent the 
# --same country.
# -- Table: PointsChange
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | team_id       | int  |
# -- | points_change | int  |
# -- +---------------+------+
# -- team_id contains unique values.
# -- Each row of this table contains the ID of a national team and the change in its points 
# --in the global rankings.
# -- points_change can be:
# -- - 0: indicates no change in points.
# -- - positive: indicates an increase in points.
# -- - negative: indicates a decrease in points.
# -- Each team_id that appears in TeamPoints will also appear in this table.
# -- The global ranking of a national team is its rank after sorting all the teams by their 
# --points in descending order. If two teams have the same points, we break the tie by sorting
# -- them by their name in lexicographical order.
# -- The points of each national team should be updated based on its corresponding points_change value.
# -- Write a solution to calculate the change in the global rankings after updating each team's points.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- TeamPoints table:
# -- +---------+-------------+--------+
# -- | team_id | name        | points |
# -- +---------+-------------+--------+
# -- | 3       | Algeria     | 1431   |
# -- | 1       | Senegal     | 2132   |
# -- | 2       | New Zealand | 1402   |
# -- | 4       | Croatia     | 1817   |
# -- +---------+-------------+--------+
# -- PointsChange table:
# -- +---------+---------------+
# -- | team_id | points_change |
# -- +---------+---------------+
# -- | 3       | 399           |
# -- | 2       | 0             |
# -- | 4       | 13            |
# -- | 1       | -22           |
# -- +---------+---------------+
# -- Output: 
# -- +---------+-------------+-----------+
# -- | team_id | name        | rank_diff |
# -- +---------+-------------+-----------+
# -- | 1       | Senegal     | 0         |
# -- | 4       | Croatia     | -1        |
# -- | 3       | Algeria     | 1         |
# -- | 2       | New Zealand | 0         |
# -- +---------+-------------+-----------+
# -- Explanation: 
# -- The global rankings were as follows:
# -- +---------+-------------+--------+------+
# -- | team_id | name        | points | rank |
# -- +---------+-------------+--------+------+
# -- | 1       | Senegal     | 2132   | 1    |
# -- | 4       | Croatia     | 1817   | 2    |
# -- | 3       | Algeria     | 1431   | 3    |
# -- | 2       | New Zealand | 1402   | 4    |
# -- +---------+-------------+--------+------+
# -- After updating the points of each team, the rankings became the following:
# -- +---------+-------------+--------+------+
# -- | team_id | name        | points | rank |
# -- +---------+-------------+--------+------+
# -- | 1       | Senegal     | 2110   | 1    |
# -- | 3       | Algeria     | 1830   | 2    |
# -- | 4       | Croatia     | 1830   | 3    |
# -- | 2       | New Zealand | 1402   | 4    |
# -- +---------+-------------+--------+------+
# -- Since after updating the points Algeria and Croatia have the same points, 
# --they are ranked according to their lexicographic order.
# -- Senegal lost 22 points but their rank did not change.
# -- Croatia gained 13 points but their rank decreased by one.
# -- Algeria gained 399 points and their rank increased by one.
# -- New Zealand did not gain or lose points and their rank did not change.
# -- Delete the TeamPoints table

import pandas as pd
data_team_points = {
    'team_id': [3, 1, 2, 4],
    'name': ['Algeria', 'Senegal', 'New Zealand', 'Croatia'],
    'points': [1431, 2132, 1402, 1817]
}
team_points_df = pd.DataFrame(data_team_points)

data_points_change = {
    'team_id': [3, 2, 4, 1],
    'points_change': [399, 0, 13, -22]
}
points_change_df = pd.DataFrame(data_points_change)
# print(team_points_df)
# print(points_change_df)

df = pd.merge(team_points_df, points_change_df, on ='team_id', how='left')
df = df.sort_values(by=['points', 'name'], ascending=[False, True])
df['prev_rnk'] = df['points'].rank(method='min', ascending=False)
df['new_points'] = df['points'] + df['points_change']
df = df.sort_values(by=['new_points', 'name'], ascending=[False, True])
df['new_rnk'] = df['new_points'].rank(method='min', ascending=False)
df['rank_diff'] = df['prev_rnk'] - df['new_rnk']
df = df[['team_id', 'name', 'rank_diff']]
print(df)
