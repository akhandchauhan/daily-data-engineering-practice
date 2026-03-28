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

df2 = df.groupby('dep_id')['emp_id'].count().reset_index()
df_merged = pd.merge(df, df2, on ='dep_id').rename(columns = {'emp_id_y':"cnt"})  
df_merged = df_merged[(df_merged['position'] == 'Manager') & (df_merged['cnt'] ==df_merged['cnt'].max())]
df_merged = df_merged[['emp_name','dep_id']].rename(columns={'emp_name': 'manager_name'}).sort_values(by='dep_id').reset_index(drop=True)
print(df_merged)

#####################################################################################################################
#m2 count window func

df['cnt'] = df.groupby('dep_id')['emp_id'].transform('count')
df_merged = df[(df['position'] == 'Manager') & (df['cnt'] ==df['cnt'].max())]
df_merged = df_merged[['emp_name','dep_id']].rename(columns={'emp_name': 'manager_name'}).sort_values(by='dep_id').reset_index(drop=True)
print(df_merged)

#####################################################################################################################
#m3 cnt with dense_rank

df['cnt'] = df.groupby('dep_id')['emp_id'].transform('count')
df['rank'] = df['cnt'].rank(method='dense', ascending=False)
result_df = df[(df['rank'] == 1) & (df['position'] == 'Manager')][['emp_name', 'dep_id']]
result_df = result_df.rename(columns={'emp_name': 'manager_name'}).sort_values(by='dep_id').reset_index(drop=True)
print(result_df)

#####################################################################################################################
# m4 latest method

df = (
    df
    .assign(
        employee_count = lambda d: d.groupby('dep_id')['emp_id'].transform('count'),
        emp_rank = lambda d : d['employee_count'].rank(method = 'dense', ascending= False)
    )
    .query("emp_rank == 1 and position == 'Manager' ")
    [['emp_name','dep_id']]
    .rename(columns = {'emp_name':'manager_name'})
    .sort_values('dep_id')
)
print(df)
