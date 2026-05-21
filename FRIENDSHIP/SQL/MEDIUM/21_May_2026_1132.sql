-- 1132. Reported Posts II

-- Table: Actions
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | post_id       | int     |
-- | action_date   | date    | 
-- | action        | enum    |
-- | extra         | varchar |
-- +---------------+---------+
-- This table may have duplicate rows.
-- The action column is an ENUM (category) type of ('view', 'like', 'reaction', 'comment', 'report', 
-- 'share').
-- The extra column has optional information about the action, such as a reason for the report or a 
-- type of reaction.
 

-- Table: Removals
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | post_id       | int     |
-- | remove_date   | date    | 
-- +---------------+---------+
-- post_id is the primary key (column with unique values) of this table.
-- Each row in this table indicates that some post was removed due to being reported or as a 
-- result of an admin review.
 
-- Write a solution to find the average daily percentage of posts that got removed after 
-- being reported as spam, rounded to 2 decimal places.

-- Actions table:
-- +---------+---------+-------------+--------+--------+
-- | user_id | post_id | action_date | action | extra  |
-- +---------+---------+-------------+--------+--------+
-- | 1       | 1       | 2019-07-01  | view   | null   |
-- | 1       | 1       | 2019-07-01  | like   | null   |
-- | 1       | 1       | 2019-07-01  | share  | null   |
-- | 2       | 2       | 2019-07-04  | view   | null   |
-- | 2       | 2       | 2019-07-04  | report | spam   |
-- | 3       | 4       | 2019-07-04  | view   | null   |
-- | 3       | 4       | 2019-07-04  | report | spam   |
-- | 4       | 3       | 2019-07-02  | view   | null   |
-- | 4       | 3       | 2019-07-02  | report | spam   |
-- | 5       | 2       | 2019-07-03  | view   | null   |
-- | 5       | 2       | 2019-07-03  | report | racism |
-- | 5       | 5       | 2019-07-03  | view   | null   |
-- | 5       | 5       | 2019-07-03  | report | racism |
-- +---------+---------+-------------+--------+--------+

-- Removals table:
-- +---------+-------------+
-- | post_id | remove_date |
-- +---------+-------------+
-- | 2       | 2019-07-20  |
-- | 3       | 2019-07-18  |
-- +---------+-------------+
-- Output: 
-- +-----------------------+
-- | average_daily_percent |
-- +-----------------------+
-- | 75.00                 |
-- +-----------------------+
-- Explanation: 
-- The percentage for 2019-07-04 is 50% because only one post of two spam reported posts were removed.
-- The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
-- The other days had no spam reports so the average is (50 + 100) / 2 = 75%
-- Note that the output is only one number and that we do not care about the remove dates.

DROP TABLE IF EXISTS Actions;
DROP TABLE IF EXISTS Removals;

CREATE TABLE Actions (
    user_id INT,
    post_id INT,
    action_date DATE,
    action ENUM('view', 'like', 'reaction', 'comment', 'report', 'share'),
    extra VARCHAR(50)
);

CREATE TABLE Removals (
    post_id INT PRIMARY KEY,
    remove_date DATE
);

INSERT INTO Actions (user_id, post_id, action_date, action, extra) VALUES
(1, 1, '2019-07-01', 'view', NULL),
(1, 1, '2019-07-01', 'like', NULL),
(1, 1, '2019-07-01', 'share', NULL),
(2, 2, '2019-07-04', 'view', NULL),
(2, 2, '2019-07-04', 'report', 'spam'),
(3, 4, '2019-07-04', 'view', NULL),
(3, 4, '2019-07-04', 'report', 'spam'),
(4, 3, '2019-07-02', 'view', NULL),
(4, 3, '2019-07-02', 'report', 'spam'),
(5, 2, '2019-07-03', 'view', NULL),
(5, 2, '2019-07-03', 'report', 'racism'),
(5, 5, '2019-07-03', 'view', NULL),
(5, 5, '2019-07-03', 'report', 'racism');

INSERT INTO Removals (post_id, remove_date) VALUES
(2, '2019-07-20'),
(3, '2019-07-18');

SELECT
    ROUND(AVG(daily_percent), 2) AS average_daily_percent
FROM (
    SELECT 
            a.action_date,
            COUNT(DISTINCT r.post_id) *100.0/COUNT(DISTINCT a.post_id) AS daily_percent
    FROM Actions a 
    LEFT JOIN Removals r
    ON a.post_id = r.post_id
    where action = 'report'
    AND extra = 'spam'
    GROUP BY 
            a.action_date
) a ;