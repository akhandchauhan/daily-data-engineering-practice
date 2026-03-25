# -- 1468. Calculate Salaries
# -- Description
# -- Table Salaries:
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | company_id    | int     |
# -- | employee_id   | int     |
# -- | employee_name | varchar |
# -- | salary        | int     |
# -- +---------------+---------+
# -- In SQL,(company_id, employee_id) is the primary key for this table.
# -- This table contains the company id, the id, the name, and the salary for an employee.
# -- Find the salaries of the employees after applying taxes. Round the salary to the nearest integer.
# -- The tax rate is calculated for each company based on the following criteria:

# -- 0% If the max salary of any employee in the company is less than $1000.
# -- 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
# -- 49% If the max salary of any employee in the company is greater than $10000.
# -- Return the result table in any order.
# -- The result format is in the following example.

# -- Example 1:
# -- Input: 
# -- Salaries table:
# -- +------------+-------------+---------------+--------+
# -- | company_id | employee_id | employee_name | salary |
# -- +------------+-------------+---------------+--------+
# -- | 1          | 1           | Tony          | 2000   |
# -- | 1          | 2           | Pronub        | 21300  |
# -- | 1          | 3           | Tyrrox        | 10800  |
# -- | 2          | 1           | Pam           | 300    |
# -- | 2          | 7           | Bassem        | 450    |
# -- | 2          | 9           | Hermione      | 700    |
# -- | 3          | 7           | Bocaben       | 100    |
# -- | 3          | 2           | Ognjen        | 2200   |
# -- | 3          | 13          | Nyancat       | 3300   |
# -- | 3          | 15          | Morninngcat   | 7777   |
# -- +------------+-------------+---------------+--------+
# -- Output: 
# -- +------------+-------------+---------------+--------+
# -- | company_id | employee_id | employee_name | salary |
# -- +------------+-------------+---------------+--------+
# -- | 1          | 1           | Tony          | 1020   |
# -- | 1          | 2           | Pronub        | 10863  |
# -- | 1          | 3           | Tyrrox        | 5508   |
# -- | 2          | 1           | Pam           | 300    |
# -- | 2          | 7           | Bassem        | 450    |
# -- | 2          | 9           | Hermione      | 700    |
# -- | 3          | 7           | Bocaben       | 76     |
# -- | 3          | 2           | Ognjen        | 1672   |
# -- | 3          | 13          | Nyancat       | 2508   |
# -- | 3          | 15          | Morninngcat   | 5911   |
# -- +------------+-------------+---------------+--------+

# import pandas as pd

# data = {
#     "company_id": [1, 1, 1, 2, 2, 2, 3, 3, 3, 3],
#     "employee_id": [1, 2, 3, 1, 7, 9, 7, 2, 13, 15],
#     "employee_name": ["Tony", "Pronub", "Tyrrox", "Pam", "Bassem", "Hermione", "Bocaben", "Ognjen", "Nyancat", "Morninngcat"],
#     "salary": [2000, 21300, 10800, 300, 450, 700, 100, 2200, 3300, 7777]
# }
# def checksal(maxi,salary):
#     if maxi >= 1000 and maxi <=10000:
#         salary = salary - (0.24*salary)
#     elif maxi > 10000:
#         salary = salary - (0.49*salary)
#     return round(salary)
    
# df = pd.DataFrame(data)
# df['maxi'] = df.groupby('company_id')['salary'].transform('max')
# df['salary'] = df.apply(lambda x :checksal(x['maxi'],x['salary']),axis = 1)
# df = df.drop(columns = ['maxi'])
#print(df)





