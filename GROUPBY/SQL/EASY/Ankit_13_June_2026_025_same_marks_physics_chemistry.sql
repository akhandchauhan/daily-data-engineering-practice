-- Find students with same marks in Physics and Chemistry
--
-- Table: exams
-- +------------+-----------+-------+
-- | student_id | subject   | marks |
-- +------------+-----------+-------+
-- | INT        | VARCHAR   | INT   |
-- +------------+-----------+-------+
--
-- Write a query to return all student_ids who scored the same marks
-- in both Physics and Chemistry.

DROP TABLE IF EXISTS exams;

CREATE TABLE exams (
    student_id INT,
    subject    VARCHAR(20),
    marks      INT
);

INSERT INTO exams (student_id, subject, marks) VALUES
(1, 'Chemistry', 91),
(1, 'Physics',   91),
(2, 'Chemistry', 80),
(2, 'Physics',   90),
(3, 'Chemistry', 80),
(3, 'Physics',   80),
(4, 'Chemistry', 71),
(4, 'Physics',   54);

-- m1
SELECT student_id
FROM exams
WHERE subject IN ('Chemistry', 'Physics')
GROUP BY student_id
HAVING COUNT(DISTINCT subject) = 2
   AND COUNT(DISTINCT marks) = 1;


