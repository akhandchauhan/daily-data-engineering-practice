# -- 1112. Highest Grade For Each Student
# -- Description
# -- Table: Enrollments
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | student_id    | int     |
# -- | course_id     | int     |
# -- | grade         | int     |
# -- +---------------+---------+
# -- (student_id, course_id) is the primary key (combination of columns with unique values) of this table.
# -- grade is never NULL.
# -- Write a solution to find the highest grade with its corresponding course for each student. 
# --In case of a tie, you should find the course with the smallest course_id.
# -- Return the result table ordered by student_id in ascending order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Enrollments table:
# -- +------------+-------------------+
# -- | student_id | course_id | grade |
# -- +------------+-----------+-------+
# -- | 2          | 2         | 95    |
# -- | 2          | 3         | 95    |
# -- | 1          | 1         | 90    |
# -- | 1          | 2         | 99    |
# -- | 3          | 1         | 80    |
# -- | 3          | 2         | 75    |
# -- | 3          | 3         | 82    |
# -- +------------+-----------+-------+
# -- Output: 
# -- +------------+-------------------+
# -- | student_id | course_id | grade |
# -- +------------+-----------+-------+
# -- | 1          | 2         | 99    |
# -- | 2          | 2         | 95    |
# -- | 3          | 3         | 82    |
# -- +------------+-----------+-------+


-- Drop table if exists
DROP TABLE IF EXISTS Enrollments;

-- Create table
CREATE TABLE Enrollments (
    student_id INT,
    course_id INT,
    grade INT
);

-- Insert data
INSERT INTO Enrollments (student_id, course_id, grade) VALUES
(2, 2, 95),
(2, 3, 95),
(1, 1, 90),
(1, 2, 99),
(3, 1, 80),
(3, 2, 75),
(3, 3, 82);


-- m1 Using Ranking
WITH student_grade_info AS (
    SELECT 
            student_id,
            course_id,
            grade,
            ROW_NUMBER() OVER(
                PARTITION BY student_id 
                ORDER BY grade DESC, course_id
                ) AS student_rank
    FROM Enrollments
)
SELECT 
        student_id,
        course_id,
        grade
FROM student_grade_info
WHERE student_rank = 1 
ORDER BY student_id;

-----------------------------------------------------------------------------------------------------------
--m2
WITH student_grade_info AS(
SELECT 
        student_id,
        course_id,
        grade,
        MAX(grade) OVER(
            PARTITION BY student_id 
        ) AS max_grade_student
    FROM Enrollments
)
SELECT 
    student_id,
    course_id,
    grade,
    max_grade_student
FROM student_grade_info
WHERE max_grade_student = grade
ORDER BY student_id, course_id;

---------------------------------------------------------------------------------------------------------

--m2 using min-max

WITH max_grade AS (
    SELECT student_id, 
           MAX(grade) AS grade
    FROM Enrollments
    GROUP BY student_id
)
SELECT e.student_id,
       MIN(e.course_id) AS course_id,
       e.grade
FROM Enrollments e
JOIN max_grade m
ON e.student_id = m.student_id
AND e.grade = m.grade
GROUP BY e.student_id, e.grade
ORDER BY e.student_id;