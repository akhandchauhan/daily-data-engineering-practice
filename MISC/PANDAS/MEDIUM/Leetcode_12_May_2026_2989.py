# 2989. Class Performance

# Table: Scores
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | student_id   | int     |
# | student_name | varchar |
# | assignment1  | int     |
# | assignment2  | int     |
# | assignment3  | int     |
# +--------------+---------+
# student_id is column of unique values for this table.
# This table contains student_id, student_name, assignment1, assignment2, and assignment3.

# Write a solution to calculate the difference in the total score (sum of all 3 assignments) 
# between the highest score obtained by students and the lowest score obtained by them.

# Return the result table in any order.
# Example 1:

# Input: 
# Scores table:
# +------------+--------------+-------------+-------------+-------------+
# | student_id | student_name | assignment1 | assignment2 | assignment3 |
# +------------+--------------+-------------+-------------+-------------+
# | 309        | Owen         | 88          | 47          | 87          |
# | 321        | Claire       | 98          | 95          | 37          |     
# | 338        | Julian       | 100         | 64          | 43          |  
# | 423        | Peyton       | 60          | 44          | 47          |  
# | 896        | David        | 32          | 37          | 50          | 
# | 235        | Camila       | 31          | 53          | 69          | 
# +------------+--------------+-------------+-------------+-------------+
# Output
# +---------------------+
# | difference_in_score | 
# +---------------------+
# | 111                 | 
# +---------------------+
# Explanation
# - student_id 309 has a total score of 88 + 47 + 87 = 222.
# - student_id 321 has a total score of 98 + 95 + 37 = 230.
# - student_id 338 has a total score of 100 + 64 + 43 = 207.
# - student_id 423 has a total score of 60 + 44 + 47 = 151.
# - student_id 896 has a total score of 32 + 37 + 50 = 119.
# - student_id 235 has a total score of 31 + 53 + 69 = 153.
# student_id 321 has the highest score of 230, while student_id 896 has the lowest score 
# of 119. Therefore, the difference between them is 111.


import pandas as pd

scores_df = pd.DataFrame({
    "student_id": [309, 321, 338, 423, 896, 235],
    "student_name": ["Owen", "Claire", "Julian", "Peyton", "David", "Camila"],
    "assignment1": [88, 98, 100, 60, 32, 31],
    "assignment2": [47, 95, 64, 44, 37, 53],
    "assignment3": [87, 37, 43, 47, 50, 69]
})

scores = scores_df.copy()
scores['total_scores'] = scores['assignment1'] + scores['assignment2'] +scores['assignment3'] 

max_difference_in_score = max(scores['total_scores']) - min(scores['total_scores'])

result = pd.DataFrame({'max_difference_in_score' :[max_difference_in_score]})
print(result)