-- 3236. CEO Subordinate Hierarchy
-- Description
-- Table: Employees
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | employee_id   | int     |
-- | employee_name | varchar |
-- | manager_id    | int     |
-- | salary        | int     |
-- +---------------+---------+
-- employee_id is the unique identifier for this table.
-- manager_id is the employee_id of the employee's manager. The CEO has a NULL manager_id.
-- Write a solution to find subordinates of the CEO (both direct and indirect), along with their level
-- in the hierarchy and their salary difference from the CEO.
-- Return the result ordered by hierarchy_level ascending, then by subordinate_id ascending.
-- Example:
-- Input:
-- Employees table:
-- +-------------+---------------+------------+---------+
-- | employee_id | employee_name | manager_id | salary  |
-- +-------------+---------------+------------+---------+
-- | 1           | Alice         | NULL       | 150000  |
-- | 2           | Bob           | 1          | 120000  |
-- | 3           | Charlie       | 1          | 110000  |
-- | 4           | David         | 2          | 105000  |
-- | 5           | Eve           | 2          | 100000  |
-- | 6           | Frank         | 3          | 95000   |
-- | 7           | Grace         | 3          | 98000   |
-- | 8           | Helen         | 5          | 90000   |
-- +-------------+---------------+------------+---------+
-- Output:
-- +----------------+------------------+-----------------+-------------------+
-- | subordinate_id | subordinate_name | hierarchy_level | salary_difference |
-- +----------------+------------------+-----------------+-------------------+
-- | 2              | Bob              | 1               | -30000            |
-- | 3              | Charlie          | 1               | -40000            |
-- | 4              | David            | 2               | -45000            |
-- | 5              | Eve              | 2               | -50000            |
-- | 6              | Frank            | 2               | -55000            |
-- | 7              | Grace            | 2               | -52000            |
-- | 8              | Helen            | 3               | -60000            |
-- +----------------+------------------+-----------------+-------------------+

DROP TABLE employees;
Create table if not exists employees(employee_id int, employee_name varchar(100), manager_id int, salary int);
Truncate table Employees;
insert into Employees (employee_id, employee_name, manager_id, salary) values ('1', 'Alice', NULL, '150000');
insert into Employees (employee_id, employee_name, manager_id, salary) values ('2', 'Bob', '1', '120000');
insert into Employees (employee_id, employee_name, manager_id, salary) values ('3', 'Charlie', '1', '110000');
insert into Employees (employee_id, employee_name, manager_id, salary) values ('4', 'David', '2', '105000');
insert into Employees (employee_id, employee_name, manager_id, salary) values ('5', 'Eve', '2', '100000');
insert into Employees (employee_id, employee_name, manager_id, salary) values ('6', 'Frank', '3', '95000');
insert into Employees (employee_id, employee_name, manager_id, salary) values ('7', 'Grace', '3', '98000');
insert into Employees (employee_id, employee_name, manager_id, salary) values ('8', 'Helen', '5', '90000');

WITH RECURSIVE cte AS (
    SELECT employee_id, employee_name, salary AS ceo_salary, salary, 0 AS hierarchy_level
    FROM Employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.employee_name, c.ceo_salary, e.salary, c.hierarchy_level + 1 AS hierarchy_level
    FROM Employees AS e
    INNER JOIN cte AS c
    ON e.manager_id = c.employee_id
)
SELECT employee_id AS subordinate_id,
       employee_name AS subordinate_name,
       hierarchy_level,
       salary - ceo_salary AS salary_difference
FROM cte
WHERE hierarchy_level > 0
ORDER BY hierarchy_level, subordinate_id;
