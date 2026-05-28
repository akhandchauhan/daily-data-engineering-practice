-- 1113. Reported Posts
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
-- The action column is an ENUM type of ('view','like','reaction','comment','report','share').
-- The extra column has optional information about the action, such as a reason for the report.
-- extra is never NULL.
-- Write a solution to report the number of posts reported yesterday for each report reason.
-- Assume today is 2019-07-05.
-- Return the result table in any order.
-- Example:
-- Input:
-- Actions table:
-- +---------+---------+-------------+--------+--------+
-- | user_id | post_id | action_date | action | extra  |
-- +---------+---------+-------------+--------+--------+
-- | 1       | 1       | 2019-07-01  | view   | null   |
-- | 2       | 4       | 2019-07-04  | view   | null   |
-- | 2       | 4       | 2019-07-04  | report | spam   |
-- | 3       | 4       | 2019-07-04  | view   | null   |
-- | 3       | 4       | 2019-07-04  | report | spam   |
-- | 4       | 3       | 2019-07-02  | report | spam   |
-- | 5       | 2       | 2019-07-04  | report | racism |
-- | 5       | 5       | 2019-07-04  | report | racism |
-- +---------+---------+-------------+--------+--------+
-- Output:
-- +---------------+--------------+
-- | report_reason | report_count |
-- +---------------+--------------+
-- | spam          | 1            |
-- | racism        | 2            |
-- +---------------+--------------+

DROP TABLE Actions;
CREATE TABLE Actions (
    user_id INT,
    post_id INT,
    action_date DATE,
    action ENUM('view', 'like', 'reaction', 'comment', 'report', 'share'),
    extra VARCHAR(255),
    PRIMARY KEY (user_id, post_id, action_date, action)
);

INSERT INTO Actions (user_id, post_id, action_date, action, extra) VALUES
(1, 1, '2019-07-01', 'view', 'null'),
(1, 1, '2019-07-01', 'like', 'null'),
(1, 1, '2019-07-01', 'share', 'null'),
(2, 4, '2019-07-04', 'view', 'null'),
(2, 4, '2019-07-04', 'report', 'spam'),
(3, 4, '2019-07-04', 'view', 'null'),
(3, 4, '2019-07-04', 'report', 'spam'),
(4, 3, '2019-07-02', 'view', 'null'),
(4, 3, '2019-07-02', 'report', 'spam'),
(5, 2, '2019-07-04', 'view', 'null'),
(5, 2, '2019-07-04', 'report', 'racism'),
(5, 5, '2019-07-04', 'view', 'null'),
(5, 5, '2019-07-04', 'report', 'racism');

SELECT extra AS report_reason, COUNT(DISTINCT post_id) AS report_count
FROM Actions
WHERE action_date = DATE_SUB('2019-07-05', INTERVAL 1 DAY)
  AND extra IS NOT NULL
  AND action = 'report'
GROUP BY extra;
