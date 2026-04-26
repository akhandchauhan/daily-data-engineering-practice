-- 574. Winning Candidate
-- Description
-- Table: Candidate
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | id          | int      |
-- | name        | varchar  |
-- +-------------+----------+
-- id is the column with unique values for this table.
-- Each row of this table contains information about the id and the name of a candidate.
-- Table: Vote
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | id          | int  |
-- | candidateId | int  |
-- +-------------+------+
-- id is an auto-increment primary key (column with unique values).
-- candidateId is a foreign key (reference column) to id from the Candidate table.
-- Each row of this table determines the candidate who got the ith vote in the elections.
-- Write a solution to report the name of the winning candidate (i.e., the candidate
-- who got the largest number of votes).
-- The test cases are generated so that exactly one candidate wins the elections.
-- Input: 
-- Candidate table:
-- +----+------+
-- | id | name |
-- +----+------+
-- | 1  | A    |
-- | 2  | B    |
-- | 3  | C    |
-- | 4  | D    |
-- | 5  | E    |
-- +----+------+
-- Vote table:
-- +----+-------------+
-- | id | candidateId |
-- +----+-------------+
-- | 1  | 2           |
-- | 2  | 4           |
-- | 3  | 3           |
-- | 4  | 2           |
-- | 5  | 5           |
-- +----+-------------+
-- Output: 
-- +------+
-- | name |
-- +------+
-- | B    |
-- +------+
-- Explanation: 
-- Candidate B has 2 votes. Candidates C, D, and E have 1 vote each.
-- The winner is candidate B.
DROP TABLE IF EXISTS Vote;
DROP TABLE IF EXISTS Candidate;
CREATE TABLE Candidate (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Vote (
    id INT PRIMARY KEY AUTO_INCREMENT,
    candidateId INT,
    FOREIGN KEY (candidateId) REFERENCES Candidate(id)
);

INSERT INTO Candidate (id, name)
VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

INSERT INTO Vote (candidateId)
VALUES 
(2),
(4),
(3),
(2),
(5);

-- m1
WITH cte as(
    SELECT candidateId,COUNT(id) as cnt 
    FROM Vote 
    GROUP BY candidateId 
    ORDER BY cnt desc
    LIMIT 1
)
SELECT name
FROM cte c1
JOIN Candidate c
ON c1.candidateId=c.id;

---------------------------------------------------------------------------------------
-- m2
SELECT 
        c.name
FROM Vote v 
JOIN Candidate c 
ON v.candidateId = c.id
GROUP BY c.id,
         c.name
ORDER BY COUNT(c.id) DESC
LIMIT 1;

--------------------------------------------------------------------------------------
-- m3
with t1 as(
    select c.name, 
           count(*) as votes
    FROM Candidate AS c
    JOIN Vote AS v 
    ON c.id = v.candidateId
    group by c.name
)
select name 
from t1 
where votes = (
    select max(votes) 
    from t1
);

--------------------------------------------------------------------------------------
--m4
WITH ranked AS (
    SELECT c.name,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM Vote v
    JOIN Candidate c
      ON v.candidateId = c.id
    GROUP BY c.id, c.name
)
SELECT name
FROM ranked
WHERE rnk = 1;