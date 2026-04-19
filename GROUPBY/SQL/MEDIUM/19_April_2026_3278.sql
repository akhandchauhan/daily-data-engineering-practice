-- 3278. Find Candidates for Data Scientist Position II 
-- Description
-- Table: Candidates
-- +--------------+---------+ 
-- | Column Name  | Type    | 
-- +--------------+---------+ 
-- | candidate_id | int     | 
-- | skill        | varchar |
-- | proficiency  | int     |
-- +--------------+---------+
-- (candidate_id, skill) is the unique key for this table.
-- Each row includes candidate_id, skill, and proficiency level (1-5).
-- Table: Projects

-- +--------------+---------+ 
-- | Column Name  | Type    | 
-- +--------------+---------+ 
-- | project_id   | int     | 
-- | skill        | varchar |
-- | importance   | int     |
-- +--------------+---------+
-- (project_id, skill) is the primary key for this table.
-- Each row includes project_id, required skill, and its importance (1-5) for
--  the project.

-- Leetcode is staffing for multiple data science projects. Write a 
--solution to find the best candidate for each project based on the following criteria:

-- Candidates must have all the skills required for a project.
-- Calculate a score for each candidate-project pair as follows:
-- Start with 100 points
-- Add 10 points for each skill where proficiency > importance
-- Subtract 5 points for each skill where proficiency < importance
-- If the candidate's skill proficiency equal to the project's skill 
-- importance, the score remains unchanged
-- Include only the top candidate (highest score) for each project. 
-- If there’s a tie, choose the candidate with the lower candidate_id. 
-- If there is no suitable candidate for a project, do not return that project.

-- Return a result table ordered by project_id in ascending order.

-- Candidates table:
-- +--------------+-----------+-------------+
-- | candidate_id | skill     | proficiency |
-- +--------------+-----------+-------------+
-- | 101          | Python    | 5           |
-- | 101          | Tableau   | 3           |
-- | 101          | PostgreSQL| 4           |
-- | 101          | TensorFlow| 2           |
-- | 102          | Python    | 4           |
-- | 102          | Tableau   | 5           |
-- | 102          | PostgreSQL| 4           |
-- | 102          | R         | 4           |
-- | 103          | Python    | 3           |
-- | 103          | Tableau   | 5           |
-- | 103          | PostgreSQL| 5           |
-- | 103          | Spark     | 4           |
-- +--------------+-----------+-------------+
-- Projects table:

-- +-------------+-----------+------------+
-- | project_id  | skill     | importance |
-- +-------------+-----------+------------+
-- | 501         | Python    | 4          |
-- | 501         | Tableau   | 3          |
-- | 501         | PostgreSQL| 5          |
-- | 502         | Python    | 3          |
-- | 502         | Tableau   | 4          |
-- | 502         | R         | 2          |
-- +-------------+-----------+------------+
-- Output:

-- +-------------+--------------+-------+
-- | project_id  | candidate_id | score |
-- +-------------+--------------+-------+
-- | 501         | 101          | 105   |
-- | 502         | 102          | 130   |
-- +-------------+--------------+-------+
-- Explanation:

-- For Project 501, Candidate 101 has the highest score of 105.
--  All other candidates have the same score but Candidate 101 has 
-- the lowest candidate_id among them.
-- For Project 502, Candidate 102 has the highest score of 130.
-- The output table is ordered by project_id in ascending order.

-- Drop tables if they exist
DROP TABLE IF EXISTS Candidates;
DROP TABLE IF EXISTS Projects;

-- Create tables
CREATE TABLE Candidates (
    candidate_id INT,
    skill VARCHAR(50),
    proficiency INT
);

CREATE TABLE Projects (
    project_id INT,
    skill VARCHAR(50),
    importance INT
);

-- Insert data into Candidates
INSERT INTO Candidates (candidate_id, skill, proficiency) VALUES
(101, 'Python', 5),
(101, 'Tableau', 3),
(101, 'PostgreSQL', 4),
(101, 'TensorFlow', 2),
(102, 'Python', 4),
(102, 'Tableau', 5),
(102, 'PostgreSQL', 4),
(102, 'R', 4),
(103, 'Python', 3),
(103, 'Tableau', 5),
(103, 'PostgreSQL', 5),
(103, 'Spark', 4);

-- Insert data into Projects
INSERT INTO Projects (project_id, skill, importance) VALUES
(501, 'Python', 4),
(501, 'Tableau', 3),
(501, 'PostgreSQL', 5),
(502, 'Python', 3),
(502, 'Tableau', 4),
(502, 'R', 2);

-- m1 wrong method
WITH skill_info AS (
    SELECT 
            p.project_id,
            c.candidate_id,
            CASE 
                WHEN c.skill IS NULL THEN 1 
                ELSE 0 
            END AS null_skill,
            CASE 
                WHEN c.proficiency > p.importance THEN 10
                WHEN c.proficiency < p.importance THEN -5
                ELSE 0 
                END 
            AS score
    FROM Projects p 
    LEFT JOIN Candidates c 
    ON p.skill = c.skill
),
score_info AS (
    SELECT 
        project_id,
        candidate_id,
        100 + SUM(score) AS score
    FROM skill_info
    GROUP BY project_id,
            candidate_id
    HAVING SUM(null_skill) = 0
),
ranked_info AS (
    SELECT 
            project_id,
            candidate_id,
            score,
            ROW_NUMBER() OVER(
                PARTITION BY project_id
                ORDER BY score DESC,
                        candidate_id
            ) AS candidate_ranked
    FROM score_info
)
SELECT 
        project_id,
        candidate_id,
        score
FROM ranked_info
WHERE candidate_ranked = 1
ORDER BY project_id;

-- Project 501 requires:

-- Python
-- Tableau
-- PostgreSQL

-- Candidate 102 has:

-- Python
-- Tableau
-- ❌ missing PostgreSQL
-- What your join produces:
-- project_id	skill	candidate_id
-- 501	Python	102
-- 501	Tableau	102
-- 501	PostgreSQL	NULL ❌

-- Now here’s the key:
-- That NULL row:
-- candidate_id = NULL

-- 👉 It does NOT belong to candidate 102’s group

-- 💥 What happens during GROUP BY

-- Your grouping:
-- GROUP BY project_id, candidate_id

-- Produces:
-- For candidate 102:
-- project_id	candidate_id	rows
-- 501	102	Python, Tableau
-----------------------------------------------------------------------------------------
-- m2 
WITH matched AS (
    SELECT 
        p.project_id,
        c.candidate_id,
        COUNT(*) AS matched_skills,
        100 + SUM(
            CASE 
                WHEN c.proficiency > p.importance THEN 10
                WHEN c.proficiency < p.importance THEN -5
                ELSE 0
            END
        ) AS score
    FROM Projects p
    JOIN Candidates c
        ON p.skill = c.skill
    GROUP BY p.project_id, c.candidate_id
),
valid AS (
    SELECT m.*
    FROM matched m
    JOIN (
        SELECT project_id, COUNT(*) AS required_skills
        FROM Projects
        GROUP BY project_id
    ) req
    ON m.project_id = req.project_id
    WHERE m.matched_skills = req.required_skills
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY project_id
               ORDER BY score DESC, candidate_id
           ) AS rn
    FROM valid
)
SELECT project_id, candidate_id, score
FROM ranked
WHERE rn = 1
ORDER BY project_id;