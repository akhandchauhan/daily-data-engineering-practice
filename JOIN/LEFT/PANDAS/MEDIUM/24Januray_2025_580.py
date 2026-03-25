# 580. Count Student Number in Departments
# Description
# Table: Student
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | student_id   | int     |
# | student_name | varchar |
# | gender       | varchar |
# | dept_id      | int     |
# +--------------+---------+
# student_id is the primary key (column with unique values) for this table.
# dept_id is a foreign key (reference column) to dept_id in the Department tables.
# Each row of this table indicates the name of a student, their gender, and the id of their department.
# Table: Department
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | dept_id     | int     |
# | dept_name   | varchar |
# +-------------+---------+
# dept_id is the primary key (column with unique values) for this table.
# Each row of this table contains the id and the name of a department.
# Write a solution to report the respective department name and number of students majoring
# in each department for all departments in the Department table (even ones with no current students).
# Return the result table ordered by student_number in descending order. In case of a tie, order them 
# by dept_name alphabetically.
# The result format is in the following example.
# Example 1:
# Input: 
# Student table:
# +------------+--------------+--------+---------+
# | student_id | student_name | gender | dept_id |
# +------------+--------------+--------+---------+
# | 1          | Jack         | M      | 1       |
# | 2          | Jane         | F      | 1       |
# | 3          | Mark         | M      | 2       |
# +------------+--------------+--------+---------+
# Department table:
# +---------+-------------+
# | dept_id | dept_name   |
# +---------+-------------+
# | 1       | Engineering |
# | 2       | Science     |
# | 3       | Law         |
# +---------+-------------+
# Output: 
# +-------------+----------------+
# | dept_name   | student_number |
# +-------------+----------------+
# | Engineering | 2              |
# | Science     | 1              |
# | Law         | 0              |
# +-------------+----------------+


import pandas as pd

# Student table
students = pd.DataFrame({
    "student_id": [1, 2, 3],
    "student_name": ["Jack", "Jane", "Mark"],
    "gender": ["M", "F", "M"],
    "dept_id": [1, 1, 2]
})

# Department table
departments = pd.DataFrame({
    "dept_id": [1, 2, 3],
    "dept_name": ["Engineering", "Science", "Law"]
})


df = (
    pd.merge(departments,students,how ='left',on ='dept_id')
    .groupby(['dept_id','dept_name'])['student_id']
    .count()
    .reset_index(name = 'student_number')
    .sort_values(by = ['student_number','dept_name'], ascending= [False, True])
    [['dept_name','student_number']]
)
print(df)

