# -- 2041. Accepted Candidates From the Interviews
# -- Description
# -- Table: Candidates
# -- +--------------+----------+
# -- | Column Name  | Type     |
# -- +--------------+----------+
# -- | candidate_id | int      |
# -- | name         | varchar  |
# -- | years_of_exp | int      |
# -- | interview_id | int      |
# -- +--------------+----------+
# -- candidate_id is the primary key column for this table.
# -- Each row of this table indicates the name of a candidate, their number of years of experience, 
# -- and their interview ID.
# -- Table: Rounds
# -- +--------------+------+
# -- | Column Name  | Type |
# -- +--------------+------+
# -- | interview_id | int  |
# -- | round_id     | int  |
# -- | score        | int  |
# -- +--------------+------+
# -- (interview_id, round_id) is the primary key column for this table.
# -- Each row of this table indicates the score of one round of an interview.
# -- Write an  SQL query to report the IDs of the candidates who have at 
# -- least two years of experience and the sum of the score of their interview rounds is strictly greater than 15.
# -- Return the result table in any order.
# -- The query result format is in the following example.
# -- Example 1:

# -- Input: 
# -- Candidates table:
# -- +--------------+---------+--------------+--------------+
# -- | candidate_id | name    | years_of_exp | interview_id |
# -- +--------------+---------+--------------+--------------+
# -- | 11           | Atticus | 1            | 101          |
# -- | 9            | Ruben   | 6            | 104          |
# -- | 6            | Aliza   | 10           | 109          |
# -- | 8            | Alfredo | 0            | 107          |
# -- +--------------+---------+--------------+--------------+
# -- Rounds table:
# -- +--------------+----------+-------+
# -- | interview_id | round_id | score |
# -- +--------------+----------+-------+
# -- | 109          | 3        | 4     |
# -- | 101          | 2        | 8     |
# -- | 109          | 4        | 1     |
# -- | 107          | 1        | 3     |
# -- | 104          | 3        | 6     |
# -- | 109          | 1        | 4     |
# -- | 104          | 4        | 7     |
# -- | 104          | 1        | 2     |
# -- | 109          | 2        | 1     |
# -- | 104          | 2        | 7     |
# -- | 107          | 2        | 3     |
# -- | 101          | 1        | 8     |
# -- +--------------+----------+-------+
# -- Output: 
# -- +--------------+
# -- | candidate_id |
# -- +--------------+
# -- | 9            |
# -- +--------------+

import pandas as pd

# Example data for Candidates table
candidates_data = {
    'candidate_id': [11, 9, 6, 8],
    'name': ['Atticus', 'Ruben', 'Aliza', 'Alfredo'],
    'years_of_exp': [1, 6, 10, 0],
    'interview_id': [101, 104, 109, 107]
}
candidates_df = pd.DataFrame(candidates_data)

# Example data for Rounds table
rounds_data = {
    'interview_id': [109, 101, 109, 107, 104, 109, 104, 104, 109, 104, 107, 101],
    'round_id': [3, 2, 4, 1, 3, 1, 4, 1, 2, 2, 2, 1],
    'score': [4, 8, 1, 3, 6, 4, 7, 2, 1, 7, 3, 8]
}
rounds_df = pd.DataFrame(rounds_data)


 # m1
# df  = pd.merge(candidates_df, rounds_df, on ='interview_id',how='left')
# df = df.query("years_of_exp >= 2")
# df = df.groupby('candidate_id')['score'].sum().reset_index()
# df = df.query('score > 15')[['candidate_id']]
# print(df)

# m2 
# interview_df = (pd.merge(candidates_df, rounds_df, how ='left', on ='interview_id')
#                 .query("years_of_exp >= 2")
#                 .groupby('candidate_id')['score']
#                 .sum()
#                 .reset_index()
#                 .query("score > 15")
#                 [['candidate_id']]
# )
# print(interview_df)
