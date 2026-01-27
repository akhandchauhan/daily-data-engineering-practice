-- 578. Get Highest Answer Rate Question
-- Description
-- Table: SurveyLog
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | id          | int  |
-- | action      | ENUM |
-- | question_id | int  |
-- | answer_id   | int  |
-- | q_num       | int  |
-- | timestamp   | int  |
-- +-------------+------+
-- This table may contain duplicate rows.
-- action is an ENUM (category) of the type: "show", "answer", or "skip".
-- Each row of this table indicates the user with ID = id has taken an action with the question
-- question_id at time timestamp.
-- If the action taken by the user is "answer", answer_id will contain the id 
--of that answer, otherwise, it will be null.
-- q_num is the numeral order of the question in the current session.
-- The answer rate for a question is the number of times a user answered the 
--question by the number of times a user showed the question.
-- Write a solution to report the question that has the highest answer rate. 
--If multiple questions have the same maximum answer rate, report the question with the smallest question_id.
-- Input: 
-- SurveyLog table:
-- +----+--------+-------------+-----------+-------+-----------+
-- | id | action | question_id | answer_id | q_num | timestamp |
-- +----+--------+-------------+-----------+-------+-----------+
-- | 5  | show   | 285         | null      | 1     | 123       |
-- | 5  | answer | 285         | 124124    | 1     | 124       |
-- | 5  | show   | 369         | null      | 2     | 125       |
-- | 5  | skip   | 369         | null      | 2     | 126       |
-- +----+--------+-------------+-----------+-------+-----------+
-- Output: 
-- +------------+
-- | survey_log |
-- +------------+
-- | 285        |
-- +------------+
-- Explanation: 
-- Question 285 was showed 1 time and answered 1 time. The answer rate of question 285 is 1.0
-- Question 369 was showed 1 time and was not answered. The answer rate of question 369 is 0.0
-- Question 285 has the highest answer rate.
 
DROP TABLE surveylog;
-- Create the SurveyLog table
CREATE TABLE SurveyLog (
    id INT,
    action ENUM('show', 'answer', 'skip'),
    question_id INT,
    answer_id INT,
    q_num INT,
    timestamp INT
);

-- Insert the values into the SurveyLog table
INSERT INTO SurveyLog (id, action, question_id, answer_id, q_num, timestamp) VALUES
(5, 'show', 285, NULL, 1, 123),
(5, 'answer', 285, 124124, 1, 124),
(5, 'show', 369, NULL, 2, 125),
(5, 'skip', 369, NULL, 2, 126);

-- method 1
SELECT survey_log
FROM(
SELECT question_id as survey_log,SUM(IF(action='answer',1,0))/SUM(IF(action='show',1,0)) as high_answer_rate
FROM SurveyLog
GROUP BY question_id
ORDER BY 2 DESC, 1
LIMIT 1) A;


----------------------------------------------------------------------------------------------------------------------------------
-- method 2

WITH T AS (
        SELECT question_id AS survey_log,
            (SUM(action = 'answer') OVER (PARTITION BY question_id)) / (
                SUM(action = 'show') OVER (PARTITION BY question_id)
            ) AS ratio
        FROM SurveyLog
    )
SELECT survey_log
FROM T
ORDER BY ratio DESC, 1
LIMIT 1;

----------------------------------------------------------------------------------------------------------------------------------
-- m3

SELECT question_id  as survey_log
FROM surveylog
GROUP BY question_id
ORDER BY SUM(IF(action ='answer',1,0))/SUM(IF(action ='show',1,0)) DESC ,question_id
LIMIT 1;


----------------------------------------------------------------------------------------------------------------------------------
-- m4

WITH question_info AS (
    SELECT 
        question_id,
        COUNT(CASE WHEN action = 'answer' THEN 1 END)/COUNT(CASE WHEN action = 'show' THEN 1 END) AS answer_rate
    FROM surveylog 
    GROUP BY question_id
)
SELECT question_id AS survey_log
FROM question_info 
ORDER BY answer_rate DESC, question_id
LIMIT 1;

----------------------------------------------------------------------------------------------------------------------------------
-- 2228. Users With Two Purchases Within Seven Days
-- Description
-- Table: Purchases
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | purchase_id   | int  |
-- | user_id       | int  |
-- | purchase_date | date |
-- +---------------+------+
-- purchase_id is the primary key for this table.
-- This table contains logs of the dates that users purchased from a certain retailer
-- Write an  SQL query to report the IDs of the users that made any two purchases at most 7 days apart.
-- Return the result table ordered by user_id. 
-- Purchases table:
-- +-------------+---------+---------------+
-- | purchase_id | user_id | purchase_date |
-- +-------------+---------+---------------+
-- | 4           | 2       | 2022-03-13    |
-- | 1           | 5       | 2022-02-11    |
-- | 3           | 7       | 2022-06-19    |
-- | 6           | 2       | 2022-03-20    |
-- | 5           | 7       | 2022-06-19    |
-- | 2           | 2       | 2022-06-08    |
-- +-------------+---------+---------------+
-- Output: 
-- +---------+
-- | user_id |
-- +---------+
-- | 2       |
-- | 7       |
-- +---------+
-- Explanation: 
-- User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the 
--second purchase is within 7 days of the first purchase, we add their ID.
-- User 5 had only 1 purchase.
-- User 7 had two purchases on the same day so we add their ID.

drop table Purchases;
CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    purchase_date DATE
);
INSERT INTO Purchases (purchase_id, user_id, purchase_date) VALUES
(4, 2, '2022-03-13'),
(1, 5, '2022-02-11'),
(3, 7, '2022-06-19'),
(6, 2, '2022-03-20'),
(5, 7, '2022-06-19'),
(2, 2, '2022-06-08');

WITH cte as(
SELECT user_id,purchase_date,LEAD(purchase_date) OVER(PARTITION BY user_id ORDER BY purchase_date) as nxt
FROM Purchases
)
SELECT DISTINCT user_id
FROM cte
WHERE dateDIFF(purchase_date,nxt)<=7;