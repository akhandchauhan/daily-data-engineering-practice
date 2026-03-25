# 1126. Active Businesses
# Table: Events
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | business_id   | int     |
# | event_type    | varchar |
# | occurences    | int     |
# +---------------+---------+
# (business_id, event_type) is the primary key of this table.
# Each row in the table logs the info that an event of some type occured at some business for
# a number of times.
# Write an  SQL query to find all active businesses.
# An active business is a business that has more than one event type with occurences greater 
# than the average occurences of that event type among all businesses.
# Events table:
# +-------------+------------+------------+
# | business_id | event_type | occurences |
# +-------------+------------+------------+
# | 1           | reviews    | 7          |
# | 3           | reviews    | 3          |
# | 1           | ads        | 11         |
# | 2           | ads        | 7          |
# | 3           | ads        | 6          |
# | 1           | page views | 3          |
# | 2           | page views | 12         |
# +-------------+------------+------------+
# Result table:
# +-------------+
# | business_id |
# +-------------+
# | 1           |
# +-------------+
# Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
# Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an 
# active business.

import pandas as pd

df = pd.DataFrame({
    'business_id': [1, 3, 1, 2, 3, 1, 2],
    'event_type': ['reviews', 'reviews', 'ads', 'ads', 'ads', 'page views', 'page views'],
    'occurences': [7, 3, 11, 7, 6, 3, 12]
})

# m1 

# events_df = pd.DataFrame(data)
# events_df['avg_occ'] = events_df.groupby('event_type')['occurences'].transform('mean')
# events_df = events_df[events_df['occurences'] > events_df['avg_occ']]
# events_df = events_df.groupby('business_id')['event_type'].agg(count='count').reset_index()
# events_df =  events_df.query('count > 1')[['business_id']]
# print(events_df)

#####################################################################################################################3

# m2

# event_average_df = (
#                     df.groupby('event_type')['occurences']
#                     .mean()
#                     .reset_index(name = 'average_event_occurence')

# )
# final = ( df.merge(event_average_df, on = 'event_type')
#             .query("occurences > average_event_occurence")
#             .groupby('business_id')['event_type']
#             .count()
#             .reset_index(name = 'df_size')
#             .query("df_size > 1")
#             [['business_id']]
# )
# print(final)

#####################################################################################################################3
#m3

df['average_event_occurence'] = df.groupby('event_type')['occurences'].transform('mean')

final = (   df
            .query("occurences > average_event_occurence")
            .groupby('business_id')['event_type']
            .count()
            .reset_index(name = 'df_size')
            .query("df_size > 1")
            [['business_id']]
)

print(final)

#####################################################################################################################3

# m4 
avg_occ = df.groupby('event_type')['occurences'].transform('mean')

active = (
    df[df['occurences'] > avg_occ]
    .groupby('business_id')
    .size()
    .loc[lambda x: x > 1]
    .reset_index(name='event_count')
    [['business_id']]
)
