-- 1225. Report Contiguous Dates
-- Table: Failed
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | fail_date    | date    |
-- +--------------+---------+
-- Primary key for this table is fail_date.
-- Failed table contains the days of failed tasks.
-- Table: Succeeded
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | success_date | date    |
-- +--------------+---------+
-- Primary key for this table is success_date.
-- Succeeded table contains the days of succeeded tasks.
-- A system is running one task every day. Every task is independent of the previous tasks.
-- The tasks can fail or succeed.
-- Write an SQL query to generate a report of period_state for each continuous interval
-- of days in the period from 2019-01-01 to 2019-12-31.
-- period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks succeeded.
-- Interval of days are retrieved as start_date and end_date.
-- Order result by start_date.
-- The query result format is in the following example:
-- Failed table:
-- +------------+
-- | fail_date  |
-- +------------+
-- | 2018-12-28 |
-- | 2018-12-29 |
-- | 2019-01-04 |
-- | 2019-01-05 |
-- +------------+
-- Succeeded table:
-- +--------------+
-- | success_date |
-- +--------------+
-- | 2018-12-30   |
-- | 2018-12-31   |
-- | 2019-01-01   |
-- | 2019-01-02   |
-- | 2019-01-03   |
-- | 2019-01-06   |
-- +--------------+
-- Result table:
-- +--------------+------------+------------+
-- | period_state | start_date | end_date   |
-- +--------------+------------+------------+
-- | succeeded    | 2019-01-01 | 2019-01-03 |
-- | failed       | 2019-01-04 | 2019-01-05 |
-- | succeeded    | 2019-01-06 | 2019-01-06 |
-- +--------------+------------+------------+
Create table If Not Exists Failed (fail_date date);
Create table If Not Exists Succeeded (success_date date);
Truncate table Failed;
insert into Failed (fail_date) values ('2018-12-28'),('2018-12-29'),
('2019-01-04'),('2019-01-05');
Truncate table Succeeded;
INSERT INTO Succeeded (success_date) VALUES
('2018-12-30'),('2018-12-31'),('2019-01-01'),('2019-01-02'),
('2019-01-03'),('2019-01-06');

-- m1
WITH cte AS (
    SELECT fail_date AS date, 'failed' AS state
    FROM Failed
    UNION ALL
    SELECT success_date AS date, 'succeeded' AS state
    FROM Succeeded
),
cte2 AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY state ORDER BY date) AS rnk
    FROM cte
    WHERE date BETWEEN '2019-01-01' AND '2019-12-31'
),
cte3 AS (
    SELECT *, DATE_SUB(date, INTERVAL rnk DAY) AS grp
    FROM cte2 
)
SELECT state AS period_state, MIN(date) AS start_date, MAX(date) AS end_date
FROM cte3
GROUP BY grp, state
ORDER BY 2;


---------------------------------------------------------------------------------
-- m2

WITH fail_base_info AS (
    SELECT 
        fail_date,
        DATE_SUB(fail_date,INTERVAL 
                    ROW_NUMBER() OVER(ORDER BY fail_date) DAY
        ) AS streak
        FROM Failed 
        WHERE fail_date>= '2019-01-01' AND fail_date < '2020-01-01'
),
final_fail_info AS (
    SELECT 
        'failed' AS period_state,
        MIN(fail_date) AS start_date,
        MAX(fail_date) AS end_date
    FROM fail_base_info
    GROUP BY streak
)
,success_base_info AS (
    SELECT 
        success_date,
        DATE_SUB(success_date,INTERVAL 
                    ROW_NUMBER() OVER(ORDER BY success_date) DAY
        ) AS streak
        FROM Succeeded 
        WHERE success_date>= '2019-01-01' AND success_date < '2020-01-01'
),
success_fail_info AS (
    SELECT 
        'Succeeded' AS period_state,
        MIN(success_date) AS start_date,
        MAX(success_date) AS end_date
    FROM success_base_info
    GROUP BY streak
)
SELECT 
        period_state,
        start_date,
        end_date
FROM final_fail_info
UNION ALL
SELECT period_state,
        start_date,
        end_date
FROM success_fail_info
ORDER BY start_date ;