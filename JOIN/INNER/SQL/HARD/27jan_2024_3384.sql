-- 3384. Team Dominance by Pass Success 
-- Table: Teams
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | player_id   | int     |
-- | team_name   | varchar | 
-- +-------------+---------+
-- player_id is the unique key for this table.
-- Each row contains the unique identifier for player and the name of one of 
-- the teams participating in that match.

-- Table: Passes
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | pass_from   | int     |
-- | time_stamp  | varchar |
-- | pass_to     | int     |
-- +-------------+---------+
-- (pass_from, time_stamp) is the primary key for this table.
-- pass_from is a foreign key to player_id from Teams table.

-- Each row represents a pass made during a match, time_stamp represents the time in
-- minutes (00:00-90:00) when the pass was made,
-- pass_to is the player_id of the player receiving the pass.

-- Write a solution to calculate the dominance score for each team in both
-- halves of the match. The rules are as follows:

-- A match is divided into two halves: first half (00:00-45:00 minutes) and second
-- half (45:01-90:00 minutes)

-- The dominance score is calculated based on successful and intercepted passes:
-- When pass_to is a player from the same team: +1 point
-- When pass_to is a player from the opposing team (interception): -1 point
-- A higher dominance score indicates better passing performance

-- Return the result table ordered by team_name and half_number in ascending order.

-- Teams table:
-- +------------+-----------+
-- | player_id  | team_name |
-- +------------+-----------+
-- | 1          | Arsenal   |
-- | 2          | Arsenal   |
-- | 3          | Arsenal   |
-- | 4          | Chelsea   |
-- | 5          | Chelsea   |
-- | 6          | Chelsea   |
-- +------------+-----------+
-- Passes table:
-- +-----------+------------+---------+
-- | pass_from | time_stamp | pass_to |
-- +-----------+------------+---------+
-- | 1         | 00:15      | 2       |
-- | 2         | 00:45      | 3       |
-- | 3         | 01:15      | 1       |
-- | 4         | 00:30      | 1       |
-- | 2         | 46:00      | 3       |
-- | 3         | 46:15      | 4       |
-- | 1         | 46:45      | 2       |
-- | 5         | 46:30      | 6       |
-- +-----------+------------+---------+
-- Output:
-- +-----------+-------------+-----------+
-- | team_name | half_number | dominance |
-- +-----------+-------------+-----------+
-- | Arsenal   | 1           | 3         |
-- | Arsenal   | 2           | 1         |
-- | Chelsea   | 1           | -1        |
-- | Chelsea   | 2           | 1         |
-- +-----------+-------------+-----------+

DROP TABLE Teams;

CREATE TABLE IF NOT EXISTS Teams (
    player_id INT PRIMARY KEY,
    team_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Passes (
    pass_from INT,
    time_stamp VARCHAR(5),
    pass_to INT,
    PRIMARY KEY (pass_from, time_stamp),
    FOREIGN KEY (pass_from) REFERENCES Teams(player_id)
);

INSERT INTO Teams (player_id, team_name)
VALUES
(1, 'Arsenal'),
(2, 'Arsenal'),
(3, 'Arsenal'),
(4, 'Chelsea'),
(5, 'Chelsea'),
(6, 'Chelsea');

INSERT INTO Passes (pass_from, time_stamp, pass_to)
VALUES
(1, '00:15', 2),
(2, '00:45', 3),
(3, '01:15', 1),
(4, '00:30', 1),
(2, '46:00', 3),
(3, '46:15', 4),
(1, '46:45', 2),
(5, '46:30', 6);

-- m1
WITH cte as(
    SELECT *
FROM Teams t
 JOIN Passes p
ON t.player_id = p.pass_from
)
,cte2 as(
 SELECT c.team_name,IFNULL((IF(c.team_name=t.team_name,1,-1)),0) as pt, 
 IF(time_stamp<='45:00',1,2) as time_st
 FROM cte c 
  JOIN Teams t
 ON c.pass_to = t.player_id
 ORDER BY c.player_id,time_stamp
 )
 SELECT team_name,time_st as half_number, SUM(pt)  as dominance
 FROM cte2
 GROUP BY 1,2;

--------------------------------------------------------------------------------------------------
-- m2 same as m3
SELECT 
    t_pass_from.team_name,
    CASE 
        WHEN  CAST(CONCAT("00:",p.time_stamp) AS TIME) >= "00:00:00" AND  
        CAST(CONCAT("00:",p.time_stamp) AS TIME) <= "00:45:00" THEN 1 

        WHEN  CAST(CONCAT("00:",p.time_stamp) AS TIME) > "00:45:00" THEN 2
    END AS half_number,
    SUM(
        CASE 
            WHEN t_pass_from.team_name <> t_pass_to.team_name THEN -1
            ELSE 1 
        END 
    ) AS dominance
FROM Passes p 
JOIN Teams t_pass_from
ON p.pass_from = t_pass_from.player_id
JOIN Teams t_pass_to
ON p.pass_to = t_pass_to.player_id
GROUP BY 
     t_pass_from.team_name,
     half_number
ORDER BY 1,2 ;

--------------------------------------------------------------------------------------------------
-- m3

SELECT 
    t1.team_name,
    CASE WHEN p.time_stamp <= '45:00' THEN 1 ELSE 2 END AS half_number,
    SUM(CASE WHEN t1.team_name = t2.team_name THEN 1 ELSE -1 END) AS dominance
FROM Passes p
JOIN Teams t1 ON p.pass_from = t1.player_id
JOIN Teams t2 ON p.pass_to = t2.player_id
GROUP BY t1.team_name, half_number
ORDER BY t1.team_name, half_number;