-- 2854. Rolling Average Steps

-- Table: Steps
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | user_id     | int  |
-- | steps_count | int  |
-- | steps_date  | date |
-- +-------------+------+
-- (user_id, steps_date) is the primary key for this table.
-- Each row of this table contains user_id, steps_count, and steps_date.

-- Write a solution to calculate 3-day rolling averages of steps for each user.
-- For each day, we calculate the average of 3 consecutive days of step
--  counts ending on that day
-- if available, otherwise the rolling average is not defined for it.
-- Output the user_id, steps_date, and rolling average rounded to two decimal places.
-- Return the result table ordered by user_id, steps_date in ascending order.
-- Example 1:
-- Input:
-- Steps table:
-- +---------+-------------+------------+
-- | user_id | steps_count | steps_date |
-- +---------+-------------+------------+
-- | 1       | 687         | 2021-09-02 |
-- | 1       | 395         | 2021-09-04 |
-- | 1       | 499         | 2021-09-05 |
-- | 1       | 712         | 2021-09-06 |
-- | 1       | 576         | 2021-09-07 |
-- | 2       | 153         | 2021-09-06 |
-- | 2       | 171         | 2021-09-07 |
-- | 2       | 530         | 2021-09-08 |
-- | 3       | 945         | 2021-09-04 |
-- | 3       | 120         | 2021-09-07 |
-- | 3       | 557         | 2021-09-08 |
-- | 3       | 840         | 2021-09-09 |
-- | 3       | 627         | 2021-09-10 |
-- +---------+-------------+------------+
-- Output:
-- +---------+------------+-----------------+
-- | user_id | steps_date | rolling_average |
-- +---------+------------+-----------------+
-- | 1       | 2021-09-06 | 535.33          |
-- | 1       | 2021-09-07 | 595.67          |
-- | 2       | 2021-09-08 | 284.67          |
-- | 3       | 2021-09-09 | 505.67          |
-- | 3       | 2021-09-10 | 674.67          |
-- +---------+------------+-----------------+
Create table if not exists Steps(user_id int, steps_count int, steps_date date);
Truncate table Steps;
INSERT INTO Steps (user_id, steps_count, steps_date) VALUES
('1', '687', '2021-09-02'),
('1', '395', '2021-09-04'),
('1', '499', '2021-09-05'),
('1', '712', '2021-09-06'),
('1', '576', '2021-09-07'),
('2', '153', '2021-09-06'),
('2', '171', '2021-09-07'),
('2', '530', '2021-09-08'),
('3', '945', '2021-09-04'),
('3', '120', '2021-09-07'),
('3', '557', '2021-09-08'),
('3', '840', '2021-09-09'),
('3', '627', '2021-09-10'),
('5', '382', '2021-09-05'),
('6', '480', '2021-09-01'),
('6', '191', '2021-09-02'),
('6', '303', '2021-09-05');

-- m1
WITH cte2 AS (
    SELECT user_id, steps_date,
           ROUND(AVG(steps_count) OVER(PARTITION BY user_id 
           ORDER BY steps_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS AVG_STEPS,
           LAG(steps_date, 2) OVER(PARTITION BY user_id 
           ORDER BY steps_date) AS two_before
    FROM Steps
)
SELECT user_id, steps_date, AVG_STEPS AS rolling_average
FROM cte2
WHERE DATEDIFF(steps_date, two_before) = 2
ORDER BY 1, 2;

---------------------------------------------------------------------------------
-- m2 
WITH user_info AS (
    SELECT
        user_id,
        steps_count,
        steps_date,
        DATE_SUB(steps_date, INTERVAL
                    ROW_NUMBER() OVER(
                        PARTITION BY user_id
                        ORDER BY steps_date
                    )
                DAY) AS streak_group
    FROM Steps
),
user_streak_info AS (
    SELECT
        user_id,
        steps_count,
        steps_date,
        streak_group,                         
        COUNT(*) OVER(
            PARTITION BY user_id, streak_group
        ) AS streak_group_count
    FROM user_info
),
user_avg_info AS (
    SELECT
        user_id,
        steps_date,
        ROW_NUMBER() OVER(
            PARTITION BY user_id, streak_group -- rank resets per streak
            ORDER BY steps_date
        ) AS user_day_ranked,
        AVG(steps_count) OVER(
            PARTITION BY user_id, streak_group --  avg stays within streak
            ORDER BY steps_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_average
    FROM user_streak_info
    WHERE streak_group_count >= 3
)
SELECT
    user_id,
    steps_date,
    ROUND(rolling_average, 2) AS rolling_average
FROM user_avg_info
WHERE user_day_ranked >= 3
ORDER BY
    user_id,
    steps_date;