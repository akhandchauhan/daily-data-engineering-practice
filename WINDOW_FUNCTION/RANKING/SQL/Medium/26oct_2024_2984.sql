-- 2984. Find Peak Calling Hours for Each City
-- Description
-- Table: Calls
-- +--------------+----------+
-- | Column Name  | Type     |
-- +--------------+----------+
-- | caller_id    | int      |
-- | recipient_id | int      |
-- | call_time    | datetime |
-- | city         | varchar  |
-- +--------------+----------+
-- (caller_id, recipient_id, call_time) is the primary key (combination of columns with unique values) 
-- for this table.
-- Each row contains caller id, recipient id, call time, and city.
-- Write a solution to find the peak calling hour for each city.
-- If multiple hours have the same number of  calls, all of those hours will 
-- be recognized as peak hours for that specific city.
-- Return the result table ordered by peak calling hour and city in descending order.
-- Input: 
-- Calls table:
-- +-----------+--------------+---------------------+----------+
-- | caller_id | recipient_id | call_time           | city     |
-- +-----------+--------------+---------------------+----------+
-- | 8         | 4            | 2021-08-24 22:46:07 | Houston  |
-- | 4         | 8            | 2021-08-24 22:57:13 | Houston  |  
-- | 5         | 1            | 2021-08-11 21:28:44 | Houston  |  
-- | 8         | 3            | 2021-08-17 22:04:15 | Houston  |
-- | 11        | 3            | 2021-08-17 13:07:00 | New York |
-- | 8         | 11           | 2021-08-17 14:22:22 | New York |
-- +-----------+--------------+---------------------+----------+
-- Output: 
-- +----------+-------------------+-----------------+
-- | city     | peak_calling_hour | number_of_calls |
-- +----------+-------------------+-----------------+
-- | Houston  | 22                | 3               |
-- | New York | 14                | 1               |
-- | New York | 13                | 1               |
-- +----------+-------------------+-----------------+
-- Explanation: 
-- For Houston:
--   - The peak time is 22:00, with a total of 3 calls recorded. 
-- For New York:
--   - Both 13:00 and 14:00 hours have equal call counts of 1, so both times are considered peak hours.
-- Output table is ordered by peak_calling_hour and city in descending order.
drop table Calls;
Create table If Not Exists Calls (caller_id int, recipient_id int, call_time datetime, city varchar(40));
INSERT INTO Calls (caller_id, recipient_id, call_time, city) VALUES
('8', '4', '2021-08-24 22:46:07', 'Houston'),
('4', '8', '2021-08-24 22:57:13', 'Houston'),
('5', '1', '2021-08-11 21:28:44', 'Houston'),
('8', '3', '2021-08-17 22:04:15', 'Houston'),
('11', '3', '2021-08-17 13:07:00', 'New York'),
('8', '11', '2021-08-17 14:22:22', 'New York');


WITH cte as(
    SELECT city, HOUR(call_time) as peak_calling_hour, COUNT(*) AS cnt
    FROM Calls
    GROUP BY 1,2
),
cte2 as(
    SELECT city, peak_calling_hour, cnt, 
    DENSE_RANK() OVER(PARTITION BY city ORDER BY cnt desc) as rnk
    FROM cte
)
SELECT city, peak_calling_hour, cnt as number_of_calls
FROM cte2
WHERE rnk = 1
ORDER BY peak_calling_hour DESC, city DESC;

-------------------------------------------------------------------------------------------------------------
-- m2
WITH call_city_info AS (
    SELECT 
        city,
        HOUR(call_time) AS call_hour,
        COUNT(caller_id) AS number_of_calls,
        DENSE_RANK() OVER(
                    PARTITION BY city 
                    ORDER BY COUNT(caller_id) DESC
                ) AS call_city_rank
    FROM Calls
    GROUP BY city,
            HOUR(call_time)
)
SELECT 
        city,
        call_hour AS peak_calling_hour,
        number_of_calls
FROM call_city_info
WHERE call_city_rank = 1
ORDER BY 
    peak_calling_hour DESC,
    city DESC
;

-------------------------------------------------------------------------------------------------------------
-- m3
WITH call_city_info AS (
    SELECT 
        city,
        HOUR(call_time) AS call_hour,
        COUNT(caller_id) AS number_of_calls,
        MAX(COUNT(HOUR(call_time))) OVER(
                    PARTITION BY city 
                ) AS max_call_city_hour
    FROM Calls
    GROUP BY city,
            HOUR(call_time)
)
SELECT 
        city,
        call_hour AS peak_calling_hour,
        number_of_calls
FROM call_city_info
WHERE max_call_city_hour = number_of_calls
ORDER BY 
    peak_calling_hour DESC,
    city DESC
;
