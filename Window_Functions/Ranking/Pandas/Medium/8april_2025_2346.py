# -- 2346. Compute the Rank as a Percentage 
# -- Description
# -- Table: Students
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | student_id    | int  |
# -- | department_id | int  |
# -- | mark          | int  |
# -- +---------------+------+
# -- student_id contains unique values.
# -- Each row of this table indicates a student's ID, the ID of the department in
# -- which the student enrolled, and their mark in the exam.
# -- Write a solution to report the rank of each student in their department as a percentage,
# -- where the rank as a percentage is computed using the following formula: 
# --(student_rank_in_the_department - 1) * 100 / (the_number_of_students_in_the_department - 1). 
# --The percentage should be rounded to 2 decimal places. student_rank_in_the_department is determined
# -- by descending mark, such that the student with the highest mark is rank 1. If two students get the 
# --same mark, they also get the same rank.

# -- Input: 
# -- Students table:
# -- +------------+---------------+------+
# -- | student_id | department_id | mark |
# -- +------------+---------------+------+
# -- | 2          | 2             | 650  |
# -- | 8          | 2             | 650  |
# -- | 7          | 1             | 920  |
# -- | 1          | 1             | 610  |
# -- | 3          | 1             | 530  |
# -- +------------+---------------+------+
# -- Output: 
# -- +------------+---------------+------------+
# -- | student_id | department_id | percentage |
# -- +------------+---------------+------------+
# -- | 7          | 1             | 0.0        |
# -- | 1          | 1             | 50.0       |
# -- | 3          | 1             | 100.0      |
# -- | 2          | 2             | 0.0        |
# -- | 8          | 2             | 0.0        |
# -- +------------+---------------+------------+
# -- Explanation: 
# -- For Department 1:
# --  - Student 7: percentage = (1 - 1) * 100 / (3 - 1) = 0.0
# --  - Student 1: percentage = (2 - 1) * 100 / (3 - 1) = 50.0
# --  - Student 3: percentage = (3 - 1) * 100 / (3 - 1) = 100.0
# -- For Department 2:
# --  - Student 2: percentage = (1 - 1) * 100 / (2 - 1) = 0.0
# --  - Student 8: percentage = (1 - 1) * 100 / (2 - 1) = 0.0


import pandas as pd

data = {
    'student_id': [2, 8, 7, 1, 3],
    'department_id': [2, 2, 1, 1, 1],
    'mark': [650, 650, 920, 610, 530]
}

students = pd.DataFrame(data)
students['rnk'] = students.groupby('department_id')['mark'].rank(method ='dense',ascending=False)
students['cnt'] = students.groupby('department_id')['mark'].transform('count')
students['percentage'] = ((students['rnk']-1) * 100 /(students['cnt']-1)).round(2).fillna(0)
students = students[['student_id', 'department_id', 'percentage']]
print(students)

########################################################################################################################################


# m2 

df = pd.DataFrame(data)
df = (
    df
    .assign(
        student_rank_in_the_department = lambda d : d.groupby('department_id')['mark']
                                                     .rank(method = 'dense', ascending= False),
        number_students_dept = lambda d : d.groupby('department_id')['student_id'].transform('count'),
        percentage = lambda d : ((d['student_rank_in_the_department'] -1) * 100.0/ (d['number_students_dept'] - 1)).round(2).fillna(0)
    )
    [['student_id','department_id','percentage']]
)
print(df)