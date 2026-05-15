-- 1767. Find the Subtasks That Did Not Execute

-- Table: Tasks
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | task_id        | int     |
-- | subtasks_count | int     |
-- +----------------+---------+
-- task_id is the primary key for this table.
-- Each row in this table indicates that task_id was divided into subtasks_count subtasks 
-- labelled from 1 to subtasks_count.It is guaranteed that 2 <= subtasks_count <= 20.

-- Table: Executed
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | task_id       | int     |
-- | subtask_id    | int     |
-- +---------------+---------+
-- (task_id, subtask_id) is the primary key for this table.
-- Each row in this table indicates that for the task task_id, the subtask with 
-- ID subtask_id was executed successfully.
-- It is guaranteed that subtask_id <= subtasks_count for each task_id.

-- Write an  SQL query to report the IDs of the missing subtasks for each task_id.
-- Return the result table in any order.

-- Tasks table:
-- +---------+----------------+
-- | task_id | subtasks_count |
-- +---------+----------------+
-- | 1       | 3              |
-- | 2       | 2              |
-- | 3       | 4              |
-- +---------+----------------

-- Executed table:
-- +---------+------------+
-- | task_id | subtask_id |
-- +---------+------------+
-- | 1       | 2          |
-- | 3       | 1          |
-- | 3       | 2          |
-- | 3       | 3          |
-- | 3       | 4          |
-- +---------+------------+
-- Result table:
-- +---------+------------+
-- | task_id | subtask_id |
-- +---------+------------+
-- | 1       | 1          |
-- | 1       | 3          |
-- | 2       | 1          |
-- | 2       | 2          |
-- +---------+------------+
-- Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, 
-- so we include (1, 1) and (1, 3) in the answer.
-- Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so 
-- we include (2, 1) and (2, 2) in the answer.
-- Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.

DROP TABLE Tasks;
Create table If Not Exists Tasks (task_id int, subtasks_count int);
Create table If Not Exists Executed (task_id int, subtask_id int);
TRUNCATE TABLE Tasks;
INSERT INTO Tasks (task_id, subtasks_count)
VALUES
(1,3),
(2,2),
(3,4);

TRUNCATE TABLE Executed;
INSERT INTO Executed (task_id, subtask_id)
VALUES
(1,2),
(3,1),
(3,2),
(3,3),
(3,4);

-- m1
WITH RECURSIVE NumberSeries AS (
    SELECT task_id, 1 AS subtask_number, subtasks_count
    FROM Tasks
    UNION ALL
    SELECT task_id, subtask_number + 1, subtasks_count
    FROM NumberSeries
    WHERE subtask_number < subtasks_count
)
SELECT n.task_id, n.subtask_number
FROM NumberSeries n 
LEFT JOIN Executed e 
on n.task_id = e.task_id and n.subtask_number = e.subtask_id
WHERE e.task_id IS NULL ;

--------------------------------------------------------------------------------------------------
-- m2
WITH RECURSIVE cte AS(
	SELECT *
    from Tasks
    UNION ALL
    SELECT task_id, subtasks_count-1
    FROM cte
    WHERE subtasks_count > 1
)
SELECT task_id, subtasks_count as subtask_id
FROM cte 
WHERE (task_id, subtasks_count) not in (SELECT * FROM executed);

--------------------------------------------------------------------------------------------------
-- M3 
WITH RECURSIVE task_generator AS (
    SELECT
        task_id,
        subtasks_count
    FROM Tasks
    UNION ALL
    SELECT
        task_id,
        subtasks_count -1 AS subtasks_count
    FROM task_generator
    WHERE subtasks_count > 1
)
SELECT 
    tg.task_id,
    tg.subtasks_count AS subtask_id
FROM task_generator tg  
LEFT JOIN  Executed e 
ON tg.task_id = e.task_id
AND tg.subtasks_count = e.subtask_id
WHERE e.task_id IS NULL
ORDER BY tg.task_id;