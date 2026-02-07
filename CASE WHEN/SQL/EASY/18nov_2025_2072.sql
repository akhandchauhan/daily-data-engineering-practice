-- .2072 The Winner University 
-- Description
-- Table: NewYork
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | student_id  | int  |
-- | score       | int  |
-- +-------------+------+
-- student_id is the primary key for this table.
-- Each row contains information about the score of one student from New York University in an exam.
-- Table: California
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | student_id  | int  |
-- | score       | int  |
-- +-------------+------+
-- student_id is the primary key for this table.
-- Each row contains information about the score of one student from California University in an exam.
-- There is a competition between New York University and California University.
-- The competition is held between the same number of students from both universities. 
--The university that has more excellent students wins the competition. If the two universities have
-- the same number of excellent students, the competition ends in a draw.
-- An excellent student is a student that scored 90% or more in the exam.
-- Write an  SQL query to report:
-- "New York University" if New York University wins the competition.
-- "California University" if California University wins the competition.
-- "No Winner" if the competition ends in a draw.
-- The query result format is in the following example.
-- Example 1:
-- Input: 
-- NewYork table:
-- +------------+-------+
-- | student_id | score |
-- +------------+-------+
-- | 1          | 90    |
-- | 2          | 87    |
-- +------------+-------+
-- California table:
-- +------------+-------+
-- | student_id | score |
-- +------------+-------+
-- | 2          | 89    |
-- | 3          | 88    |
-- +------------+-------+
-- Output: 
-- +---------------------+
-- | winner              |
-- +---------------------+
-- | New York University |
-- +---------------------+
-- Explanation:
-- New York University has 1 excellent student, and California University has 0 excellent students.
DROP TABLE IF EXISTS NewYork;
DROP TABLE IF EXISTS California;

CREATE TABLE NewYork (
    student_id INT PRIMARY KEY,
    score INT
);
INSERT INTO NewYork (student_id, score)
VALUES (1, 90),
       (2, 87);
CREATE TABLE California (
    student_id INT PRIMARY KEY,
    score INT
);
INSERT INTO California (student_id, score)
VALUES (2, 89),
       (3, 88);

-- m1
with cte1 as ( 
select sum(case when score >= 90 then 1 else 0 end) as ny_score from NewYork ) ,
cte2 as (
select sum(case when score >= 90 then 1 else 0 end) as cf_score from California) 
SELECT
    CASE
        WHEN ny_score > cf_score THEN 'New York University'
        WHEN ny_score < cf_score THEN 'California University'
        ELSE 'No Winner'
    END AS winner
FROM
    cte1, cte2;

----------------------------------------------------------------------------------------------------------------------------------  
-- method 2
WITH cte as(
    SELECT COUNT(student_id) as cnt1
    FROM Newyork
    WHERE score >=90
),cte2 as(
    SELECT COUNT(student_id) as cnt2
    FROM California
    WHERE score >=90
)
SELECT case when cnt1>cnt2 THEN 'New york University' 
        WHEN cnt2>cnt1 THEN 'California University'
        ELSE 'Draw' end as winner
FROM cte,cte2;  

----------------------------------------------------------------------------------------------------------------------------------
-- m3 
WITH student_info AS (
    SELECT student_id, score, 'New York University' AS university
    FROM NewYork 
    UNION 
    SELECT student_id, score, 'California University' AS university
    FROM California
),
uni_cnt AS (
    SELECT university, COUNT(student_id) AS stud_cnt
    FROM student_info
    WHERE score >= 90
    GROUP BY university
)
SELECT 
    CASE 
        WHEN COUNT(DISTINCT university) = 1 THEN MAX(university)
        WHEN MAX(stud_cnt) = MIN(stud_cnt) THEN 'No Winner'
        WHEN MAX(CASE WHEN university = 'New York University' THEN stud_cnt ELSE 0 END) > 
             MAX(CASE WHEN university = 'California University' THEN stud_cnt ELSE 0 END) 
             THEN 'New York University'
        ELSE 'California University'
    END AS winner
FROM uni_cnt;


----------------------------------------------------------------------------------------------------------------------------------
-- m4
WITH university_info AS (
    SELECT 'newyork' AS city,
          COUNT(student_id) as excellent_student_count
    FROM newyork
     WHERE score >= 90
    UNION 
    SELECT 'california',
            COUNT(student_id) as excellent_student_count
    FROM california
    WHERE score >= 90
)
SELECT 
    CASE 
    WHEN MAX(CASE WHEN city = 'california' THEN excellent_student_count END) >  
       MAX(CASE WHEN city = 'newyork' THEN excellent_student_count END) THEN 'California University'
    WHEN MAX(CASE WHEN city = 'california' THEN excellent_student_count END) <
       MAX(CASE WHEN city = 'newyork' THEN excellent_student_count END) THEN 'New York University'
    ELSE 'No Winner'
    END AS winner

FROM university_info;



;