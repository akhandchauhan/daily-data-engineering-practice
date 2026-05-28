# -- 1285. Find the Start and End Number of Continuous Ranges
# -- Description
# -- Table: Logs
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | log_id        | int     |
# -- +---------------+---------+
# -- log_id is the column of unique values for this table.
# -- Each row of this table contains the ID in a log Table.
# -- Write a solution to find the start and end number of continuous ranges in the table Logs.
# -- Return the result table ordered by start_id.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Logs table:
# -- +------------+
# -- | log_id     |
# -- +------------+
# -- | 1          |
# -- | 2          |
# -- | 3          |
# -- | 7          |
# -- | 8          |
# -- | 10         |
# -- +------------+
# -- Output: 
# -- +------------+--------------+
# -- | start_id   | end_id       |
# -- +------------+--------------+
# -- | 1          | 3            |
# -- | 7          | 8            |
# -- | 10         | 10           |
# -- +------------+--------------+


import pandas as pd

logs = {
    'log_id' : [1,2,3,7,8,10]
    }
df = pd.DataFrame(logs)


#m1 
df = df.sort_values('log_id').reset_index(drop=True)
df['rank'] = range(1, len(df) + 1)
df['diff'] = df['log_id']  - df['rank']
df = df.groupby('diff').agg(
    start_id = ('log_id','min'),
    end_id = ('log_id','max')
)
df = df.sort_values(by='start_id')[['start_id', 'end_id']]
print(df)


#m2 somewhat tricky and misaligned
df['diff'] = df['log_id'] - df['log_id'].rank(ascending=True)

# Step 2: Group by the identifier and compute start and end of each range
df = df.groupby('diff')['log_id'].agg(['min', 'max']).reset_index()
df = df.rename(columns={'min': 'start_id', 'max': 'end_id'})

# Step 4: Sort by 'start_id' and select the required columns
df = df.sort_values(by='start_id')[['start_id', 'end_id']]

print(df)
