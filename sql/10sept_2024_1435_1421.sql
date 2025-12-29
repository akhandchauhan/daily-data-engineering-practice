-- 1421. NPV Queries
-- Description
-- Table: NPV
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | year          | int     |
-- | npv           | int     |
-- +---------------+---------+
-- (id, year) is the primary key (combination of columns with unique values) of this table.
-- The table has information about the id and the year of each inventory and the corresponding net present value.
-- Table: Queries
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | year          | int     |
-- +---------------+---------+
-- (id, year) is the primary key (combination of columns with unique values) of this table.
-- The table has information about the id and the year of each inventory query.
-- Write a solution to find the npv of each query of the Queries table.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- NPV table:
-- +------+--------+--------+
-- | id   | year   | npv    |
-- +------+--------+--------+
-- | 1    | 2018   | 100    |
-- | 7    | 2020   | 30     |
-- | 13   | 2019   | 40     |
-- | 1    | 2019   | 113    |
-- | 2    | 2008   | 121    |
-- | 3    | 2009   | 12     |
-- | 11   | 2020   | 99     |
-- | 7    | 2019   | 0      |
-- +------+--------+--------+
-- Queries table:
-- +------+--------+
-- | id   | year   |
-- +------+--------+
-- | 1    | 2019   |
-- | 2    | 2008   |
-- | 3    | 2009   |
-- | 7    | 2018   |
-- | 7    | 2019   |
-- | 7    | 2020   |
-- | 13   | 2019   |
-- +------+--------+
-- Output: 
-- +------+--------+--------+
-- | id   | year   | npv    |
-- +------+--------+--------+
-- | 1    | 2019   | 113    |
-- | 2    | 2008   | 121    |
-- | 3    | 2009   | 12     |
-- | 7    | 2018   | 0      |
-- | 7    | 2019   | 0      |
-- | 7    | 2020   | 30     |
-- | 13   | 2019   | 40     |
-- +------+--------+--------+
-- Explanation: 
-- The npv value of (7, 2018) is not present in the NPV table, we consider it 0.
-- The npv values of all other queries can be found in the NPV table.


SELECT q.id,
       q.year,
       IFNULL(NPV.npv,0) as npv
FROM Queries q 
LEFT JOIN NPV 
ON q.id = NPV.id and q.year = NPV.year;


CREATE TABLE NPV (
    id INT,
    year INT,
    npv INT,
    PRIMARY KEY (id, year)
);
INSERT INTO NPV (id, year, npv) VALUES
(1, 2018, 100),
(7, 2020, 30),
(13, 2019, 40),
(1, 2019, 113),
(2, 2008, 121),
(3, 2009, 12),
(11, 2020, 99),
(7, 2019, 0);
CREATE TABLE Queries (
    id INT,
    year INT,
    PRIMARY KEY (id, year)
);

INSERT INTO Queries (id, year) VALUES
(1, 2019),
(2, 2008),
(3, 2009),
(7, 2018),
(7, 2019),
(7, 2020),
(13, 2019);

SELECT q.*, IFNULL(npv, 0) AS npv
FROM Queries AS q
LEFT JOIN NPV AS n 
USING (id, year);

-- method 2
SELECT q.id,q.year,IFNULL(npv,0) as npv
FROM Queries q
LEFT JOIN NPV n
ON q.id = n.id and q.year = n.year;

-- 1435. Create a Session Bar Chart
-- Description
-- Table: Sessions
-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | session_id          | int     |
-- | duration            | int     |
-- +---------------------+---------+
-- session_id is the column of unique values for this table.
-- duration is the time in seconds that a user has visited the application.

-- You want to know how long a user visits your application. 
--You decided to create bins of "[0-5>", "[5-10>", "[10-15>", and "15 minutes or more" 
--and count the number of sessions on it.
-- Write a solution to report the (bin, total).
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Sessions table:
-- +-------------+---------------+
-- | session_id  | duration      |
-- +-------------+---------------+
-- | 1           | 30            |
-- | 2           | 199           |
-- | 3           | 299           |
-- | 4           | 580           |
-- | 5           | 1000          |
-- +-------------+---------------+
-- Output: 
-- +--------------+--------------+
-- | bin          | total        |
-- +--------------+--------------+
-- | [0-5>        | 3            |
-- | [5-10>       | 1            |
-- | [10-15>      | 0            |
-- | 15 or more   | 1            |
-- +--------------+--------------+
-- Explanation: 
-- For session_id 1, 2, and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
-- For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
-- There is no session with a duration greater than or equal to 10 minutes and less than 15 minutes.
-- For session_id 5 has a duration greater than or equal to 15 minutes.

CREATE TABLE Sessions (
    session_id INT,
    duration INT,
    PRIMARY KEY (session_id)
);
INSERT INTO Sessions (session_id, duration) VALUES
(1, 30),
(2, 199),
(3, 299),
(4, 580),
(5, 1000);

SELECT '[0-5>' AS bin, COUNT(1) AS total 
FROM Sessions
WHERE duration < 300
UNION
SELECT '[5-10>' AS bin, COUNT(1) AS total 
FROM Sessions 
WHERE 300 <= duration AND duration < 600
UNION
SELECT '[10-15>' AS bin, COUNT(1) AS total 
FROM Sessions 
WHERE 600 <= duration AND duration < 900
UNION
SELECT '15 or more' AS bin, COUNT(1) AS total 
FROM Sessions 
WHERE 900 <= duration;
