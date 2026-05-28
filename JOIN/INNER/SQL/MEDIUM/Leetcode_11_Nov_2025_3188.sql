-- 3188. Find Top Scoring Students II
-- Description
-- Table: students
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | student_id  | int      |
-- | name        | varchar  |
-- | major       | varchar  |
-- +-------------+----------+
-- student_id is the primary key for this table.
-- Table: courses
-- +-------------+-------------------+
-- | Column Name | Type              |
-- +-------------+-------------------+
-- | course_id   | int               |
-- | name        | varchar           |
-- | credits     | int               |
-- | major       | varchar           |
-- | mandatory   | enum('yes','no')  |
-- +-------------+-------------------+
-- course_id is the primary key for this table.
-- Table: enrollments
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | student_id  | int      |
-- | course_id   | int      |
-- | semester    | varchar  |
-- | grade       | varchar  |
-- | GPA         | decimal  |
-- +-------------+----------+
-- (student_id, course_id, semester) is the primary key for this table.
-- Write a solution to find the students who meet the following criteria:
-- Have taken all mandatory courses and at least two elective courses offered in their major.
-- Achieved a grade of A in all mandatory courses and at least B in elective courses.
-- Maintained an average GPA of at least 2.5 across all their courses.
-- Return the result ordered by student_id in ascending order.
-- Output:
-- +------------+
-- | student_id |
-- +------------+
-- | 1          |
-- | 3          |
-- +------------+

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

CREATE TABLE IF NOT EXISTS students (
    student_id INT,
    name VARCHAR(255),
    major VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS courses (
    course_id INT,
    name VARCHAR(255),
    credits INT,
    major VARCHAR(255),
    mandatory ENUM('yes', 'no') DEFAULT 'no'
);

CREATE TABLE IF NOT EXISTS enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(255),
    grade VARCHAR(10),
    GPA DECIMAL(3,2)
);

TRUNCATE TABLE students;
INSERT INTO students (student_id, name, major) VALUES
(1, 'Alice', 'Computer Science'),
(2, 'Bob', 'Computer Science'),
(3, 'Charlie', 'Mathematics'),
(4, 'David', 'Mathematics');

TRUNCATE TABLE courses;
INSERT INTO courses (course_id, name, credits, major, mandatory) VALUES
(101, 'Algorithms', 3, 'Computer Science', 'Yes'),
(102, 'Data Structures', 3, 'Computer Science', 'Yes'),
(103, 'Calculus', 4, 'Mathematics', 'Yes'),
(104, 'Linear Algebra', 4, 'Mathematics', 'Yes'),
(105, 'Machine Learning', 3, 'Computer Science', 'No'),
(106, 'Probability', 3, 'Mathematics', 'No'),
(107, 'Operating Systems', 3, 'Computer Science', 'No'),
(108, 'Statistics', 3, 'Mathematics', 'No');

TRUNCATE TABLE enrollments;
INSERT INTO enrollments (student_id, course_id, semester, grade, GPA) VALUES
(1, 101, 'Fall 2023', 'A', 4.0),
(1, 102, 'Spring 2023', 'A', 4.0),
(1, 105, 'Spring 2023', 'A', 4.0),
(1, 107, 'Fall 2023', 'B', 3.5),
(2, 101, 'Fall 2023', 'A', 4.0),
(2, 102, 'Spring 2023', 'B', 3.0),
(3, 103, 'Fall 2023', 'A', 4.0),
(3, 104, 'Spring 2023', 'A', 4.0),
(3, 106, 'Spring 2023', 'A', 4.0),
(3, 108, 'Fall 2023', 'B', 3.5),
(4, 103, 'Fall 2023', 'B', 3.0),
(4, 104, 'Spring 2023', 'B', 3.0);

WITH T AS (
    SELECT student_id
    FROM enrollments
    GROUP BY 1
    HAVING AVG(GPA) >= 2.5
)
SELECT student_id
FROM T
    JOIN students USING (student_id)
    JOIN courses USING (major)
    LEFT JOIN enrollments USING (student_id, course_id)
GROUP BY 1
HAVING
    SUM(mandatory = 'yes' AND grade = 'A') = SUM(mandatory = 'yes')
    AND SUM(mandatory = 'no' AND grade IS NOT NULL) = SUM(mandatory = 'no' AND grade IN ('A', 'B'))
    AND SUM(mandatory = 'no' AND grade IS NOT NULL) >= 2
ORDER BY 1;
