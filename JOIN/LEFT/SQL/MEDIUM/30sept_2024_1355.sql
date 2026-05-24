-- 1355. Activity Participants

-- Table: Friends
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- | activity      | varchar |
-- +---------------+---------+
-- id is the id of the friend and the primary key for this table in SQL.
-- name is the name of the friend.
-- activity is the name of the activity which the friend takes part in.

-- Table: Activities
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- In SQL, id is the primary key for this table.
-- name is the name of the activity

-- Find the names of all the activities with neither the maximum nor the 
-- minimum number of participants.
-- Each activity in the Activities table is performed by any person in the 
-- table Friends.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input:
-- Friends table:
-- +------+--------------+---------------+
-- | id   | name         | activity      |
-- +------+--------------+---------------+
-- | 1    | Jonathan D.  | Eating        |
-- | 2    | Jade W.      | Singing       |
-- | 3    | Victor J.    | Singing       |
-- | 4    | Elvis Q.     | Eating        |
-- | 5    | Daniel A.    | Eating        |
-- | 6    | Bob B.       | Horse Riding  |
-- +------+--------------+---------------+
-- Activities table:
-- +------+--------------+
-- | id   | name         |
-- +------+--------------+
-- | 1    | Eating       |
-- | 2    | Singing      |
-- | 3    | Horse Riding |
-- +------+--------------+
-- Output:
-- +--------------+
-- | activity     |
-- +--------------+
-- | Singing      |
-- +--------------+
-- Explanation:
-- Eating activity is performed by 3 friends (maximum).
-- Horse Riding activity is performed by 1 friend (minimum).
-- Singing is performed by 2 friends.

DROP TABLE Friends;
DROP TABLE Activities;
CREATE TABLE Friends (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    activity VARCHAR(50)
);

CREATE TABLE Activities (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);
INSERT INTO Friends (id, name, activity) VALUES
(1, 'Jonathan D.', 'Eating'),
(2, 'Jade W.', 'Singing'),
(3, 'Victor J.', 'Singing'),
(4, 'Elvis Q.', 'Eating'),
(5, 'Daniel A.', 'Eating'),
(6, 'Bob B.', 'Horse Riding');

INSERT INTO Activities (id, name) VALUES
(1, 'Eating'),
(2, 'Singing'),
(3, 'Horse Riding');

WITH cte AS (
    SELECT activity, COUNT(id) AS num_part
    FROM Friends
    GROUP BY activity
),
cte2 AS (
    SELECT a.name, IFNULL(c.num_part, 0) AS frequency
    FROM Activities a
    LEFT JOIN cte c
    ON a.name = c.activity
)
SELECT name AS activity
FROM cte2
WHERE frequency <> (SELECT MAX(frequency) FROM cte2)
AND frequency <> (SELECT MIN(frequency) FROM cte2);

--------------------------------------------------------------------------------
-- m2
WITH activity_info AS (
    SELECT 
        a.name AS activity_name,
        COUNT(*) AS cnt 
    FROM Activities a 
    LEFT JOIN Friends f 
    ON a.name = f.activity
    GROUP BY 
        a.name
),
not_included_list AS (
    SELECT activity_name 
    FROM activity_info 
    WHERE cnt = (SELECT MAX(cnt) FROM activity_info) 
    OR cnt = (SELECT MIN(cnt) FROM activity_info)
)
SELECT 
        ai.activity_name
FROM activity_info ai
LEFT JOIN not_included_list nil 
ON ai.activity_name = nil.activity_name
WHERE nil.activity_name IS NULL ;

--------------------------------------------------------------------------------
-- m3
WITH activity_info AS (
    SELECT 
        a.name AS activity_name,
        COUNT(*) AS cnt 
    FROM Activities a 
    LEFT JOIN Friends f 
    ON a.name = f.activity
    GROUP BY 
        a.name
),
activity_ranked AS (
    SELECT
        activity_name,
        cnt,
        DENSE_RANK() OVER(ORDER BY cnt DESC) AS max_count,
        DENSE_RANK() OVER(ORDER BY cnt) AS min_count
    FROM activity_info 
),
not_included_list AS (
    SELECT * 
    FROM activity_ranked
    WHERE max_count = 1 OR min_count = 1
)
SELECT 
        ar.activity_name
FROM activity_ranked ar
LEFT JOIN not_included_list nil 
ON ar.activity_name = nil.activity_name
WHERE nil.activity_name IS NULL ;