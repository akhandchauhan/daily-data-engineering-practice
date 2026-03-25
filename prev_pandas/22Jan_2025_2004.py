# 2004. The Number of Seniors and Juniors to Join the Company
# Description
# Table: Candidates
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | employee_id | int  |
# | experience  | enum |
# | salary      | int  |
# +-------------+------+
# employee_id is the primary key column for this table.
# experience is an enum with one of the values ('Senior', 'Junior').
# Each row of this table indicates the id of a candidate, their monthly salary, and their experience.
# A company wants to hire new employees. The budget of the company for the salaries is $70000.
# The company's criteria for hiring are:
# Hiring the largest number of seniors.
# After hiring the maximum number of seniors, use the remaining budget to hire the largest number of juniors.
# Write an SQL query to find the number of seniors and juniors hired under the mentioned criteria.
# Return the result table in any order.
# The query result format is in the following example.
# Example 1:
# Input: 
# Candidates table:
# +-------------+------------+--------+
# | employee_id | experience | salary |
# +-------------+------------+--------+
# | 1           | Junior     | 10000  |
# | 9           | Junior     | 10000  |
# | 2           | Senior     | 20000  |
# | 11          | Senior     | 20000  |
# | 13          | Senior     | 50000  |
# | 4           | Junior     | 40000  |
# +-------------+------------+--------+
# Output: 
# +------------+---------------------+
# | experience | accepted_candidates |
# +------------+---------------------+
# | Senior     | 2                   |
# | Junior     | 2                   |
# +------------+---------------------+
# Explanation: 
# We can hire 2 seniors with IDs (2, 11). Since the budget is $70000 and the sum of their salaries is $40000,
# we still have $30000 but they are not enough to hire the senior candidate with ID 13.
# We can hire 2 juniors with IDs (1, 9). Since the remaining budget is $30000 and the sum of their salaries
# is $20000, we still have $10000 but they are not enough to hire the junior candidate with ID 4.
# Example 2:
# Input: 
# Candidates table:
# +-------------+------------+--------+
# | employee_id | experience | salary |
# +-------------+------------+--------+
# | 1           | Junior     | 10000  |
# | 9           | Junior     | 10000  |
# | 2           | Senior     | 80000  |
# | 11          | Senior     | 80000  |
# | 13          | Senior     | 80000  |
# | 4           | Junior     | 40000  |
# +-------------+------------+--------+
# Output: 
# +------------+---------------------+
# | experience | accepted_candidates |
# +------------+---------------------+
# | Senior     | 0                   |
# | Junior     | 3                   |
# +------------+---------------------+
# Explanation: 
# We cannot hire any seniors with the current budget as we need at least $80000 to hire one senior.
# We can hire all three juniors with the remaining budget.

import pandas as pd

candidates = pd.DataFrame({
    "employee_id": [1, 9, 2, 11, 13, 4],
    "experience": ["Junior", "Junior", "Senior", "Senior", "Senior", "Junior"],
    "salary": [10000, 10000, 20000, 20000, 50000, 40000]
})

candidates = candidates.sort_values(by = ['experience','salary'])
candidates['running_total'] = candidates.groupby('experience')['salary'].cumsum() 
senior_candidate = (candidates.query('experience == "Senior" and running_total <= 70000')
                               .groupby('experience')
                               .agg(
                                   senior_sal_allot = ('salary','sum'),
                                   accepted_candidates = ('employee_id','count')
                               )
                               .reset_index()
                               .fillna(0)                    
)
senior_sal = senior_candidate['senior_sal_allot'].sum()
senior_candidate = senior_candidate[['experience','accepted_candidates']]
junior_candidate = (candidates[(candidates['experience'] == "Junior") & (candidates['running_total'] <= (70000 - senior_sal))]
                               .groupby('experience')
                               .agg(
                                   senior_sal_allot = ('salary','sum'),
                                   accepted_candidates = ('employee_id','count')
                               )
                               .reset_index()
                               .fillna(0)
                               [['experience','accepted_candidates']]
)
df = pd.concat([senior_candidate,junior_candidate])
print(df)



##################################################################################################################################

# m2 

import pandas as pd

BUDGET = 70000

candidates = pd.DataFrame({
    "employee_id": [1, 9, 2, 11, 13, 4],
    "experience": ["Junior", "Junior", "Senior", "Senior", "Senior", "Junior"],
    "salary": [10000, 10000, 20000, 20000, 50000, 40000]
})

# ---------- Seniors ----------
seniors = (
    candidates[candidates["experience"] == "Senior"]
    .sort_values("salary")
)

seniors["running_total"] = seniors["salary"].cumsum()

senior_hired = seniors[seniors["running_total"] <= BUDGET]

senior_count = len(senior_hired)
senior_spent = senior_hired["salary"].sum()

# ---------- Juniors ----------
remaining_budget = BUDGET - senior_spent

juniors = (
    candidates[candidates["experience"] == "Junior"]
    .sort_values("salary")
)

juniors["running_total"] = juniors["salary"].cumsum()

junior_hired = juniors[juniors["running_total"] <= remaining_budget]

junior_count = len(junior_hired)

# ---------- Result ----------
result = pd.DataFrame({
    "experience": ["Senior", "Junior"],
    "accepted_candidates": [senior_count, junior_count]
})

print(result)
