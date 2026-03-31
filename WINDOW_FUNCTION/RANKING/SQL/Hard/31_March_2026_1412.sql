-- 1412. Find the Quiet Students in All Exams
-- SQL Schema 
-- Table: Student
-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | student_id          | int     |
-- | student_name        | varchar |
-- +---------------------+---------+
-- student_id is the primary key for this table.
-- student_name is the name of the student.

-- Table: Exam
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | exam_id       | int     |
-- | student_id    | int     |
-- | score         | int     |
-- +---------------+---------+
-- (exam_id, student_id) is the primary key for this table.
-- Student with student_id got score points in exam with id exam_id.
 

-- A "quite" student is the one who took at least one exam and didn't score neither 
--the high score nor the low score.
-- Write an SQL query to report the students (student_id, student_name) being "quiet" 
--in ALL exams.

-- Don't return the student who has never taken any exam. Return the result table ordered by student_id.

-- Student table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Jade          |
-- | 3           | Stella        |
-- | 4           | Jonathan      |
-- | 5           | Will          |
-- +-------------+---------------+

-- Exam table:
-- +------------+--------------+-----------+
-- | exam_id    | student_id   | score     |
-- +------------+--------------+-----------+
-- | 10         |     1        |    70     |
-- | 10         |     2        |    80     |
-- | 10         |     3        |    90     |
-- | 20         |     1        |    80     |
-- | 30         |     1        |    70     |
-- | 30         |     3        |    80     |
-- | 30         |     4        |    90     |
-- | 40         |     1        |    60     |
-- | 40         |     2        |    70     |
-- | 40         |     4        |    80     |
-- +------------+--------------+-----------+

-- Result table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 2           | Jade          |
-- +-------------+---------------+

-- For exam 1: Student 1 and 3 hold the lowest and high score respectively.
-- For exam 2: Student 1 hold both highest and lowest score.
-- For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
-- Student 2 and 5 have never got the highest or lowest in any of the exam.
-- Since student 5 is not taking any exam, he is excluded from the result.
-- So, we only return the information of Student 2.


-- Drop tables if they exist
DROP TABLE IF EXISTS Exam;
DROP TABLE IF EXISTS Student;

-- Create Student table
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

-- Create Exam table
CREATE TABLE Exam (
    exam_id INT,
    student_id INT,
    score INT,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- Insert into Student
INSERT INTO Student (student_id, student_name) VALUES
(1, 'Daniel'),
(2, 'Jade'),
(3, 'Stella'),
(4, 'Jonathan'),
(5, 'Will');

-- Insert into Exam
INSERT INTO Exam (exam_id, student_id, score) VALUES
(10, 1, 70),
(10, 2, 80),
(10, 3, 90),
(20, 1, 80),
(30, 1, 70),
(30, 3, 80),
(30, 4, 90),
(40, 1, 60),
(40, 2, 70),
(40, 4, 80);

-- m1
WITH exam_score_info AS (
    SELECT 
            exam_id,
            MIN(score) AS min_score,
            MAX(score) AS max_score
    FROM Exam 
    GROUP BY exam_id
)
SELECT 
        s.student_id,
        s.student_name
FROM exam e 
JOIN student s 
ON e.student_id = s.student_id
LEFT JOIN exam_score_info esi_min
ON e.exam_id = esi_min.exam_id
AND e.score = esi_min.min_score
LEFT JOIN exam_score_info esi_max
ON e.exam_id = esi_max.exam_id
AND e.score = esi_max.max_score
GROUP BY 
        s.student_id,
        s.student_name
HAVING COUNT(esi_min.exam_id) = 0
AND COUNT(esi_max.exam_id) = 0
ORDER BY s.student_id;


-----------------------------------------------------------------------------------------------------------
-- m2 
WITH exam_score AS (
    SELECT 
            s.student_id,
            s.student_name,
            e.exam_id,
            e.score,
            MIN(e.score) OVER(PARTITION BY e.exam_id) AS min_score,
            MAX(e.score) OVER(PARTITION BY e.exam_id) AS max_score
    FROM student s 
    JOIN exam e 
    ON s.student_id = e.student_id
)
SELECT
        student_id,
        student_name
FROM exam_score 
GROUP BY student_id,
         student_name
HAVING COUNT(CASE WHEN score = min_score THEN 1 END) = 0
AND COUNT(CASE WHEN score = max_score THEN 1 END) = 0
ORDER BY student_id;

-----------------------------------------------------------------------------------------------------------
-- m3

WITH all_scores AS (
    SELECT 
        exam_id,
        MIN(score) AS min_score,
        MAX(score) AS max_score
    FROM Exam
    GROUP BY exam_id
)
SELECT e.student_id
FROM Exam e
JOIN all_scores a 
    ON e.exam_id = a.exam_id
GROUP BY e.student_id
HAVING MAX(
    CASE 
        WHEN e.score = a.min_score OR e.score = a.max_score 
        THEN 1 
        ELSE 0 
    END
) = 0;