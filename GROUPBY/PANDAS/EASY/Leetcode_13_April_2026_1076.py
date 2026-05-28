# 1076. Project Employees II
# Description
# Table: Project
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | project_id  | int     |
# | employee_id | int     |
# +-------------+---------+
# (project_id, employee_id) is the primary key (combination of columns with 
# unique values) of this table.
# employee_id is a foreign key (reference column) to Employee table.
# Each row of this table indicates that the employee with employee_id is 
# working on the project with project_id.
 
# Table: Employee
# +------------------+---------+
# | Column Name      | Type    |
# +------------------+---------+
# | employee_id      | int     |
# | name             | varchar |
# | experience_years | int     |
# +------------------+---------+
# employee_id is the primary key (column with unique values) of this table.
# Each row of this table contains information about one employee.

# Write a solution to report all the projects that have the most employees.
# Return the result table in any order.
# Input: 
# Project table:
# +-------------+-------------+
# | project_id  | employee_id |
# +-------------+-------------+
# | 1           | 1           |
# | 1           | 2           |
# | 1           | 3           |
# | 2           | 1           |
# | 2           | 4           |
# +-------------+-------------+
# Employee table:
# +-------------+--------+------------------+
# | employee_id | name   | experience_years |
# +-------------+--------+------------------+
# | 1           | Khaled | 3                |
# | 2           | Ali    | 2                |
# | 3           | John   | 1                |
# | 4           | Doe    | 2                |
# +-------------+--------+------------------+
# Output: 
# +-------------+
# | project_id  |
# +-------------+
# | 1           |
# +-------------+
# Explanation: The first project has 3 employees while the second one has 2.

import pandas as pd

project = pd.DataFrame({
    "project_id": [1, 1, 1, 2, 2],
    "employee_id": [1, 2, 3, 1, 4]
})

# m1 

df = (
    project.groupby('project_id')['employee_id']
    .count()
    .reset_index(name = 'employee_count')
)
max_emp_count = df['employee_count'].max()
df = df[df['employee_count'] == max_emp_count][['project_id']]
print(df)

##########################################################################################
# m2 

df = (
    project.groupby('project_id')['employee_id']
    .count()
    .reset_index(name = 'employee_count')
    .assign(
        employee_ranked = lambda d: (
            d['employee_count'].rank(method = 'dense', ascending= False)
        )
    )
    .loc[lambda d: d.employee_ranked == 1]
    [['project_id']]
)

print(df)

##########################################################################################
# m3
df = (
    project
    .groupby('project_id')
    .size()
    .reset_index(name='employee_count')
)

result = df[df['employee_count'] == df['employee_count'].max()][['project_id']]