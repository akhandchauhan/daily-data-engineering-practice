-- 603. Consecutive Available Seats 

-- Table: Cinema
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | seat_id     | int  |
-- | free        | bool |
-- +-------------+------+
-- seat_id is an auto-increment column for this table.
-- Each row of this table indicates whether the ith seat is free or not. 
-- 1 means free while 0 means occupied.
 
-- Find all the consecutive available seats in the cinema.
-- Return the result table ordered by seat_id in ascending order.

-- The test cases are generated so that more than two seats are consecutively available.

-- The result format is in the following example.

-- Example 1:

-- Input: 
-- Cinema table:
-- +---------+------+
-- | seat_id | free | lag | lead
-- +---------+------+
-- | 1       | 1    | NULL - 0
-- | 2       | 0    | 1 - 1
-- | 3       | 1    | 0 - 1
-- | 4       | 1    | 1 - 1
-- | 5       | 1    | 1 - NULL
-- +---------+------+
-- Output: 
-- +---------+
-- | seat_id |
-- +---------+
-- | 3       |
-- | 4       |
-- | 5       |
-- +---------+

DROP TABLE IF EXISTS Cinema;

CREATE TABLE Cinema (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    free INT
);

INSERT INTO Cinema (seat_id, free) VALUES
(1, 1),
(2, 0),
(3, 1),
(4, 1),
(5, 1);

-- m1 not correct 
WITH seat_info AS (
    SELECT 
        seat_id,
        free,
        LEAD(free,1,1) OVER(ORDER BY seat_id) AS next
    FROM Cinema
)
SELECT seat_id
FROM seat_info 
WHERE free = 1 
AND next = 1
ORDER BY seat_id;


--------------------------------------------------------------------------------------------
-- m2 
SELECT seat_id
FROM (
    SELECT 
        seat_id,
        free,
        LAG(free) OVER(ORDER BY seat_id) AS prev,
        LEAD(free) OVER(ORDER BY seat_id) AS next
    FROM Cinema
) t
WHERE free = 1 
AND (prev = 1 OR next = 1)
ORDER BY seat_id;