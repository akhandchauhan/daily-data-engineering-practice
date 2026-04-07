-- 579. Find Cumulative Salary of an Employee
-- Description
-- Table: Employee

-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | id          | int  |
-- | month       | int  |
-- | salary      | int  |
-- +-------------+------+
-- (id, month) is the primary key (combination of columns with unique values) 
-- for this table.
-- Each row in the table indicates the salary of an employee in one month
-- during the year 2020.  

-- Write a solution to calculate the cumulative salary summary for every 
-- employee in a single unified table.

-- The cumulative salary summary for an employee can be calculated as follows:

-- For each month that the employee worked, sum up the salaries in that month 
-- and the previous two months. This is their 3-month sum for that month. 
-- If an employee did not work for the company in previous months, their
-- effective salary for those months is 0.
-- Do not include the 3-month sum for the most recent month that the employee 
-- worked for in the summary.
-- Do not include the 3-month sum for any month the employee did not work.
-- Return the result table ordered by id in ascending order. In case of a tie, 
-- order it by month in descending order.

-- The result format is in the following example.

-- Example 1:

-- Input: 
-- Employee table:
-- +----+-------+--------+
-- | id | month | salary |
-- +----+-------+--------+
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 1  | 2     | 30     |
-- | 2  | 2     | 30     |
-- | 3  | 2     | 40     |
-- | 1  | 3     | 40     |
-- | 3  | 3     | 60     |
-- | 1  | 4     | 60     |
-- | 3  | 4     | 70     |
-- | 1  | 7     | 90     |
-- | 1  | 8     | 90     |
-- +----+-------+--------+
-- Output: 
-- +----+-------+--------+
-- | id | month | Salary |
-- +----+-------+--------+
-- | 1  | 7     | 90     |
-- | 1  | 4     | 130    |
-- | 1  | 3     | 90     |
-- | 1  | 2     | 50     |
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 3  | 3     | 100    |
-- | 3  | 2     | 40     |
-- +----+-------+--------+
-- Explanation: 
-- Employee '1' has five salary records excluding their most recent month '8':
-- - 90 for month '7'.
-- - 60 for month '4'.
-- - 40 for month '3'.
-- - 30 for month '2'.
-- - 20 for month '1'.
-- So the cumulative salary summary for this employee is:
-- +----+-------+--------+
-- | id | month | salary |
-- +----+-------+--------+
-- | 1  | 7     | 90     |  (90 + 0 + 0)
-- | 1  | 4     | 130    |  (60 + 40 + 30)
-- | 1  | 3     | 90     |  (40 + 30 + 20)
-- | 1  | 2     | 50     |  (30 + 20 + 0)
-- | 1  | 1     | 20     |  (20 + 0 + 0)
-- +----+-------+--------+
-- Note that the 3-month sum for month '7' is 90 because they did not
-- work during month '6' or month '5'.

-- Employee '2' only has one salary record (month '1') excluding 
-- their most recent month '2'.
-- +----+-------+--------+
-- | id | month | salary |
-- +----+-------+--------+
-- | 2  | 1     | 20     |  (20 + 0 + 0)
-- +----+-------+--------+

-- Employee '3' has two salary records excluding their most recent month '4':
-- - 60 for month '3'.
-- - 40 for month '2'.
-- So the cumulative salary summary for this employee is:
-- +----+-------+--------+
-- | id | month | salary |
-- +----+-------+--------+
-- | 3  | 3     | 100    |  (60 + 40 + 0)
-- | 3  | 2     | 40     |  (40 + 0 + 0)

drop table Employee;
Create table If Not Exists Employee (id int, month int, salary int);
Truncate table Employee;

INSERT INTO Employee (id, month, salary) VALUES
('1', '1', '20'),
('2', '1', '20'),
('1', '2', '30'),
('2', '2', '30'),
('3', '2', '40'),
('1', '3', '40'),
('3', '3', '60'),
('1', '4', '60'),
('3', '4', '70'),
('1', '7', '90'),
('1', '8', '90');

-- m1 
WITH cte AS (
    SELECT id,month,salary,
           ROW_NUMBER() OVER(PARTITION BY id ORDER BY month DESC) AS rn
    FROM Employee
)
SELECT id, month, 
    SUM(salary) OVER(
        PARTITION BY id 
        ORDER BY month 
        RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Salary
FROM cte
WHERE rn > 1
ORDER BY id, month DESC;

----------------------------------------------------------------------------------------
-- m2 = WRONG BUT GOOD TRY
-- M2 fails because isolating month 7 into its own island via the gap 
-- trick cuts it off from month 5's salary, which is within the 2-calendar-month
-- lookback range.
WITH employee_ranked AS (
    SELECT 
            id,
            month,
            salary,
            ROW_NUMBER() OVER(
                PARTITION BY id 
                ORDER BY month DESC
            ) AS id_month_ranked_desc,
            ROW_NUMBER() OVER(
                PARTITION BY id 
                ORDER BY month 
            ) AS id_month_ranked
    FROM Employee
)
SELECT 
        id,
        month,
        SUM(salary) OVER(
            PARTITION BY id,(month - CAST(id_month_ranked AS signed))
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING  AND CURRENT ROW
        ) AS Salary
FROM employee_ranked
WHERE id_month_ranked_desc <> 1
ORDER BY id,
        month DESC;

----------------------------------------------------------------------------------------
-- m3

SELECT 
    emp1.id,
    emp1.month,
    SUM(emp2.salary) AS salary
FROM Employee emp1
INNER JOIN Employee emp2
    ON emp1.id = emp2.id
    AND (emp1.month - emp2.month) BETWEEN 0 AND 2
WHERE (emp1.id, emp1.month) NOT IN (
    SELECT 
        id,
        MAX(month)
    FROM Employee
    GROUP BY id
)
GROUP BY emp1.id, emp1.month
ORDER BY emp1.id, emp1.month DESC;