# 1767. Find the Subtasks That Did Not Execute

# Table: Tasks
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | task_id        | int     |
# | subtasks_count | int     |
# +----------------+---------+
# task_id is the primary key for this table.
# Each row in this table indicates that task_id was divided into subtasks_count subtasks 
# labelled from 1 to subtasks_count.It is guaranteed that 2 <= subtasks_count <= 20.

# Table: Executed
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | task_id       | int     |
# | subtask_id    | int     |
# +---------------+---------+
# (task_id, subtask_id) is the primary key for this table.
# Each row in this table indicates that for the task task_id, the subtask with 
# ID subtask_id was executed successfully.
# It is guaranteed that subtask_id <= subtasks_count for each task_id.

# Write an  SQL query to report the IDs of the missing subtasks for each task_id.
# Return the result table in any order.

# Tasks table:
# +---------+----------------+
# | task_id | subtasks_count |
# +---------+----------------+
# | 1       | 3              |
# | 2       | 2              |
# | 3       | 4              |
# +---------+----------------

# Executed table:
# +---------+------------+
# | task_id | subtask_id |
# +---------+------------+
# | 1       | 2          |
# | 3       | 1          |
# | 3       | 2          |
# | 3       | 3          |
# | 3       | 4          |
# +---------+------------+
# Result table:
# +---------+------------+
# | task_id | subtask_id |
# +---------+------------+
# | 1       | 1          |
# | 1       | 3          |
# | 2       | 1          |
# | 2       | 2          |
# +---------+------------+
# Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, 
# so we include (1, 1) and (1, 3) in the answer.
# Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so 
# we include (2, 1) and (2, 2) in the answer.
# Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.


import pandas as pd

tasks = pd.DataFrame({
    "task_id": [1, 2, 3],
    "subtasks_count": [3, 2, 4]
})

executed = pd.DataFrame({
    "task_id": [1, 3, 3, 3, 3],
    "subtask_id": [2, 1, 2, 3, 4]
})

tasks = tasks.copy()

tasks["subtask_id"] = tasks["subtasks_count"].apply(
    lambda x: list(range(1, x + 1))
)

all_subtasks = tasks.explode("subtask_id")

all_subtasks = all_subtasks.rename(columns = {'task_id' : 'all_task_id', 'subtask_id':'all_subtask_id'})

df = (
    all_subtasks.merge(executed, how= 'left', right_on= ['task_id','subtask_id'], left_on= ['all_task_id','all_subtask_id'])
    .loc[lambda d: d['task_id'].isna()]
    [['all_task_id','all_subtask_id']]
    .rename(columns = {'all_task_id' : 'task_id', 'all_subtask_id':'subtask_id'})
)   

print(df)