# -- 1350. Students With Invalid Departments
# -- Description
# -- Table: Departments
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | id            | int     |
# -- | name          | varchar |
# -- +---------------+---------+
# -- In SQL, id is the primary key of this table.
# -- The table has information about the id of each department of a university.
# -- Table: Students
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | id            | int     |
# -- | name          | varchar |
# -- | department_id | int     |
# -- +---------------+---------+
# -- In SQL, id is the primary key of this table.
# -- The table has information about the id of each student at a university and the id 
# --of the department he/she studies at.
# -- Find the id and the name of all students who are enrolled in departments that no longer exist.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Departments table:
# -- +------+--------------------------+
# -- | id   | name                     |
# -- +------+--------------------------+
# -- | 1    | Electrical Engineering   |
# -- | 7    | Computer Engineering     |
# -- | 13   | Bussiness Administration |
# -- +------+--------------------------+
# -- Students table:
# -- +------+----------+---------------+
# -- | id   | name     | department_id |
# -- +------+----------+---------------+
# -- | 23   | Alice    | 1             |
# -- | 1    | Bob      | 7             |
# -- | 5    | Jennifer | 13            |
# -- | 2    | John     | 14            |
# -- | 4    | Jasmine  | 77            |
# -- | 3    | Steve    | 74            |
# -- | 6    | Luis     | 1             |
# -- | 8    | Jonathan | 7             |
# -- | 7    | Daiana   | 33            |
# -- | 11   | Madelynn | 1             |
# -- +------+----------+---------------+
# -- Output: 
# -- +------+----------+
# -- | id   | name     |
# -- +------+----------+
# -- | 2    | John     |
# -- | 7    | Daiana   |
# -- | 4    | Jasmine  |
# -- | 3    | Steve    |
# -- +------+----------+
# -- Explanation: 
# -- John, Daiana, Steve, and Jasmine are enrolled in departments 14, 33, 74, and 77 respectively. 
# --department 14, 33, 74, and 77 do not exist in the Departments table.


import pandas as pd
departments_data = {
    'id': [1, 7, 13],
    'name': ['Electrical Engineering', 'Computer Engineering', 'Bussiness Administration']
}

students_data = {
    'id': [23, 1, 5, 2, 4, 3, 6, 8, 7, 11],
    'name': ['Alice', 'Bob', 'Jennifer', 'John', 'Jasmine', 'Steve', 'Luis', 'Jonathan', 'Daiana', 'Madelynn'],
    'department_id': [1, 7, 13, 14, 77, 74, 1, 7, 33, 1]
}
departments_df = pd.DataFrame(departments_data)
students_df = pd.DataFrame(students_data)


# m1 
# df = pd.merge(students_df, departments_df, left_on ='department_id', right_on ='id', how ='left')
# df = df[df['id_y'].isnull() == True][['id_x','name_x']].rename(columns = {'id_x':'id','name_x':'name'})
# print(df)


###########################################################################################################
# m2
valid_department_ids = departments_df['id'].tolist()
invalid_students_df = students_df[~students_df['department_id'].isin(valid_department_ids)]
result = invalid_students_df[['id', 'name']]

# Show the result
print(result)

###########################################################################################################

#m3

df = (pd
      .merge(students_df,departments_df, how ='left' ,left_on ='department_id', right_on ='id')
      .query("id_y.isnull() == True")
      .rename(columns= {'id_x':'id', 'name_x':'name'})
      [['id','name']]
)

print(df)

