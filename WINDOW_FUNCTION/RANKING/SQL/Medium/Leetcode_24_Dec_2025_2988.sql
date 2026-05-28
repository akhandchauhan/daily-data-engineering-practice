-- 2988. Manager of the Largest Department
-- Description
-- Table: Employees
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | emp_id      | int     |
-- | emp_name    | varchar |
-- | dep_id      | int     |
-- | position    | varchar |
-- +-------------+---------+
-- emp_id is column of unique values for this table.
-- This table contains emp_id, emp_name, dep_id, and position.
-- Write a solution to find the name of the manager from the largest department. There may be 
-- multiple largest departments when the number of employees in those departments is the same.
-- Return the result table sorted by dep_id in ascending order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Employees table:
-- +--------+----------+--------+---------------+
-- | emp_id | emp_name | dep_id | position      | 
-- +--------+----------+--------+---------------+
-- | 156    | Michael  | 107    | Manager       |
-- | 112    | Lucas    | 107    | Consultant    |    
-- | 8      | Isabella | 101    | Manager       | 
-- | 160    | Joseph   | 100    | Manager       | 
-- | 80     | Aiden    | 100    | Engineer      | 
-- | 190    | Skylar   | 100    | Freelancer    | 
-- | 196    | Stella   | 101    | Coordinator   |
-- | 167    | Audrey   | 100    | Consultant    |
-- | 97     | Nathan   | 101    | Supervisor    |
-- | 128    | Ian      | 101    | Administrator |
-- | 81     | Ethan    | 107    | Administrator |
-- +--------+----------+--------+---------------+
-- Output
-- +--------------+--------+
-- | manager_name | dep_id | 
-- +--------------+--------+
-- | Joseph       | 100    | 
-- | Isabella     | 101    | 
-- +--------------+--------+
-- Explanation
-- - Departments with IDs 100 and 101 each has a total of 4 employees, while department 107 has 
-- 3 employees. Since both departments 100 and 101 have an equal number of employees, their respective
--  managers will be included.
-- Output table is ordered by dep_id in ascending order.

DROP TABLE Employees;
Create table if not exists Employees ( emp_id int, emp_name varchar(50), dep_id int, position varchar(30));
INSERT INTO Employees (emp_id, emp_name, dep_id, position) VALUES
('156', 'Michael', '107', 'Manager'),
('112', 'Lucas', '107', 'Consultant'),
('8', 'Isabella', '101', 'Manager'),
('160', 'Joseph', '100', 'Manager'),
('80', 'Aiden', '100', 'Engineer'),
('190', 'Skylar', '100', 'Freelancer'),
('196', 'Stella', '101', 'Coordinator'),
('167', 'Audrey', '100', 'Consultant'),
('97', 'Nathan', '101', 'Supervisor'),
('128', 'Ian', '101', 'Administrator'),
('81', 'Ethan', '107', 'Administrator');

-- m1
WITH cte as(
    SELECT dep_id, COUNT(emp_name) as cnt
    FROM Employees 
    GROUP BY dep_id
)
SELECT e.emp_name as manager_name, e.dep_id
FROM cte as c
JOIN Employees as e
ON c.dep_id = e.dep_id
AND position = 'Manager' and cnt = (SELECT MAX(cnt) FROM cte)
ORDER BY e.dep_id;

----------------------------------------------------------------------------------------------------------
-- m2
WITH cte as(
    SELECT *, 
           COUNT(emp_name) OVER(PARTITION BY dep_id) as cnt
        FROM Employees 
)
SELECT emp_name as manager_name, dep_id
FROM cte 
WHERE position = 'Manager' and cnt  = (SELECT MAX(cnt) FROM cte)
ORDER BY dep_id;

----------------------------------------------------------------------------------------------------------
-- m3
WITH CTE AS (
    SELECT *, COUNT(emp_name) OVER (PARTITION BY dep_id) AS num_emp
    FROM Employees
),
cte2 AS (
    SELECT *, DENSE_RANK() OVER (ORDER BY num_emp DESC) AS rnk
    FROM CTE
)
SELECT emp_name AS manager_name, dep_id
FROM cte2
WHERE rnk = 1 AND position = 'Manager'
ORDER BY dep_id;


----------------------------------------------------------------------------------------------------------
-- m4 

SELECT 
        manager_name,
        dep_id
FROM (
    SELECT 
            dep_id,
            MAX(CASE WHEN position = 'Manager' THEN emp_name END) AS manager_name,
            DENSE_RANK() OVER(ORDER BY COUNT(emp_id) DESC) AS employee_count_rank
    FROM Employees 
    GROUP BY dep_id
) a
WHERE employee_count_rank = 1
ORDER BY dep_id;