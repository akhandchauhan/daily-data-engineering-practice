-- 2346. Compute the Rank as a Percentage 
-- Description
-- Table: Students
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | student_id    | int  |
-- | department_id | int  |
-- | mark          | int  |
-- +---------------+------+
-- student_id contains unique values.
-- Each row of this table indicates a student's ID, the ID of the department in
-- which the student enrolled, and their mark in the exam.
-- Write a solution to report the rank of each student in their department as a percentage,
-- where the rank as a percentage is computed using the following formula: 
--(student_rank_in_the_department - 1) * 100 / (the_number_of_students_in_the_department - 1). 
--The percentage should be rounded to 2 decimal places. student_rank_in_the_department is determined
-- by descending mark, such that the student with the highest mark is rank 1. If two students get the 
--same mark, they also get the same rank.

-- Input: 
-- Students table:
-- +------------+---------------+------+
-- | student_id | department_id | mark |
-- +------------+---------------+------+
-- | 2          | 2             | 650  |
-- | 8          | 2             | 650  |
-- | 7          | 1             | 920  |
-- | 1          | 1             | 610  |
-- | 3          | 1             | 530  |
-- +------------+---------------+------+
-- Output: 
-- +------------+---------------+------------+
-- | student_id | department_id | percentage |
-- +------------+---------------+------------+
-- | 7          | 1             | 0.0        |
-- | 1          | 1             | 50.0       |
-- | 3          | 1             | 100.0      |
-- | 2          | 2             | 0.0        |
-- | 8          | 2             | 0.0        |
-- +------------+---------------+------------+
-- Explanation: 
-- For Department 1:
--  - Student 7: percentage = (1 - 1) * 100 / (3 - 1) = 0.0
--  - Student 1: percentage = (2 - 1) * 100 / (3 - 1) = 50.0
--  - Student 3: percentage = (3 - 1) * 100 / (3 - 1) = 100.0
-- For Department 2:
--  - Student 2: percentage = (1 - 1) * 100 / (2 - 1) = 0.0
--  - Student 8: percentage = (1 - 1) * 100 / (2 - 1) = 0.0


-- Drop table if exists
DROP TABLE IF EXISTS Students;

-- Create table
CREATE TABLE Students (
    student_id INT,
    department_id INT,
    mark INT
);

-- Insert data
INSERT INTO Students (student_id, department_id, mark) VALUES
(2, 2, 650),
(8, 2, 650),
(7, 1, 920),
(1, 1, 610),
(3, 1, 530);

WITH student_rank_info AS (
    SELECT 
            student_id,
            department_id,
            RANK() OVER(
                PARTITION BY department_id 
                ORDER BY mark DESC
            ) AS stud_rank_dept,
            COUNT(student_id) OVER(
                PARTITION BY department_id
            ) AS number_students_department
     FROM Students
)
SELECT 
        student_id,
        department_id,
        IFNULL
            (ROUND
            ((stud_rank_dept -1)*100.0/(number_students_department-1),
            2),
        0) AS percentage
FROM student_rank_info


---------------------------------------------------------------------------------------

-- m2 
-- percent_rank doesnt return null, default it will return 0
SELECT 
    student_id,
    department_id,
    ROUND(
        PERCENT_RANK() OVER (
            PARTITION BY department_id 
            ORDER BY mark DESC
        ) * 100.0,
    2) AS percentage
FROM Students;
