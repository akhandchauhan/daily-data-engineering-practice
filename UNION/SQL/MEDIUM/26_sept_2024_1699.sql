-- 1699. Number of Calls Between Two Persons
-- Description
-- Table: Calls
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | from_id     | int     |
-- | to_id       | int     |
-- | duration    | int     |
-- +-------------+---------+
-- This table does not have a primary key (column with unique values), it may contain duplicates.
-- This table contains the duration of a phone call between from_id and to_id.
-- from_id != to_id

-- Write a solution to report the number of  calls and the total  call duration 
--between each pair of distinct persons (person1, person2) where person1 < person2.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Calls table:
-- +---------+-------+----------+
-- | from_id | to_id | duration |
-- +---------+-------+----------+
-- | 1       | 2     | 59       |
-- | 2       | 1     | 11       |
-- | 1       | 3     | 20       |
-- | 3       | 4     | 100      |
-- | 3       | 4     | 200      |
-- | 3       | 4     | 200      |
-- | 4       | 3     | 499      |
-- +---------+-------+----------+
-- Output: 
-- +---------+---------+------------+----------------+
-- | person1 | person2 | call_count | total_duration |
-- +---------+---------+------------+----------------+
-- | 1       | 2       | 2          | 70             |
-- | 1       | 3       | 1          | 20             |
-- | 3       | 4       | 4          | 999            |
-- +---------+---------+------------+----------------+
-- Explanation: 
-- Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
-- Users 1 and 3 had 1 call and the total duration is 20.
-- Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).

DROP TABLE Calls;
CREATE TABLE Calls (
    from_id INT,
    to_id INT,
    duration INT
);

-- Insert the provided values into the Calls table
INSERT INTO Calls (from_id, to_id, duration) VALUES
(1, 2, 59),
(2, 1, 11),
(1, 3, 20),
(3, 4, 100),
(3, 4, 200),
(3, 4, 200),
(4, 3, 499);

-- m1 
WITH call_info AS (
    SELECT
        from_id AS person1,
        to_id AS person2,
        duration
    FROM Calls
    UNION ALL
    SELECT
        to_id AS person1,
        from_id AS person2,
        duration
    FROM Calls
)
SELECT
        person1,
        person2,
        COUNT(*) AS call_count,
        SUM(duration) AS total_duration
FROM call_info
WHERE person1 < person2
GROUP BY   person1,
        person2 ;

--------------------------------------------------------------------------------------------------
-- m2
WITH cte AS (
    SELECT CASE WHEN from_id < to_id THEN from_id ELSE to_id END AS person1,
        CASE WHEN from_id < to_id THEN to_id ELSE from_id END AS person2, 
        duration
    FROM Calls
)
SELECT person1, person2, 
    COUNT(*) AS call_count, 
    SUM(duration) AS total_duration
FROM cte
GROUP BY person1, person2;

--------------------------------------------------------------------------------------------------
-- m3
SELECT
    LEAST(from_id, to_id) AS person1,
    GREATEST(from_id, to_id) AS person2,
    COUNT(*) AS call_count,
    SUM(duration) AS total_duration
FROM Calls
GROUP BY 1,2;