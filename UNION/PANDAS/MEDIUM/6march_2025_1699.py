# -- 1699. Number of Calls Between Two Persons
# -- Description
# -- Table: Calls
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | from_id     | int     |
# -- | to_id       | int     |
# -- | duration    | int     |
# -- +-------------+---------+
# -- This table does not have a primary key (column with unique values), it may contain duplicates.
# -- This table contains the duration of a phone call between from_id and to_id.
# -- from_id != to_id
# -- Write a solution to report the number of  calls and the total  call duration 
# --between each pair of distinct persons (person1, person2) where person1 < person2.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Calls table:
# -- +---------+-------+----------+
# -- | from_id | to_id | duration |
# -- +---------+-------+----------+
# -- | 1       | 2     | 59       |
# -- | 2       | 1     | 11       |
# -- | 1       | 3     | 20       |
# -- | 3       | 4     | 100      |
# -- | 3       | 4     | 200      |
# -- | 3       | 4     | 200      |
# -- | 4       | 3     | 499      |
# -- +---------+-------+----------+
# -- Output: 
# -- +---------+---------+------------+----------------+
# -- | person1 | person2 | call_count | total_duration |
# -- +---------+---------+------------+----------------+
# -- | 1       | 2       | 2          | 70             |
# -- | 1       | 3       | 1          | 20             |
# -- | 3       | 4       | 4          | 999            |
# -- +---------+---------+------------+----------------+
# -- Explanation: 
# -- Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
# -- Users 1 and 3 had 1 call and the total duration is 20.
# -- Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).


import pandas as pd
import numpy as np
pd.set_option('display.max_columns', None)

data = {
    "from_id": [1, 2, 1, 3, 3, 3, 4],
    "to_id": [2, 1, 3, 4, 4, 4, 3],
    "duration": [59, 11, 20, 100, 200, 200, 499]
}

calls_df = pd.DataFrame(data)

# m1
df = pd.concat(
    [
        calls_df[['from_id','to_id','duration']].rename(columns = {'from_id':'person1','to_id':'person2'}),
        calls_df[['to_id','from_id','duration']].rename(columns = {'from_id':'person2','to_id':'person1'})
    ]
)

df = (
    df[df['person1'] < df['person2']]
    .groupby(['person1','person2'], as_index = False)
    .agg(
        call_count = ('person1','count'),
        total_duration = ('duration','sum')
    )
)
print(df)

#####################################################################################################################
# m2

calls_df = calls_df.copy()

calls_df['person1'] = np.where(calls_df['from_id'] < calls_df['to_id'],calls_df['from_id'],calls_df['to_id'] )
calls_df['person2'] = np.where(calls_df['from_id'] < calls_df['to_id'],calls_df['to_id'],calls_df['from_id'] )

df = (
    calls_df
    .groupby(['person1','person2'], as_index = False)
    .agg(
        call_count = ('person1','count'),
        total_duration = ('duration','sum')
    )
)

#####################################################################################################################
# m3

calls_df = calls_df.copy()

calls_df['person1'] = calls_df[['from_id','to_id']].min(axis = 1)
calls_df['person2'] = calls_df[['from_id','to_id']].max(axis = 1)


df = (
    calls_df
    .groupby(['person1','person2'], as_index = False)
    .agg(
        call_count = ('person1','count'),
        total_duration = ('duration','sum')
    )
)
print(df)