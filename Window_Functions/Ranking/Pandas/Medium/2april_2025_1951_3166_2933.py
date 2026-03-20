# -- 1951. All the Pairs With the Maximum Number of Common Followers
# -- Description
# -- Table: Relations
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | user_id     | int  |
# -- | follower_id | int  |
# -- +-------------+------+
# -- (user_id, follower_id) is the primary key for this table.
# -- Each row of this table indicates that the user with ID follower_id is following the user 
# -- with ID user_id.
# -- Write an  SQL query to find all the pairs of users with the maximum number of common followers.
# --  In other words, if the maximum number of common followers between any two users is maxCommon, 
# --  then you have to return all pairs of users that have maxCommon common followers.SQL database courses
# -- The result table should contain the pairs user1_id and user2_id where user1_id < user2_id.
# -- Return the result table in any order.
# -- The query result format is in the following example:
# -- Relations table:
# -- +---------+-------------+
# -- | user_id | follower_id |
# -- +---------+-------------+
# -- | 1       | 3           |
# -- | 2       | 3           |
# -- | 7       | 3           |
# -- | 1       | 4           |
# -- | 2       | 4           |
# -- | 7       | 4           |
# -- | 1       | 5           |
# -- | 2       | 6           |
# -- | 7       | 5           |
# -- +--------+-------------+
# -- Result table:
# -- +----------+----------+
# -- | user1_id | user2_id |
# -- +----------+----------+
# -- | 1        | 7        |
# -- +----------+----------+
# -- Users 1 and 2 have 2 common followers (3 and 4).
# -- Users 1 and 7 have 3 common followers (3, 4, and 5).
# -- Users 2 and 7 have 2 common followers (3 and 4).
# -- Since the maximum number of common followers between any two users is 3, 
# -- we return all pairs of users with 3 common followers, which is only the pair (1, 7).
# --  We return the pair as (1, 7), not as (7, 1).
# -- Note that we do not have any information about the users that follow users 3, 4, and 
# -- 5, so we consider them to have 0 followers.

# import pandas as pd
# relations = pd.DataFrame({
#     'user_id': [1, 2, 7, 1, 2, 7, 1, 2, 7],
#     'follower_id': [3, 3, 3, 4, 4, 4, 5, 6, 5]
# })

# df = pd.merge(relations,relations,how ='cross')
# df = df.query("user_id_x < user_id_y and follower_id_x == follower_id_y")
# df= df.groupby(['user_id_x','user_id_y'])['follower_id_x'].count().reset_index()
# df = df[df['follower_id_x'] == max(df['follower_id_x'])][['user_id_x','user_id_y']].\
#          rename(columns ={'user_id_x':'user1_id','user_id_y':'user2_id'})
# print(df)

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



# -- 2993. Friday Purchases I
# -- Description
# -- Table: Purchases
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | user_id       | int  |
# -- | purchase_date | date |
# -- | amount_spend  | int  |
# -- +---------------+------+
# -- (user_id, purchase_date, amount_spend) is the primary key (combination of columns with unique values) 
# -- for this table.
# -- purchase_date will range from November 1, 2023, to November 30, 2023, inclusive of both dates.
# -- Each row contains user id, purchase date, and amount spend.
# -- Write a solution to calculate the total spending by users on each Friday of every week in 
# -- November 2023. Output only weeks that include at least one purchase on a Friday.
# -- Return the result table ordered by week of month in ascending order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Purchases table:
# -- +---------+---------------+--------------+
# -- | user_id | purchase_date | amount_spend |
# -- +---------+---------------+--------------+
# -- | 11      | 2023-11-07    | 1126         |
# -- | 15      | 2023-11-30    | 7473         |
# -- | 17      | 2023-11-14    | 2414         |
# -- | 12      | 2023-11-24    | 9692         |
# -- | 8       | 2023-11-03    | 5117         |
# -- | 1       | 2023-11-16    | 5241         |
# -- | 10      | 2023-11-12    | 8266         |
# -- | 13      | 2023-11-24    | 12000        |
# -- +---------+---------------+--------------+
# -- Output: 
# -- +---------------+---------------+--------------+
# -- | week_of_month | purchase_date | total_amount |
# -- +---------------+---------------+--------------+
# -- | 1             | 2023-11-03    | 5117         |
# -- | 4             | 2023-11-24    | 21692        |
# -- +---------------+---------------+--------------+ 
# -- Explanation: 
# -- - During the first week of November 2023, transactions amounting to $5,117 occurred on Friday, 2023-11-03.
# -- - For the second week of November 2023, there were no transactions on Friday, 2023-11-10.
# -- - Similarly, during the third week of November 2023, there were no transactions on Friday, 2023-11-17.
# -- - In the fourth week of November 2023, two transactions took place on Friday, 2023-11-24, amounting to $12,000 
# -- and $9,692 respectively, summing up to a total of $21,692.
# -- Output table is ordered by week_of_month in ascending order.

import pandas as pd

data = {
    'user_id': [11, 15, 17, 12, 8, 1, 10, 13],
    'purchase_date': ['2023-11-07', '2023-11-30', '2023-11-14', '2023-11-24', 
                     '2023-11-03', '2023-11-16', '2023-11-12', '2023-11-24'],
    'amount_spend': [1126, 7473, 2414, 9692, 5117, 5241, 8266, 12000]
}

purchases = pd.DataFrame(data)
purchases['purchase_date'] = pd.to_datetime(purchases['purchase_date'])
purchases['day_of_week'] = purchases['purchase_date'].dt.dayofweek
purchases['week_of_month'] = (purchases['purchase_date'].dt.day - 1) // 7 + 1

friday_purchases = purchases[purchases['day_of_week'] == 4]
result = friday_purchases.groupby(['week_of_month', 'purchase_date'])['amount_spend'].sum().reset_index()
result = result.rename(columns={'amount_spend': 'total_amount'})
result = result.sort_values('week_of_month').reset_index(drop=True)
result['purchase_date'] = result['purchase_date'].dt.strftime('%Y-%m-%d')

print(result)