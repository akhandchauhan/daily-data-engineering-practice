-- 2668. Find Latest Salaries
-- Description
-- Table: Salary
-- +---------------+---------+ 
-- | Column Name   | Type    | 
-- +---------------+---------+ 
-- | emp_id        | int     | 
-- | firstname     | varchar |
-- | lastname      | varchar |
-- | salary        | varchar |
-- | department_id | varchar |
-- +---------------+---------+
-- (emp_id, salary) is the primary key for this table.
-- Each row contains employees details and their yearly salaries, however, 
--some of the records are old and contain outdated salary information. 

-- Write an  SQL query to find the current salary of each employee assuming 
--that salaries increase each year. Output their emp_id, firstname, lastname,
--  salary, and department_id.

-- Return the result table ordered by emp_id in ascending order.

-- Input:
-- Salary table:
-- +--------+-----------+----------+--------+---------------+
-- | emp_id | firstname | lastname | salary | department_id |
-- +--------+-----------+----------+--------+---------------+ 
-- | 1      | Todd      | Wilson   | 110000 | D1006         |
-- | 1      | Todd      | Wilson   | 106119 | D1006         | 
-- | 2      | Justin    | Simon    | 128922 | D1005         | 
-- | 2      | Justin    | Simon    | 128922 | D1005         | 
-- | 3      | Kelly     | Rosario  | 42689  | D1002         | 
-- | 4      | Patricia  | Powell   | 162825 | D1004         |
-- | 4      | Patricia  | Powell   | 170000 | D1004         |
-- | 5      | Sherry    | Golden   | 44101  | D1002         | 
-- | 6      | Natasha   | Swanson  | 79632  | D1005         | 
-- | 6      | Natasha   | Swanson  | 90000  | D1005         |
-- +--------+-----------+----------+--------+---------------+
-- Output:
-- +--------+-----------+----------+--------+---------------+
-- | emp_id | firstname | lastname | salary | department_id |
-- +--------+-----------+----------+--------+---------------+ 
-- | 1      | Todd      | Wilson   | 110000 | D1006         |
-- | 2      | Justin    | Simon    | 130000 | D1005         | 
-- | 3      | Kelly     | Rosario  | 42689  | D1002         | 
-- | 4      | Patricia  | Powell   | 170000 | D1004         |
-- | 5      | Sherry    | Golden   | 44101  | D1002         | 
-- | 6      | Natasha   | Swanson  | 90000  | D1005         |
-- +--------+-----------+----------+--------+---------------+

-- Explanation:
-- - emp_id 1 has two records with a salary of 110000, 106119 out of these 110000 
-- is an updated salary (Assuming salary is increasing each year)
-- - emp_id 2 has two records with a salary of 128922, 128922 out of these 130000 
-- is an updated salary.
-- - emp_id 3 has only one salary record so that is already an updated salary.
-- - emp_id 4 has two records with a salary of 162825, 170000 out of these 170000
--  is an updated salary.
-- - emp_id 5 has only one salary record so that is already an updated salary.
-- - emp_id 6 has two records with a salary of 79632, 90000 out of these 90000 is 
-- an updated salary.
 drop Table Salary;
Create table If Not Exists Salary (emp_id int,firstname varchar(100),
lastname varchar(100),salary int, department_id varchar(100));
Truncate table Salary;
INSERT INTO Salary (emp_id, firstname, lastname, salary, department_id)
VALUES 
(1, 'Todd', 'Wilson', 110000, 'D1006'),
(1, 'Todd', 'Wilson', 106119, 'D1006'),
(2, 'Justin', 'Simon', 128922, 'D1005'),
(2, 'Justin', 'Simon', 130000, 'D1005'),
(3, 'Kelly', 'Rosario', 42689, 'D1002'),
(4, 'Patricia', 'Powell', 162825, 'D1004'),
(4, 'Patricia', 'Powell', 170000, 'D1004'),
(5, 'Sherry', 'Golden', 44101, 'D1002'),
(6, 'Natasha', 'Swanson', 79632, 'D1005'),
(6, 'Natasha', 'Swanson', 90000, 'D1005');


-- m1
SELECT emp_id, firstname, lastname,department_id,MAX(salary)
FROM Salary
GROUP BY emp_id, firstname, lastname,department_id
ORDER BY emp_id;

----------------------------------------------------------------------------------------
-- m2
WITH salary_info AS (
SELECT
    *,
    MAX(salary) OVER(
        PARTITION BY emp_id
    ) AS latest_salary
FROM Salary
)
SELECT 
    emp_id,
    firstname,
    lastname,
    salary,
    department_id
FROM salary_info
WHERE salary = latest_salary
ORDER BY emp_id;

---------------------------------------------------------------------------------------
-- m3
WITH emp_salary_ranked AS (
SELECT
    *,
    ROW_NUMBER() OVER(
        PARTITION BY emp_id
        ORDER BY salary DESC
    ) AS salary_ranked
FROM Salary
)
SELECT 
    emp_id,
    firstname,
    lastname,
    salary,
    department_id
FROM emp_salary_ranked
WHERE salary_ranked = 1
ORDER BY emp_id;