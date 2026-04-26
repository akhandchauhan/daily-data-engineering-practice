# 3308. Find Top Performing Driver 

# Description
# Table: Drivers
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | driver_id    | int     |
# | name         | varchar |
# | age          | int     |
# | experience   | int     |
# | accidents    | int     |
# +--------------+---------+
# (driver_id) is the unique key for this table.
# Each row includes a driver's ID, their name, age, years of driving experience, 
# and the number of accidents they’ve had.

# Table: Vehicles
# +--------------+---------+
# | vehicle_id   | int     |
# | driver_id    | int     |
# | model        | varchar |
# | fuel_type    | varchar |
# | mileage      | int     |
# +--------------+---------+
# (vehicle_id, driver_id, fuel_type) is the unique key for this table.
# Each row includes the vehicle's ID, the driver who operates it, the model,
# fuel type, and mileage.

# Table: Trips
# +--------------+---------+
# | trip_id      | int     |
# | vehicle_id   | int     |
# | distance     | int     |
# | duration     | int     |
# | rating       | int     |
# +--------------+---------+
# (trip_id) is the unique key for this table.
# Each row includes a trip's ID, the vehicle used, the distance covered 
# (in miles), the trip duration (in minutes), and the passenger's rating (1-5).

# Uber is analyzing drivers based on their trips. Write a solution to find the 
# top-performing driver for each fuel type based on the following criteria:

# A driver's performance is calculated as the average rating across all their trips.
# Average rating should be rounded to 2 decimal places.
# If two drivers have the same average rating, the driver with the longer 
# total distance traveled should be ranked higher.
# If there is still a tie, choose the driver with the fewest accidents.
# Return the result table ordered by fuel_type in ascending order.

# Drivers table:
# +-----------+----------+-----+------------+-----------+
# | driver_id | name     | age | experience | accidents |
# +-----------+----------+-----+------------+-----------+
# | 1         | Alice    | 34  | 10         | 1         |
# | 2         | Bob      | 45  | 20         | 3         |
# | 3         | Charlie  | 28  | 5          | 0         |
# +-----------+----------+-----+------------+-----------+

# Vehicles table:
# +------------+-----------+---------+-----------+---------+
# | vehicle_id | driver_id | model   | fuel_type | mileage |
# +------------+-----------+---------+-----------+---------+
# | 100        | 1         | Sedan   | Gasoline  | 20000   |
# | 101        | 2         | SUV     | Electric  | 30000   |
# | 102        | 3         | Coupe   | Gasoline  | 15000   |
# +------------+-----------+---------+-----------+---------+

# Trips table:
# +---------+------------+----------+----------+--------+
# | trip_id | vehicle_id | distance | duration | rating |
# +---------+------------+----------+----------+--------+
# | 201     | 100        | 50       | 30       | 5      |
# | 202     | 100        | 30       | 20       | 4      |
# | 203     | 101        | 100      | 60       | 4      |
# | 204     | 101        | 80       | 50       | 5      |
# | 205     | 102        | 40       | 30       | 5      |
# | 206     | 102        | 60       | 40       | 5      |
# +---------+------------+----------+----------+--------+

# Output:
# +-----------+-----------+--------+----------+
# | fuel_type | driver_id | rating | distance |
# +-----------+-----------+--------+----------+
# | Electric  | 2         | 4.50   | 180      |
# | Gasoline  | 3         | 5.00   | 100      |
# +-----------+-----------+--------+----------+
# Explanation:

# For fuel type Gasoline, both Alice (Driver 1) and Charlie (Driver 3) have trips.
# Charlie has an average rating of 5.0, while Alice has 4.5. Therefore,
# Charlie is selected.
# For fuel type Electric, Bob (Driver 2) is the only driver with an average
# rating of 4.5, so he is selected.
# The output table is ordered by fuel_type in ascending order.

import pandas as pd

drivers_df = pd.DataFrame({
    "driver_id": [1, 2, 3],
    "name": ["Alice", "Bob", "Charlie"],
    "age": [34, 45, 28],
    "experience": [10, 20, 5],
    "accidents": [1, 3, 0]
})

vehicles_df = pd.DataFrame({
    "vehicle_id": [100, 101, 102],
    "driver_id": [1, 2, 3],
    "model": ["Sedan", "SUV", "Coupe"],
    "fuel_type": ["Gasoline", "Electric", "Gasoline"],
    "mileage": [20000, 30000, 15000]
})

trips_df = pd.DataFrame({
    "trip_id": [201, 202, 203, 204, 205, 206],
    "vehicle_id": [100, 100, 101, 101, 102, 102],
    "distance": [50, 30, 100, 80, 40, 60],
    "duration": [30, 20, 60, 50, 30, 40],
    "rating": [5, 4, 4, 5, 5, 5]
})

df_merged = (
    vehicles_df.merge(trips_df, how = 'inner', on ='vehicle_id')
    .merge(drivers_df, how = 'inner', on = 'driver_id')
    .groupby(['fuel_type','driver_id'], as_index = False)
    .agg(
        rating = ('rating','mean'),
        distance = ('distance','sum'),
        accidents = ('accidents','max')
    )
    .assign(
        rating = lambda d: d['rating'].round(2)
    )
)
df_merged = df_merged.sort_values(
                by = ['fuel_type','rating','distance','accidents'],
                ascending= [True, False,False, True ]
)
df_merged['driver_ranked'] = df_merged.groupby('fuel_type').cumcount() + 1
df_merged = (
            df_merged[df_merged['driver_ranked'] == 1]
            .sort_values('fuel_type')
            [['fuel_type','driver_id','rating','distance']]
)
print(df_merged)