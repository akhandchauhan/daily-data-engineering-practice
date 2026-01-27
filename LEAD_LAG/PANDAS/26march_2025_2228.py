# -- 2228. Users With Two Purchases Within Seven Days
# -- Description
# -- Table: Purchases
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | purchase_id   | int  |
# -- | user_id       | int  |
# -- | purchase_date | date |
# -- +---------------+------+
# -- purchase_id is the primary key for this table.
# -- This table contains logs of the dates that users purchased from a certain retailer
# -- Write an  SQL query to report the IDs of the users that made any two purchases at most 7 days apart.
# -- Return the result table ordered by user_id. 


# -- Purchases table:
# -- +-------------+---------+---------------+
# -- | purchase_id | user_id | purchase_date |
# -- +-------------+---------+---------------+
# -- | 4           | 2       | 2022-03-13    |
# -- | 1           | 5       | 2022-02-11    |
# -- | 3           | 7       | 2022-06-19    |
# -- | 6           | 2       | 2022-03-20    |
# -- | 5           | 7       | 2022-06-19    |
# -- | 2           | 2       | 2022-06-08    |
# -- +-------------+---------+---------------+
# -- Output: 
# -- +---------+
# -- | user_id |
# -- +---------+
# -- | 2       |
# -- | 7       |
# -- +---------+
# -- Explanation: 
# -- User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the 
# --second purchase is within 7 days of the first purchase, we add their ID.
# -- User 5 had only 1 purchase.
# -- User 7 had two purchases on the same day so we add their ID.

import pandas as pd

data = {
    'purchase_id': [4, 1, 3, 6, 5, 2],
    'user_id': [2, 5, 7, 2, 7, 2],
    'purchase_date': ['2022-03-13', '2022-02-11', '2022-06-19', '2022-03-20', '2022-06-19', '2022-06-08']
}

df = pd.DataFrame(data)
df['purchase_date'] = pd.to_datetime(df['purchase_date'])

# m1

# df = df.sort_values(by ='purchase_date')
# df['nxt_date'] = df.groupby('user_id')['purchase_date'].shift(1)
# df = df[df['nxt_date'].dt.day - df['purchase_date'].dt.day <= 7][['user_id']].drop_duplicates()
# print(df)


# Filter rows where the difference between the current and next purchase is 7 days or fewer
# df_filtered = df[df['nxt_date'] - df['purchase_date'] <= pd.Timedelta(days=7)]


############################################################################################################################################

# m2 

# df['purchase_date'] = pd.to_datetime(df['purchase_date'])
# df = df.sort_values(by = ['user_id','purchase_date'])
# df['next_purchase_date'] = df.groupby('user_id')['purchase_date'].shift(-1)
# df['days_diff'] = (df['next_purchase_date'] - df['purchase_date']).dt.days

# df = df.query('days_diff <= 7')[['user_id']].drop_duplicates().sort_values('user_id')
# print(df)


############################################################################################################################################


#m3

df = (df.merge(df, how = 'inner', on ='user_id')
        .query('purchase_id_x < purchase_id_y')
)
df['days_diff'] = (df['purchase_date_y'] - df['purchase_date_x']).dt.days

df = df.query('days_diff <= 7')[['user_id']].drop_duplicates().sort_values('user_id')
print(df)