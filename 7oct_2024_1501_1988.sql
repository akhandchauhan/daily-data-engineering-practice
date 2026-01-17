-- 1988. Find Cutoff Score for Each School
-- Level
-- Medium
-- Description
-- Table: Schools
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | school_id   | int  |
-- | capacity    | int  |
-- +-------------+------+
-- school_id is the primary key for this table.
-- This table contains information about the capacity of some schools. The capacity is the maximum number 
--of students the school can accept.
-- Table: Exam
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | score         | int  |
-- | student_count | int  |
-- +---------------+------+
-- score is the primary key for this table.
-- Each row in this table indicates that there are student_count students that got at least score points
-- in the exam.
-- The data in this table will be logically correct, meaning a row recording a higher score will have 
--the same or smaller 
-- student_count compared to a row recording a lower score. More formally, for every two rows i and j
-- in the table, if scorei > scorej then student_counti <= student_countj.
-- Every year, each school announces a minimum score requirement that a student needs to apply to it.
-- The school chooses 
-- the minimum score requirement based on the exam results of all the students:

-- They want to ensure that even if every student meeting the requirement applies,
-- the school can accept everyone.
-- They also want to maximize the possible number of students that can apply.
-- They must use a score that is in the Exam table.
-- Write an  SQL query to report the minimum score requirement for each school.
-- If there are multiple score values 
-- satisfying the above conditions, choose the smallest one. If the input data is not 
-- enough to determine the score, report -1.
-- Return the result table in any order.
-- The query result format is in the following example.
-- Example 1:
-- Input:
-- Schools table:
-- +-----------+----------+
-- | school_id | capacity |
-- +-----------+----------+
-- | 11        | 151      |
-- | 5         | 48       |
-- | 9         | 9        |
-- | 10        | 99       |
-- +-----------+----------+
-- Exam table:
-- +-------+---------------+
-- | score | student_count |
-- +-------+---------------+
-- | 975   | 10            |
-- | 966   | 60            |
-- | 844   | 76            |
-- | 749   | 76            |
-- | 744   | 100           |
-- +-------+---------------+
-- Output:
-- +-----------+-------+
-- | school_id | score |
-- +-----------+-------+
-- | 5         | 975   |
-- | 9         | -1    |
-- | 10        | 749   |
-- | 11        | 744   |
-- +-----------+-------

-- Explanation: 
-- - School 5: The school's capacity is 48. Choosing 975 as the min score requirement, 
--the school will get at most 10 applications, which is within capacity.
-- - School 10: The school's capacity is 99. Choosing 844 or 749 as the min score requirement,
-- the school will get at most 76 applications, 
-- which is within capacity. We choose the smallest of them, which is 749.
-- - School 11: The school's capacity is 151. Choosing 744 as the min score requirement,
-- the school will get at most 100 applications, which is within capacity.
-- - School 9: The data given is not enough to determine the min score requirement. Choosing 975 as the m

DROP TABLE IF EXISTS Schools;
DROP TABLE IF EXISTS Exam;

CREATE TABLE Schools (
    school_id INT PRIMARY KEY,
    capacity INT
);

CREATE TABLE Exam (
    score INT PRIMARY KEY,
    student_count INT
);

INSERT INTO Schools (school_id, capacity) 
VALUES 
(11, 151),
(5, 48),
(9, 9),
(10, 99);

INSERT INTO Exam (score, student_count) 
VALUES 
(975, 10),
(966, 60),
(844, 76),
(749, 76),
(744, 100);


-- Here both of these examples have wrong logic because:
-- Exam table:
-- score | student_count
-- ------|---------------
-- 900   | 80
-- 800   | 80
-- 700   | 79

-- School capacity: 80
-- according to this, we will gett 700 as score with student_count as 79
-- but ultimately we want to maximise the student_count
-- so the correct solutin is score - 800 with student_count 80

select school_id, ifnull(min(score),-1) as score
from Schools 
left join Exam
on capacity >= student_count
group by school_id;

-- m2 
WITH cte as(
    SELECT *,ROW_NUMBER() OVER(PARTITION BY school_id ORDER BY score) as rnk
    FROM Schools s 
    LEFT JOIN exam e
    ON s.capacity >= e.student_count
)
SELECT school_id, IFNULL(score,-1) as score
FROM cte
WHERE rnk = 1;

--------------------------------------------------------------------------------------------------------------------------
-- Correct Solutions

WITH student_score_info as (
    SELECT s.school_id,
            MAX(e.student_count) as max_student_count
    FROM Schools s 
    LEFT JOIN Exam e 
    ON s.capacity >= e.student_count
    GROUP BY 1
)
SELECT sci.school_id,
      IFNULL(MIN(e.score), -1) as score
FROM student_score_info sci 
LEFT JOIN exam e 
ON sci.max_student_count = e.student_count
GROUP BY 1;



-- m2
WITH school_score_info as (
 SELECT s.school_id,
        e.score,
        e.student_count,
        MAX(e.student_count) OVER(PARTITION BY s.school_id) as max_student_count
    FROM Schools s 
    LEFT JOIN Exam e 
    ON s.capacity >= e.student_count
)
SELECT school_id,
       IFNULL(MIN(score),-1) as score
FROM school_score_info
WHERE student_count = max_student_count or max_student_count IS NULL
GROUP BY 1