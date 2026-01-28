-- 1308. Running Total for Different Genders
-- Description
-- Table: Scores
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | player_name   | varchar |
-- | gender        | varchar |
-- | day           | date    |
-- | score_points  | int     |
-- +---------------+---------+
-- (gender, day) is the primary key (combination of columns with unique values) for this table.
-- A competition is held between the female team and the male team.
-- Each row of this table indicates that a player_name and with gender has scored score_point in someday.
-- Gender is 'F' if the player is in the female team and 'M' if the player is in the male team.
-- Write a solution to find the total score for each gender on each day.
-- Return the result table ordered by gender and day in ascending order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Scores table:
-- +-------------+--------+------------+--------------+
-- | player_name | gender | day        | score_points |
-- +-------------+--------+------------+--------------+
-- | Aron        | F      | 2020-01-01 | 17           |
-- | Alice       | F      | 2020-01-07 | 23           |
-- | Bajrang     | M      | 2020-01-07 | 7            |
-- | Khali       | M      | 2019-12-25 | 11           |
-- | Slaman      | M      | 2019-12-30 | 13           |
-- | Joe         | M      | 2019-12-31 | 3            |
-- | Jose        | M      | 2019-12-18 | 2            |
-- | Priya       | F      | 2019-12-31 | 23           |
-- | Priyanka    | F      | 2019-12-30 | 17           |
-- +-------------+--------+------------+--------------+
-- Output: 
-- +--------+------------+-------+
-- | gender | day        | total |
-- +--------+------------+-------+
-- | F      | 2019-12-30 | 17    |
-- | F      | 2019-12-31 | 40    |
-- | F      | 2020-01-01 | 57    |
-- | F      | 2020-01-07 | 80    |
-- | M      | 2019-12-18 | 2     |
-- | M      | 2019-12-25 | 13    |
-- | M      | 2019-12-30 | 26    |
-- | M      | 2019-12-31 | 29    |
-- | M      | 2020-01-07 | 36    |
-- +--------+------------+-------+
-- Explanation: 
-- For the female team:
-- The first day is 2019-12-30, Priyanka scored 17 points and the total score for the team is 17.
-- The second day is 2019-12-31, Priya scored 23 points and the total score for the team is 40.
-- The third day is 2020-01-01, Aron scored 17 points and the total score for the team is 57.
-- The fourth day is 2020-01-07, Alice scored 23 points and the total score for the team is 80.

-- For the male team:
-- The first day is 2019-12-18, Jose scored 2 points and the total score for the team is 2.
-- The second day is 2019-12-25, Khali scored 11 points and the total score for the team is 13.
-- The third day is 2019-12-30, Slaman scored 13 points and the total score for the team is 26.
-- The fourth day is 2019-12-31, Joe scored 3 points and the total score for the team is 29.
-- The fifth day is 2020-01-07, Bajrang scored 7 points and the total score for the team is 36.

DROP TABLE scores;
CREATE TABLE Scores (
    player_name VARCHAR(50),
    gender VARCHAR(1),
    day DATE,
    score_points INT,
    PRIMARY KEY (gender, day, player_name)
);
INSERT INTO Scores (player_name, gender, day, score_points)
VALUES 
('Aron', 'F', '2020-01-01', 17),
('Alice', 'F', '2020-01-07', 23),
('Bajrang', 'M', '2020-01-07', 7),
('Khali', 'M', '2019-12-25', 11),
('Slaman', 'M', '2019-12-30', 13),
('Joe', 'M', '2019-12-31', 3),
('Jose', 'M', '2019-12-18', 2),
('Priya', 'F', '2019-12-31', 23),
('Priyanka', 'F', '2019-12-30', 17);

-- method 1
SELECT gender,day,SUM(score_points) OVER(ORDER BY day) as total
FROM Scores
WHERE gender='F'
UNION 
SELECT gender,day,SUM(score_points) OVER(ORDER BY day)
FROM Scores
WHERE gender='M'
ORDER BY gender,day;

--method 2
SELECT gender,day,SUM(score_points) OVER(PARTITION BY gender ORDER BY gender,day ROWS BETWEEN UNBOUNDED
PRECEDING AND CURRENT ROW) as total
FROM Scores;


-- 1285. Find the Start and End Number of Continuous Ranges
-- Description
-- Table: Logs
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | log_id        | int     |
-- +---------------+---------+
-- log_id is the column of unique values for this table.
-- Each row of this table contains the ID in a log Table.
-- Write a solution to find the start and end number of continuous ranges in the table Logs.
-- Return the result table ordered by start_id.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Logs table:
-- +------------+
-- | log_id     |
-- +------------+
-- | 1          |
-- | 2          |
-- | 3          |
-- | 7          |
-- | 8          |
-- | 10         |
-- +------------+
-- Output: 
-- +------------+--------------+
-- | start_id   | end_id       |
-- +------------+--------------+
-- | 1          | 3            |
-- | 7          | 8            |
-- | 10         | 10           |
-- +------------+--------------+
-- Explanation: 
-- The result table should contain all ranges in table Logs.
-- From 1 to 3 is contained in the table.
-- From 4 to 6 is missing in the table
-- From 7 to 8 is contained in the table.
-- Number 9 is missing from the table.
-- Number 10 is contained in the table.


DROP TABLE Logs;
CREATE TABLE Logs (
    log_id INT PRIMARY KEY
);
INSERT INTO Logs (log_id)
VALUES 
(1),
(2),
(3),
(7),
(8),
(10);

with cte as(
SELECT log_id, log_id - ROW_NUMBER() OVER(order by log_id) as rnk
FROM Logs
)
SELECT Min(log_id) as start_id, Max(log_id) as end_id
FROM cte
GROUP BY rnk
ORDER BY start_id;


