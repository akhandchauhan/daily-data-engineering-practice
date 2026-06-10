-- 3188. Find Top Scoring Students II

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
-- Have taken all mandatory courses and at least two elective courses offered 
-- in their major.
-- Achieved a grade of A in all mandatory courses and at least B in elective courses.
-- Maintained an average GPA of at least 2.5 across all their courses.
-- Return the result ordered by student_id in ascending order.

-- students table:
--  +------------+------------------+------------------+
--  | student_id | name             | major            |
--  +------------+------------------+------------------+
--  | 1          | Alice            | Computer Science |
--  | 2          | Bob              | Computer Science |
--  | 3          | Charlie          | Mathematics      |
--  | 4          | David            | Mathematics      |
--  +------------+------------------+------------------+
 
-- courses table:
--  +-----------+-------------------+---------+------------------+----------+
--  | course_id | name              | credits | major            | mandatory|
--  +-----------+-------------------+---------+------------------+----------+
--  | 101       | Algorithms        | 3       | Computer Science | yes      |
--  | 102       | Data Structures   | 3       | Computer Science | yes      |
--  | 103       | Calculus          | 4       | Mathematics      | yes      |
--  | 104       | Linear Algebra    | 4       | Mathematics      | yes      |
--  | 105       | Machine Learning  | 3       | Computer Science | no       |
--  | 106       | Probability       | 3       | Mathematics      | no       |
--  | 107       | Operating Systems | 3       | Computer Science | no       |
--  | 108       | Statistics        | 3       | Mathematics      | no       |
--  +-----------+-------------------+---------+------------------+----------+
 
-- enrollments table:

--  +------------+-----------+-------------+-------+-----+
--  | student_id | course_id | semester    | grade | GPA |
--  +------------+-----------+-------------+-------+-----+
--  | 1          | 101       | Fall 2023   | A     | 4.0 |
--  | 1          | 102       | Spring 2023 | A     | 4.0 |
--  | 1          | 105       | Spring 2023 | A     | 4.0 |
--  | 1          | 107       | Fall 2023   | B     | 3.5 |
--  | 2          | 101       | Fall 2023   | A     | 4.0 |
--  | 2          | 102       | Spring 2023 | B     | 3.0 |
--  | 3          | 103       | Fall 2023   | A     | 4.0 |
--  | 3          | 104       | Spring 2023 | A     | 4.0 |
--  | 3          | 106       | Spring 2023 | A     | 4.0 |
--  | 3          | 108       | Fall 2023   | B     | 3.5 |
--  | 4          | 103       | Fall 2023   | B     | 3.0 |
--  | 4          | 104       | Spring 2023 | B     | 3.0 |
--  +------------+-----------+-------------+-------+-----+
 
-- Output:

--  +------------+
--  | student_id |
--  +------------+
--  | 1          |
--  | 3          |
--  +------------+
 
-- Explanation:

-- Alice (student_id 1) is a Computer Science major and has taken both Algorithms 
-- and Data Structures, receiving an A in both. She has also taken Machine Learning
--  and Operating Systems as electives, receiving an A and B respectively.
-- Bob (student_id 2) is a Computer Science major but did not receive an A in 
-- all required courses.
-- Charlie (student_id 3) is a Mathematics major and has taken both Calculus 
-- and Linear Algebra, receiving an A in both. He has also taken Probability 
-- and Statistics as electives, receiving an A and B respectively.
-- David (student_id 4) is a Mathematics major but did not receive an A in 
-- all required courses.
-- Note: Output table is ordered by student_id in ascending order.
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

-- m1
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

---------------------------------------------------------------------------------
-- m2
-- BUG: non_mandatory_course_count only counts electives with grade A or B.
-- The condition non_mandatory_course_count >= 2 only checks that at least 2 electives
-- have A/B — it does NOT verify that ALL taken electives have grade >= B.
-- Edge case: student takes 3 electives (A, B, C) → non_mandatory_course_count = 2,
-- passes the >= 2 check, but should fail because C violates "at least B in elective courses".
-- Fix: also assert elec_ab = elec_total (see m3).
WITH student_course_info AS (
    SELECT 
        s.student_id,
        s.major,
        COUNT(CASE 
                    WHEN s.major = c.major 
                    AND c.mandatory = 'yes' 
                    AND e.grade = 'A'
                THEN 1 
            END) AS mandatory_course_count,
        COUNT(CASE 
                    WHEN s.major = c.major 
                    AND c.mandatory = 'no' 
                    AND e.grade IN ('A', 'B')
                THEN 1 
            END) AS non_mandatory_course_count,
        AVG(e.gpa) AS avg_gpa
    FROM students s 
    JOIN enrollments e 
    ON s.student_id = e.student_id
    JOIN courses c
    ON c.course_id = e.course_id 
    GROUP BY 
            s.student_id,
            s.major
),
mandatory_course_info AS (
    SELECT 
        major,
        COUNT(course_id) AS mandatory_course_count
    FROM courses  
    WHERE mandatory = 'yes'
    GROUP BY major
)
SELECT 
    sci.student_id
FROM student_course_info sci 
JOIN mandatory_course_info mci 
ON sci.major = mci.major
WHERE 
    sci.avg_gpa >=2.5
    AND sci.non_mandatory_course_count >= 2
    AND sci.mandatory_course_count = mci.mandatory_course_count
ORDER BY
        sci.student_id;

---------------------------------------------------------------------------------
-- m3 (fixed m2: adds elec_ab = elec_total guard to enforce ALL taken electives have >= B)
WITH student_course_info AS (
    SELECT
        s.student_id,
        s.major,
        AVG(e.gpa) AS avg_gpa,
        SUM(c.major = s.major AND c.mandatory = 'yes' AND e.grade = 'A') AS mand_a,
        SUM(c.major = s.major AND c.mandatory = 'no' AND e.grade IN ('A', 'B')) AS elec_ab,
        SUM(c.major = s.major AND c.mandatory = 'no') AS elec_total
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON c.course_id = e.course_id
    GROUP BY s.student_id, s.major
),
mandatory_course_info AS (
    SELECT
        major,
        COUNT(*) AS total_mand
    FROM courses
    WHERE mandatory = 'yes'
    GROUP BY major
)
SELECT sci.student_id
FROM student_course_info sci
JOIN mandatory_course_info mci ON sci.major = mci.major
WHERE
    sci.avg_gpa >= 2.5
    AND sci.mand_a = mci.total_mand
    AND sci.elec_ab = sci.elec_total
    AND sci.elec_total >= 2
ORDER BY sci.student_id;