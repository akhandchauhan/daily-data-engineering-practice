# 569. Median Employee Salary 
# Description
# Table: Employee

# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | id           | int     |
# | company      | varchar |
# | salary       | int     |
# +--------------+---------+
# id is the primary key (column with unique values) for this table.
# Each row of this table indicates the company and the salary of one employee.

# Write a solution to find the rows that contain the median salary of each company.
# While calculating the median, when you sort the salaries of the company,
# break the ties by id.

# Return the result table in any order.
# Input: 
# Employee table:
# +----+---------+--------+
# | id | company | salary |
# +----+---------+--------+
# | 1  | A       | 2341   |
# | 2  | A       | 341    |
# | 3  | A       | 15     |
# | 4  | A       | 15314  |
# | 5  | A       | 451    |
# | 6  | A       | 513    |
# | 7  | B       | 15     |
# | 8  | B       | 13     |
# | 9  | B       | 1154   |
# | 10 | B       | 1345   |
# | 11 | B       | 1221   |
# | 12 | B       | 234    |
# | 13 | C       | 2345   |
# | 14 | C       | 2645   |
# | 15 | C       | 2645   |
# | 16 | C       | 2652   |
# | 17 | C       | 65     |
# +----+---------+--------+
# Output: 
# +----+---------+--------+
# | id | company | salary |
# +----+---------+--------+
# | 5  | A       | 451    |
# | 6  | A       | 513    |
# | 12 | B       | 234    |
# | 9  | B       | 1154   |
# | 14 | C       | 2645   |
# +----+---------+--------+
# Explanation: 
# For company A, the rows sorted are as follows:
# +----+---------+--------+
# | id | company | salary |
# +----+---------+--------+
# | 3  | A       | 15     |
# | 2  | A       | 341    |
# | 5  | A       | 451    | <-- median
# | 6  | A       | 513    | <-- median
# | 1  | A       | 2341   |
# | 4  | A       | 15314  |
# +----+---------+--------+
# For company B, the rows sorted are as follows:
# +----+---------+--------+
# | id | company | salary |
# +----+---------+--------+
# | 8  | B       | 13     |
# | 7  | B       | 15     |
# | 12 | B       | 234    | <-- median
# | 11 | B       | 1221   | <-- median
# | 9  | B       | 1154   |
# | 10 | B       | 1345   |
# +----+---------+--------+
# For company C, the rows sorted are as follows:
# +----+---------+--------+
# | id | company | salary |
# +----+---------+--------+
# | 17 | C       | 65     |
# | 13 | C       | 2345   |
# | 14 | C       | 2645   | <-- median
# | 15 | C       | 2645   | 
# | 16 | C       | 2652   |
# +----+---------+--------+

# Follow up: Could you solve it without using any built-in or window functions?


import pandas as pd
import numpy as np

data = {
    "id": [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17],
    "company": ["A","A","A","A","A","A","B","B","B","B","B","B","C","C","C","C","C"],
    "salary": [2341,341,15,15314,451,513,15,13,1154,1345,1221,234,2345,2645,2645,2652,65]
}

df = pd.DataFrame(data)
df = (
    df.sort_values(
        by=['salary', 'id'],
        ascending=[True, True]
    )
    .assign(
        company_rank=lambda d: d.groupby('company').cumcount() + 1,
        company_count=lambda d: d.groupby('company')['id'].transform('count'),
    )
    .loc[
        lambda d: (
            (d['company_count'] % 2 == 1) & 
            (d['company_rank'] == np.ceil(d['company_count'] / 2))
        ) |
        (
            (d['company_count'] % 2 == 0) &
            (
                (d['company_rank'] == d['company_count'] / 2) |
                (d['company_rank'] == d['company_count'] / 2 + 1)
            )
        )
    ]
    [['id','company','salary']]
)

print(df)
