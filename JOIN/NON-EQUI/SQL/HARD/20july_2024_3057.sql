-- 3057. Employees Project Allocation
-- Description
-- Table: Project
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- | workload    | int     |
-- +-------------+---------+
-- employee_id is the primary key (column with unique values) of this table.
-- employee_id is a foreign key to Employee table.
-- Each row indicates that the employee with employee_id is working on project with project_id
-- with the given workload.
-- Table: Employees
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | team             | varchar |
-- +------------------+---------+
-- employee_id is the primary key for this table.
-- Write a solution to find the employees who are allocated to projects with a workload that exceeds
-- the average workload of all employees for their respective teams.
-- Return the result table ordered by employee_id, project_id in ascending order.
-- Input:
-- Project table:
-- +------------+-------------+----------+
-- | project_id | employee_id | workload |
-- +------------+-------------+----------+
-- | 1          | 1           | 45       |
-- | 1          | 2           | 90       |
-- | 2          | 3           | 12       |
-- | 2          | 4           | 68       |
-- +------------+-------------+----------+
-- Employees table:
-- +-------------+--------+------+
-- | employee_id | name   | team |
-- +-------------+--------+------+
-- | 1           | Khaled | A    |
-- | 2           | Ali    | B    |
-- | 3           | John   | B    |
-- | 4           | Doe    | A    |
-- +-------------+--------+------+
-- Output:
-- +-------------+------------+---------------+------------------+
-- | employee_id | project_id | employee_name | project_workload |
-- +-------------+------------+---------------+------------------+
-- | 2           | 1          | Ali           | 90               |
-- | 4           | 2          | Doe           | 68               |
-- +-------------+------------+---------------+------------------+

Create table If Not Exists Project (project_id int, employee_id int, workload int);
Create table If Not Exists Employees (employee_id int, name varchar(20), team varchar(20));
Truncate table Project;
insert into Project (project_id, employee_id, workload) values ('1', '1', '45');
insert into Project (project_id, employee_id, workload) values ('1', '2', '90');
insert into Project (project_id, employee_id, workload) values ('2', '3', '12');
insert into Project (project_id, employee_id, workload) values ('2', '4', '68');
Truncate table Employees;
insert into Employees (employee_id, name, team) values ('1', 'Khaled', 'A');
insert into Employees (employee_id, name, team) values ('2', 'Ali', 'B');
insert into Employees (employee_id, name, team) values ('3', 'John', 'B');
insert into Employees (employee_id, name, team) values ('4', 'Doe', 'A');

WITH T AS (
    SELECT team, AVG(workload) AS avg_workload
    FROM Project
    JOIN Employees USING (employee_id)
    GROUP BY 1
)
SELECT employee_id, project_id, name AS employee_name, workload AS project_workload
FROM Project
    JOIN Employees USING (employee_id)
    JOIN T USING (team)
WHERE workload > avg_workload
ORDER BY 1, 2;
