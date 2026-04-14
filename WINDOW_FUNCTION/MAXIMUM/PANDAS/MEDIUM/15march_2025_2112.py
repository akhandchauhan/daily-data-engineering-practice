# -- 2112. The Airport With the Most Traffic
# -- Description
# -- Table: Flights
# -- +-------------------+------+
# -- | Column Name       | Type |
# -- +-------------------+------+
# -- | departure_airport | int  |
# -- | arrival_airport   | int  |
# -- | flights_count     | int  |
# -- +-------------------+------+
# -- (departure_airport, arrival_airport) is the primary key column for this table.
# -- Each row of this table indicates that there were flights_count flights that departed from departure_airport and 
# --arrived at arrival_airport.
# -- Write an  SQL query to report the ID of the airport with the most traffic. The airport with the most traffic
# -- is the airport that -- has the largest total number of flights that either departed from or arrived at the airport. 
# --If there is more than one airport with the most traffic, report them all.
# -- Return the result table in any order.
# -- The query result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Flights table:
# -- +-------------------+-----------------+---------------+
# -- | departure_airport | arrival_airport | flights_count |
# -- +-------------------+-----------------+---------------+
# -- | 1                 | 2               | 4             |
# -- | 2                 | 1               | 5             |
# -- | 2                 | 4               | 5             |
# -- +-------------------+-----------------+---------------+
# -- Output: 
# -- +------------+
# -- | airport_id |
# -- +------------+
# -- | 2          |
# -- +------------+
# -- Explanation: 
# -- Airport 1 was engaged with 9 flights (4 departures, 5 arrivals).
# -- Airport 2 was engaged with 14 flights (10 departures, 4 arrivals).
# -- Airport 4 was engaged with 5 flights (5 arrivals).
# -- The airport with the most traffic is airport 2.
# -- Example 2:
# -- Input: 
# -- Flights table:
# -- +-------------------+-----------------+---------------+
# -- | departure_airport | arrival_airport | flights_count |
# -- +-------------------+-----------------+---------------+
# -- | 1                 | 2               | 4             |
# -- | 2                 | 1               | 5             |
# -- | 3                 | 4               | 5             |
# -- | 4                 | 3               | 4             |
# -- | 5                 | 6               | 7             |
# -- +-------------------+-----------------+---------------+
# -- Output: 
# -- +------------+
# -- | airport_id |
# -- +------------+
# -- | 1          |
# -- | 2          |
# -- | 3          |
# -- | 4          |
# -- +------------+
# -- Explanation: 
# -- Airport 1 was engaged with 9 flights (4 departures, 5 arrivals).
# -- Airport 2 was engaged with 9 flights (5 departures, 4 arrivals).
# -- Airport 3 was engaged with 9 flights (5 departures, 4 arrivals).
# -- Airport 4 was engaged with 9 flights (4 departures, 5 arrivals).
# -- Airport 5 was engaged with 7 flights (7 departures).
# -- Airport 6 was engaged with 7 flights (7 arrivals).
# -- The airports with the most traffic are airports 1, 2, 3, and 4.a


import pandas as pd

# Creating the Flights DataFrame
data = {
    'departure_airport': [1, 2, 2],
    'arrival_airport': [2, 1, 4],
    'flights_count': [4, 5, 5]
}

df1 = pd.DataFrame(data)


df2 = df1[["arrival_airport", "departure_airport", "flights_count"]]


df = pd.concat([df1, df2])
print(df)

# Now calculating the total flights for each airport (departure + arrival)
airport_traffic = df.groupby(['departure_airport']).agg({'flights_count': 'sum'}).reset_index()
airport_traffic.rename(columns={'departure_airport': 'airport_id'}, inplace=True)

# Grouping for arrival_airport traffic
arrival_traffic = df.groupby(['arrival_airport']).agg({'flights_count': 'sum'}).reset_index()
arrival_traffic.rename(columns={'arrival_airport': 'airport_id'}, inplace=True)

# Merging both departure and arrival traffic
total_traffic = pd.concat([airport_traffic, arrival_traffic]).groupby('airport_id').agg({'flights_count': 'sum'}).reset_index()

# Find the airport(s) with the most traffic
max_traffic = total_traffic['flights_count'].max()
result = total_traffic[total_traffic['flights_count'] == max_traffic]

# Displaying the result
print(result[['airport_id']])
