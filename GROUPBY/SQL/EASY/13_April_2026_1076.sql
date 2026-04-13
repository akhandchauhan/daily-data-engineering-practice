-- 1076. Project Employees II
-- Description
-- Table: Project
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- (project_id, employee_id) is the primary key (combination of columns with 
-- unique values) of this table.
-- employee_id is a foreign key (reference column) to Employee table.
-- Each row of this table indicates that the employee with employee_id is 
-- working on the project with project_id.
 
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

-- Write a solution to report all the projects that have the most employees.
-- Return the result table in any order.
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
-- | 3           | John   | 1                |
-- | 4           | Doe    | 2                |
-- +-------------+--------+------------------+
-- Output: 
-- +-------------+
-- | project_id  |
-- +-------------+
-- | 1           |
-- +-------------+
-- Explanation: The first project has 3 employees while the second one has 2.

-- Drop tables if they already exist
DROP TABLE IF EXISTS Project;

-- Create Project table
CREATE TABLE Project (
    project_id INT,
    employee_id INT
);

-- Insert data into Project table
INSERT INTO Project (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4);


-- m1
WITH project_info AS (
    SELECT project_id,
            COUNT(employee_id) AS employee_count
    FROM Project
    GROUP BY project_id
)
SELECT project_id
FROM project_info
WHERE employee_count = (
    SELECT MAX(employee_count)
    FROM project_info
);

-----------------------------------------------------------------------------------------
-- m2 
WITH project_info AS (
    SELECT project_id,
           DENSE_RANK() OVER(
                ORDER BY COUNT(employee_id) DESC
           ) AS employee_ranked
    FROM Project
    GROUP BY project_id
)
SELECT project_id
FROM project_info
WHERE employee_ranked = 1;

-----------------------------------------------------------------------------------------
-- m3
SELECT project_id
FROM (
    SELECT 
        project_id,
        COUNT(*) AS cnt,
        MAX(COUNT(*)) OVER () AS max_cnt
    FROM Project
    GROUP BY project_id
) t
WHERE cnt = max_cnt;