# -- 1112. Highest Grade For Each Student
# -- Description
# -- Table: Enrollments
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | student_id    | int     |
# -- | course_id     | int     |
# -- | grade         | int     |
# -- +---------------+---------+
# -- (student_id, course_id) is the primary key (combination of columns with unique values) of this table.
# -- grade is never NULL.
# -- Write a solution to find the highest grade with its corresponding course for each student. 
# --In case of a tie, you should find the course with the smallest course_id.
# -- Return the result table ordered by student_id in ascending order.
# -- The result format is in the following example.
# -- Example 1:

# -- Input: 
# -- Enrollments table:
# -- +------------+-------------------+
# -- | student_id | course_id | grade |
# -- +------------+-----------+-------+
# -- | 2          | 2         | 95    |
# -- | 2          | 3         | 95    |
# -- | 1          | 1         | 90    |
# -- | 1          | 2         | 99    |
# -- | 3          | 1         | 80    |
# -- | 3          | 2         | 75    |
# -- | 3          | 3         | 82    |
# -- +------------+-----------+-------+
# -- Output: 
# -- +------------+-------------------+
# -- | student_id | course_id | grade |
# -- +------------+-----------+-------+
# -- | 1          | 2         | 99    |
# -- | 2          | 2         | 95    |
# -- | 3          | 3         | 82    |
# -- +------------+-----------+-------+



import pandas as pd

# Create the DataFrame from the provided data
data = [
    [2, 2, 95],
    [2, 3, 95],
    [1, 1, 90],
    [1, 2, 99],
    [3, 1, 80],
    [3, 2, 75],
    [3, 3, 82]
]

df = pd.DataFrame(data, columns=['student_id', 'course_id', 'grade'])

# m1 using rank
df = df.sort_values(
    by=['student_id','grade','course_id'],
    ascending=[True, False, True]
)

df['grade_rank'] = (
    df.groupby('student_id').cumcount() + 1
)

df = (
    df[df['grade_rank'] == 1]
    [['student_id','course_id','grade']]
    .sort_values('student_id')
)

print(df)
###########################################################################################################

#m2 using head

df = (
    df.sort_values(
        ['student_id','grade','course_id'],
        ascending=[True, False, True]
    )
    .groupby('student_id')
    .head(1)
    .sort_values('student_id')
)

print(df)

