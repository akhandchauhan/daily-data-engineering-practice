# 3278. Find Candidates for Data Scientist Position II 
# Description
# Table: Candidates
# +--------------+---------+ 
# | Column Name  | Type    | 
# +--------------+---------+ 
# | candidate_id | int     | 
# | skill        | varchar |
# | proficiency  | int     |
# +--------------+---------+
# (candidate_id, skill) is the unique key for this table.
# Each row includes candidate_id, skill, and proficiency level (1-5).
# Table: Projects

# +--------------+---------+ 
# | Column Name  | Type    | 
# +--------------+---------+ 
# | project_id   | int     | 
# | skill        | varchar |
# | importance   | int     |
# +--------------+---------+
# (project_id, skill) is the primary key for this table.
# Each row includes project_id, required skill, and its importance (1-5) for
#  the project.

# Leetcode is staffing for multiple data science projects. Write a 
# solution to find the best candidate for each project based on the following criteria:

# Candidates must have all the skills required for a project.
# Calculate a score for each candidate-project pair as follows:
# Start with 100 points
# Add 10 points for each skill where proficiency > importance
# Subtract 5 points for each skill where proficiency < importance
# If the candidate's skill proficiency equal to the project's skill 
# importance, the score remains unchanged
# Include only the top candidate (highest score) for each project. 
# If there’s a tie, choose the candidate with the lower candidate_id. 
# If there is no suitable candidate for a project, do not return that project.

# Return a result table ordered by project_id in ascending order.

# Candidates table:
# +--------------+-----------+-------------+
# | candidate_id | skill     | proficiency |
# +--------------+-----------+-------------+
# | 101          | Python    | 5           |
# | 101          | Tableau   | 3           |
# | 101          | PostgreSQL| 4           |
# | 101          | TensorFlow| 2           |
# | 102          | Python    | 4           |
# | 102          | Tableau   | 5           |
# | 102          | PostgreSQL| 4           |
# | 102          | R         | 4           |
# | 103          | Python    | 3           |
# | 103          | Tableau   | 5           |
# | 103          | PostgreSQL| 5           |
# | 103          | Spark     | 4           |
# +--------------+-----------+-------------+
# Projects table:
# +-------------+-----------+------------+
# | project_id  | skill     | importance |
# +-------------+-----------+------------+
# | 501         | Python    | 4          |
# | 501         | Tableau   | 3          |
# | 501         | PostgreSQL| 5          |
# | 502         | Python    | 3          |
# | 502         | Tableau   | 4          |
# | 502         | R         | 2          |
# +-------------+-----------+------------+
# Output:

# +-------------+--------------+-------+
# | project_id  | candidate_id | score |
# +-------------+--------------+-------+
# | 501         | 101          | 105   |
# | 502         | 102          | 130   |
# +-------------+--------------+-------+
# Explanation:

# For Project 501, Candidate 101 has the highest score of 105.
#  All other candidates have the same score but Candidate 101 has 
# the lowest candidate_id among them.
# For Project 502, Candidate 102 has the highest score of 130.
# The output table is ordered by project_id in ascending order.

import pandas as pd
import numpy as np

# Candidates DataFrame
candidates = pd.DataFrame({
    'candidate_id': [101,101,101,101,102,102,102,102,103,103,103,103],
    'skill': [
        'Python','Tableau','PostgreSQL','TensorFlow',
        'Python','Tableau','PostgreSQL','R',
        'Python','Tableau','PostgreSQL','Spark'
    ],
    'proficiency': [5,3,4,2,4,5,4,4,3,5,5,4]
})

# Projects DataFrame
projects = pd.DataFrame({
    'project_id': [501,501,501,502,502,502],
    'skill': ['Python','Tableau','PostgreSQL','Python','Tableau','R'],
    'importance': [4,3,5,3,4,2]
})
# m1 slightly wrong ordering of ranking in sequence
df = (
    projects.merge(candidates, on = 'skill')
    .assign(
        score = lambda d: 
            np.where(d['importance'] < d['proficiency'],10,
                np.where(d['importance'] > d['proficiency'],-5,0))
    )
    .groupby(['project_id','candidate_id'])
    .agg(
        score = ('score','sum'),
        skill_count = ('project_id','count')
    )
    .reset_index()
    .assign(score = lambda d: d['score'] +100 )
    .sort_values(['project_id','score','candidate_id'], ascending= [True,False,True])
    .assign(
        candidate_ranked = lambda d: d.groupby('project_id')['score'].cumcount()+1
    )
    .loc[lambda d: d.candidate_ranked == 1]
    [['project_id','skill_count','candidate_id','score']]
)

project_df = (
    projects.groupby('project_id', as_index = False)['skill']
    .count()
    .rename(columns = {'skill':'actual_skill_count'})
)
final_df = (
    df.merge(project_df, left_on = ['project_id','skill_count'], right_on = ['project_id','actual_skill_count'])
    [['project_id','candidate_id','score']]
    .sort_values('project_id')
)

print(final_df)

#######################################################################################################################
# m2 

df = (
    projects.merge(candidates, on='skill')
    .assign(
        score=lambda d: np.where(
            d['proficiency'] > d['importance'], 10,
            np.where(d['proficiency'] < d['importance'], -5, 0)
        )
    )
    .groupby(['project_id','candidate_id'], as_index=False)
    .agg(
        score=('score','sum'),
        skill_count=('skill','count')
    )
    .assign(score=lambda d: d['score'] + 100)
)

# ✅ required skills
required = (
    projects.groupby('project_id', as_index=False)
    .agg(required_skills=('skill','count'))
)

# ✅ filter FIRST (fix)
valid = df.merge(required, on='project_id') \
          .query("skill_count == required_skills")

# ✅ rank AFTER filtering (fix)
result = (
    valid.sort_values(['project_id','score','candidate_id'],
                      ascending=[True,False,True])
    .groupby('project_id', as_index=False)
    .first()[['project_id','candidate_id','score']]
)

print(result)