-- 3089. Find Bursty Behavior

-- Table: Posts
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | post_id     | int     |
-- | user_id     | int     |
-- | post_date   | date    |
-- +-------------+---------+
-- post_id is the primary key (column with unique values) for this table.
-- Each row of this table contains post_id, user_id, and post_date.

-- Write a solution to find users who demonstrate bursty behavior in their
-- posting patterns during February 2024. Bursty behavior is defined as any
-- period of 7 consecutive days where a user's posting frequency is at
-- least twice their average weekly posting frequency for February 2024.

-- Note: Only include the dates from February 1 to February 28 in your analysis,
-- which means you should count February as having exactly 4 weeks.

-- Return the result table ordered by user_id in ascending order.

-- Example 1:
-- Posts table:
-- +---------+---------+------------+
-- | post_id | user_id | post_date  |
-- +---------+---------+------------+
-- | 1       | 1       | 2024-02-27 |
-- | 2       | 5       | 2024-02-06 |
-- | 3       | 3       | 2024-02-25 |
-- | 4       | 3       | 2024-02-14 |
-- | 5       | 3       | 2024-02-06 |
-- | 6       | 2       | 2024-02-25 |
-- +---------+---------+------------+
-- Output:
-- +---------+----------------+------------------+
-- | user_id | max_7day_posts | avg_weekly_posts |
-- +---------+----------------+------------------+
-- | 1       | 1              | 0.2500           |
-- | 2       | 1              | 0.2500           |
-- | 5       | 1              | 0.2500           |
-- +---------+----------------+------------------+
-- Explanation:
-- User 1, 2, 5: 1 post each in Feb -> avg_weekly_posts = 1/4 = 0.25,
-- max_7day_posts = 1 >= 2 * 0.25, so they qualify.
-- User 3: 3 posts (02-06, 02-14, 02-25), none within 7 days of another,
-- so max_7day_posts = 1, avg_weekly_posts = 3/4 = 0.75, 1 < 2 * 0.75 -> excluded.

USE practice;

DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    post_date DATE
);

INSERT INTO
    Posts (post_id, user_id, post_date)
VALUES (1, 1, '2024-02-27'),
    (2, 5, '2024-02-06'),
    (3, 3, '2024-02-25'),
    (4, 3, '2024-02-14'),
    (5, 3, '2024-02-06'),
    (6, 2, '2024-02-25');


WITH user_post_info AS (
    SELECT
        user_id,
        WEEK(post_date) AS post_date,
        COUNT(*) AS post_count,
        MAX(COUNT(*)) OVER(PARTITION BY user_id) AS max_7day_posts
    FROM Posts
    WHERE 
        post_date >= '2024-02-01'
        AND post_date < '2024-03-01'
    GROUP BY 
        user_id,
        week(post_date)
)