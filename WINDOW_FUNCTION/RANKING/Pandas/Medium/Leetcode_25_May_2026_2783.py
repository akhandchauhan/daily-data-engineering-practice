# 2783. Flight Occupancy and Waitlist Analysis

# Table: Flights
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | flight_id   | int  |
# | capacity    | int  |
# +-------------+------+
# flight_id is the column with unique values for this table.
# Each row of this table contains flight id and its capacity.
# Table: Passengers
# +--------------+------+
# | Column Name  | Type |
# +--------------+------+
# | passenger_id | int  |
# | flight_id    | int  |
# +--------------+------+
# passenger_id is the column with unique values for this table.
# Each row of this table contains passenger id and flight id.

# Passengers book tickets for flights in advance. If a passenger books a 
# ticket for a flight and there are still empty seats available, 
# the ticket will be confirmed. However, the passenger will
# be on a waitlist if the flight is already at full capacity.

# Write a solution to report the number of passengers who successfully 
# booked a flight (got a seat) and the number of passengers who are 
# on the waitlist for each flight.
# Return the result table ordered by flight_id in ascending order.
# Input:
# Flights table:
# +-----------+----------+
# | flight_id | capacity |
# +-----------+----------+
# | 1         | 2        |
# | 2         | 2        |
# | 3         | 1        |
# +-----------+----------+
# Passengers table:
# +--------------+-----------+
# | passenger_id | flight_id |
# +--------------+-----------+
# | 101          | 1         |
# | 102          | 1         |
# | 103          | 1         |
# | 104          | 2         |
# | 105          | 2         |
# | 106          | 3         |
# | 107          | 3         |
# +--------------+-----------+
# Output:
# +-----------+------------+--------------+
# | flight_id | booked_cnt | waitlist_cnt |
# +-----------+------------+--------------+
# | 1         | 2          | 1            |
# | 2         | 2          | 0            |
# | 3         | 1          | 1            |
# +-----------+------------+--------------+

import pandas as pd
flights = pd.DataFrame({
    'flight_id': [1, 2, 3],
    'capacity': [2, 2, 1]
})

passengers = pd.DataFrame({
    'passenger_id': [101, 102, 103, 104, 105, 106, 107],
    'flight_id': [1, 1, 1, 2, 2, 3, 3]
})


merged_df = (
    flights.merge(passengers, how = 'left', on = 'flight_id')
    .sort_values(['flight_id', 'passenger_id'])
    .assign(
        passenger_ranked = lambda d: d.groupby('flight_id')['passenger_id'].cumcount()+1
    )
    .assign(
        pass_diff = lambda d: d['capacity'] - d['passenger_ranked']
    )
    .groupby('flight_id', as_index = False)
    .agg(
        booked_cnt = ('pass_diff', lambda d: (d >= 0).sum()),
        waitlist_cnt = ('pass_diff', lambda d: (d < 0).sum())
    )
    .sort_values('flight_id')
)
print(merged_df)