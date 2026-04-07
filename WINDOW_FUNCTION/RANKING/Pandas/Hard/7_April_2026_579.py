# 579. Find Cumulative Salary of an Employee
# Description
# Table: Employee

# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | id          | int  |
# | month       | int  |
# | salary      | int  |
# +-------------+------+
# (id, month) is the primary key (combination of columns with unique values) 
# for this table.
# Each row in the table indicates the salary of an employee in one month
# during the year 2020.  

# Write a solution to calculate the cumulative salary summary for every 
# employee in a single unified table.

# The cumulative salary summary for an employee can be calculated as follows:

# For each month that the employee worked, sum up the salaries in that month 
# and the previous two months. This is their 3-month sum for that month. 
# If an employee did not work for the company in previous months, their
# effective salary for those months is 0.
# Do not include the 3-month sum for the most recent month that the employee 
# worked for in the summary.
# Do not include the 3-month sum for any month the employee did not work.
# Return the result table ordered by id in ascending order. In case of a tie, 
# order it by month in descending order.

# The result format is in the following example.

# Example 1:

# Input: 
# Employee table:
# +----+-------+--------+
# | id | month | salary |
# +----+-------+--------+
# | 1  | 1     | 20     |
# | 2  | 1     | 20     |
# | 1  | 2     | 30     |
# | 2  | 2     | 30     |
# | 3  | 2     | 40     |
# | 1  | 3     | 40     |
# | 3  | 3     | 60     |
# | 1  | 4     | 60     |
# | 3  | 4     | 70     |
# | 1  | 7     | 90     |
# | 1  | 8     | 90     |
# +----+-------+--------+
# Output: 
# +----+-------+--------+
# | id | month | Salary |
# +----+-------+--------+
# | 1  | 7     | 90     |
# | 1  | 4     | 130    |
# | 1  | 3     | 90     |
# | 1  | 2     | 50     |
# | 1  | 1     | 20     |
# | 2  | 1     | 20     |
# | 3  | 3     | 100    |
# | 3  | 2     | 40     |
# +----+-------+--------+
# Explanation: 
# Employee '1' has five salary records excluding their most recent month '8':
# - 90 for month '7'.
# - 60 for month '4'.
# - 40 for month '3'.
# - 30 for month '2'.
# - 20 for month '1'.
# So the cumulative salary summary for this employee is:
# +----+-------+--------+
# | id | month | salary |
# +----+-------+--------+
# | 1  | 7     | 90     |  (90 + 0 + 0)
# | 1  | 4     | 130    |  (60 + 40 + 30)
# | 1  | 3     | 90     |  (40 + 30 + 20)
# | 1  | 2     | 50     |  (30 + 20 + 0)
# | 1  | 1     | 20     |  (20 + 0 + 0)
# +----+-------+--------+
# Note that the 3-month sum for month '7' is 90 because they did not
# work during month '6' or month '5'.

# Employee '2' only has one salary record (month '1') excluding 
# their most recent month '2'.
# +----+-------+--------+
# | id | month | salary |
# +----+-------+--------+
# | 2  | 1     | 20     |  (20 + 0 + 0)
# +----+-------+--------+

# Employee '3' has two salary records excluding their most recent month '4':
# - 60 for month '3'.
# - 40 for month '2'.
# So the cumulative salary summary for this employee is:
# +----+-------+--------+
# | id | month | salary |
# +----+-------+--------+
# | 3  | 3     | 100    |  (60 + 40 + 0)
# | 3  | 2     | 40     |  (40 + 0 + 0)



import pandas as pd

employee_df = pd.DataFrame({
    'id': [1, 2, 1, 2, 3, 1, 3, 1, 3, 1, 1],
    'month': [1, 1, 2, 2, 2, 3, 3, 4, 4, 7, 8],
    'salary': [20, 20, 30, 30, 40, 40, 60, 60, 70, 90, 90]
})

df = employee_df.copy()

latest = df.groupby('id')['month'].max().reset_index(name='max_month')

df = (
    df.merge(df, on='id', suffixes=('_cur', '_prev'))
      .loc[lambda d: (d['month_prev'].between(d['month_cur']-2, d['month_cur']))]
      .merge(latest, on='id')
      .loc[lambda d: d['month_cur'] < d['max_month']]
      .groupby(['id', 'month_cur'], as_index=False)['salary_prev']
      .sum()
      .rename(columns={'month_cur': 'month', 'salary_prev': 'salary'})
      .sort_values(by = ['id','month'], ascending = [True, False])
      .reset_index(drop = True)
)

print(df)


