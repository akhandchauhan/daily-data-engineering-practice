# .2072 The Winner University 
# Description
# Table: NewYork
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | student_id  | int  |
# | score       | int  |
# +-------------+------+
# student_id is the primary key for this table.
# Each row contains information about the score of one student from New York University in an exam.
# Table: California
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | student_id  | int  |
# | score       | int  |
# +-------------+------+
# student_id is the primary key for this table.
# Each row contains information about the score of one student from California University in an exam.
# There is a competition between New York University and California University.
# The competition is held between the same number of students from both universities. 
# The university that has more excellent students wins the competition. If the two universities have
# the same number of excellent students, the competition ends in a draw.
# An excellent student is a student that scored 90% or more in the exam.
# Write an  SQL query to report:
# "New York University" if New York University wins the competition.
# "California University" if California University wins the competition.
# "No Winner" if the competition ends in a draw.
# The query result format is in the following example.
# Example 1:
# Input: 
# NewYork table:
# +------------+-------+
# | student_id | score |
# +------------+-------+
# | 1          | 90    |
# | 2          | 87    |
# +------------+-------+
# California table:
# +------------+-------+
# | student_id | score |
# +------------+-------+
# | 2          | 89    |
# | 3          | 88    |
# +------------+-------+
# Output: 
# +---------------------+
# | winner              |
# +---------------------+
# | New York University |
# +---------------------+
# Explanation:
# New York University has 1 excellent student, and California University has 0 excellent students.

import pandas as pd
import numpy as np

newyork = pd.DataFrame({
    "student_id": [1, 2],
    "score": [90, 87]
})

california = pd.DataFrame({
    "student_id": [2, 3],
    "score": [89, 88]
})

# newyork_count = newyork.query("score >= 90").size
# california_count = california.query("score >= 90").size

# conditions = [
#     newyork_count > california_count,
#     newyork_count < california_count,
#     newyork_count == california_count
# ]

# values = ['New York University','California University','No Winner']

# result = np.select(
#     conditions,
#     values,
#     default='No Winner'
# )

# print(result)

#############################################################

# m2 

ny_count = (newyork["score"] >= 90).sum()
ca_count = (california["score"] >= 90).sum()

if ny_count > ca_count:
    winner = "New York University"
elif ny_count < ca_count:
    winner = "California University"
else:
    winner = "No Winner"

print(winner)
