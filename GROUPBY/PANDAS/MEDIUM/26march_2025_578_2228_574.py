# -- 2228. Users With Two Purchases Within Seven Days
# -- Description
# -- Table: Purchases
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | purchase_id   | int  |
# -- | user_id       | int  |
# -- | purchase_date | date |
# -- +---------------+------+
# -- purchase_id is the primary key for this table.
# -- This table contains logs of the dates that users purchased from a certain retailer
# -- Write an  SQL query to report the IDs of the users that made any two purchases at most 7 days apart.
# -- Return the result table ordered by user_id. 
# -- Purchases table:
# -- +-------------+---------+---------------+
# -- | purchase_id | user_id | purchase_date |
# -- +-------------+---------+---------------+
# -- | 4           | 2       | 2022-03-13    |
# -- | 1           | 5       | 2022-02-11    |
# -- | 3           | 7       | 2022-06-19    |
# -- | 6           | 2       | 2022-03-20    |
# -- | 5           | 7       | 2022-06-19    |
# -- | 2           | 2       | 2022-06-08    |
# -- +-------------+---------+---------------+
# -- Output: 
# -- +---------+
# -- | user_id |
# -- +---------+
# -- | 2       |
# -- | 7       |
# -- +---------+
# -- Explanation: 
# -- User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the 
# --second purchase is within 7 days of the first purchase, we add their ID.
# -- User 5 had only 1 purchase.
# -- User 7 had two purchases on the same day so we add their ID.

# import pandas as pd

# data = {
#     'purchase_id': [4, 1, 3, 6, 5, 2],
#     'user_id': [2, 5, 7, 2, 7, 2],
#     'purchase_date': ['2022-03-13', '2022-02-11', '2022-06-19', '2022-03-20', '2022-06-19', '2022-06-08']
# }

# df = pd.DataFrame(data)
# df['purchase_date'] = pd.to_datetime(df['purchase_date'])
# df = df.sort_values(by ='purchase_date')
# df['nxt_date'] = df.groupby('user_id')['purchase_date'].shift(1)
# df = df[df['nxt_date'].dt.day - df['purchase_date'].dt.day <= 7][['user_id']].drop_duplicates()
# print(df)


# Filter rows where the difference between the current and next purchase is 7 days or fewer
# df_filtered = df[df['nxt_date'] - df['purchase_date'] <= pd.Timedelta(days=7)]

# -- 578. Get Highest Answer Rate Question
# -- Description
# -- Table: SurveyLog
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | id          | int  |
# -- | action      | ENUM |
# -- | question_id | int  |
# -- | answer_id   | int  |
# -- | q_num       | int  |
# -- | timestamp   | int  |
# -- +-------------+------+
# -- This table may contain duplicate rows.
# -- action is an ENUM (category) of the type: "show", "answer", or "skip".
# -- Each row of this table indicates the user with ID = id has taken an action with the question
# -- question_id at time timestamp.
# -- If the action taken by the user is "answer", answer_id will contain the id 
# --of that answer, otherwise, it will be null.
# -- q_num is the numeral order of the question in the current session.
# -- The answer rate for a question is the number of times a user answered the 
# --question by the number of times a user showed the question.
# -- Write a solution to report the question that has the highest answer rate. 
# --If multiple questions have the same maximum answer rate, report the question with the smallest question_id.
# -- Input: 
# -- SurveyLog table:
# -- +----+--------+-------------+-----------+-------+-----------+
# -- | id | action | question_id | answer_id | q_num | timestamp |
# -- +----+--------+-------------+-----------+-------+-----------+
# -- | 5  | show   | 285         | null      | 1     | 123       |
# -- | 5  | answer | 285         | 124124    | 1     | 124       |
# -- | 5  | show   | 369         | null      | 2     | 125       |
# -- | 5  | skip   | 369         | null      | 2     | 126       |
# -- +----+--------+-------------+-----------+-------+-----------+
# -- Output: 
# -- +------------+
# -- | survey_log |
# -- +------------+
# -- | 285        |
# -- +------------+
# -- Explanation: 
# -- Question 285 was showed 1 time and answered 1 time. The answer rate of question 285 is 1.0
# -- Question 369 was showed 1 time and was not answered. The answer rate of question 369 is 0.0
# -- Question 285 has the highest answer rate.


# import pandas as pd
# data = {
#     'id': [5, 5, 5, 5],
#     'action': ['show', 'answer', 'show', 'skip'],
#     'question_id': [285, 285, 369, 369],
#     'answer_id': [None, 124124, None, None],
#     'q_num': [1, 1, 2, 2],
#     'timestamp': [123, 124, 125, 126]
# }
# df = pd.DataFrame(data)

# show_counts = df[df['action'] == 'show'].groupby('question_id').size()
# answer_counts = df[df['action'] == 'answer'].groupby('question_id').size()

# rate_df = pd.DataFrame({
#     'show_count': show_counts,
#     'answer_count': answer_counts
# }).fillna(0)

# rate_df['answer_rate'] = rate_df['answer_count'] / rate_df['show_count']

# # Find the question with the highest answer rate (smallest question_id in case of tie)
# max_rate_question = rate_df['answer_rate'].idxmax()

# print(max_rate_question)
# print(rate_df)

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
# -- Each row of this table determines the candidate who got the ith vote in the elections.
# -- Write a solution to report the name of the winning candidate (i.e., the candidate who got
# -- the largest number of votes).
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
candidates = pd.DataFrame(candidate_data)
votes = pd.DataFrame(vote_data)
joined_df = pd.merge(votes, candidates, left_on='candidateId', right_on='id', how='left')
vote_counts = joined_df.groupby('name').size()
winning_candidate = vote_counts.idxmax()
print(pd.DataFrame({'name': [winning_candidate]}))

