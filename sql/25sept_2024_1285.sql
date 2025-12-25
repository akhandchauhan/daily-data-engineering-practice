-- 1285. Find the Start and End Number of Continuous Ranges
-- Description
-- Table: Logs
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | log_id        | int     |
-- +---------------+---------+
-- log_id is the column of unique values for this table.
-- Each row of this table contains the ID in a log Table.
-- Write a solution to find the start and end number of continuous ranges in the table Logs.
-- Return the result table ordered by start_id.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Logs table:
-- +------------+
-- | log_id     |
-- +------------+
-- | 1          |
-- | 2          |
-- | 3          |
-- | 7          |
-- | 8          |
-- | 10         |
-- +------------+
-- Output: 
-- +------------+--------------+
-- | start_id   | end_id       |
-- +------------+--------------+
-- | 1          | 3            |
-- | 7          | 8            |
-- | 10         | 10           |
-- +------------+--------------+
-- Explanation: 
-- The result table should contain all ranges in table Logs.
-- From 1 to 3 is contained in the table.
-- From 4 to 6 is missing in the table
-- From 7 to 8 is contained in the table.
-- Number 9 is missing from the table.
-- Number 10 is contained in the table.

DROP TABLE Logs;
CREATE TABLE Logs (
    log_id INT PRIMARY KEY
);
INSERT INTO Logs (log_id)
VALUES 
(1),
(2),
(3),
(7),
(8),
(10);

-- m1
with cte as(
    SELECT log_id, log_id - ROW_NUMBER() OVER(order by log_id) as rnk
    FROM Logs
)
SELECT Min(log_id) as start_id, Max(log_id) as end_id
FROM cte
GROUP BY rnk
ORDER BY start_id;


-- m2 claude over engineered solution
SELECT 
    MIN(a.log_id) AS start_id,
    MAX(a.log_id) AS end_id
FROM Logs a
LEFT JOIN Logs b ON a.log_id = b.log_id + 1
LEFT JOIN Logs c ON a.log_id = c.log_id - 1
WHERE b.log_id IS NULL  -- Start of a range (no previous consecutive)
   OR c.log_id IS NULL  -- End of a range (no next consecutive)
   OR (b.log_id IS NOT NULL AND c.log_id IS NOT NULL)
GROUP BY a.log_id - 
    (SELECT COUNT(*) FROM Logs WHERE log_id <= a.log_id)
ORDER BY start_id;


-- m3 

SELECT 
    MIN(log_id) AS start_id,
    MAX(log_id) AS end_id
FROM Logs
GROUP BY log_id - (SELECT COUNT(*) FROM Logs l2 WHERE l2.log_id <= Logs.log_id)
ORDER BY start_id;

