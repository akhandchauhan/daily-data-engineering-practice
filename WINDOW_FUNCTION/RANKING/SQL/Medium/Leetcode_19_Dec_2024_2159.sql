-- 2159. Order Two Columns Independently
-- Description
-- Table: Data
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | first_col   | int  |
-- | second_col  | int  |
-- +-------------+------+
-- There is no primary key for this table and it may contain duplicates.
-- Write an SQL query to independently:
-- order first_col in ascending order.
-- order second_col in descending order.
-- The query result format is in the following example.
-- Example 1:
-- Input: 
-- Data table:
-- +-----------+------------+
-- | first_col | second_col |
-- +-----------+------------+
-- | 4         | 2          |
-- | 2         | 3          |
-- | 3         | 1          |
-- | 1         | 4          |
-- +-----------+------------+
-- Output: 
-- +-----------+------------+
-- | first_col | second_col |
-- +-----------+------------+
-- | 1         | 4          |
-- | 2         | 3          |
-- | 3         | 2          |
-- | 4         | 1          |

drop table if exists Data;
CREATE TABLE Data (
    first_col INT,
    second_col INT
);

-- Insert values into the Data table
INSERT INTO Data (first_col, second_col) VALUES
(4, 2),
(2, 3),
(3, 1),
(1, 4);

WITH cte1 AS (
    SELECT 
        first_col, 
        ROW_NUMBER() OVER (ORDER BY first_col) AS rnk1
    FROM Data
),
cte2 AS (
    SELECT 
        second_col, 
        ROW_NUMBER() OVER (ORDER BY second_col DESC) AS rnk2
    FROM Data
)
SELECT 
    cte1.first_col, 
    cte2.second_col
FROM cte1
JOIN cte2
ON cte1.rnk1 = cte2.rnk2;


-----------------------------------------------------------------------------------------------------------
-- m2 = wrong query

WITH data_ranking AS (
    SELECT 
            first_col,
            second_col,
            ROW_NUMBER() OVER(ORDER BY first_col) AS first_ranking,
            ROW_NUMBER() OVER(ORDER BY second_col DESC) AS second_ranking
    FROM Data 
)
SELECT first_col,
        second_col
FROM data_ranking
ORDER BY first_ranking,
         second_ranking ;