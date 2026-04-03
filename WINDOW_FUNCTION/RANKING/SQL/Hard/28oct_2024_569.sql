-- 569. Median Employee Salary 
-- Description
-- Table: Employee

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | id           | int     |
-- | company      | varchar |
-- | salary       | int     |
-- +--------------+---------+
-- id is the primary key (column with unique values) for this table.
-- Each row of this table indicates the company and the salary of one employee.

-- Write a solution to find the rows that contain the median salary of each company.
-- While calculating the median, when you sort the salaries of the company,
-- break the ties by id.

-- Return the result table in any order.
-- Input: 
-- Employee table:
-- +----+---------+--------+
-- | id | company | salary |
-- +----+---------+--------+
-- | 1  | A       | 2341   |
-- | 2  | A       | 341    |
-- | 3  | A       | 15     |
-- | 4  | A       | 15314  |
-- | 5  | A       | 451    |
-- | 6  | A       | 513    |
-- | 7  | B       | 15     |
-- | 8  | B       | 13     |
-- | 9  | B       | 1154   |
-- | 10 | B       | 1345   |
-- | 11 | B       | 1221   |
-- | 12 | B       | 234    |
-- | 13 | C       | 2345   |
-- | 14 | C       | 2645   |
-- | 15 | C       | 2645   |
-- | 16 | C       | 2652   |
-- | 17 | C       | 65     |
-- +----+---------+--------+
-- Output: 
-- +----+---------+--------+
-- | id | company | salary |
-- +----+---------+--------+
-- | 5  | A       | 451    |
-- | 6  | A       | 513    |
-- | 12 | B       | 234    |
-- | 9  | B       | 1154   |
-- | 14 | C       | 2645   |
-- +----+---------+--------+
-- Explanation: 
-- For company A, the rows sorted are as follows:
-- +----+---------+--------+
-- | id | company | salary |
-- +----+---------+--------+
-- | 3  | A       | 15     |
-- | 2  | A       | 341    |
-- | 5  | A       | 451    | <-- median
-- | 6  | A       | 513    | <-- median
-- | 1  | A       | 2341   |
-- | 4  | A       | 15314  |
-- +----+---------+--------+
-- For company B, the rows sorted are as follows:
-- +----+---------+--------+
-- | id | company | salary |
-- +----+---------+--------+
-- | 8  | B       | 13     |
-- | 7  | B       | 15     |
-- | 12 | B       | 234    | <-- median
-- | 11 | B       | 1221   | <-- median
-- | 9  | B       | 1154   |
-- | 10 | B       | 1345   |
-- +----+---------+--------+
-- For company C, the rows sorted are as follows:
-- +----+---------+--------+
-- | id | company | salary |
-- +----+---------+--------+
-- | 17 | C       | 65     |
-- | 13 | C       | 2345   |
-- | 14 | C       | 2645   | <-- median
-- | 15 | C       | 2645   | 
-- | 16 | C       | 2652   |
-- +----+---------+--------+

-- Follow up: Could you solve it without using any built-in or window functions?

drop table project;
drop table Employee;
-- Create the Employee table
CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Company VARCHAR(255),
    Salary INT
);

INSERT INTO Employee (Id, Company, Salary) VALUES
(1, 'A', 2341),
(2, 'A', 341),
(3, 'A', 15),
(4, 'A', 15314),
(5, 'A', 451),
(6, 'A', 513),
(7, 'B', 15),
(8, 'B', 13),
(9, 'B', 1154),
(10, 'B', 1345),
(11, 'B', 1221),
(12, 'B', 234),
(13, 'C', 2345),
(14, 'C', 2645),
(15, 'C', 2645),
(16, 'C', 2652),
(17, 'C', 65);

-- m1
WITH cte AS (
    SELECT Id, Company, Salary, 
        ROW_NUMBER() OVER (PARTITION BY Company ORDER BY Salary, id) AS rnk,
        COUNT(*) OVER (PARTITION BY Company) AS ṇ
    FROM Employee
)
SELECT  Id, Company, Salary
FROM cte
WHERE(n % 2 = 1 AND rnk = (n + 1) / 2)
OR (n % 2 = 0 AND (rnk = n / 2 OR rnk = n / 2 + 1));

----------------------------------------------------------------------------------------
-- m2
WITH cte AS (
    SELECT Id, Company, Salary, 
        ROW_NUMBER() OVER (PARTITION BY Company ORDER BY Salary, id) AS rnk,
        COUNT(*) OVER (PARTITION BY Company) AS n
    FROM Employee
)
SELECT  Id, Company, Salary
FROM cte
WHERE rnk BETWEEN n/2 and (n/2)+1;

----------------------------------------------------------------------------------------
-- m3
WITH cte as(
SELECT *,ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary, id) as rnk,
COUNT(company) OVER(PARTITION BY company) as cnt
FROM employee
)
SELECT *
FROM cte 
WHERE rnk IN (
    IF(cnt%2=0, cnt/2, (cnt+1)/2),
    IF(cnt%2=0, cnt/2 + 1, (cnt+1)/2)
)
ORDER BY company,rnk;

----------------------------------------------------------------------------------------
-- m4
WITH employee_info AS (
    SELECT 
            id,
            company,
            salary,
            ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary, id) AS employee_rank,
            COUNT(company) OVER(PARTITION BY company) AS employee_count
    FROM employee
)
SELECT * 
FROM employee_info
WHERE 
    (employee_count%2 =1 and employee_rank = CEIL(employee_count/2))
    OR (employee_count%2 =0 and 
    (employee_rank =(employee_count/2) or employee_rank = ((employee_count/2)+1))
    
);