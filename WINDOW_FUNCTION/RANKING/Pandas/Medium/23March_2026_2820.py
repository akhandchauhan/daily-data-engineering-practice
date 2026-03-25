# 2820. Election Results
# Description
# Table: Votes
# +-------------+---------+ 
# | Column Name | Type    | 
# +-------------+---------+ 
# | voter       | varchar | 
# | candidate   | varchar |
# +-------------+---------+
# (voter, candidate) is the primary key (combination of unique values) for this table.
# Each row of this table contains name of the voter and their candidate. 
# The election is conducted in a city where everyone can vote for one or more candidates or choose 
# not to vote. Each person has 
# 1 vote so if they vote for multiple candidates, their vote gets equally split across them. 
# For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 
# votes each.
# Write a solution to find candidate who got the most votes and won the election. Output the name 
# of the candidate or If multiple
# candidates have an equal number of votes, display the names of all of them.
# Return the result table ordered by candidate in ascending order.
# The result format is in the following example.
# Example 1:
# Input: 
# Votes table:
# +----------+-----------+
# | voter    | candidate |
# +----------+-----------+
# | Kathy    | null      |
# | Charles  | Ryan      |
# | Charles  | Christine |
# | Charles  | Kathy     |
# | Benjamin | Christine |
# | Anthony  | Ryan      |
# | Edward   | Ryan      |
# | Terry    | null      |
# | Evelyn   | Kathy     |
# | Arthur   | Christine |
# +----------+-----------+
# Output: 
# +-----------+
# | candidate | 
# +-----------+
# | Christine |  
# | Ryan      |  
# +-----------+
# Explanation: 
# - Kathy and Terry opted not to participate in voting, resulting in their votes 
# being recorded as 0. Charles distributed 
# his vote among three candidates, equating to 0.33 for each candidate. On the 
# other hand, Benjamin, Arthur, Anthony, Edward, 
# and Evelyn each cast their votes for a single candidate.
# - Collectively, Candidate Ryan and Christine amassed a total of 2.33 votes, 
# while Kathy received a combined total of 1.33 votes.
# Since Ryan and Christine received an equal number of votes, we will display
# their names in ascending order.


import pandas as pd

votes = pd.DataFrame({
    "voter": [
        "Kathy", "Charles", "Charles", "Charles",
        "Benjamin", "Anthony", "Edward",
        "Terry", "Evelyn", "Arthur"
    ],
    "candidate": [
        None, "Ryan", "Christine", "Kathy",
        "Christine", "Ryan", "Ryan",
        None, "Kathy", "Christine"
    ]
})

# m1
votes_df = votes.copy()

votes_df = votes_df[votes_df['candidate'].notna()]
votes_df['voter_rank'] = (votes_df
                          .groupby('voter')['candidate']
                          .transform('count')
)
votes_df['proportion_vote'] = (1.0/votes_df['voter_rank'])

df = votes_df.groupby('candidate', as_index = False)['proportion_vote'].sum()

df['candidate_rank'] = df['proportion_vote'].rank(method = 'dense', ascending = False)

df= df[df['candidate_rank'] == 1][['candidate']].reset_index(drop = True)
print(df)


############################################################################################


# m2

df = (
    votes[votes['candidate'].notna()]
    .assign(vote_share=lambda d: 1.0 / d.groupby('voter')['candidate'].transform('count'))
    .groupby('candidate', as_index=False)['vote_share']
    .sum()
)

result = df[df['vote_share'] == df['vote_share'].max()][['candidate']]