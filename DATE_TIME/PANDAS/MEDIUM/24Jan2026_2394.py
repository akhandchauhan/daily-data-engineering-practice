# 2394. Employees With Deductions
# Description
# Table: Employees
# +--------------+------+
# | Column Name  | Type |
# +--------------+------+
# | employee_id  | int  |
# | needed_hours | int  |
# +--------------+------+
# employee_id is the primary key for this table.
# Each row contains the id of an employee and the minimum number of
# hours needed for them to work to get their salary.
# Table: Logs
# +-------------+----------+
# | Column Name | Type     |
# +-------------+----------+
# | employee_id | int      |
# | in_time     | datetime |
# | out_time    | datetime |
# +-------------+----------+
# (employee_id, in_time, out_time) is the primary key for this table.
# Each row of this table shows the time stamps for an employee. in_time is the time the employee
# started to work, and out_time is the time the employee ended work.
# All the times are in October 2022. out_time can be one day after in_time which means
# the employee worked after the midnight.

# In a company, each employee must work a certain number of hours every month. 
# Employees work in sessions. The number of hours an employee worked can be calculated from the 
# sum of the number of minutes the employee worked in all of their sessions. The number of minutes 
# in each session is rounded up.

# For example, if the employee worked for 51 minutes and 2 seconds in a session, we consider it 52 minutes.
# Write an SQL query to report the IDs of the employees that will be deducted. In other words, report the IDs
# of the employees that did not work the needed hours.

# Return the result table in any order.
# Example 1:

# Input: 
# Employees table:
# +-------------+--------------+
# | employee_id | needed_hours |
# +-------------+--------------+
# | 1           | 20           |
# | 2           | 12           |
# | 3           | 2            |
# +-------------+--------------+
# Logs table:
# +-------------+---------------------+---------------------+
# | employee_id | in_time             | out_time            |
# +-------------+---------------------+---------------------+
# | 1           | 2022-10-01 09:00:00 | 2022-10-01 17:00:00 |
# | 1           | 2022-10-06 09:05:04 | 2022-10-06 17:09:03 |
# | 1           | 2022-10-12 23:00:00 | 2022-10-13 03:00:01 |
# | 2           | 2022-10-29 12:00:00 | 2022-10-29 23:58:58 |
# +-------------+---------------------+---------------------+
# Output: 
# +-------------+
# | employee_id |
# +-------------+
# | 2           |
# | 3           |
# +-------------+
# Explanation: 
# Employee 1:
#  - Worked for three sessions:
#     - On 2022-10-01, they worked for 8 hours.
#     - On 2022-10-06, they worked for 8 hours and 4 minutes.
#     - On 2022-10-12, they worked for 4 hours and 1 minute. Note that they worked through midnight.
#  - Employee 1 worked a total of 20 hours and 5 minutes across sessions and will not be deducted.
# Employee 2:
#  - Worked for one session:
#     - On 2022-10-29, they worked for 11 hours and 59 minutes.
#  - Employee 2 did not work their hours and will be deducted.
# Employee 3:
#  - Did not work any session.
#  - Employee 3 did not work their hours and will be deducted.


import pandas as pd
import datetime as dt

# Employees DataFrame
employees = pd.DataFrame({
    "employee_id": [1, 2, 3],
    "needed_hours": [20, 12, 2]
})

# Logs DataFrame
logs = pd.DataFrame({
    "employee_id": [1, 1, 1, 2],
    "in_time": [
        "2022-10-01 09:00:00",
        "2022-10-06 09:05:04",
        "2022-10-12 23:00:00",
        "2022-10-29 12:00:00"
    ],
    "out_time": [
        "2022-10-01 17:00:00",
        "2022-10-06 17:09:03",
        "2022-10-13 03:00:01",
        "2022-10-29 23:58:58"
    ]
})

# m1
# # Convert to datetime
# logs["in_time"] = pd.to_datetime(logs["in_time"])
# logs["out_time"] = pd.to_datetime(logs["out_time"])

# logs['diff'] = ((logs['out_time'].dt.second - logs['in_time'].dt.second)/60).ceil()
# logs = logs.groupby('employee_id')['diff'].sum().reset_index()

# df = (employees.merge(logs, how = 'left', on ='employee_id')
#                 .fillna(0)
#               .query("logs < needed_hours * 60")
# )
# print(df)

##############################################################################################

#m2

import pandas as pd
import numpy as np

# Convert to datetime
logs["in_time"] = pd.to_datetime(logs["in_time"])
logs["out_time"] = pd.to_datetime(logs["out_time"])

# ✅Correct session duration in minutes (rounded up per session)
logs["session_minutes"] = np.ceil(
    (logs["out_time"] - logs["in_time"]).dt.total_seconds() / 60
)

# Aggregate per employee
worked_minutes = (
    logs.groupby("employee_id")["session_minutes"]
    .sum()
    .reset_index()
)

# Merge with employees
result = (
    employees.merge(worked_minutes, how="left", on="employee_id")
    .fillna(0)
)

# Filter employees with deductions
result = result[
    result["session_minutes"] < result["needed_hours"] * 60
][["employee_id"]]

print(result)
