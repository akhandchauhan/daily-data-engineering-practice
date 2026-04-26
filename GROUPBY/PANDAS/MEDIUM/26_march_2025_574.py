# -- 574. Winning Candidate
# -- Description
# -- Table: Candidate
# -- +-------------+----------+
# -- | Column Name | Type     |
# -- +-------------+----------+
# -- | id          | int      |
# -- | name        | varchar  |
# -- +-------------+----------+
# -- id is the column with unique values for this table.
# -- Each row of this table contains information about the id and the name of a candidate.
# -- Table: Vote
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | id          | int  |
# -- | candidateId | int  |
# -- +-------------+------+
# -- id is an auto-increment primary key (column with unique values).
# -- candidateId is a foreign key (reference column) to id from the Candidate table.
# -- Each row of this table determines the candidate who got the ith vote in the 
# -- elections.
# -- Write a solution to report the name of the winning candidate (i.e., the candidate 
# -- who got the largest number of votes).
# -- The test cases are generated so that exactly one candidate wins the elections.
# -- Input: 
# -- Candidate table:
# -- +----+------+
# -- | id | name |
# -- +----+------+
# -- | 1  | A    |
# -- | 2  | B    |
# -- | 3  | C    |
# -- | 4  | D    |
# -- | 5  | E    |
# -- +----+------+
# -- Vote table:
# -- +----+-------------+
# -- | id | candidateId |
# -- +----+-------------+
# -- | 1  | 2           |
# -- | 2  | 4           |
# -- | 3  | 3           |
# -- | 4  | 2           |
# -- | 5  | 5           |
# -- +----+-------------+
# -- Output: 
# -- +------+
# -- | name |
# -- +------+
# -- | B    |
# -- +------+
# -- Explanation: 
# -- Candidate B has 2 votes. Candidates C, D, and E have 1 vote each.
# -- The winner is candidate B.

import pandas as pd

candidate_data = {
    'id': [1, 2, 3, 4, 5],
    'name': ['A', 'B', 'C', 'D', 'E']
}
vote_data = {
    'id': [1, 2, 3, 4, 5],
    'candidateId': [2, 4, 3, 2, 5]
}
candidate_df = pd.DataFrame(candidate_data)
vote_df = pd.DataFrame(vote_data)

# m1  head approach
merged_df = (
    vote_df.merge(candidate_df, left_on='candidateId', right_on = 'id')
    .groupby(["candidateId","name"], as_index = False)['id_x']
    .count()
    .sort_values(by = 'id_x', ascending = False)
    [['name']]
    .head(1)
)
print(merged_df)

###################################################################################
# m2 using max

merged_df = (
    vote_df.merge(candidate_df, left_on='candidateId', right_on = 'id')
    .groupby(["candidateId","name"], as_index = False)['id_x']
    .count()
    .loc[lambda d: d['id_x'] == d['id_x'].max()]
    [['name']]
    
)
print(merged_df)

###################################################################################
# m3 using dense_rank

merged_df = (
    vote_df.merge(candidate_df, left_on='candidateId', right_on = 'id')
    .groupby(["candidateId","name"], as_index = False)['id_x']
    .count()
    .assign(
        candidate_ranked = lambda d: d['id_x'].rank(method = 'dense', ascending = False)
    )
    .loc[lambda d: d['candidate_ranked'] == 1]
    [['name']]
    
)
print(merged_df)