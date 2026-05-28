# -- 2238. Number of Times a Driver Was a Passenger

# -- Table: Rides
# -- +--------------+------+
# -- | Column Name  | Type |
# -- +--------------+------+
# -- | ride_id      | int  |
# -- | driver_id    | int  |
# -- | passenger_id | int  |
# -- +--------------+------+
# -- ride_id is the primary key for this table.
# -- Each row of this table contains the ID of the driver and the ID of the passenger that rode 
# in ride_id. Note that driver_id != passenger_id.

# -- Write an  SQL query to report the ID of each driver and the number of
#   times they were a passenger.

# -- Return the result table in any order.
# -- Rides table:
# -- +---------+-----------+--------------+
# -- | ride_id | driver_id | passenger_id |
# -- +---------+-----------+--------------+
# -- | 1       | 7         | 1            |
# -- | 2       | 7         | 2            |
# -- | 3       | 11        | 1            |
# -- | 4       | 11        | 7            |
# -- | 5       | 11        | 7            |
# -- | 6       | 11        | 3            |
# -- +---------+-----------+--------------+
# -- Output: 
# -- +-----------+-----+
# -- | driver_id | cnt |
# -- +-----------+-----+
# -- | 7         | 2   |
# -- | 11        | 0   |
# -- +-----------+-----+
# -- Explanation: 
# -- There are two drivers in all the given rides: 7 and 11.
# -- The driver with ID = 7 was a passenger two times.
# -- The driver with ID = 11 was never a passenger.


import pandas as pd

# Creating the DataFrame
data = {
    "ride_id": [1, 2, 3, 4, 5, 6],
    "driver_id": [7, 7, 11, 11, 11, 11],
    "passenger_id": [1, 2, 1, 7, 7, 3]
}

rides = pd.DataFrame(data)


df = rides.copy()
df = df['driver_id'].drop_duplicates()
df = pd.DataFrame(df)
df = df.merge(rides,left_on ='driver_id',right_on='passenger_id',how ='left')
df = df.groupby('driver_id_x').size().reset_index(name='cnt').rename(columns = {'driver_id_x':'driver_id'})

print(df)

##########################################################################################################
# m2
driver_df = rides[['driver_id']].drop_duplicates()

passenger_counts = (
    rides.groupby('passenger_id', as_index=False)
    .size()
    .rename(columns={
        'passenger_id':'driver_id',
        'size':'cnt'
    })
)

df = (
    driver_df
    .merge(passenger_counts, on='driver_id', how='left')
    .fillna({'cnt':0})
    .astype({'cnt':'int'})
)