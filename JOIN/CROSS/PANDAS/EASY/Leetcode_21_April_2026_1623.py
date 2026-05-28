# 1623. All Valid Triplets That Can Represent a Country
# SQL Schema 
# Table: SchoolA
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | student_id    | int     |
# | student_name  | varchar |
# +---------------+---------+
# student_id is the primary key for this table.
# Each row of this table contains the name and the id of a student in school A.
# All student_name are distinct.

# Table: SchoolB

# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | student_id    | int     |
# | student_name  | varchar |
# +---------------+---------+
# student_id is the primary key for this table.
# Each row of this table contains the name and the id of a student in school B.
# All student_name are distinct.

# Table: SchoolC

# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | student_id    | int     |
# | student_name  | varchar |
# +---------------+---------+
# student_id is the primary key for this table.
# Each row of this table contains the name and the id of a student in school C.
# All student_name are distinct.

# There is a country with three schools, where each student is enrolled in 
# exactly one school. The country is joining a competition and wants to 
# select one student from each school to represent the country such that:

# member_A is selected from SchoolA,
# member_B is selected from SchoolB,
# member_C is selected from SchoolC, and
# The selected students' names and IDs are pairwise distinct (i.e. no 
# two students share the same name, and no two students share the same ID).

# Write an  SQL query to find all the possible triplets representing the 
# country under the given constraints.

# SchoolA table:
# +------------+--------------+
# | student_id | student_name |
# +------------+--------------+
# | 1          | Alice        |
# | 2          | Bob          |
# +------------+--------------+

# SchoolB table:
# +------------+--------------+
# | student_id | student_name |
# +------------+--------------+
# | 3          | Tom          |
# +------------+--------------+

# SchoolC table:
# +------------+--------------+
# | student_id | student_name |
# +------------+--------------+
# | 3          | Tom          |
# | 2          | Jerry        |
# | 10         | Alice        |
# +------------+--------------+

# Result table:
# +----------+----------+----------+
# | member_A | member_B | member_C |
# +----------+----------+----------+
# | Alice    | Tom      | Jerry    |
# | Bob      | Tom      | Alice    |
# +----------+----------+----------+
# Let us see all the possible triplets.
# - (Alice, Tom, Tom) --> Rejected because member_B and member_C have the same 
# name and the same ID.
# - (Alice, Tom, Jerry) --> Valid triplet.
# - (Alice, Tom, Alice) --> Rejected because member_A and member_C have the same name.
# - (Bob, Tom, Tom) --> Rejected because member_B and member_C have the same name 
# and the same ID.
# - (Bob, Tom, Jerry) --> Rejected because member_A and member_C have the same ID.
# - (Bob, Tom, Alice) --> Valid triplet.

import pandas as pd

# SchoolA
schoolA = pd.DataFrame({
    "student_id": [1, 2],
    "student_name": ["Alice", "Bob"]
})

# SchoolB
schoolB = pd.DataFrame({
    "student_id": [3],
    "student_name": ["Tom"]
})

# SchoolC
schoolC = pd.DataFrame({
    "student_id": [3, 2, 10],
    "student_name": ["Tom", "Jerry", "Alice"]
})

df =(
    schoolA.merge(schoolB, how ='cross')
    .merge(schoolC, how= 'cross')

    .query('student_id_x != student_id_y and student_id_y != student_id and student_id != student_id_x and student_name_x != student_name_y and student_name_y != student_name and student_name_x != student_name')
    [['student_name_x','student_name_y','student_name']]
    .rename(columns = {
        'student_name_x' : 'member_A',
        'student_name_y' : 'member_B',
        'student_name' : 'member_C'
    })
)
print(df)

##########################################################################################
# m2

# Step 1: Rename columns to avoid confusion
A = schoolA.rename(columns={'student_id': 'id_A', 'student_name': 'name_A'})
B = schoolB.rename(columns={'student_id': 'id_B', 'student_name': 'name_B'})
C = schoolC.rename(columns={'student_id': 'id_C', 'student_name': 'name_C'})

# Step 2: Generate all combinations (CROSS JOIN)
df = A.merge(B, how='cross').merge(C, how='cross')

# Step 3: Apply constraints (pairwise distinct IDs and names)
df = df[
    (df['id_A'] != df['id_B']) &
    (df['id_A'] != df['id_C']) &
    (df['id_B'] != df['id_C']) &
    (df['name_A'] != df['name_B']) &
    (df['name_A'] != df['name_C']) &
    (df['name_B'] != df['name_C'])
]

# Step 4: Select final columns
result = df[['name_A', 'name_B', 'name_C']].rename(columns={
    'name_A': 'member_A',
    'name_B': 'member_B',
    'name_C': 'member_C'
}).reset_index(drop=True)

print(result)