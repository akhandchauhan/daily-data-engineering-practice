-- 2853. Highest Salaries Difference

-- Table: Salaries
-- +-------------+---------+ 
-- | Column Name | Type    | 
-- +-------------+---------+ 
-- | emp_name    | varchar | 
-- | department  | varchar | 
-- | salary      | int     |
-- +-------------+---------+
-- (emp_name, department) is the primary key for this table.
-- Each row of this table contains emp_name, department and salary. There will be at 
-- least one entry for the engineering and marketing departments.
-- Write an  SQL query to calculate the difference between the highest salaries 
-- in the marketing and engineering department. Output the absolute difference in salaries.

-- Input: 
-- Salaries table:
-- +----------+-------------+--------+
-- | emp_name | department  | salary |
-- +----------+-------------+--------+
-- | Kathy    | Engineering | 50000  |
-- | Roy      | Marketing   | 30000  |
-- | Charles  | Engineering | 45000  |
-- | Jack     | Engineering | 85000  | 
-- | Benjamin | Marketing   | 34000  |
-- | Anthony  | Marketing   | 42000  |
-- | Edward   | Engineering | 102000 |
-- | Terry    | Engineering | 44000  |
-- | Evelyn   | Marketing   | 53000  |
-- | Arthur   | Engineering | 32000  |
-- +----------+-------------+--------+
-- Output: 
-- +-------------------+
-- | salary_difference | 
-- +-------------------+
-- | 49000             | 
-- +-------------------+
-- Explanation: 
-- - The Engineering and Marketing departments have the highest salaries of 102,000 
-- and 53,000, respectively. Resulting in an absolute difference of 49,000.

drop table Salaries;
Create table if not exists Salaries(emp_name varchar(30), department varchar(30),salary int);
Truncate table Salaries;

INSERT INTO Salaries (emp_name, department, salary) 
VALUES
    ('Kathy', 'Engineering', 50000),
    ('Roy', 'Marketing', 30000),
    ('Charles', 'Engineering', 45000),
    ('Jack', 'Engineering', 85000),
    ('Benjamin', 'Marketing', 34000),
    ('Anthony', 'Marketing', 42000),
    ('Edward', 'Engineering', 102000),
    ('Terry', 'Engineering', 44000),
    ('Evelyn', 'Marketing', 53000),
    ('Arthur', 'Engineering', 32000);

SELECT
    ABS(
        MAX(CASE WHEN department = 'Engineering' THEN salary END) -
        MAX(CASE WHEN department = 'Marketing' THEN salary END)
    ) AS salary_difference
FROM Salaries;

--------------------------------------------------------------------------------------------------
-- m2

SELECT ABS((SELECT MAX(salary) 
FROM Salaries
WHERE department='Engineering')
-(SELECT MAX(salary) 
FROM Salaries
WHERE department='Marketing')) as salary_difference;
