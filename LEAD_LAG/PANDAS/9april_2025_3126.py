# -- 3204. Bitwise User Permissions Analysis 
# -- Description
# -- Table: user_permissions
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | user_id     | int     |
# -- | permissions | int     |
# -- +-------------+---------+
# -- user_id is the primary key.
# -- Each row of this table contains the user ID and their permissions encoded as an integer.
# -- Consider that each bit in the permissions integer represents a different access level or 
# -- feature that a user has.
# -- Write a solution to calculate the following:
# -- common_perms: The access level granted to all users. This is computed using a bitwise 
# -- AND operation on the permissions column.
# -- any_perms: The access level granted to any user. This is computed using a bitwise OR 
# -- operation on the permissions column.
# -- Return the result table in any order.
# -- The result format is shown in the following example.
# -- Example:
# -- Input:
# -- user_permissions table:
# -- +---------+-------------+
# -- | user_id | permissions |
# -- +---------+-------------+
# -- | 1       | 5           |
# -- | 2       | 12          |
# -- | 3       | 7           |
# -- | 4       | 3           |
# -- +---------+-------------+
# -- Output:
# -- +-------------+--------------+
# -- | common_perms | any_perms   |
# -- +--------------+-------------+
# -- | 0            | 15          |
# -- +--------------+-------------+
# -- Explanation:
# -- common_perms: Represents the bitwise AND result of all permissions:
# -- <ul>
# -- 	<li>For user 1 (5): 5 (binary 0101)</li>
# -- 	<li>For user 2 (12): 12 (binary 1100)</li>
# -- 	<li>For user 3 (7): 7 (binary 0111)</li>
# -- 	<li>For user 4 (3): 3 (binary 0011)</li>
# -- 	<li>Bitwise AND: 5 &amp; 12 &amp; 7 &amp; 3 = 0 (binary 0000)</li>
# -- </ul>
# -- </li>
# -- <li><strong>any_perms:</strong> Represents the bitwise OR result of all permissions:
# -- <ul>
# -- 	<li>Bitwise OR: 5 | 12 | 7 | 3 = 15 (binary 1111)</li>
# -- </ul>



import pandas as pd

df = pd.DataFrame({
    'user_id': [1, 2, 3, 4],
    'permissions': [5, 12, 7, 3]
})

common_perms = df['permissions'].iloc[0]
any_perms = df['permissions'].iloc[0]


for val in df['permissions'].iloc[1:]:
    common_perms = common_perms & val
    any_perms = any_perms | val

result = pd.DataFrame({
    'common_perms': [common_perms],
    'any_perms': [any_perms]
})

print(result)

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
df['next_time'] = df['status_time'].shift(-1)
df['next_status'] = df['session_status'].shift(-1)

# Filter only valid start-stop pairs
paired = df[(df['session_status'] == 'start') & (df['next_status'] == 'stop')].copy()

# Compute duration in seconds
paired['duration'] = (paired['next_time'] - paired['status_time']).dt.total_seconds()

# Sum and convert to full days
total_seconds = paired['duration'].sum()
total_days = int(total_seconds // (24 * 3600))

result = pd.DataFrame({'total_uptime_days': [total_days]})
print(result)



