# 2853. Highest Salaries Difference

# Table: Salaries
# +-------------+---------+ 
# | Column Name | Type    | 
# +-------------+---------+ 
# | emp_name    | varchar | 
# | department  | varchar | 
# | salary      | int     |
# +-------------+---------+
# (emp_name, department) is the primary key for this table.
# Each row of this table contains emp_name, department and salary. There will be at 
# least one entry for the engineering and marketing departments.
# Write an  SQL query to calculate the difference between the highest salaries 
# in the marketing and engineering department. Output the absolute difference in salaries.

# Input: 
# Salaries table:
# +----------+-------------+--------+
# | emp_name | department  | salary |
# +----------+-------------+--------+
# | Kathy    | Engineering | 50000  |
# | Roy      | Marketing   | 30000  |
# | Charles  | Engineering | 45000  |
# | Jack     | Engineering | 85000  | 
# | Benjamin | Marketing   | 34000  |
# | Anthony  | Marketing   | 42000  |
# | Edward   | Engineering | 102000 |
# | Terry    | Engineering | 44000  |
# | Evelyn   | Marketing   | 53000  |
# | Arthur   | Engineering | 32000  |
# +----------+-------------+--------+
# Output: 
# +-------------------+
# | salary_difference | 
# +-------------------+
# | 49000             | 
# +-------------------+
# Explanation: 
# - The Engineering and Marketing departments have the highest salaries of 102,000 
# and 53,000, respectively. Resulting in an absolute difference of 49,000.


import pandas as pd

salaries_df = pd.DataFrame({
    "emp_name": [
        "Kathy", "Roy", "Charles", "Jack", "Benjamin",
        "Anthony", "Edward", "Terry", "Evelyn", "Arthur"
    ],
    "department": [
        "Engineering", "Marketing", "Engineering", "Engineering", "Marketing",
        "Marketing", "Engineering", "Engineering", "Marketing", "Engineering"
    ],
    "salary": [
        50000, 30000, 45000, 85000, 34000,
        42000, 102000, 44000, 53000, 32000
    ]
})

eng_sal = salaries_df[salaries_df['department'] == 'Engineering']['salary'].max()
market_sal = salaries_df[salaries_df['department'] == 'Marketing']['salary'].max()

result_df = pd.DataFrame({'salary_difference' : [abs(eng_sal - market_sal)]})

print(result_df)

#####################################################################################################
# m2

max_salaries = (
    salaries_df
    .groupby('department')['salary']
    .max()
)

result_df = pd.DataFrame({
    'salary_difference': [
        abs(
            max_salaries['Engineering']
            -
            max_salaries['Marketing']
        )
    ]
})