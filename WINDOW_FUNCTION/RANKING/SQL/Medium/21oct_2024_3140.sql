-- 3140. Consecutive Available Seats II 
-- Description
-- Table: Cinema
-- \| Column Name \| Type \|
-- \| seat_id     \| int  \|
-- \| free        \| bool \|
-- seat_id is an auto-increment column for this table.
-- Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.
-- Write a solution to find the length of longest consecutive sequence of available seats in the cinema.

-- Note:
-- There will always be at most one longest consecutive sequence.
-- If there are multiple consecutive sequences with the same length, include all of them in the output.
-- Return the result table ordered by first_seat_id in ascending order.

-- \| 1       \| 1    \|
-- \| 2       \| 0    \|
-- \| 3       \| 1    \|
-- \| 4       \| 1    \|
-- \| 5       \| 1    \|
-- Output:
-- +-----------------+----------------+-----------------------+
-- | first_seat_id   | last_seat_id   | consecutive_seats_len |
-- +-----------------+----------------+-----------------------+
-- | 3               | 5              | 3                     |
-- +-----------------+----------------+-----------------------+
-- Explanation:
-- Longest consecutive sequence of available seats starts from seat 3 and ends at seat 5 with a length of 3.
-- Output table is ordered by first_seat_id in ascending order.

DROP TABLE Cinema;

CREATE TABLE if Not exists Cinema (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    free BOOLEAN
);

Truncate table Cinema;
INSERT INTO Cinema (seat_id, free) VALUES
(1, 1),
(2, 0),
(3, 1),
(4, 1),
(5, 1);

-- m1 
WITH
    T AS (
        SELECT
            *,
            seat_id - (RANK() OVER (ORDER BY seat_id)) AS gid
        FROM Cinema
        WHERE free = 1
    ),
    P AS (
        SELECT
            MIN(seat_id) AS first_seat_id,
            MAX(seat_id) AS last_seat_id,
            COUNT(1) AS consecutive_seats_len,
            RANK() OVER (ORDER BY COUNT(1) DESC) AS rk
        FROM T
        GROUP BY gid
    )
SELECT first_seat_id, last_seat_id, consecutive_seats_len
FROM P
WHERE rk = 1
ORDER BY 1;


--------------------------------------------------------------------------------------------------------
-- m2

WITH seating_info AS (
    SELECT 
        seat_id,
        free,
        CAST(seat_id AS signed) - CAST(ROW_NUMBER() OVER(ORDER BY seat_id) AS signed) as seat_rank
    FROM Cinema
    WHERE free = 1
)
SELECT
    first_seat_id,
    last_seat_id,
    consecutive_seats_len
FROM (
    SELECT 
        seat_rank,
        COUNT(free) AS consecutive_seats_len,
        MAX(seat_id) AS last_seat_id ,
        MIN(seat_id) AS first_seat_id,
        DENSE_RANK() OVER(ORDER BY COUNT(free) DESC) AS seating_rank
    FROM seating_info si 
    GROUP BY seat_rank
) t  
WHERE seating_rank = 1
ORDER BY first_seat_id
;

--------------------------------------------------------------------------------------------------------
-- m3

WITH grouped AS (
    SELECT 
        seat_id,
        seat_id - ROW_NUMBER() OVER (ORDER BY seat_id) AS grp
    FROM Cinema
    WHERE free = 1
),
agg AS (
    SELECT 
        MIN(seat_id) AS first_seat_id,
        MAX(seat_id) AS last_seat_id,
        COUNT(*) AS len
    FROM grouped
    GROUP BY grp
)
SELECT 
    first_seat_id,
    last_seat_id,
    len AS consecutive_seats_len
FROM (
    SELECT *,
        DENSE_RANK() OVER (ORDER BY len DESC) AS rnk
    FROM agg
) t
WHERE rnk = 1
ORDER BY first_seat_id;

--------------------------------------------------------------------------------------------------------
-- m4

WITH flagged AS (
    SELECT 
        seat_id,
        free,
        CASE 
            WHEN free = 1 AND LAG(free) OVER (ORDER BY seat_id) = 1 
            THEN 0 ELSE 1 
        END AS new_group
    FROM Cinema
),
grouped AS (
    SELECT *,
        SUM(new_group) OVER (ORDER BY seat_id) AS grp
    FROM flagged
    WHERE free = 1
),
agg AS (
    SELECT 
        MIN(seat_id) AS first_seat_id,
        MAX(seat_id) AS last_seat_id,
        COUNT(*) AS len
    FROM grouped
    GROUP BY grp
)
SELECT *
FROM (
    SELECT *,
        DENSE_RANK() OVER (ORDER BY len DESC) AS rnk
    FROM agg
) t
WHERE rnk = 1;