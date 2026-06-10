# 3188. Find Top Scoring Students II
# Table: students
# +-------------+----------+
# | Column Name | Type     |
# +-------------+----------+
# | student_id  | int      |
# | name        | varchar  |
# | major       | varchar  |
# +-------------+----------+
# student_id is the primary key for this table.

# Table: courses
# +-------------+-------------------+
# | Column Name | Type              |
# +-------------+-------------------+
# | course_id   | int               |
# | name        | varchar           |
# | credits     | int               |
# | major       | varchar           |
# | mandatory   | enum('yes','no')  |
# +-------------+-------------------+
# course_id is the primary key for this table.

# Table: enrollments
# +-------------+----------+
# | Column Name | Type     |
# +-------------+----------+
# | student_id  | int      |
# | course_id   | int      |
# | semester    | varchar  |
# | grade       | varchar  |
# | GPA         | decimal  |
# +-------------+----------+
# (student_id, course_id, semester) is the primary key for this table.

# Write a solution to find the students who meet the following criteria:
# Have taken all mandatory courses and at least two elective courses offered in their major.
# Achieved a grade of A in all mandatory courses and at least B in elective courses.
# Maintained an average GPA of at least 2.5 across all their courses.
# Return the result ordered by student_id in ascending order.

# students table:
# +------------+------------------+------------------+
# | student_id | name             | major            |
# +------------+------------------+------------------+
# | 1          | Alice            | Computer Science |
# | 2          | Bob              | Computer Science |
# | 3          | Charlie          | Mathematics      |
# | 4          | David            | Mathematics      |
# +------------+------------------+------------------+

# courses table:
# +-----------+-------------------+---------+------------------+----------+
# | course_id | name              | credits | major            | mandatory|
# +-----------+-------------------+---------+------------------+----------+
# | 101       | Algorithms        | 3       | Computer Science | yes      |
# | 102       | Data Structures   | 3       | Computer Science | yes      |
# | 103       | Calculus          | 4       | Mathematics      | yes      |
# | 104       | Linear Algebra    | 4       | Mathematics      | yes      |
# | 105       | Machine Learning  | 3       | Computer Science | no       |
# | 106       | Probability       | 3       | Mathematics      | no       |
# | 107       | Operating Systems | 3       | Computer Science | no       |
# | 108       | Statistics        | 3       | Mathematics      | no       |
# +-----------+-------------------+---------+------------------+----------+

# enrollments table:
# +------------+-----------+-------------+-------+-----+
# | student_id | course_id | semester    | grade | GPA |
# +------------+-----------+-------------+-------+-----+
# | 1          | 101       | Fall 2023   | A     | 4.0 |
# | 1          | 102       | Spring 2023 | A     | 4.0 |
# | 1          | 105       | Spring 2023 | A     | 4.0 |
# | 1          | 107       | Fall 2023   | B     | 3.5 |
# | 2          | 101       | Fall 2023   | A     | 4.0 |
# | 2          | 102       | Spring 2023 | B     | 3.0 |
# | 3          | 103       | Fall 2023   | A     | 4.0 |
# | 3          | 104       | Spring 2023 | A     | 4.0 |
# | 3          | 106       | Spring 2023 | A     | 4.0 |
# | 3          | 108       | Fall 2023   | B     | 3.5 |
# | 4          | 103       | Fall 2023   | B     | 3.0 |
# | 4          | 104       | Spring 2023 | B     | 3.0 |
# +------------+-----------+-------------+-------+-----+

# Output:
# +------------+
# | student_id |
# +------------+
# | 1          |
# | 3          |
# +------------+

# Explanation:
# Alice (student_id 1) is a Computer Science major and has taken both Algorithms and
# Data Structures, receiving an A in both. She has also taken Machine Learning and
# Operating Systems as electives, receiving an A and B respectively.
# Bob (student_id 2) is a Computer Science major but did not receive an A in all
# required courses.
# Charlie (student_id 3) is a Mathematics major and has taken both Calculus and
# Linear Algebra, receiving an A in both. He has also taken Probability and Statistics
# as electives, receiving an A and B respectively.
# David (student_id 4) is a Mathematics major but did not receive an A in all
# required courses.
# Note: Output table is ordered by student_id in ascending order.

import pandas as pd
import numpy as np

students = pd.DataFrame({
    "student_id": [1, 2, 3, 4],
    "name": ["Alice", "Bob", "Charlie", "David"],
    "major": ["Computer Science", "Computer Science", "Mathematics", "Mathematics"]
})

courses = pd.DataFrame({
    "course_id": [101, 102, 103, 104, 105, 106, 107, 108],
    "name": ["Algorithms", "Data Structures", "Calculus", "Linear Algebra",
             "Machine Learning", "Probability", "Operating Systems", "Statistics"],
    "credits": [3, 3, 4, 4, 3, 3, 3, 3],
    "major": ["Computer Science", "Computer Science", "Mathematics", "Mathematics",
              "Computer Science", "Mathematics", "Computer Science", "Mathematics"],
    "mandatory": ["yes", "yes", "yes", "yes", "no", "no", "no", "no"]
})

enrollments = pd.DataFrame({
    "student_id": [1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 4, 4],
    "course_id":  [101, 102, 105, 107, 101, 102, 103, 104, 106, 108, 103, 104],
    "semester":   ["Fall 2023", "Spring 2023", "Spring 2023", "Fall 2023",
                   "Fall 2023", "Spring 2023", "Fall 2023", "Spring 2023",
                   "Spring 2023", "Fall 2023", "Fall 2023", "Spring 2023"],
    "grade": ["A", "A", "A", "B", "A", "B", "A", "A", "A", "B", "B", "B"],
    "GPA":   [4.0, 4.0, 4.0, 3.5, 4.0, 3.0, 4.0, 4.0, 4.0, 3.5, 3.0, 3.0]
})

pd.set_option("display.max_columns",None)

df_merged = (
    students.merge(enrollments, on = 'student_id')
    .merge(courses, on = 'course_id')
    .assign(
        mandatory_course_flag = lambda d: np.where(
                                    (d['grade'] == 'A') & 
                                    (d['mandatory'] == 'yes') & 
                                    (d['major_x'] == d['major_y']),1,0
        ),
        elective_ab = lambda d: np.where(
                                    (d['grade'].isin(['A','B'])) & 
                                    (d['mandatory'] == 'no') & 
                                    (d['major_x'] == d['major_y']),1,0
        ),
        elective_total = lambda d: np.where(
                                    (d['mandatory'] == 'no') & 
                                    (d['major_x'] == d['major_y']),1,0
        )
    )
    .groupby(['student_id','major_x'], as_index= False)
    .agg(
        avg_gpa = ('GPA','mean'),
        mandatory_courses_count = ('mandatory_course_flag','sum'),
        elective_ab_count = ('elective_ab','sum'),
        elective_total = ('elective_total','sum')
    )
    .rename(columns = {'major_x':'major'})
    .loc[lambda d: (d['avg_gpa'] >= 2.5) &
                    (d['elective_ab_count'] == d['elective_total']) &
                     (d['elective_total'] >= 2)
        ]
)

final_df = (
    courses[courses['mandatory'] == 'yes']
    .groupby('major', as_index = False)['course_id']
    .count()
    .rename(columns = {'course_id':'actual_mandatory_course_count'})
    .merge(df_merged, on = 'major')
    .loc[lambda d: d['actual_mandatory_course_count'] == d['mandatory_courses_count']]
    [['student_id']]
    .sort_values('student_id')
)
print(final_df)