# -- 3126. Server Utilization Time 
# -- Description
# -- Table: Servers
# -- +----------------+----------+
# -- | Column Name    | Type     |
# -- +----------------+----------+
# -- | server_id      | int      |
# -- | status_time    | datetime |
# -- | session_status | enum     |
# -- +----------------+----------+
# -- (server_id, status_time, session_status) is the primary key (combination of columns with unique values) 
# -- for this table.
# -- session_status is an ENUM (category) type of ('start', 'stop').
# -- Each row of this table contains server_id, status_time, and session_status.
# -- Write a solution to find the total time when servers were running. The output should be rounded down 
# -- to the nearest number of full days.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example:
# -- Input:
# -- Servers table:
# -- +-----------+---------------------+----------------+
# -- | server_id | status_time         | session_status |
# -- +-----------+---------------------+----------------+
# -- | 3         | 2023-11-04 16:29:47 | start          |
# -- | 3         | 2023-11-05 01:49:47 | stop           |
# -- | 3         | 2023-11-25 01:37:08 | start          |
# -- | 3         | 2023-11-25 03:50:08 | stop           |
# -- | 1         | 2023-11-13 03:05:31 | start          |
# -- | 1         | 2023-11-13 11:10:31 | stop           |
# -- | 4         | 2023-11-29 15:11:17 | start          |
# -- | 4         | 2023-11-29 15:42:17 | stop           |
# -- | 4         | 2023-11-20 00:31:44 | start          |
# -- | 4         | 2023-11-20 07:03:44 | stop           |
# -- | 1         | 2023-11-20 00:27:11 | start          |
# -- | 1         | 2023-11-20 01:41:11 | stop           |
# -- | 3         | 2023-11-04 23:16:48 | start          |
# -- | 3         | 2023-11-05 01:15:48 | stop           |
# -- | 4         | 2023-11-30 15:09:18 | start          |
# -- | 4         | 2023-11-30 20:48:18 | stop           |
# -- | 4         | 2023-11-25 21:09:06 | start          |
# -- | 4         | 2023-11-26 04:58:06 | stop           |
# -- | 5         | 2023-11-16 19:42:22 | start          |
# -- | 5         | 2023-11-16 21:08:22 | stop           |
# -- +-----------+---------------------+----------------+
# -- Output:
# -- +-------------------+
# -- | total_uptime_days |
# -- +-------------------+
# -- | 1                 |
# -- +-------------------+
# -- Explanation:
# -- For server ID 3:
# -- From 2023-11-04 16:29:47 to 2023-11-05 01:49:47: ~9.3 hours
# -- From 2023-11-25 01:37:08 to 2023-11-25 03:50:08: ~2.2 hours
# -- From 2023-11-04 23:16:48 to 2023-11-05 01:15:48: ~1.98 hours
# -- Total for server 3: ~13.48 hours
# -- For server ID 1:
# -- From 2023-11-13 03:05:31 to 2023-11-13 11:10:31: ~8 hours
# -- From 2023-11-20 00:27:11 to 2023-11-20 01:41:11: ~1.23 hours
# -- Total for server 1: ~9.23 hours
# -- For server ID 4:
# -- From 2023-11-29 15:11:17 to 2023-11-29 15:42:17: ~0.52 hours
# -- From 2023-11-20 00:31:44 to 2023-11-20 07:03:44: ~6.53 hours
# -- From 2023-11-30 15:09:18 to 2023-11-30 20:48:18: ~5.65 hours
# -- From 2023-11-25 21:09:06 to 2023-11-26 04:58:06: ~7.82 hours
# -- Total for server 4: ~20.52 hours
# -- For server ID 5:
# -- From 2023-11-16 19:42:22 to 2023-11-16 21:08:22: ~1.43 hours
# -- Total for server 5: ~1.43 hours
# -- The accumulated runtime for all servers totals approximately 44.46 hours,
# --  equivalent to one full day plus some additional hours. However, since we consider only full
# --   days, the final output is rounded to 1 full day.


import pandas as pd

data = [
    [3, '2023-11-04 16:29:47', 'start'],
    [3, '2023-11-05 01:49:47', 'stop'],
    [3, '2023-11-25 01:37:08', 'start'],
    [3, '2023-11-25 03:50:08', 'stop'],
    [1, '2023-11-13 03:05:31', 'start'],
    [1, '2023-11-13 11:10:31', 'stop'],
    [4, '2023-11-29 15:11:17', 'start'],
    [4, '2023-11-29 15:42:17', 'stop'],
    [4, '2023-11-20 00:31:44', 'start'],
    [4, '2023-11-20 07:03:44', 'stop'],
    [1, '2023-11-20 00:27:11', 'start'],
    [1, '2023-11-20 01:41:11', 'stop'],
    [3, '2023-11-04 23:16:48', 'start'],
    [3, '2023-11-05 01:15:48', 'stop'],
    [4, '2023-11-30 15:09:18', 'start'],
    [4, '2023-11-30 20:48:18', 'stop'],
    [4, '2023-11-25 21:09:06', 'start'],
    [4, '2023-11-26 04:58:06', 'stop'],
    [5, '2023-11-16 19:42:22', 'start'],
    [5, '2023-11-16 21:08:22', 'stop'],
]

df = pd.DataFrame(data, columns=['server_id', 'status_time', 'session_status'])
df['status_time'] = pd.to_datetime(df['status_time'])

df = df.sort_values(['server_id', 'status_time'])

# Keep only start rows and pair them with the next row (which should be a stop)
# df['next_time'] = df['status_time'].shift(-1)
# df['next_status'] = df['session_status'].shift(-1)

# # Filter only valid start-stop pairs
# paired = df[(df['session_status'] == 'start') & (df['next_status'] == 'stop')].copy()

# # Compute duration in seconds
# paired['duration'] = (paired['next_time'] - paired['status_time']).dt.total_seconds()

# # Sum and convert to full days
# total_seconds = paired['duration'].sum()
# total_days = int(total_seconds // (24 * 3600))

# result = pd.DataFrame({'total_uptime_days': [total_days]})
# print(result)

################################################################################

# m2



# Sort by server and time
df = df.sort_values(['server_id', 'status_time'])

# ROW_NUMBER per server
df['rn'] = df.groupby('server_id').cumcount() + 1

# Self join: current row with next row
paired = df.merge(
    df,
    left_on=['server_id', 'rn'],
    right_on=['server_id', 'rn'],
    how='inner',
    suffixes=('_start', '_stop')
)

# Shift logic using rn
paired = paired[paired['rn_stop'] == paired['rn_start'] + 1]

# Keep valid start → stop pairs
paired = paired[
    (paired['session_status_start'] == 'start') &
    (paired['session_status_stop'] == 'stop')
]

# Compute duration
paired['duration'] = (
    paired['status_time_stop'] - paired['status_time_start']
).dt.total_seconds()

# Sum and convert to full days
total_days = int(paired['duration'].sum() // (24 * 3600))

result = pd.DataFrame({'total_uptime_days': [total_days]})
print(result)


