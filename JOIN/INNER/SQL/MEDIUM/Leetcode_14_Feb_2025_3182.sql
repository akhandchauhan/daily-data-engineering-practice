-- 3182. Find Top Scoring Students 
-- Description
-- Table: students
-- +-------------+----------+
-- | Column Name | Type     | 
-- +-------------+----------+
-- | student_id  | int      |
-- | name        | varchar  |
-- | major       | varchar  |
-- +-------------+----------+
-- student_id is the primary key (combination of columns with unique values) for this table.
-- Each row of this table contains the student ID, student name, and their major.

-- Table: courses
-- +-------------+----------+
-- | Column Name | Type     | 
-- +-------------+----------+
-- | course_id   | int      |
-- | name        | varchar  |
-- | credits     | int      |
-- | major       | varchar  |
-- +-------------+----------+
-- course_id is the primary key (combination of columns with unique values) for this table.
-- Each row of this table contains the course ID, course name, the number of credits for the course, 
-- and the major it belongs to.

-- Table: enrollments
-- +-------------+----------+
-- | Column Name | Type     | 
-- +-------------+----------+
-- | student_id  | int      |
-- | course_id   | int      |
-- | semester    | varchar  |
-- | grade       | varchar  |
-- +-------------+----------+
-- (student_id, course_id, semester) is the primary key (combination of columns with unique 
-- values) for this table.
-- Each row of this table contains the student ID, course ID, semester, and grade received.

-- Write a solution to find the students who have taken all courses offered in their major and have
-- achieved a grade of A in all these courses.

-- Return the result table ordered by student_id in ascending order.
-- Input:
-- students table:
-- +------------+------------------+------------------+
-- | student_id | name             | major            |
-- +------------+------------------+------------------+
-- | 1          | Alice            | Computer Science |
-- | 2          | Bob              | Computer Science |
-- | 3          | Charlie          | Mathematics      |
-- | 4          | David            | Mathematics      |
-- +------------+------------------+------------------+
-- courses table:
-- +-----------+-----------------+---------+------------------+
-- | course_id | name            | credits | major            |
-- +-----------+-----------------+---------+------------------+
-- | 101       | Algorithms      | 3       | Computer Science |
-- | 102       | Data Structures | 3       | Computer Science |
-- | 103       | Calculus        | 4       | Mathematics      |
-- | 104       | Linear Algebra  | 4       | Mathematics      |
-- +-----------+-----------------+---------+------------------+
-- enrollments table:
-- +------------+-----------+----------+-------+
-- | student_id | course_id | semester | grade |
-- +------------+-----------+----------+-------+
-- | 1          | 101       | Fall 2023| A     |
-- | 1          | 102       | Fall 2023| A     |
-- | 2          | 101       | Fall 2023| B     |
-- | 2          | 102       | Fall 2023| A     |
-- | 3          | 103       | Fall 2023| A     |
-- | 3          | 104       | Fall 2023| A     |
-- | 4          | 103       | Fall 2023| A     |
-- | 4          | 104       | Fall 2023| B     |
-- +------------+-----------+----------+-------+
-- Output:
-- +------------+
-- | student_id |
-- +------------+
-- | 1          |
-- | 3          |
-- +------------+
-- Explanation:
-- Alice (student_id 1) is a Computer Science major and has taken both "Algorithms" and 
-- "Data Structures", receiving an 'A' in both.
-- Bob (student_id 2) is a Computer Science major but did not receive an 'A' in all 
-- required courses.
-- Charlie (student_id 3) is a Mathematics major and has taken both "Calculus" and 
-- "Linear Algebra", receiving an 'A' in both.
-- David (student_id 4) is a Mathematics major but did not receive an 'A' in all 
-- required courses.
-- Note: Output table is ordered by student_id in ascending order.

DROP TABLE IF EXISTS students;
CREATE TABLE  students (
    student_id INT ,
    name VARCHAR(255),
    major VARCHAR(255)
);
DROP TABLE IF EXISTS courses;
CREATE TABLE  courses (
    course_id INT ,
    name VARCHAR(255),
    credits INT,
    major VARCHAR(255)
);

DROP TABLE IF EXISTS enrollments;
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(255),
    grade VARCHAR(10)

);
TRUNCATE TABLE students;
INSERT INTO students (student_id, name, major) VALUES
(1, 'Alice', 'Computer Science'),
(2, 'Bob', 'Computer Science'),
(3, 'Charlie', 'Mathematics'),
(4, 'David', 'Mathematics');

TRUNCATE TABLE courses;
INSERT INTO courses (course_id, name, credits, major) VALUES
(101, 'Algorithms', 3, 'Computer Science'),
(102, 'Data Structures', 3, 'Computer Science'),
(103, 'Calculus', 4, 'Mathematics'),
(104, 'Linear Algebra', 4, 'Mathematics');

TRUNCATE TABLE enrollments;
INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES
(1, 101, 'Fall 2023', 'A'),
(1, 102, 'Fall 2023', 'A'),
(2, 101, 'Fall 2023', 'B'),
(2, 102, 'Fall 2023', 'A'),
(3, 103, 'Fall 2023', 'A'),
(3, 104, 'Fall 2023', 'A'),
(4, 103, 'Fall 2023', 'A'),
(4, 104, 'Fall 2023', 'B');

SELECT s.student_id 
FROM students s 
 JOIN courses c 
ON s.major = c.major 
LEFT JOIN enrollments e 
ON c.course_id = e.course_id 
AND e.student_id = s.student_id
AND e.grade = 'A'
GROUP BY s.student_id
HAVING 
        COUNT(DISTINCT c.course_id) = COUNT(DISTINCT e.course_id)
;


