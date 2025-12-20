# -- 1285. Find the Start and End Number of Continuous Ranges
# -- Description
# -- Table: Logs
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | log_id        | int     |
# -- +---------------+---------+
# -- log_id is the column of unique values for this table.
# -- Each row of this table contains the ID in a log Table.
# -- Write a solution to find the start and end number of continuous ranges in the table Logs.
# -- Return the result table ordered by start_id.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Logs table:
# -- +------------+
# -- | log_id     |
# -- +------------+
# -- | 1          |
# -- | 2          |
# -- | 3          |
# -- | 7          |
# -- | 8          |
# -- | 10         |
# -- +------------+
# -- Output: 
# -- +------------+--------------+
# -- | start_id   | end_id       |
# -- +------------+--------------+
# -- | 1          | 3            |
# -- | 7          | 8            |
# -- | 10         | 10           |
# -- +------------+--------------+


import pandas as pd

logs = {
    'log_id' : [1,2,3,7,8,10]
    }
df = pd.DataFrame(logs)


# m1 
# df = df.sort_values('log_id').reset_index(drop=True)
# df['rank'] = range(1, len(df) + 1)
# df['diff'] = df['log_id']  - df['rank']
# df = df.groupby('diff').agg(
#     start_id = ('log_id','min'),
#     end_id = ('log_id','max')
# )
# df = df.sort_values(by='start_id')[['start_id', 'end_id']]
# print(df)


# m2 somewhat tricky and misaligned
# df['diff'] = df['log_id'] - df['log_id'].rank(ascending=True)

# # Step 2: Group by the identifier and compute start and end of each range
# df = df.groupby('diff')['log_id'].agg(['min', 'max']).reset_index()
# df = df.rename(columns={'min': 'start_id', 'max': 'end_id'})

# # Step 4: Sort by 'start_id' and select the required columns
# df = df.sort_values(by='start_id')[['start_id', 'end_id']]

# print(df)



# -- 1270. All People Report to the Given Manager
# -- Description
# -- Table: Employees
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | employee_id   | int     |
# -- | employee_name | varchar |
# -- | manager_id    | int     |
# -- +---------------+---------+
# -- employee_id is the column of unique values for this table.
# -- Each row of this table indicates that the employee with ID employee_id and name employee_name 
# --reports his work to his/her direct manager with manager_id
# -- The head of the company is the employee with employee_id = 1.
# -- Write a solution to find employee_id of all employees that directly or indirectly report their 
# --work to the head of the company.
# -- The indirect relation between managers will not exceed three managers as the company is small.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:

# -- Input: 
# -- Employees table:
# -- +-------------+---------------+------------+
# -- | employee_id | employee_name | manager_id |
# -- +-------------+---------------+------------+
# -- | 1           | Boss          | 1          |
# -- | 3           | Alice         | 3          |
# -- | 2           | Bob           | 1          |
# -- | 4           | Daniel        | 2          |
# -- | 7           | Luis          | 4          |
# -- | 8           | Jhon          | 3          |
# -- | 9           | Angela        | 8          |
# -- | 77          | Robert        | 1          |
# -- +-------------+---------------+------------+
# -- Output: 
# -- +-------------+
# -- | employee_id |
# -- +-------------+
# -- | 2           |
# -- | 77          |
# -- | 4           |
# -- | 7           |
# -- +-------------+

# import pandas as pd
# data = {
#     "employee_id": [1, 3, 2, 4, 7, 8, 9, 77],
#     "employee_name": ["Boss", "Alice", "Bob", "Daniel", "Luis", "Jhon", "Angela", "Robert"],
#     "manager_id": [1, 3, 1, 2, 4, 3, 8, 1]
# }

# df1 = pd.DataFrame(data)
# df1 = df1.merge(df1,left_on='manager_id',right_on ='employee_id', how='left').merge(df1,left_on='manager_id_y',right_on ='employee_id', how='left')
# df1 = df1.query("employee_name_x != 'Boss' and manager_id == 1")[["employee_id_x"]]
# print(df1)
