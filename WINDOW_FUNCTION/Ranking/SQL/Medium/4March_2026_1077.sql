-- 1077. Project Employees III
-- Description
-- Table: Project
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- (project_id, employee_id) is the primary key (combination of columns with unique values) of this table.
-- employee_id is a foreign key (reference column) to Employee table.
-- Each row of this table indicates that the employee with employee_id is working on the project with
-- project_id.
-- Table: Employee
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | experience_years | int     |
-- +------------------+---------+
-- employee_id is the primary key (column with unique values) of this table.
-- Each row of this table contains information about one employee.
-- Write a solution to report the most experienced employees in each project. In case of a tie,
-- report all employees with the maximum number of experience years.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:

-- Input: 
-- Project table:
-- +-------------+-------------+
-- | project_id  | employee_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- | 1           | 2           |
-- | 1           | 3           |
-- | 2           | 1           |
-- | 2           | 4           |
-- +-------------+-------------+
-- Employee table:
-- +-------------+--------+------------------+
-- | employee_id | name   | experience_years |
-- +-------------+--------+------------------+
-- | 1           | Khaled | 3                |
-- | 2           | Ali    | 2                |
-- | 3           | John   | 3                |
-- | 4           | Doe    | 2                |
-- +-------------+--------+------------------+
-- Output: 
-- +-------------+---------------+
-- | project_id  | employee_id   |
-- +-------------+---------------+
-- | 1           | 1             |
-- | 1           | 3             |
-- | 2           | 1             |
-- +-------------+---------------+
-- Explanation: Both employees with id 1 and 3 have the most experience among the employees of the first


DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    experience_years INT
);

CREATE TABLE Project (
    project_id INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

INSERT INTO Employee (employee_id, name, experience_years) VALUES
(1, 'Khaled', 3),
(2, 'Ali', 2),
(3, 'John', 3),
(4, 'Doe', 2);

INSERT INTO Project (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4);

WITH employee_experience_info AS (
    SELECT 
        p.project_id,
        p.employee_id,
        DENSE_RANK() OVER(
            PARTITION BY p.project_id 
            ORDER BY e.experience_years DESC
        ) AS employee_experience_rank
    FROM Employee e  
    JOIN Project p   
    ON e.employee_id = p.employee_id
)
SELECT 
      project_id,
      employee_id
FROM employee_experience_info
WHERE employee_experience_rank = 1;

-- start from the fact table when joining
----------------------------------------------------------------------------------------------------------

--m2

WITH max_exp AS (
    SELECT 
        p.project_id,
        MAX(e.experience_years) AS max_exp
    FROM Project p
    JOIN Employee e
        ON p.employee_id = e.employee_id
    GROUP BY p.project_id
)
SELECT 
    p.project_id,
    p.employee_id
FROM Project p
JOIN Employee e
    ON p.employee_id = e.employee_id
JOIN max_exp m
    ON p.project_id = m.project_id
   AND e.experience_years = m.max_exp;

----------------------------------------------------------------------------------------------------------

--m3 
WITH cte AS (
    SELECT 
        p.project_id,
        p.employee_id,
        e.experience_years,
        MAX(e.experience_years) OVER (PARTITION BY p.project_id) AS max_exp
    FROM Project p
    LEFT JOIN Employee e
        ON p.employee_id = e.employee_id
)
SELECT 
    project_id,
    employee_id
FROM cte
WHERE experience_years = max_exp;