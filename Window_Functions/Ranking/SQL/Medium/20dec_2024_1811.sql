-- 1811. Find Interview Candidates
-- SQL Schema
-- Table: Contests

-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | contest_id   | int  |
-- | gold_medal   | int  |
-- | silver_medal | int  |
-- | bronze_medal | int  |
-- +--------------+------+
-- contest_id is the primary key for this table.
-- This table contains the LeetCode contest ID and the user IDs of the gold,
-- silver, and bronze medalists.
-- It is guaranteed that any consecutive contests have consecutive IDs and 
--that no ID is skipped.
 

-- Table: Users

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | mail        | varchar |
-- | name        | varchar |
-- +-------------+---------+
-- user_id is the primary key for this table.
-- This table contains information about the users.
 

-- Write an SQL query to report the name and the mail of all interview 
--candidates. A user is an interview candidate if at least one of these two 
--conditions is true:

-- The user won any medal in three or more consecutive contests.
-- The user won the gold medal in three or more different contests 
--(not necessarily consecutive).
-- Return the result table in any order.

-- The query result format is in the following example:

 

-- Contests table:
-- +------------+------------+--------------+--------------+
-- | contest_id | gold_medal | silver_medal | bronze_medal |
-- +------------+------------+--------------+--------------+
-- | 190        | 1          | 5            | 2            |
-- | 191        | 2          | 3            | 5            |
-- | 192        | 5          | 2            | 3            |
-- | 193        | 1          | 3            | 5            |
-- | 194        | 4          | 5            | 2            |
-- | 195        | 4          | 2            | 1            |
-- | 196        | 1          | 5            | 2            |
-- +------------+------------+--------------+--------------+
-- Users table:
-- +---------+--------------------+-------+
-- | user_id | mail               | name  |
-- +---------+--------------------+-------+
-- | 1       | sarah@leetcode.com | Sarah |
-- | 2       | bob@leetcode.com   | Bob   |
-- | 3       | alice@leetcode.com | Alice |
-- | 4       | hercy@leetcode.com | Hercy |
-- | 5       | quarz@leetcode.com | Quarz |
-- +---------+--------------------+-------+
-- Result table:
-- +-------+--------------------+
-- | name  | mail               |
-- +-------+--------------------+
-- | Sarah | sarah@leetcode.com |
-- | Bob   | bob@leetcode.com   |
-- | Alice | alice@leetcode.com |
-- | Quarz | quarz@leetcode.com |
-- +-------+--------------------+
-- Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
-- Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
--     - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
-- Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
-- Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.

DROP TABLE Users;
DROP TABLE Contests;
-- Create the Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    mail VARCHAR(255),
    name VARCHAR(255)
);

-- Create the Contests table
CREATE TABLE Contests (
    contest_id INT PRIMARY KEY,
    gold_medal INT,
    silver_medal INT,
    bronze_medal INT,
    FOREIGN KEY (gold_medal) REFERENCES Users(user_id),
    FOREIGN KEY (silver_medal) REFERENCES Users(user_id),
    FOREIGN KEY (bronze_medal) REFERENCES Users(user_id)
);

WITH cte AS (
    -- Combine all users who won a medal (gold, silver, or bronze) along with contest_id
    SELECT gold_medal AS user, contest_id FROM contests
    UNION
    SELECT silver_medal AS user, contest_id FROM contests
    UNION
    SELECT bronze_medal AS user, contest_id FROM contests
),
cte2 AS (
    -- Assign a row number based on contest_id for each user
    SELECT user, contest_id, 
           ROW_NUMBER() OVER (PARTITION BY user ORDER BY contest_id) AS rnk
    FROM cte
),
cte3 AS (
    -- Find users who have won medals in three or more consecutive contests
    SELECT user
    FROM cte2
    GROUP BY user, contest_id - rnk
    HAVING COUNT(*) >= 3

    UNION

    -- Find users who won the gold medal in three or more different contests
    SELECT gold_medal AS user
    FROM contests
    GROUP BY gold_medal
    HAVING COUNT(DISTINCT contest_id) >= 3
)
-- Select the name and mail of the users from Users table
SELECT u.name, u.mail
FROM cte3
LEFT JOIN Users u 
ON cte3.user = u.user_id;