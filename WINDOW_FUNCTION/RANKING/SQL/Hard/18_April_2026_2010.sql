-- 2010. The Number of Seniors and Juniors to Join the Company II
-- Description
-- Table: Candidates
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | employee_id | int  |
-- | experience  | enum |
-- | salary      | int  |
-- +-------------+------+
-- employee_id is the primary key column for this table.
-- experience is an enum with one of the values ('Senior', 'Junior').
-- Each row of this table indicates the id of a candidate, their monthly salary,
--  and their experience.
-- The salary of each candidate is guaranteed to be unique.

-- A company wants to hire new employees. The budget of the company for the salaries 
-- is $70000. The company's criteria for hiring are:

-- Keep hiring the senior with the smallest salary until you cannot hire any more seniors.
-- Use the remaining budget to hire the junior with the smallest salary.
-- Keep hiring the junior with the smallest salary until you cannot hire any more juniors.
-- Write an SQL query to find the ids of seniors and juniors hired under the mentioned 
-- criteria.

-- Input:
-- Candidates table:
-- +-------------+------------+--------+
-- | employee_id | experience | salary |
-- +-------------+------------+--------+
-- | 1           | Junior     | 10000  |
-- | 9           | Junior     | 15000  |
-- | 2           | Senior     | 20000  |
-- | 11          | Senior     | 16000  |
-- | 13          | Senior     | 50000  |
-- | 4           | Junior     | 40000  |
-- +-------------+------------+--------+
-- Output: 
-- +-------------+
-- | employee_id |
-- +-------------+
-- | 11          |
-- | 2           |
-- | 1           |
-- | 9           |
-- +-------------+
-- Explanation: 
-- We can hire 2 seniors with IDs (11, 2). Since the budget is $70000 and the sum
--  of their salaries is $36000, we still have $34000 but they are not enough to
--   hire the senior candidate with ID 13.
-- We can hire 2 juniors with IDs (1, 9). Since the remaining budget is $34000 
-- and the sum of their salaries is $25000, we still have $9000 but they are not 
-- enough to hire the junior candidate with ID 4.

-- Example 2:
-- Input:
-- Candidates table:
-- +-------------+------------+--------+
-- | employee_id | experience | salary |
-- +-------------+------------+--------+
-- | 1           | Junior     | 25000  |
-- | 9           | Junior     | 10000  |
-- | 2           | Senior     | 85000  |
-- | 11          | Senior     | 80000  |
-- | 13          | Senior     | 90000  |
-- | 4           | Junior     | 30000  |
-- +-------------+------------+--------+
-- Output: 
-- +-------------+
-- | employee_id |
-- +-------------+
-- | 9           |
-- | 1           |
-- | 4           |
-- +-------------+
-- Explanation: 
-- We cannot hire any seniors with the current budget as we need at least 
-- $80000 to hire one senior.
-- We can hire all three juniors with the remaining budget.


DROP TABLE IF EXISTS Candidates;

CREATE TABLE Candidates (
    employee_id INT PRIMARY KEY,
    experience ENUM('Senior', 'Junior'),
    salary INT
);

INSERT INTO Candidates (employee_id, experience, salary) VALUES
(1, 'Junior', 10000),
(9, 'Junior', 15000),
(2, 'Senior', 20000),
(11, 'Senior', 16000),
(13, 'Senior', 50000),
(4, 'Junior', 40000);

-- example 2

TRUNCATE TABLE candidates;
INSERT INTO Candidates (employee_id, experience, salary) VALUES
(1, 'Junior', 25000),
(9, 'Junior', 10000),
(2, 'Senior', 85000),
(11, 'Senior', 80000),
(13, 'Senior', 90000),
(4, 'Junior', 30000);

-- m1 wrong dont evaluate
WITH base_employee_info AS (
    SELECT 
        employee_id,
        experience,
        salary,
        ROW_NUMBER() OVER(
            PARTITION BY experience
            ORDER BY salary) AS employee_ranked,
        SUM(salary) OVER(
            PARTITION BY experience
            ORDER BY salary
        ) AS cum_sum
    FROM Candidates
),
senior_hired_cte AS (
    SELECT 
        MAX(employee_id) AS employee_id,
        COALESCE(MAX(70000 - cum_sum), 70000) AS balance_left
    FROM base_employee_info
    WHERE experience = 'Senior'
    AND 70000 - cum_sum >= 0
)
SELECT employee_id
FROM senior_hired_cte
WHERE employee_id IS NOT NULL
UNION 
(SELECT 
        employee_id
    FROM base_employee_info
    WHERE experience = 'Junior'
    AND (SELECT MIN(balance_left) FROM senior_hired_cte) - cum_sum >= 0 
    AND employee_id IS NOT NULL
);

-----------------------------------------------------------------------------------
--m2
WITH base_employee_info AS (
    SELECT 
        employee_id,
        experience,
        salary,
        SUM(salary) OVER(
            PARTITION BY experience
            ORDER BY salary
        ) AS cum_sum
    FROM Candidates
),
senior_hired_cte AS (
    SELECT 
        employee_id,
        70000 - cum_sum AS balance_left
    FROM base_employee_info
    WHERE experience = 'Senior'
    AND 70000 - cum_sum >= 0
)
-- seniors
SELECT employee_id
FROM senior_hired_cte
UNION
-- juniors
SELECT employee_id
FROM base_employee_info
WHERE experience = 'Junior'
AND (
    SELECT COALESCE(MIN(balance_left), 70000) 
    FROM senior_hired_cte
) - cum_sum >= 0;


-----------------------------------------------------------------------------------------
-- m3
WITH ordered AS (
    SELECT *,
           SUM(salary) OVER (
               PARTITION BY experience
               ORDER BY salary
           ) AS cum_sum
    FROM Candidates
),
seniors AS (
    SELECT *
    FROM ordered
    WHERE experience = 'Senior'
    AND cum_sum <= 70000
),
remaining AS (
    SELECT 70000 - COALESCE(MAX(cum_sum), 0) AS budget
    FROM seniors
),
juniors AS (
    SELECT *
    FROM ordered
    WHERE experience = 'Junior'
    AND cum_sum <= (SELECT budget FROM remaining)
)
SELECT employee_id FROM seniors
UNION ALL
SELECT employee_id FROM juniors;

