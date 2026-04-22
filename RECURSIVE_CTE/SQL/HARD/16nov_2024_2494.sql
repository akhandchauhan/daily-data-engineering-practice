-- 2494. Merge Overlapping Events in the Same Hall
-- Description
-- Table: HallEvents
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | hall_id     | int  |
-- | start_day   | date |
-- | end_day     | date |
-- +-------------+------+
-- There is no primary key in this table. It may contain duplicates.
-- Each row of this table indicates the start day and end day of an event and the hall 
-- in which the event is held.

-- Write an SQL query to merge all the overlapping events that are held in the same hall.
-- Two events overlap if they have at least one day in common.
-- Return the result table in any order.
-- The query result format is in the following example.
-- Example 1:
-- Input: 
-- HallEvents table:
    SELECT 
            hall_id,
            start_day,
            end_date
    FROM hall_events
    UNION ALL
    SELECT 
            
    FROM cte
-- +---------+------------+------------+
-- | hall_id | start_day  | end_day    |
-- +---------+------------+------------+
-- | 1       | 2023-01-13 | 2023-01-14 |
-- | 1       | 2023-01-14 | 2023-01-17 |
-- | 1       | 2023-01-18 | 2023-01-25 |
-- | 2       | 2022-12-09 | 2022-12-23 |
-- | 2       | 2022-12-13 | 2022-12-17 |
-- | 3       | 2022-12-01 | 2023-01-30 |
-- +---------+------------+------------+
-- Output: 
-- +---------+------------+------------+
-- | hall_id | start_day  | end_day    |
-- +---------+------------+------------+
-- | 1       | 2023-01-13 | 2023-01-17 |
-- | 1       | 2023-01-18 | 2023-01-25 |
-- | 2       | 2022-12-09 | 2022-12-23 |
-- | 3       | 2022-12-01 | 2023-01-30 |
-- +---------+------------+------------+
-- Explanation: There are three halls.
-- Hall 1:
-- - The two events ["2023-01-13", "2023-01-14"] and ["2023-01-14", "2023-01-17"] 
-- overlap. We merge them in one event ["2023-01-13", "2023-01-17"].
-- - The event ["2023-01-18", "2023-01-25"] does not overlap with any other event, 
-- so we leave it as it is.
-- Hall 2:
-- - The two events ["2022-12-09", "2022-12-23"] and ["2022-12-13", "2022-12-17"] overlap. We merge them 
--in one event ["2022-12-09", "2022-12-23"].
-- Hall 3:
-- - The hall has only one event, so we return it. Note that we only consider the 
-- events of each hall separately.
DROP TABLE hall_events;

create table hall_events
(
hall_id integer,
start_date date,
end_date date
);
TRUNCATE TABLE hall_events;

insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');


--- 1 join is not sufficient because many rows can be overlapping
SELECT *
FROM hall_events h1
LEFT JOIN hall_events h2
ON h1.hall_id = h2.hall_id and h2.start_date between h1.start_date AND h1.end_date;


-- m2
WITH RECURSIVE cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (PARTITION BY hall_id ORDER BY start_date) AS event_id
    FROM hall_events
),
r_cte AS (
    SELECT  hall_id,  start_date, end_date, event_id, 1 AS flag 
    FROM cte 
    WHERE event_id = 1
    UNION ALL
    SELECT cte.hall_id, cte.start_date, cte.end_date, cte.event_id,
        CASE 
            WHEN cte.hall_id = r_cte.hall_id 
            AND (
                cte.start_date BETWEEN r_cte.start_date AND r_cte.end_date 
                OR r_cte.start_date BETWEEN cte.start_date AND cte.end_date
            ) 
            THEN flag ELSE flag + 1 END AS flag
    FROM r_cte
    INNER JOIN cte 
    ON r_cte.event_id + 1 = cte.event_id
    AND r_cte.hall_id = cte.hall_id
)
SELECT hall_id, flag, MIN(start_date) AS start_date, MAX(end_date) AS end_date
FROM r_cte
GROUP BY hall_id, flag;