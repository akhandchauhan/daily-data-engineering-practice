# 2142. The Number of Passengers in Each Bus I 
# Description
# Table: Buses
# +--------------+------+
# | Column Name  | Type |
# +--------------+------+
# | bus_id       | int  |
# | arrival_time | int  |
# +--------------+------+
# bus_id is the column with unique values for this table.
# Each row of this table contains information about the arrival time of a bus at the LeetCode station.
# No two buses will arrive at the same time.
# Table: Passengers
# +--------------+------+
# | Column Name  | Type |
# +--------------+------+
# | passenger_id | int  |
# | arrival_time | int  |
# +--------------+------+
# passenger_id is the column with unique values for this table.
# Each row of this table contains information about the arrival time of a passenger at the LeetCode station.
# Buses and passengers arrive at the LeetCode station. If a bus arrives at the station at time
# tbus and a passenger arrived at time tpassenger where tpassenger <= tbus and the passenger did
# not catch any bus, the passenger will use that bus.
# Write a solution to report the number of users that used each bus.
# Return the result table ordered by bus_id in ascending order.
# Input: 
# Buses table:
# +--------+--------------+
# | bus_id | arrival_time |
# +--------+--------------+
# | 1      | 2            |
# | 2      | 4            |
# | 3      | 7            |
# +--------+--------------+
# Passengers table:
# +--------------+--------------+
# | passenger_id | arrival_time |
# +--------------+--------------+
# | 11           | 1            |
# | 12           | 5            |
# | 13           | 6            |
# | 14           | 7            |
# +--------------+--------------+
# Output: 
# +--------+----------------+
# | bus_id | passengers_cnt |
# +--------+----------------+
# | 1      | 1              |
# | 2      | 0              |
# | 3      | 3              |
# +--------+----------------+
# Explanation: 
# - Passenger 11 arrives at time 1.
# - Bus 1 arrives at time 2 and collects passenger 11.
# - Bus 2 arrives at time 4 and does not collect any passengers.
# - Passenger 12 arrives at time 5.
# - Passenger 13 arrives at time 6.
# - Passenger 14 arrives at time 7.
# - Bus 3 arrives at time 7 and collects passengers 12, 13, and 14.


import pandas as pd

# Buses table
buses = pd.DataFrame({
    "bus_id": [1, 2, 3],
    "arrival_time": [2, 4, 7]
})

# Passengers table
passengers = pd.DataFrame({
    "passenger_id": [11, 12, 13, 14],
    "arrival_time": [1, 5, 6, 7]
})

print("Buses")
print(buses)

print("\nPassengers")
print(passengers)


df = (
    
        buses.assign(
          prev_arrival_time = lambda d: d['arrival_time'].shift(1).fillna(0).astype(int) +1
        )
        .merge(passengers, how ='cross')
        .query("arrival_time_y >= prev_arrival_time and arrival_time_y <= arrival_time_x")
        .groupby('bus_id')['passenger_id']
        .count()
        .reset_index(name ='passengers_cnt')
)

df = buses.merge(df,how ='left',on = 'bus_id').fillna(0)[['bus_id','passengers_cnt']]
df['passengers_cnt'] = df['passengers_cnt'].astype(int)
print(df)





###################################################################################################################################

#m2

buses_sorted = buses.sort_values('arrival_time')
passengers_sorted = passengers.sort_values('arrival_time')

i = 0
n = len(passengers_sorted)
counts = []

for _, bus in buses_sorted.iterrows():
    cnt = 0
    while i < n and passengers_sorted.iloc[i]['arrival_time'] <= bus['arrival_time']:
        cnt += 1
        i += 1
    counts.append(cnt)

final = buses_sorted[['bus_id']].copy()
final['passengers_cnt'] = counts

print(final)
