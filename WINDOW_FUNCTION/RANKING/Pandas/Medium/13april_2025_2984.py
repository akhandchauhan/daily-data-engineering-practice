# 2984. Find Peak Calling Hours for Each City
# Description
# Table: Calls
# +--------------+----------+
# | Column Name  | Type     |
# +--------------+----------+
# | caller_id    | int      |
# | recipient_id | int      |
# | call_time    | datetime |
# | city         | varchar  |
# +--------------+----------+
# (caller_id, recipient_id, call_time) is the primary key (combination of columns with unique values) 
# for this table.
# Each row contains caller id, recipient id, call time, and city.
# Write a solution to find the peak calling hour for each city.
# If multiple hours have the same number of  calls, all of those hours will 
# be recognized as peak hours for that specific city.
# Return the result table ordered by peak calling hour and city in descending order.
# Input: 
# Calls table:
# +-----------+--------------+---------------------+----------+
# | caller_id | recipient_id | call_time           | city     |
# +-----------+--------------+---------------------+----------+
# | 8         | 4            | 2021-08-24 22:46:07 | Houston  |
# | 4         | 8            | 2021-08-24 22:57:13 | Houston  |  
# | 5         | 1            | 2021-08-11 21:28:44 | Houston  |  
# | 8         | 3            | 2021-08-17 22:04:15 | Houston  |
# | 11        | 3            | 2021-08-17 13:07:00 | New York |
# | 8         | 11           | 2021-08-17 14:22:22 | New York |
# +-----------+--------------+---------------------+----------+
# Output: 
# +----------+-------------------+-----------------+
# | city     | peak_calling_hour | number_of_calls |
# +----------+-------------------+-----------------+
# | Houston  | 22                | 3               |
# | New York | 14                | 1               |
# | New York | 13                | 1               |
# +----------+-------------------+-----------------+
# Explanation: 
# For Houston:
#   - The peak time is 22:00, with a total of 3 calls recorded. 
# For New York:
#   - Both 13:00 and 14:00 hours have equal call counts of 1, so both times are considered peak hours.
# Output table is ordered by peak_calling_hour and city in descending order.

import pandas as pd
import datetime as dt

data = {
    'caller_id': [8, 4, 5, 8, 11, 8],
    'recipient_id': [4, 8, 1, 3, 3, 11],
    'call_time': [
        '2021-08-24 22:46:07',
        '2021-08-24 22:57:13',
        '2021-08-11 21:28:44',
        '2021-08-17 22:04:15',
        '2021-08-17 13:07:00',
        '2021-08-17 14:22:22'
    ],
    'city': ['Houston', 'Houston', 'Houston', 'Houston', 'New York', 'New York']
}

df = pd.DataFrame(data)
df['call_time'] = pd.to_datetime(df['call_time'])

df['hr'] = df['call_time'].dt.hour
df['cnt'] = df.groupby(['city', 'hr'])['caller_id'].transform('count')
df = df[df['cnt'] == df.groupby('city')['cnt'].transform('max')]
df = df.rename(columns={'hr': 'peak_calling_hour', 'cnt': 'number_of_calls'})

df = df[['city', 'peak_calling_hour', 'number_of_calls']]
df = df.sort_values(by=['peak_calling_hour', 'city'], ascending=[False, False]).reset_index(drop=True)
print(df)


#####################################################################################################################

# m2 
df['call_hour'] = df['call_time'].dt.hour

df= (
    df.groupby(['city','call_hour'])['caller_id']
    .count()
    .reset_index()
    .rename(columns = {'caller_id' : 'number_of_calls'})
    .assign(
        call_rank = lambda d : d.groupby('city')['number_of_calls']
        .rank(method = 'dense',ascending= False)
    )
    .query("call_rank == 1")
    .rename(columns = {'call_hour':'peak_calling_hour'})
    [['city','peak_calling_hour','number_of_calls']]
    .sort_values(by = ['peak_calling_hour','city'], ascending= [False, False])
)

print(df)

#####################################################################################################################

# m3

df= (
    df.groupby(['city','call_hour'])['caller_id']
    .count()
    .reset_index()
    .rename(columns = {'caller_id' : 'number_of_calls'})
    .assign(
        max_call = lambda d : d.groupby('city')['number_of_calls']
        .transform('max')
    )
    .loc[lambda d: d['max_call'] == d['number_of_calls']]
    .rename(columns = {'call_hour':'peak_calling_hour'})
    [['city','peak_calling_hour','number_of_calls']]
    .sort_values(by = ['peak_calling_hour','city'], ascending= [False, False])
)

print(df)