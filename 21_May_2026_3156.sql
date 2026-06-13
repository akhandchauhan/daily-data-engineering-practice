-- 3156. Employee Task Duration and Concurrent Tasks 

-- Table: Tasks
-- +---------------+----------+
-- | Column Name   | Type     |
-- +---------------+----------+
-- | task_id       | int      |
-- | employee_id   | int      |
-- | start_time    | datetime |
-- | end_time      | datetime |
-- +---------------+----------+
-- (task_id, employee_id) is the primary key for this table.
-- Each row in this table contains the task identifier, the employee identifier,
-- and the start and end times of each task.

-- Write a solution to find the total duration of tasks for each employee 
-- and the maximum number of concurrent tasks an employee handled at any point in time. 
-- The total duration should be rounded down to the nearest number of full hours.

-- Return the result table ordered by employee_id ascending order.

-- Tasks table:
-- +---------+-------------+---------------------+---------------------+
-- | task_id | employee_id | start_time          | end_time            |
-- +---------+-------------+---------------------+---------------------+
-- | 1       | 1001        | 2023-05-01 08:00:00 | 2023-05-01 09:00:00 |
-- | 2       | 1001        | 2023-05-01 08:30:00 | 2023-05-01 10:30:00 |
-- | 3       | 1001        | 2023-05-01 11:00:00 | 2023-05-01 12:00:00 |
-- | 7       | 1001        | 2023-05-01 13:00:00 | 2023-05-01 15:30:00 |
-- | 4       | 1002        | 2023-05-01 09:00:00 | 2023-05-01 10:00:00 |
-- | 5       | 1002        | 2023-05-01 09:30:00 | 2023-05-01 11:30:00 |
-- | 6       | 1003        | 2023-05-01 14:00:00 | 2023-05-01 16:00:00 |
-- +---------+-------------+---------------------+---------------------+

-- Output:
-- +-------------+------------------+----------------------+
-- | employee_id | total_task_hours | max_concurrent_tasks |
-- +-------------+------------------+----------------------+
-- | 1001        | 6                | 2                    |
-- | 1002        | 2                | 2                    |
-- | 1003        | 2                | 1                    |
-- +-------------+------------------+----------------------+
-- Explanation:

-- For employee ID 1001:
-- Task 1 and Task 2 overlap from 08:30 to 09:00 (30 minutes).
-- Task 7 has a duration of 150 minutes (2 hours and 30 minutes).
-- Total task time: 60 (Task 1) + 120 (Task 2) + 60 (Task 3) + 150 (Task 7) - 30 (overlap) = 360 
-- minutes = 6 hours.
-- Maximum concurrent tasks: 2 (during the overlap period).
-- For employee ID 1002:
-- Task 4 and Task 5 overlap from 09:30 to 10:00 (30 minutes).
-- Total task time: 60 (Task 4) + 120 (Task 5) - 30 (overlap) = 150 minutes = 2 hours and 30 minutes.
-- Total task hours (rounded down): 2 hours.
-- Maximum concurrent tasks: 2 (during the overlap period).
-- For employee ID 1003:
-- No overlapping tasks.
-- Total task time: 120 minutes = 2 hours.
-- Maximum concurrent tasks: 1.
-- Note: Output table is ordered by employee_id in ascending order.

DROP TABLE IF EXISTS Tasks;

CREATE TABLE Tasks (
    task_id      INT,
    employee_id  INT,
    start_time   DATETIME,
    end_time     DATETIME
);

INSERT INTO Tasks (task_id, employee_id, start_time, end_time) VALUES
(1, 1001, '2023-05-01 08:00:00', '2023-05-01 09:00:00'),
(2, 1001, '2023-05-01 08:30:00', '2023-05-01 10:30:00'),
(3, 1001, '2023-05-01 11:00:00', '2023-05-01 12:00:00'),
(7, 1001, '2023-05-01 13:00:00', '2023-05-01 15:30:00'),
(4, 1002, '2023-05-01 09:00:00', '2023-05-01 10:00:00'),
(5, 1002, '2023-05-01 09:30:00', '2023-05-01 11:30:00'),
(6, 1003, '2023-05-01 14:00:00', '2023-05-01 16:00:00');

WITH tasks_ranked AS (
    SELECT 
        task_id,
        employee_id,
        start_time,
        end_time,
        ROW_NUMBER() OVER(
            PARTITION BY employee_id
            ORDER BY start_time  -- ❌ no tie-break column; ranks are non-deterministic when two tasks share the same start_time
        ) AS task_rank
    FROM Tasks
)
,overlapping_tasks_info AS(
    SELECT 
            t1.employee_id,
            t1.start_time,  -- ❌ grouping on start_time merges two distinct tasks that start at the same time into one row
            SUM(
                TIMESTAMPDIFF(second,t2.start_time,t1.end_time) -- ❌ overcounts when t1 fully contains t2; correct formula: TIMESTAMPDIFF(second, t2.start_time, LEAST(t1.end_time, t2.end_time))
            ) AS total_task_seconds,
            COUNT(*) AS task_count  -- ❌ counts later-ranked overlapping tasks only; misses pairs where a later task contains an earlier one across rank gap
    FROM tasks_ranked t1
    JOIN tasks_ranked t2  -- ❌ entire pairwise subtraction strategy breaks for 3+ simultaneously overlapping tasks (inclusion-exclusion problem)
    ON t1.employee_id = t2.employee_id
    AND t1.task_id <> t2.task_id
    AND t1.task_rank < t2.task_rank
    WHERE 
        t2.start_time <= t1.end_time
        AND t1.start_time <= t2.end_time 
    GROUP BY 
            t1.employee_id,
            t1.start_time
),
concurrent_info AS (
    SELECT 
        employee_id,
        SUM(total_task_seconds) AS total_task_seconds,
        MAX(task_count) + 1 AS max_task_count  -- ❌ wrong: if task A overlaps B and C but B and C don't overlap each other, this returns 3 instead of 2
    FROM overlapping_tasks_info
    GROUP BY employee_id
),
all_task_info AS (
    SELECT 
        employee_id,
        SUM(
                TIMESTAMPDIFF(second,start_time,end_time)
            ) AS total_task_seconds  -- ✓ correct raw sum of all individual task durations before deducting overlaps
    FROM tasks t
    GROUP BY 
            employee_id
)
SELECT
    ati.employee_id,
    FLOOR(
        (ati.total_task_seconds - COALESCE(ci.total_task_seconds,0))/3600  -- ❌ pairwise overlap subtraction is mathematically incorrect for 3+ overlapping tasks; need merge-intervals approach
    ) AS total_task_hours,
    COALESCE(ci.max_task_count, 1) AS max_concurrent_tasks  -- ✓ correct fallback to 1 for employees with no overlapping tasks
FROM all_task_info ati
LEFT JOIN concurrent_info ci
ON ati.employee_id = ci.employee_id
-- ❌ missing ORDER BY employee_id ASC — required by the problem statement