# -- 2988. Manager of the Largest Department
# -- Description
# -- Table: Employees
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | emp_id      | int     |
# -- | emp_name    | varchar |
# -- | dep_id      | int     |
# -- | position    | varchar |
# -- +-------------+---------+
# -- emp_id is column of unique values for this table.
# -- This table contains emp_id, emp_name, dep_id, and position.
# -- Write a solution to find the name of the manager from the largest department. There may be 
# -- multiple largest departments when the number of employees in those departments is the same.
# -- Return the result table sorted by dep_id in ascending order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Employees table:
# -- +--------+----------+--------+---------------+
# -- | emp_id | emp_name | dep_id | position      | 
# -- +--------+----------+--------+---------------+
# -- | 156    | Michael  | 107    | Manager       |
# -- | 112    | Lucas    | 107    | Consultant    |    
# -- | 8      | Isabella | 101    | Manager       | 
# -- | 160    | Joseph   | 100    | Manager       | 
# -- | 80     | Aiden    | 100    | Engineer      | 
# -- | 190    | Skylar   | 100    | Freelancer    | 
# -- | 196    | Stella   | 101    | Coordinator   |
# -- | 167    | Audrey   | 100    | Consultant    |
# -- | 97     | Nathan   | 101    | Supervisor    |
# -- | 128    | Ian      | 101    | Administrator |
# -- | 81     | Ethan    | 107    | Administrator |
# -- +--------+----------+--------+---------------+
# -- Output
# -- +--------------+--------+
# -- | manager_name | dep_id | 
# -- +--------------+--------+
# -- | Joseph       | 100    | 
# -- | Isabella     | 101    | 
# -- +--------------+--------+
# -- Explanation
# -- - Departments with IDs 100 and 101 each has a total of 4 employees, while department 107 has 
# -- 3 employees. Since both departments 100 and 101 have an equal number of employees, their respective
# --  managers will be included.
# -- Output table is ordered by dep_id in ascending order.


import pandas as pd

data = {
    'emp_id': [156, 112, 8, 160, 80, 190, 196, 167, 97, 128, 81],
    'emp_name': ['Michael', 'Lucas', 'Isabella', 'Joseph', 'Aiden', 'Skylar', 'Stella', 'Audrey', 'Nathan', 'Ian', 'Ethan'],
    'dep_id': [107, 107, 101, 100, 100, 100, 101, 100, 101, 101, 107],
    'position': ['Manager', 'Consultant', 'Manager', 'Manager', 'Engineer', 'Freelancer', 'Coordinator', 'Consultant', 'Supervisor', 'Administrator', 'Administrator']
}

df = pd.DataFrame(data)


# m1

# df2 = df.groupby('dep_id')['emp_id'].count().reset_index()
# df_merged = pd.merge(df, df2, on ='dep_id', how= 'left').rename(columns = {'emp_id_y':"cnt"})  
# df_merged = df_merged[(df_merged['position'] == 'Manager') & (df_merged['cnt'] ==df_merged['cnt'].max())]
# df_merged = df_merged[['emp_name','dep_id']].rename(columns={'emp_name': 'manager_name'}).sort_values(by='dep_id').reset_index(drop=True)
# print(df_merged)

#m2 count window func

# df['cnt'] = df.groupby('dep_id')['emp_id'].transform('count')
# df_merged = df[(df['position'] == 'Manager') & (df['cnt'] ==df['cnt'].max())]
# df_merged = df_merged[['emp_name','dep_id']].rename(columns={'emp_name': 'manager_name'}).sort_values(by='dep_id').reset_index(drop=True)
# print(df_merged)

#m3 cnt with dense_rank

# df['cnt'] = df.groupby('dep_id')['emp_id'].transform('count')
# df['rank'] = df['cnt'].rank(method='dense', ascending=False)
# result_df = df[(df['rank'] == 1) & (df['position'] == 'Manager')][['emp_name', 'dep_id']]
# result_df = result_df.rename(columns={'emp_name': 'manager_name'}).sort_values(by='dep_id').reset_index(drop=True)
# print(result_df)

# -- 2986. Find Third Transaction
# -- Description
# -- Table: Transactions
# -- +------------------+----------+
# -- | Column Name      | Type     |
# -- +------------------+----------+
# -- | user_id          | int      |
# -- | spend            | decimal  |
# -- | transaction_date | datetime |
# -- +------------------+----------+
# -- (user_id, transaction_date) is column of unique values for this table.
# -- This table contains user_id, spend, and transaction_date.
# -- Write a solution to find the third transaction (if they have at least three transactions) 
# -- of every user, where the spending on the preceding two transactions is lower than the spending
# --  on the third transaction.
# -- Return the result table by user_id in ascending order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Transactions table:
# -- +---------+--------+---------------------+
# -- | user_id | spend  | transaction_date    | 
# -- +---------+--------+---------------------+
# -- | 1       | 65.56  | 2023-11-18 13:49:42 | 
# -- | 1       | 96.0   | 2023-11-30 02:47:26 |     
# -- | 1       | 7.44   | 2023-11-02 12:15:23 | 
# -- | 1       | 49.78  | 2023-11-12 00:13:46 | 
# -- | 2       | 40.89  | 2023-11-21 04:39:15 |  
# -- | 2       | 100.44 | 2023-11-20 07:39:34 | 
# -- | 3       | 37.33  | 2023-11-03 06:22:02 | 
# -- | 3       | 13.89  | 2023-11-11 16:00:14 | 
# -- | 3       | 7.0    | 2023-11-29 22:32:36 | 
# -- +---------+--------+---------------------+
# -- Output
# -- +---------+-------------------------+------------------------+
# -- | user_id | third_transaction_spend | third_transaction_date | 
# -- +---------+-------------------------+------------------------+
# -- | 1       | 65.56                   | 2023-11-18 13:49:42    |  
# -- +---------+-------------------------+------------------------+
# -- Explanation
# -- - For user_id 1, their third transaction occurred on 2023-11-18 at 13:49:42 with an amount of $65.56, 
# -- surpassing the expenditures of the previous two transactions which were $7.44 on 2023-11-02 at 12:15:23 
# -- and $49.78 on 2023-11-12 at 00:13:46. Thus, this third transaction will be included in the output table.
# -- - user_id 2 only has a total of 2 transactions, so there isn't a third transaction to consider.
# -- - For user_id 3, the amount of $7.0 for their third transaction is less than that of the preceding two 
# -- transactions, so it won't be included.
# -- Output table is ordered by user_id in ascending order.

import pandas as pd

data = {
    'user_id': [1, 1, 1, 1, 2, 2, 3, 3, 3],
    'spend': [65.56, 96.0, 7.44, 49.78, 40.89, 100.44, 37.33, 13.89, 7.0],
    'transaction_date': [
        '2023-11-18 13:49:42',
        '2023-11-30 02:47:26',
        '2023-11-02 12:15:23',
        '2023-11-12 00:13:46',
        '2023-11-21 04:39:15',
        '2023-11-20 07:39:34',
        '2023-11-03 06:22:02',
        '2023-11-11 16:00:14',
        '2023-11-29 22:32:36'
    ]
}

df = pd.DataFrame(data)
df['transaction_date'] = pd.to_datetime(df['transaction_date'])


#m1
# df['order_rnk'] = df.groupby('user_id')['transaction_date'].rank(method ='dense')
# df = df.query("order_rnk <= 3")
# df['spend_rnk'] = df.groupby('user_id')['spend'].rank(method ='dense')
# df = df.query("order_rnk == 3 and spend_rnk == 3")[['user_id','spend','transaction_date']]\
#             .rename(columns = {'spend': 'third_transaction_spend','transaction_date':'third_transaction_date'})
# print(df)

#m2

df = df.sort_values(by=['user_id', 'transaction_date'])
df['order_rnk'] = df.groupby('user_id')['transaction_date'].rank(method='dense')
df['spend_lag1'] = df.groupby('user_id')['spend'].shift(1)
df['spend_lag2'] = df.groupby('user_id')['spend'].shift(2)

df_result = df[
    (df['order_rnk'] == 3) &
    (df['spend'] > df['spend_lag1']) &
    (df['spend'] > df['spend_lag2'])
][['user_id', 'spend', 'transaction_date']]

df_result = df_result.rename(columns={
    'spend': 'third_transaction_spend',
    'transaction_date': 'third_transaction_date'
}).sort_values(by='user_id').reset_index(drop=True)

print(df_result)