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
-- (gender, day) is the primary key (combination of columns with unique values) 
--for this table.
-- A competition is held between the female team and the male team.
-- Each row of this table indicates that a player_name and with gender has scored
-- score_point in someday.
-- Gender is 'F' if the player is in the female team and 'M' if the player is in 
--the male team.
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


-------------------------------------------------------------------------------------------------------------------------------------
--method 2
SELECT
    gender,
    day,
    SUM(score_points) OVER (
        PARTITION BY gender
        ORDER BY day
    ) AS total
FROM Scores
ORDER BY gender, day;


-------------------------------------------------------------------------------------------------------------------------------------

-- m3 

WITH score_info AS (
    SELECT gender,
        day,
        SUM(score_points) AS total_score_points
    FROM scores 
    GROUP BY gender,
            day
)
SELECT gender,
       day,
       SUM(total_score_points) OVER(
                    PARTITION BY gender 
                    ORDER BY day 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total
FROM score_info 
ORDER BY gender,
         day;

-------------------------------------------------------------------------------------------------------------------------------------
--m4
WITH daily_scores AS (
    SELECT
        gender,
        day,
        SUM(score_points) AS daily_total
    FROM Scores
    GROUP BY gender, day
)
SELECT
    d1.gender,
    d1.day,
    SUM(d2.daily_total) AS total
FROM daily_scores d1
JOIN daily_scores d2
  ON d1.gender = d2.gender
 AND d2.day <= d1.day  -- “For the current row (d1.day), join all rows (d2) that happened on or before this day.”
GROUP BY d1.gender, d1.day
ORDER BY d1.gender, d1.day;
