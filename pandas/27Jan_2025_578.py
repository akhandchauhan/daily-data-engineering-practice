# 578. Get Highest Answer Rate Question
# Description
# Table: SurveyLog
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | id          | int  |
# | action      | ENUM |
# | question_id | int  |
# | answer_id   | int  |
# | q_num       | int  |
# | timestamp   | int  |
# +-------------+------+
# This table may contain duplicate rows.
# action is an ENUM (category) of the type: "show", "answer", or "skip".
# Each row of this table indicates the user with ID = id has taken an action with the question
# question_id at time timestamp.
# If the action taken by the user is "answer", answer_id will contain the id 
# of that answer, otherwise, it will be null.
# q_num is the numeral order of the question in the current session.
# The answer rate for a question is the number of times a user answered the 
# question by the number of times a user showed the question.
# Write a solution to report the question that has the highest answer rate. 
# If multiple questions have the same maximum answer rate, report the question with the smallest question_id.
# Input: 
# SurveyLog table:
# +----+--------+-------------+-----------+-------+-----------+
# | id | action | question_id | answer_id | q_num | timestamp |
# +----+--------+-------------+-----------+-------+-----------+
# | 5  | show   | 285         | null      | 1     | 123       |
# | 5  | answer | 285         | 124124    | 1     | 124       |
# | 5  | show   | 369         | null      | 2     | 125       |
# | 5  | skip   | 369         | null      | 2     | 126       |
# +----+--------+-------------+-----------+-------+-----------+
# Output: 
# +------------+
# | survey_log |
# +------------+
# | 285        |
# +------------+
# Explanation: 
# Question 285 was showed 1 time and answered 1 time. The answer rate of question 285 is 1.0
# Question 369 was showed 1 time and was not answered. The answer rate of question 369 is 0.0
# Question 285 has the highest answer rate.

import pandas as pd

SurveyLog = pd.DataFrame(
    [
        [5, 'show',   285, None,   1, 123],
        [5, 'answer', 285, 124124, 1, 124],
        [5, 'show',   369, None,   2, 125],
        [5, 'skip',   369, None,   2, 126],
    ],
    columns=['id', 'action', 'question_id', 'answer_id', 'q_num', 'timestamp']
)

df = (
    SurveyLog
    .groupby('question_id')
    .agg(
        answer_action=('action', lambda d: d.where(d == 'answer').count()),
        show_action=('action', lambda d: d.where(d == 'show').count())
    )
    .assign(answer_rate=lambda d: d['answer_action'] / d['show_action'])
    .reset_index()
    .sort_values(
        by=['answer_rate', 'question_id'],
        ascending=[False, True]
    )
    .rename(columns={'question_id': 'survey_log'})
    [['survey_log']]
    .head(1)
)

print(df)

##################################################################################################################################

# m2 

df = (
    SurveyLog
    .groupby('question_id')
    .agg(
        answer_action=('action', lambda x: (x == 'answer').sum()),
        show_action=('action', lambda x: (x == 'show').sum())
    )
    .assign(answer_rate=lambda d: d['answer_action'] / d['show_action'])
    .reset_index()
    .sort_values(
        by=['answer_rate', 'question_id'],
        ascending=[False, True]
    )
    .rename(columns={'question_id': 'survey_log'})
    [['survey_log']]
    .head(1)
)

print(df)
