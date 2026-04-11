-- 2995. Viewers Turned Streamers
-- Description
-- Table: Sessions
-- +---------------+----------+
-- | Column Name   | Type     |
-- +---------------+----------+
-- | user_id       | int      |
-- | session_start | datetime |
-- | session_end   | datetime |
-- | session_id    | int      |
-- | session_type  | enum     |
-- +---------------+----------+
-- session_id is column of unique values for this table.
-- session_type is an ENUM (category) type of (Viewer, Streamer).
-- This table contains user id, session start, session end, session id and session type.
-- Write a solution to find the number of streaming sessions for users whose first session
-- was as a viewer.
-- Return the result table ordered by count of streaming sessions, user_id in descending
-- order.
-- Input: 
-- Sessions table:
-- +---------+---------------------+---------------------+------------+--------------+
-- | user_id | session_start       | session_end         | session_id | session_type | 
-- +---------+---------------------+---------------------+------------+--------------+
-- | 101     | 2023-11-06 13:53:42 | 2023-11-06 14:05:42 | 375        | Viewer       |  
-- | 101     | 2023-11-22 16:45:21 | 2023-11-22 20:39:21 | 594        | Streamer     |   
-- | 102     | 2023-11-16 13:23:09 | 2023-11-16 16:10:09 | 777        | Streamer     | 
-- | 102     | 2023-11-17 13:23:09 | 2023-11-17 16:10:09 | 778        | Streamer     | 
-- | 101     | 2023-11-20 07:16:06 | 2023-11-20 08:33:06 | 315        | Streamer     | 
-- | 104     | 2023-11-27 03:10:49 | 2023-11-27 03:30:49 | 797        | Viewer       | 
-- | 103     | 2023-11-27 03:10:49 | 2023-11-27 03:30:49 | 798        | Streamer     |  
-- +---------+---------------------+---------------------+------------+--------------+
-- Output: 
-- +---------+----------------+
-- | user_id | sessions_count | 
-- +---------+----------------+
-- | 101     | 2              | 
-- +---------+----------------+
-- Explanation
-- - user_id 101, initiated their initial session as a viewer on 2023-11-06 at 13:53:42,
-- followed by two subsequent sessions as a Streamer, the count will be 2.
-- - user_id 102, although there are two sessions, the initial session was as a Streamer,
-- so this user will be excluded.
-- - user_id 103 participated in only one session, which was as a Streamer, hence, 
-- it won't be considered.
-- - User_id 104 commenced their first session as a viewer but didn't have any 
-- subsequent sessions, therefore, they won't be included in the final count. 
-- Output table is ordered by sessions count and user_id in descending order.

DROP TABLE Sessions;
CREATE TABLE Sessions (
    user_id INT,
    session_start DATETIME,
    session_end DATETIME,
    session_id INT PRIMARY KEY,
    session_type ENUM('Viewer', 'Streamer')
);

INSERT INTO Sessions (user_id, session_start, session_end, session_id, session_type) VALUES
(101, '2023-11-06 13:53:42', '2023-11-06 14:05:42', 375, 'Viewer'),  
(101, '2023-11-22 16:45:21', '2023-11-22 20:39:21', 594, 'Streamer'),   
(102, '2023-11-16 13:23:09', '2023-11-16 16:10:09', 777, 'Streamer'), 
(102, '2023-11-17 13:23:09', '2023-11-17 16:10:09', 778, 'Streamer'), 
(101, '2023-11-20 07:16:06', '2023-11-20 08:33:06', 315, 'Streamer'), 
(104, '2023-11-27 03:10:49', '2023
-11-27 03:30:49', 797, 'Viewer'), 
(103, '2023-11-27 03:10:49', '2023-11-27 03:30:49', 798, 'Streamer');

WITH cte as(
SELECT *,ROW_NUMBER() OVER(PARTITION BY user_id order by session_start) as rnk,
SUM((IF(session_type='Streamer',1,0))) OVER(PARTITION BY user_id) as sum_ses
FROM Sessions
)
SELECT user_id,sum_ses as sessions_count
FROM cte
WHERE rnk = 1 
AND session_type ='Viewer'
and sum_ses > 0
ORDER BY sessions_count DESC, user_id DESC;

---------------------------------------------------------------------------------------
-- m2
WITH cte as(
SELECT *,
    ROW_NUMBER() OVER(PARTITION BY user_id order by session_start) as rnk
FROM Sessions
)
SELECT user_id, COUNT(*) AS sessions_count
FROM cte
WHERE user_id IN (
    SELECT user_id
    FROM cte
    WHERE rnk = 1
    AND session_type = 'Viewer'
)
AND session_type = 'Streamer'
GROUP BY user_id
ORDER BY sessions_count DESC, user_id DESC;

----------------------------------------------------------------------------------------
-- m3 
WITH session_info AS (
    SELECT 
            user_id,
            session_type,
            ROW_NUMBER() OVER(
                PARTITION BY user_id
                ORDER BY session_start
            ) AS session_ranked,
            COUNT(CASE WHEN session_type = 'Streamer' THEN 1 END) OVER(
                PARTITION BY user_id
            ) AS sessions_count      
    FROM Sessions
)
SELECT 
        user_id,
        sessions_count
FROM session_info
WHERE session_ranked = 1
AND session_type = 'Viewer'
AND sessions_count > 0
ORDER BY 
        sessions_count DESC,
        user_id DESC;

----------------------------------------------------------------------------------------
-- m4 
WITH session_ranked AS (
SELECT 
        user_id,
        session_type,
        ROW_NUMBER() OVER(
            PARTITION BY user_id
            ORDER BY session_start
        ) AS session_ranked     
    FROM Sessions 
),
session_count_info AS (
    SELECT 
        user_id,
        COUNT(session_type) AS sessions_count
    FROM Sessions
    WHERE session_type = 'Streamer'
    GROUP BY user_id
)
SELECT 
        sr.user_id,
        sci.sessions_count
FROM session_ranked sr 
JOIN session_count_info sci 
ON sr.user_id = sci.user_id
AND sci.sessions_count > 0
AND sr.session_type = 'Viewer'
AND sr.session_ranked = 1
ORDER BY 
        sci.sessions_count DESC,
        sr.user_id DESC;