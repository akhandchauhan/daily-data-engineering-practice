# -- 3166. Calculate Parking Fees and Duration 
# -- Description
# -- Table: ParkingTransactions
# -- +--------------+-----------+
# -- | Column Name  | Type      |
# -- +--------------+-----------+
# -- | lot_id       | int       |
# -- | car_id       | int       |
# -- | entry_time   | datetime  |
# -- | exit_time    | datetime  |
# -- | fee_paid     | decimal   |
# -- +--------------+-----------+
# -- (lot_id, car_id, entry_time) is the primary key (combination of columns with unique values) 
# --for this table.
# -- Each row of this table contains the ID of the parking lot, the ID of the car, the entry and 
# --exit times, and the fee paid for the parking duration.
# -- Write a solution to find the total parking fee paid by each car across all parking lots, and 
# --the average hourly fee (rounded to 2 decimal places) paid by each car. Also, find the parking 
# --lot where each car spent the most total time.
# -- Return the result table ordered by car_id in ascending order.

# -- ParkingTransactions table:
# -- +--------+--------+---------------------+---------------------+----------+
# -- | lot_id | car_id | entry_time          | exit_time           | fee_paid |
# -- +--------+--------+---------------------+---------------------+----------+
# -- | 1      | 1001   | 2023-06-01 08:00:00 | 2023-06-01 10:30:00 | 5.00     |
# -- | 1      | 1001   | 2023-06-02 11:00:00 | 2023-06-02 12:45:00 | 3.00     |
# -- | 2      | 1001   | 2023-06-01 10:45:00 | 2023-06-01 12:00:00 | 6.00     |
# -- | 2      | 1002   | 2023-06-01 09:00:00 | 2023-06-01 11:30:00 | 4.00     |
# -- | 3      | 1001   | 2023-06-03 07:00:00 | 2023-06-03 09:00:00 | 4.00     |
# -- | 3      | 1002   | 2023-06-02 12:00:00 | 2023-06-02 14:00:00 | 2.00     |
# -- +--------+--------+---------------------+---------------------+----------+
# -- Output:
# -- +--------+----------------+----------------+---------------+
# -- | car_id | total_fee_paid | avg_hourly_fee | most_time_lot |
# -- +--------+----------------+----------------+---------------+
# -- | 1001   | 18.00          | 2.40           | 1             |
# -- | 1002   | 6.00           | 1.33           | 2             |
# -- +--------+----------------+----------------+---------------+
# -- Explanation:
# -- For car ID 1001:
# -- From 2023-06-01 08:00:00 to 2023-06-01 10:30:00 in lot 1: 2.5 hours, fee 5.00
# -- From 2023-06-02 11:00:00 to 2023-06-02 12:45:00 in lot 1: 1.75 hours, fee 3.00
# -- From 2023-06-01 10:45:00 to 2023-06-01 12:00:00 in lot 2: 1.25 hours, fee 6.00
# -- From 2023-06-03 07:00:00 to 2023-06-03 09:00:00 in lot 3: 2 hours, fee 4.00
# -- Total fee paid: 18.00, total hours: 7.5, average hourly fee: 2.40, most time spent 
# --in lot 1: 4.25 hours.
# -- For car ID 1002:
# -- From 2023-06-01 09:00:00 to 2023-06-01 11:30:00 in lot 2: 2.5 hours, fee 4.00
# -- From 2023-06-02 12:00:00 to 2023-06-02 14:00:00 in lot 3: 2 hours, fee 2.00
# -- Total fee paid: 6.00, total hours: 4.5, average hourly fee: 1.33, most time spent in 
# --lot 2: 2.5 hours.
# -- Note: Output table is ordered by car_id in ascending order.


import pandas as pd

data = {
    'lot_id': [1, 1, 2, 2, 3, 3],
    'car_id': [1001, 1001, 1001, 1002, 1001, 1002],
    'entry_time': ['2023-06-01 08:00:00', '2023-06-02 11:00:00', '2023-06-01 10:45:00', 
                   '2023-06-01 09:00:00', '2023-06-03 07:00:00', '2023-06-02 12:00:00'],
    'exit_time': ['2023-06-01 10:30:00', '2023-06-02 12:45:00', '2023-06-01 12:00:00',
                  '2023-06-01 11:30:00', '2023-06-03 09:00:00', '2023-06-02 14:00:00'],
    'fee_paid': [5.00, 3.00, 6.00, 4.00, 4.00, 2.00]
}

parking_transactions = pd.DataFrame(data)
parking_transactions['entry_time'] = pd.to_datetime(parking_transactions['entry_time'])
parking_transactions['exit_time'] = pd.to_datetime(parking_transactions['exit_time'])

# Calculate duration in hours
parking_transactions['duration_hours'] = (parking_transactions['exit_time'] - parking_transactions['entry_time']).\
                                            dt.total_seconds() / 3600

# First group by lot_id and car_id (your approach)
lot_car_metrics = parking_transactions.groupby(['lot_id', 'car_id']).agg(
    fee_paid_lot=('fee_paid', 'sum'),
    total_hours_lot=('duration_hours', 'sum')
).reset_index()

# Now calculate the required metrics by car_id
total_fees = lot_car_metrics.groupby('car_id')['fee_paid_lot'].sum().reset_index()
total_hours = lot_car_metrics.groupby('car_id')['total_hours_lot'].sum().reset_index()

# Calculate average hourly fee
summary = pd.merge(total_fees, total_hours, on='car_id')
summary['avg_hourly_fee'] = (summary['fee_paid_lot'] / summary['total_hours_lot']).round(2)

# Find the lot where each car spent the most time
most_time_lot = lot_car_metrics.loc[lot_car_metrics.groupby('car_id')['total_hours_lot'].idxmax()][['car_id', 'lot_id']]
most_time_lot.columns = ['car_id', 'most_time_lot']

# Merge all results
result = pd.merge(summary, most_time_lot, on='car_id')
result = result[['car_id', 'fee_paid_lot', 'avg_hourly_fee', 'most_time_lot']]
result.columns = ['car_id', 'total_fee_paid', 'avg_hourly_fee', 'most_time_lot']

# Sort by car_id
result = result.sort_values('car_id').reset_index(drop=True)

print(result)


############################################################################################

# m2 

import pandas as pd
import datetime as dt

pd.set_option('display.max_columns', None)

data = {
    'lot_id': [1, 1, 2, 2, 3, 3],
    'car_id': [1001, 1001, 1001, 1002, 1001, 1002],
    'entry_time': ['2023-06-01 08:00:00', '2023-06-02 11:00:00', '2023-06-01 10:45:00', 
                   '2023-06-01 09:00:00', '2023-06-03 07:00:00', '2023-06-02 12:00:00'],
    'exit_time': ['2023-06-01 10:30:00', '2023-06-02 12:45:00', '2023-06-01 12:00:00',
                  '2023-06-01 11:30:00', '2023-06-03 09:00:00', '2023-06-02 14:00:00'],
    'fee_paid': [5.00, 3.00, 6.00, 4.00, 4.00, 2.00]
}

df = pd.DataFrame(data)


df['entry_time'] = pd.to_datetime(df['entry_time'])
df['exit_time'] = pd.to_datetime(df['exit_time'])

base_df = (
    df
    .assign(
        time_parked = lambda d : (d['exit_time'] - d['entry_time']).dt.seconds/3600
    )
    .groupby(['lot_id','car_id'])
    .agg(
        total_fee_paid = ('fee_paid','sum'),
        time_parked = ('time_parked','sum')
    )
    .reset_index()
)

fee_time_df = (
    base_df.groupby('car_id', as_index = False)
    .agg(
        total_fee_paid = ('total_fee_paid','sum'),
        time_parked = ('time_parked','sum')
    )
    .assign(
        avg_hourly_fee = lambda d : (d['total_fee_paid']/d['time_parked']).round(2),
        total_fee_paid = lambda d: (d['total_fee_paid'].round(2))
    )
    [['car_id','total_fee_paid','avg_hourly_fee']]
    
)

parking_rank_df = base_df.copy()

parking_rank_df = (
    base_df
    .sort_values(['car_id','time_parked','lot_id'], ascending=[True, False, True])
    .assign(ranking=lambda d: d.groupby('car_id').cumcount() + 1)
)

parking_rank_df = (
     parking_rank_df.query("ranking == 1")
     .rename(columns= {'lot_id':'most_time_lot'})
     [['car_id','most_time_lot']]
 )


final_df = (
    fee_time_df.merge(parking_rank_df , on = 'car_id')
    [['car_id','total_fee_paid','avg_hourly_fee','most_time_lot']]
)
print(final_df)

