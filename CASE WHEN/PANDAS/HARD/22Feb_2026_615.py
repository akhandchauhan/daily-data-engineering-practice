# 615. Average Salary Departments VS Company 
# Table: Salary
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | id          | int  |
# | employee_id | int  |
# | amount      | int  |
# | pay_date    | date |
# +-------------+------+
# In SQL, id is the primary key column for this table.
# Each row of this table indicates the salary of an employee in one month.
# employee_id is a foreign key (reference column) from the Employee table.

# Table: Employee
# +---------------+------+
# | Column Name   | Type |
# +---------------+------+
# | employee_id   | int  |
# | department_id | int  |
# +---------------+------+
# In SQL, employee_id is the primary key column for this table.
# Each row of this table indicates the department of an employee.

# Find the comparison result (higher/lower/same) of the average salary of employees 
# in a department to the company's average salary.
# Return the result table in any order.
# Example 1:

# Input: 
# Salary table:
# +----+-------------+--------+------------+
# | id | employee_id | amount | pay_date   |
# +----+-------------+--------+------------+
# | 1  | 1           | 9000   | 2017/03/31 |
# | 2  | 2           | 6000   | 2017/03/31 |
# | 3  | 3           | 10000  | 2017/03/31 |
# | 4  | 1           | 7000   | 2017/02/28 |
# | 5  | 2           | 6000   | 2017/02/28 |
# | 6  | 3           | 8000   | 2017/02/28 |
# +----+-------------+--------+------------+
# Employee table:
# +-------------+---------------+
# | employee_id | department_id |
# +-------------+---------------+
# | 1           | 1             |
# | 2           | 2             |
# | 3           | 2             |
# +-------------+---------------+
# Output: 
# +-----------+---------------+------------+
# | pay_month | department_id | comparison |
# +-----------+---------------+------------+
# | 2017-02   | 1             | same       |
# | 2017-03   | 1             | higher     |
# | 2017-02   | 2             | same       |
# | 2017-03   | 2             | lower      |
# +-----------+---------------+------------+
# Explanation: 
# In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
# The average salary for department '1' is 9000, which is the salary of employee_id '1' 
# since there is only one employee in this department. So the comparison result is 'higher' 
# since 9000 > 8333.33 obviously.
# The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of 
# employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.

# With he same formula for the average salary comparison in February, the result
#  is 'same' since both the department '1' and '2' have the same average salary
#  with the company, which is 7000.



import pandas as pd
import datetime as dt
import numpy as np
 
# Salary table
salary = pd.DataFrame({
    "id": [1, 2, 3, 4, 5, 6],
    "employee_id": [1, 2, 3, 1, 2, 3],
    "amount": [9000, 6000, 10000, 7000, 6000, 8000],
    "pay_date": pd.to_datetime([
        "2017-03-31",
        "2017-03-31",
        "2017-03-31",
        "2017-02-28",
        "2017-02-28",
        "2017-02-28"
    ])
})

# Employee table
employee = pd.DataFrame({
    "employee_id": [1, 2, 3],
    "department_id": [1, 2, 2]
})

# m1 using join 

# wrong method
#salary['pay_month'] = (salary['pay_date'].dt.year).astype(str) + "-" + salary['pay_date'].dt.month.astype(str)
# salary['pay_month'] = salary['pay_date'].dt.strftime('%Y-%m')

# employee_avg_salary = (salary
#                        .groupby('pay_month')
#                        ['amount'].mean()
#                        .reset_index()
# )

# department_avg_salary = (
#                         salary.merge(employee, on ='employee_id')
#                         .groupby(['department_id','pay_month'])
#                         ['amount'].mean()
#                         .reset_index()
# )

# df = employee_avg_salary.merge(department_avg_salary, on ='pay_month')


# conditions = [
#     df['amount_y'] > df['amount_x'],
#     df['amount_y'] < df['amount_x']
# ]

# values = [
#     'higher',
#     'lower'
# ]

# df['comparison'] = np.select(conditions, values, default = 'same')
# df = df[['pay_month','department_id','comparison']]
# print(df)


##################################################################################################################

# m2

# salary['pay_month'] = salary['pay_date'].dt.strftime('%Y-%m')

# df = salary.merge(employee, on ='employee_id')
# df['employee_average_salary'] = df.groupby('pay_month')['amount'].transform('mean')
# df['department_average_salary'] = df.groupby(['department_id','pay_month'])['amount'].transform('mean')

# conditions = [
#     df['department_average_salary'] > df['employee_average_salary'],
#     df['department_average_salary'] < df['employee_average_salary']
# ]

# values = [
#     'higher',
#     'lower'
# ]

# df['comparison'] = np.select(conditions, values, default = 'same')
# df = df[['pay_month','department_id','comparison']].drop_duplicates()
# print(df)


##################################################################################################################################################

#m3

salary['pay_month'] = salary['pay_date'].dt.strftime('%Y-%m')

df = salary.merge(employee, on ='employee_id')
df['employee_average_salary'] = df.groupby('pay_month')['amount'].transform('mean')
df['department_average_salary'] = df.groupby(['department_id','pay_month'])['amount'].transform('mean')

conditions = [
    df['department_average_salary'] > df['employee_average_salary'],
    df['department_average_salary'] < df['employee_average_salary']
]

values = [
    'higher',
    'lower'
]

df['comparison'] = np.select(conditions, values, default = 'same')
df = df.groupby(['pay_month','department_id'])['comparison'].max().reset_index()
print(df)