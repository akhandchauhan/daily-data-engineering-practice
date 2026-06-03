-- 1142. User Activity for the Past 30 Days II

-- Table: Activity
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | session_id    | int     |
-- | activity_date | date    |
-- | activity_type | enum    |
-- +---------------+---------+
-- This table may have duplicate rows.
-- The activity_type column is an ENUM (category) of type ('open_session',
-- 'end_session', 'scroll_down', 'send_message').
-- The table shows the user activities for a social media website.
-- Note that each session belongs to exactly one user.

-- Write a solution to find the average number of sessions per
-- user for a period of 30 days ending 2019-07-27 inclusively,
-- rounded to 2 decimal places. The sessions we want to count for
-- a user are those with at least one activity in that time period.

-- The result format is in the following example.

-- Activity table:
-- +---------+------------+---------------+---------------+
-- | user_id | session_id | activity_date | activity_type |
-- +---------+------------+---------------+---------------+
-- | 1       | 1          | 2019-07-20    | open_session  |
-- | 1       | 1          | 2019-07-20    | scroll_down   |
-- | 1       | 1          | 2019-07-20    | end_session   |
-- | 2       | 4          | 2019-07-20    | open_session  |
-- | 2       | 4          | 2019-07-21    | send_message  |
-- | 2       | 4          | 2019-07-21    | end_session   |
-- | 3       | 2          | 2019-07-21    | open_session  |
-- | 3       | 2          | 2019-07-21    | send_message  |
-- | 3       | 2          | 2019-07-21    | end_session   |
-- | 3       | 5          | 2019-07-21    | open_session  |
-- | 3       | 5          | 2019-07-21    | scroll_down   |
-- | 3       | 5          | 2019-07-21    | end_session   |
-- | 4       | 3          | 2019-06-25    | open_session  |
-- | 4       | 3          | 2019-06-25    | end_session   |
-- +---------+------------+---------------+---------------+
-- Output:
-- +---------------------------+
-- | average_sessions_per_user |
-- +---------------------------+
-- | 1.33                      |
-- +---------------------------+
-- Explanation: User 1 and 2 each had 1 session in the past 30
-- days while user 3 had 2 sessions so the average is (1 + 1 + 2) / 3 = 1.33.


DROP TABLE IF EXISTS Activity;

CREATE TABLE Activity (
    user_id       INT,
    session_id    INT,
    activity_date DATE,
    activity_type ENUM('open_session', 'end_session', 'scroll_down', 
    'send_message')
);

INSERT INTO Activity (user_id, session_id, activity_date, activity_type) VALUES
(1, 1, '2019-07-20', 'open_session'),
(1, 1, '2019-07-20', 'scroll_down'),
(1, 1, '2019-07-20', 'end_session'),
(2, 4, '2019-07-20', 'open_session'),
(2, 4, '2019-07-21', 'send_message'),
(2, 4, '2019-07-21', 'end_session'),
(3, 2, '2019-07-21', 'open_session'),
(3, 2, '2019-07-21', 'send_message'),
(3, 2, '2019-07-21', 'end_session'),
(3, 5, '2019-07-21', 'open_session'),
(3, 5, '2019-07-21', 'scroll_down'),
(3, 5, '2019-07-21', 'end_session'),
(4, 3, '2019-06-25', 'open_session'),
(4, 3, '2019-06-25', 'end_session');

-- m1
SELECT IFNULL(ROUND(
            AVG(unique_session_cnt), 2), 0) AS average_sessions_per_user
FROM (
    SELECT
            user_id,
            COUNT(DISTINCT session_id) AS unique_session_cnt
    FROM Activity
    WHERE
        DATEDIFF('2019-07-27',activity_date) between 0 and 29
    GROUP BY
            user_id
) A ;

-- DATEDIFF = 0 → 2019-07-27 (included)
-- DATEDIFF = 29 → 2019-06-28 (included, the 30th day back)