# 1412. Find the Quiet Students in All Exams
# SQL Schema 
# Table: Student
# +---------------------+---------+
# | Column Name         | Type    |
# +---------------------+---------+
# | student_id          | int     |
# | student_name        | varchar |
# +---------------------+---------+
# student_id is the primary key for this table.
# student_name is the name of the student.

# Table: Exam
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | exam_id       | int     |
# | student_id    | int     |
# | score         | int     |
# +---------------+---------+
# (exam_id, student_id) is the primary key for this table.
# Student with student_id got score points in exam with id exam_id.
 

# A "quite" student is the one who took at least one exam and didn't score neither 
# the high score nor the low score.
# Write an SQL query to report the students (student_id, student_name) being "quiet" 
# in ALL exams.

# Don't return the student who has never taken any exam. Return the result table ordered by student_id.

# Student table:
# +-------------+---------------+
# | student_id  | student_name  |
# +-------------+---------------+
# | 1           | Daniel        |
# | 2           | Jade          |
# | 3           | Stella        |
# | 4           | Jonathan      |
# | 5           | Will          |
# +-------------+---------------+

# Exam table:
# +------------+--------------+-----------+
# | exam_id    | student_id   | score     |
# +------------+--------------+-----------+
# | 10         |     1        |    70     |
# | 10         |     2        |    80     |
# | 10         |     3        |    90     |
# | 20         |     1        |    80     |
# | 30         |     1        |    70     |
# | 30         |     3        |    80     |
# | 30         |     4        |    90     |
# | 40         |     1        |    60     |
# | 40         |     2        |    70     |
# | 40         |     4        |    80     |
# +------------+--------------+-----------+

# Result table:
# +-------------+---------------+
# | student_id  | student_name  |
# +-------------+---------------+
# | 2           | Jade          |
# +-------------+---------------+

# For exam 1: Student 1 and 3 hold the lowest and high score respectively.
# For exam 2: Student 1 hold both highest and lowest score.
# For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
# Student 2 and 5 have never got the highest or lowest in any of the exam.
# Since student 5 is not taking any exam, he is excluded from the result.
# So, we only return the information of Student 2.

import pandas as pd

# Student DataFrame
student_data = {
    "student_id": [1, 2, 3, 4, 5],
    "student_name": ["Daniel", "Jade", "Stella", "Jonathan", "Will"]
}

student_df = pd.DataFrame(student_data)

# Exam DataFrame
exam_data = {
    "exam_id": [10, 10, 10, 20, 30, 30, 30, 40, 40, 40],
    "student_id": [1, 2, 3, 1, 1, 3, 4, 1, 2, 4],
    "score": [70, 80, 90, 80, 70, 80, 90, 60, 70, 80]
}

exam_df = pd.DataFrame(exam_data)


df_merged = (
    student_df.merge(exam_df,on ='student_id')
    .groupby(['exam_id'], as_index = False)
    .agg(
        max_score = ('score','max'),
        min_score = ('score','min')
    )
)

final = (
    df_merged.merge(exam_df, on ='exam_id')
    .assign(
        max_score_flag=lambda d: (d['score'] == d['max_score']).astype(int),
        min_score_flag=lambda d: (d['score'] == d['min_score']).astype(int)
    )
    .groupby('student_id', as_index = False)
    .agg(
        max_score_count = ('max_score_flag','sum'),
        min_score_count = ('min_score_flag','sum')
    )
    .loc[lambda d: (d['max_score_count'] == 0) & (d['min_score_count'] == 0)]
    [['student_id']]
    .merge(student_df, on = 'student_id')
    .reset_index(drop = True)
    .sort_values(['student_id'])
)

print(final)


###############################################################################################

# m2
import numpy as np

final2 = (
    exam_df.assign(
        max_score=lambda d: d.groupby('exam_id')['score'].transform('max'),
        min_score=lambda d: d.groupby('exam_id')['score'].transform('min'),
        max_score_flag=lambda d: np.where(d['score'] == d['max_score'],1,0),
        min_score_flag=lambda d: np.where(d['score'] == d['min_score'],1,0)
    )
    .groupby('student_id', as_index = False)
    .agg(
        max_score_count = ('max_score_flag','sum'),
        min_score_count = ('min_score_flag','sum')
    )
    .loc[lambda d: (d['max_score_count'] == 0) & (d['min_score_count'] == 0)]
    [['student_id']]
    .merge(student_df, on = 'student_id')
    .reset_index(drop = True)
    .sort_values(['student_id'])
)

print(final2)

###############################################################################################

# m3
import numpy as np

final3 = (
    exam_df.assign(
        max_score = lambda d: d.groupby('exam_id')['score'].transform('max'),
        min_score = lambda d: d.groupby('exam_id')['score'].transform('min'),
        flag = lambda d: np.where((d['max_score'] == d['score']) | (d['min_score'] == d['score']),1,0)
    )
    .groupby('student_id', as_index = False)
    .agg(
        score_count = ('flag','max')
    )
    .loc[lambda d: (d['score_count'] == 0)]
    [['student_id']]
    .merge(student_df, on = 'student_id')
    .reset_index(drop = True)
    .sort_values(['student_id'])
)

print(final3)