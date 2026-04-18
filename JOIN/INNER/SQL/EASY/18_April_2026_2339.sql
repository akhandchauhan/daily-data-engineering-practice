-- 2339. All the Matches of the League 
-- Description
-- Table: Teams
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | team_name   | varchar |
-- +-------------+---------+
-- team_name is the column with unique values of this table.
-- Each row of this table shows the name of a team.

-- Write a solution to report all the possible matches of the league. 
-- Note that every two teams play two matches with each other, with one 
-- team being the home_team once and the other time being the away_team.

-- Return the result table in any order.

-- Input: 
-- Teams table:
-- +-------------+
-- | team_name   |
-- +-------------+
-- | Leetcode FC |
-- | Ahly SC     |
-- | Real Madrid |
-- +-------------+
-- Output: 
-- +-------------+-------------+
-- | home_team   | away_team   |
-- +-------------+-------------+
-- | Real Madrid | Leetcode FC |
-- | Real Madrid | Ahly SC     |
-- | Leetcode FC | Real Madrid |
-- | Leetcode FC | Ahly SC     |
-- | Ahly SC     | Real Madrid |
-- | Ahly SC     | Leetcode FC |
-- +-------------+-------------+
-- Explanation: All the matches of the league are shown in the table.

CREATE DATABASE PRACTICE;

USE  PRACTICE;
DROP TABLE IF EXISTS Teams;

CREATE TABLE Teams (
    team_name VARCHAR(50) UNIQUE
);

INSERT INTO Teams (team_name)
VALUES 
    ("Leetcode FC"),
    ("Ahly SC"),
    ("Real Madrid");

SELECT 
        t1.team_name AS home_team,
        t2.team_name AS away_team
FROM Teams t1
CROSS JOIN Teams t2
WHERE t1.team_name <> t2.team_name ;