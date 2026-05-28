# 2668. Find Latest Salaries
# Description
# Table: Salary
# +---------------+---------+ 
# | Column Name   | Type    | 
# +---------------+---------+ 
# | emp_id        | int     | 
# | firstname     | varchar |
# | lastname      | varchar |
# | salary        | varchar |
# | department_id | varchar |
# +---------------+---------+
# (emp_id, salary) is the primary key for this table.
# Each row contains employees details and their yearly salaries, however, 
# some of the records are old and contain outdated salary information. 

# Write an  SQL query to find the current salary of each employee assuming 
# that salaries increase each year. Output their emp_id, firstname, lastname,
#  salary, and department_id.

# Return the result table ordered by emp_id in ascending order.

# Input:
# Salary table:
# +--------+-----------+----------+--------+---------------+
# | emp_id | firstname | lastname | salary | department_id |
# +--------+-----------+----------+--------+---------------+ 
# | 1      | Todd      | Wilson   | 110000 | D1006         |
# | 1      | Todd      | Wilson   | 106119 | D1006         | 
# | 2      | Justin    | Simon    | 128922 | D1005         | 
# | 2      | Justin    | Simon    | 128922 | D1005         | 
# | 3      | Kelly     | Rosario  | 42689  | D1002         | 
# | 4      | Patricia  | Powell   | 162825 | D1004         |
# | 4      | Patricia  | Powell   | 170000 | D1004         |
# | 5      | Sherry    | Golden   | 44101  | D1002         | 
# | 6      | Natasha   | Swanson  | 79632  | D1005         | 
# | 6      | Natasha   | Swanson  | 90000  | D1005         |
# +--------+-----------+----------+--------+---------------+
# Output:
# +--------+-----------+----------+--------+---------------+
# | emp_id | firstname | lastname | salary | department_id |
# +--------+-----------+----------+--------+---------------+ 
# | 1      | Todd      | Wilson   | 110000 | D1006         |
# | 2      | Justin    | Simon    | 130000 | D1005         | 
# | 3      | Kelly     | Rosario  | 42689  | D1002         | 
# | 4      | Patricia  | Powell   | 170000 | D1004         |
# | 5      | Sherry    | Golden   | 44101  | D1002         | 
# | 6      | Natasha   | Swanson  | 90000  | D1005         |
# +--------+-----------+----------+--------+---------------+

# Explanation:
# - emp_id 1 has two records with a salary of 110000, 106119 out of these 110000 
# is an updated salary (Assuming salary is increasing each year)
# - emp_id 2 has two records with a salary of 128922, 128922 out of these 130000 
# is an updated salary.
# - emp_id 3 has only one salary record so that is already an updated salary.
# - emp_id 4 has two records with a salary of 162825, 170000 out of these 170000
#  is an updated salary.
# - emp_id 5 has only one salary record so that is already an updated salary.
# - emp_id 6 has two records with a salary of 79632, 90000 out of these 90000 is 
# an updated salary.

import pandas as pd

salary = pd.DataFrame({
    "emp_id": [1, 1, 2, 2, 3, 4, 4, 5, 6, 6],
    "firstname": ["Todd", "Todd", "Justin", "Justin", "Kelly", "Patricia", "Patricia", "Sherry", "Natasha", "Natasha"],
    "lastname": ["Wilson", "Wilson", "Simon", "Simon", "Rosario", "Powell", "Powell", "Golden", "Swanson", "Swanson"],
    "salary": [110000, 106119, 128922, 128922, 42689, 162825, 170000, 44101, 79632, 90000],
    "department_id": ["D1006", "D1006", "D1005", "D1005", "D1002", "D1004", "D1004", "D1002", "D1005", "D1005"]
})

# m1 

df = (
    salary.groupby(['emp_id','firstname','lastname','department_id'])['salary']
    .max()
    .reset_index()
    [['emp_id','firstname','lastname','salary','department_id']]
)
print(df)