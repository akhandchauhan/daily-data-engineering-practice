-- 1303. Find the Team Size
-- Description
-- Table: Employee
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | employee_id   | int     |
-- | team_id       | int     |
-- +---------------+---------+
-- employee_id is the primary key (column with unique values) for this table.
-- Each row of this table contains the ID of each employee and their respective team.
-- Write a solution to find the team size of each of the employees.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Employee Table:
-- +-------------+------------+
-- | employee_id | team_id    |
-- +-------------+------------+
-- |     1       |     8      |
-- |     2       |     8      |
-- |     3       |     8      |
-- |     4       |     7      |
-- |     5       |     9      |
-- |     6       |     9      |
-- +-------------+------------+
-- Output: 
-- +-------------+------------+
-- | employee_id | team_size  |
-- +-------------+------------+
-- |     1       |     3      |
-- |     2       |     3      |
-- |     3       |     3      |
-- |     4       |     1      |
-- |     5       |     2      |
-- |     6       |     2      |
-- +-------------+------------+
-- Explanation: 
-- Employees with Id 1,2,3 are part of a team with team_id = 8.
-- Employee with Id 4 is part of a team with team_id = 7.
-- Employees with Id 5,6 are part of a team with team_id = 9.

DROP TABLE Employee;
-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    team_id INT
);
-- Insert data into Employee table
INSERT INTO Employee (employee_id, team_id) VALUES
(1, 8),
(2, 8),
(3, 8),
(4, 7),
(5, 9),
(6, 9);


-- m1 
WITH team_info AS (
    SELECT team_id,
        COUNT(employee_id) AS team_size
    FROM Employee
    GROUP BY team_id
)
SELECT e.employee_id,
       ti.team_size
FROM Employee e
JOIN team_info ti 
ON e.team_id = ti.team_id;


----------------------------------------------------------------------------------------------------------------------------------
--m2
SELECT employee_id,
       COUNT(team_id) OVER(PARTITION BY team_id) as team_size
FROM Employee;

