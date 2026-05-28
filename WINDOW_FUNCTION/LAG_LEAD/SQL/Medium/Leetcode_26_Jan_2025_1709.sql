-- 1709. Biggest Window Between Visits

-- Table: UserVisits
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | user_id     | int  |
-- | visit_date  | date |
-- +-------------+------+
-- This table does not have a primary key.
-- This table contains logs of the dates that users vistied a certain retailer.

-- Assume today's date is '2021-1-1'.
-- Write an SQL query that will, for each user_id, find out the largest window 
--of days between each visit and the one right after it (or today if you are considering the last visit).

-- Return the result table ordered by user_id.

-- The query result format is in the following example:

-- UserVisits table:
-- +---------+------------+
-- | user_id | visit_date |
-- +---------+------------+
-- | 1       | 2020-11-28 |
-- | 1       | 2020-10-20 |
-- | 1       | 2020-12-3  |
-- | 2       | 2020-10-5  |
-- | 2       | 2020-12-9  |
-- | 3       | 2020-11-11 |
-- +---------+------------+
-- Result table:
-- +---------+---------------+
-- | user_id | biggest_window|
-- +---------+---------------+
-- | 1       | 39            |
-- | 2       | 65            |
-- | 3       | 51            |
-- +---------+---------------+
-- For the first user, the windows in question are between dates:
--     - 2020-10-20 and 2020-11-28 with a total of 39 days.
--     - 2020-11-28 and 2020-12-3 with a total of 5 days.
--     - 2020-12-3 and 2021-1-1 with a total of 29 days.
-- Making the biggest window the one with 39 days.
-- For the second user, the windows in question are between dates:
--     - 2020-10-5 and 2020-12-9 with a total of 65 days.
--     - 2020-12-9 and 2021-1-1 with a total of 23 days.
-- Making the biggest window the one with 65 days.
-- For the third user, the only window in question is between dates 2020-11-11 and 2021-1-1 with a total of 51 days.

DROP TABLE Purchases;
DROP TABLE Visits;
-- Create table
CREATE TABLE Visits (
    user_id INT,
    visit_date DATE
);

-- Insert data
INSERT INTO Visits (user_id, visit_date) VALUES
(1, '2020-11-28'),
(1, '2020-10-20'),
(1, '2020-12-03'),
(2, '2020-10-05'),
(2, '2020-12-09'),
(3, '2020-11-11');

-- m1 using lead/lag
WITH user_visit_info AS (
    SELECT user_id,
        visit_date,
        LEAD(visit_date,1,'2021-01-01') OVER(PARTITION BY user_id ORDER BY visit_date) AS nxt_visit_dt
    FROM Visits 
)
SELECT user_id,
        MAX(DATEDIFF(nxt_visit_dt,visit_date)) AS biggest_window
FROM user_visit_info 
GROUP BY user_id
ORDER BY user_id;

---------------------------------------------------------------------------------------------------------------------------------

-- m2 not working overcomplicated
-- using ranking 

WITH user_visit_info AS (
    SELECT user_id,
        visit_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY visit_date) AS user_visit_rank,
        COUNT(user_id) OVER(PARTITION BY user_id) AS user_count
    FROM Visits
)
SELECT * 
FROM user_visit_info uvi1
JOIN user_visit_info uvi2 
ON uvi1.user_id = uvi2.user_id 
AND
( CASE WHEN uvi1.user_count = 1 
    THEN uvi1.user_visit_rank = uvi2.user_visit_rank 
    ELSE uvi1.user_visit_rank = uvi2.user_visit_rank + 1
    END 
)


-- m3 

WITH ranked_visits AS (
    SELECT 
        user_id,
        visit_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY visit_date) AS rn
    FROM Visits
),
paired_visits AS (
    SELECT 
        v1.user_id,
        v1.visit_date,
        COALESCE(v2.visit_date, '2021-01-01') AS next_visit_date
    FROM ranked_visits v1
    LEFT JOIN ranked_visits v2
      ON v1.user_id = v2.user_id
     AND v1.rn + 1 = v2.rn
)
SELECT
    user_id,
    MAX(DATEDIFF(next_visit_date, visit_date)) AS biggest_window
FROM paired_visits
GROUP BY user_id
ORDER BY user_id;

