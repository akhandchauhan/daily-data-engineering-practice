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
-- least twice to their average weekly posting frequency for February 2024.

-- Note: Only include the dates from February 1 to February 28 in your analysis,
-- which means you should count February as having exactly 4 weeks.

-- Return the result table orderd by user_id in ascending order.
-- Posts table:
-- count of post in one week 
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

-- User 1: Made only 1 post in February, resulting in an average of 0.25 
-- posts per week and a max of 1 post in any 7-day period.
-- User 2: Also made just 1 post, with the same average and max 7-day posting
--  frequency as User 1.
-- User 5: Like Users 1 and 2, User 5 made only 1 post throughout February, 
-- leading to the same average and max 7-day posting metrics.
-- User 3: Although User 3 made more posts than the others (3 posts), they 
-- did not reach twice the average weekly posts in their consecutive 7-day
--  window, so they are not listed in the output.

-- Note: Output table is ordered by user_id in ascending order.

DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    post_date DATE
);

INSERT INTO Posts (post_id, user_id, post_date) VALUES
(1, 1, '2024-02-27'),
(2, 5, '2024-02-06'),
(3, 3, '2024-02-25'),
(4, 3, '2024-02-14'),
(5, 3, '2024-02-06'),
(6, 2, '2024-02-25');


SELECT 
    post_id,
    user_id,
    post_date,
    FLOOR((DAY(post_date) - 1) / 7) + 1 AS week_no,
    ROW_NUMBER() OVER(
        PARTITION BY user_id, FLOOR((DAY(post_date) - 1) / 7) + 1
        ORDER BY post_date
    ) AS user_ranked
FROM Posts
WHERE post_date >= '2024-02-01' AND
post_date < '2024-03-01';