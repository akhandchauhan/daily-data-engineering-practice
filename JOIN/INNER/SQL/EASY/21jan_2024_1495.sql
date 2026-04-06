-- 1495. Friendly Movies Streamed Last Month
-- Online movie streaming services
-- SQL Schema 
-- Table: TVProgram
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | program_date  | date    |
-- | content_id    | int     |
-- | channel       | varchar |
-- +---------------+---------+
-- (program_date, content_id) is the primary key for this table.
-- This table contains information of the programs on the TV.
-- content_id is the id of the program in some channel on the TV.
-- Table: Content
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | content_id       | varchar |
-- | title            | varchar |
-- | Kids_content     | enum    |
-- | content_type     | varchar |
-- +------------------+---------+
-- content_id is the primary key for this table.
-- Kids_content is an enum that takes one of the values ('Y', 'N') where:
-- 'Y' means is content for kids otherwise 'N' is not content for kids.
-- content_type is the category of the content as movies, series, etc.

-- Write an  SQL query to report the distinct titles of the kid-friendly movies
-- streamed in June 2020.Online movie streaming services.

-- Return the result table in any order.
-- The query result format is in the following example.
-- TVProgram table:
-- +--------------------+--------------+-------------+
-- | program_date       | content_id   | channel     |
-- +--------------------+--------------+-------------+
-- | 2020-06-10 08:00   | 1            | LC-Channel  |
-- | 2020-05-11 12:00   | 2            | LC-Channel  |
-- | 2020-05-12 12:00   | 3            | LC-Channel  |
-- | 2020-05-13 14:00   | 4            | Disney Ch   |
-- | 2020-06-18 14:00   | 4            | Disney Ch   |
-- | 2020-07-15 16:00   | 5            | Disney Ch   |
-- +--------------------+--------------+-------------+
-- Content table:
-- +------------+----------------+---------------+---------------+
-- | content_id | title          | Kids_content  | content_type  |
-- +------------+----------------+---------------+---------------+
-- | 1          | Leetcode Movie | N             | Movies        |
-- | 2          | Alg. for Kids  | Y             | Series        |
-- | 3          | Database Sols  | N             | Series        |
-- | 4          | Aladdin        | Y             | Movies        |
-- | 5          | Cinderella     | Y             | Movies        |
-- +------------+----------------+---------------+---------------+
-- Result table:
-- +--------------+
-- | title        |
-- +--------------+
-- | Aladdin      |
-- +--------------+
-- "Leetcode Movie" is not a content for kids.
-- "Alg. for Kids" is not a movie.
-- "Database Sols" is not a movie
-- "Alladin" is a movie, content for kids and was streamed in June 2020.
-- "Cinderella" was not streamed in June 2020.
DROP TABLE IF EXISTS TVProgram;
DROP TABLE IF EXISTS Content;

CREATE TABLE TVProgram (
    program_date DATE,
    content_id INT,
    channel VARCHAR(50),
    PRIMARY KEY (program_date, content_id)
);

CREATE TABLE Content (
    content_id VARCHAR(50),
    title VARCHAR(100),
    Kids_content ENUM('Y', 'N'),
    content_type VARCHAR(50),
    PRIMARY KEY (content_id)
);
INSERT INTO TVProgram (program_date, content_id, channel)
VALUES
('2020-06-10', 1, 'LC-Channel'),
('2020-05-11', 2, 'LC-Channel'),
('2020-05-12', 3, 'LC-Channel'),
('2020-06-18', 4, 'Disney Ch'),
('2020-05-13',4,'Disney Ch'),
('2020-07-15', 5, 'Disney Ch');

INSERT INTO Content (content_id, title, Kids_content, content_type)
VALUES
('1', 'Leetcode Movie', 'N', 'Movies'),
('2', 'Alg. for Kids', 'Y', 'Series'),
('3', 'Database Sols', 'N', 'Series'),
('4', 'Aladdin', 'Y', 'Movies'),
('5', 'Cinderella', 'Y', 'Movies');

-- m1 
SELECT DISTINCT title
FROM Tvprogram tv
LEFT JOIN Content c
ON tv.content_id = c.content_id
WHERE Kids_content = 'Y'  
and content_type = "Movies" 
and YEAR(program_date) = 2020 
and MONTH(program_date) =6;

---------------------------------------------------------------------------------------
-- m2
SELECT DISTINCT title
FROM TVProgram tp 
JOIN Content c 
ON tp.content_id = c.content_id
AND c.Kids_content = 'Y'
AND c.content_type = "Movies" 
AND tp.program_date >= '2020-06-01'
AND tp.program_date < '2020-07-01';


---------------------------------------------------------------------------------------

-- m3

SELECT c.title
FROM Content c
JOIN TVProgram tp
  ON tp.content_id = CAST(c.content_id AS SIGNED)
WHERE c.Kids_content = 'Y'
  AND c.content_type = 'Movies'
  AND tp.program_date >= '2020-06-01'
  AND tp.program_date < '2020-07-01'
GROUP BY c.title;