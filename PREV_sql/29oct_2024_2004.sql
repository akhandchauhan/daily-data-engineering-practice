-- 2004. The Number of Seniors and Juniors to Join the Company
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
-- Each row of this table indicates the id of a candidate, their monthly salary, and their experience.
-- A company wants to hire new employees. The budget of the company for the salaries is $70000.
-- The company's criteria for hiring are:
-- Hiring the largest number of seniors.
-- After hiring the maximum number of seniors, use the remaining budget to hire the largest number of juniors.
-- Write an SQL query to find the number of seniors and juniors hired under the mentioned criteria.
-- Return the result table in any order.
-- The query result format is in the following example.
-- Example 1:
-- Input: 
-- Candidates table:
-- +-------------+------------+--------+
-- | employee_id | experience | salary |
-- +-------------+------------+--------+
-- | 1           | Junior     | 10000  |
-- | 9           | Junior     | 10000  |
-- | 2           | Senior     | 20000  |
-- | 11          | Senior     | 20000  |
-- | 13          | Senior     | 50000  |
-- | 4           | Junior     | 40000  |
-- +-------------+------------+--------+
-- Output: 
-- +------------+---------------------+
-- | experience | accepted_candidates |
-- +------------+---------------------+
-- | Senior     | 2                   |
-- | Junior     | 2                   |
-- +------------+---------------------+
-- Explanation: 
-- We can hire 2 seniors with IDs (2, 11). Since the budget is $70000 and the sum of their salaries is $40000,
-- we still have $30000 but they are not enough to hire the senior candidate with ID 13.
-- We can hire 2 juniors with IDs (1, 9). Since the remaining budget is $30000 and the sum of their salaries
-- is $20000, we still have $10000 but they are not enough to hire the junior candidate with ID 4.
-- Example 2:
-- Input: 
-- Candidates table:
-- +-------------+------------+--------+
-- | employee_id | experience | salary |
-- +-------------+------------+--------+
-- | 1           | Junior     | 10000  |
-- | 9           | Junior     | 10000  |
-- | 2           | Senior     | 80000  |
-- | 11          | Senior     | 80000  |
-- | 13          | Senior     | 80000  |
-- | 4           | Junior     | 40000  |
-- +-------------+------------+--------+
-- Output: 
-- +------------+---------------------+
-- | experience | accepted_candidates |
-- +------------+---------------------+
-- | Senior     | 0                   |
-- | Junior     | 3                   |
-- +------------+---------------------+
-- Explanation: 
-- We cannot hire any seniors with the current budget as we need at least $80000 to hire one senior.
-- We can hire all three juniors with the remaining budget.

DROP TABLE IF EXISTS Candidates;

-- Create the Candidates table
CREATE TABLE Candidates (
    employee_id INT PRIMARY KEY,
    experience ENUM('Senior', 'Junior'),
    salary INT
);

-- Insert values into the Candidates table
INSERT INTO Candidates (employee_id, experience, salary) VALUES
(1, 'Junior', 10000),
(9, 'Junior', 10000),
(2, 'Senior', 20000),
(11, 'Senior', 20000),
(13, 'Senior', 50000),
(4, 'Junior', 40000);


WITH cte as(
    SELECT *,SUM(salary) OVER(PARTITION BY experience ORDER BY salary) as cum_sum
    FROM Candidates
    ),
    cte2 as(
    SELECT 'Senior' as experience,
    IFNULL(COUNT(employee_id),0) as accept_cand
    FROM cte
    WHERE experience='Senior'
    AND cum_sum <= 70000
)
SELECT *
FROM cte2
UNION 
SELECT 'Junior' as experience,
IFNULL(COUNT(employee_id),0) as accept_cand
FROM cte
WHERE experience='Junior'
AND cum_sum <= 70000 -IFNULL((SELECT max(cum_sum) FROM cte2),0);

-- m2  = not working my sol
WITH cte as(
    SELECT *, 
SUM(salary) OVER(PARTITION BY experience ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING and current row) as cum_sum
FROM Candidates
),cte2 as(
SELECT *,RANK() OVER(PARTITION BY experience ORDER BY cum_sum) as rnk
FROM cte
),cte3 as(
SELECT *,max(cum_sum) OVER(PARTITION BY experience) as maxi
FROM cte2
WHERE cum_sum < 70000 
)
SELECT *
FROM cte3
WHERE experience = 'Junior' and 
cum_sum + (SELECT maxi FROM cte3 where experience =' Senior') < 70000;

-- m3 =easy way
WITH s AS (
    SELECT employee_id,
        SUM(salary) OVER (ORDER BY salary) AS cur
    FROM Candidates
    WHERE experience = 'Senior'
),
j AS (
    SELECT 
        employee_id,
        IFNULL(
            (SELECT MAX(cur) FROM s WHERE cur <= 70000), 0) + SUM(salary) OVER (ORDER BY salary) AS cur
    FROM Candidates
    WHERE experience = 'Junior'
)
SELECT 
    'Senior' AS experience,
    COUNT(employee_id) AS accepted_candidates
FROM s
WHERE cur <= 70000
UNION ALL
SELECT 
    'Junior' AS experience,
    COUNT(employee_id) AS accepted_candidates
FROM j
WHERE cur <= 70000;


--- m4 agian i attempted
WITH senior as (
    SELECT *, sum(salary) OVER(order by salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cum_sum
FROM Candidates 
WHERE experience = 'Senior'
),
junior as (
    SELECT *,(SELECT MAX(cum_sum) FROM senior where cum_sum < 70000) + 
    sum(salary) OVER(order by salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cum_sum_junior
    FROM Candidates
    WHERE experience = 'Junior'
)
SELECT 'Senior' as experience,IFNULL(COUNT(salary),0) as accepted_candidates
FROM senior 
WHERE cum_sum < 70000
UNION 
SELECT 'junior',COUNT(salary) 
FROM junior
WHERE cum_sum_junior < 70000;


-- m5 22 Jan 2026


WITH salary_info as (
    SELECT *,
        SUM(salary) OVER(PARTITION BY experience ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cum_sum
    FROM Candidates
),
senior_exp as (
    SELECT 'Senior' as experience,
            COALESCE(MAX(cum_sum), 0) AS senior_spent,
            COUNT(employee_id) as senior_cnt
    FROM salary_info
    WHERE experience = 'Senior' AND cum_sum <= 70000
)
SELECT experience, IFNULL(senior_cnt,0) as accepted_candidates
FROM senior_exp
UNION ALL 
SELECT 'junior', IFNULL(COUNT(employee_id), 0) as accepted_candidates
FROM salary_info 
WHERE experience = 'Junior'  AND cum_sum <= (
          SELECT 70000 - senior_spent
          FROM senior_exp
      );