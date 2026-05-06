-- 1212. Team Scores in Football Tournament 

-- Table: Teams
-- +--------------+----------+
-- | Column Name   | Type     |
-- +---------------+----------+
-- | team_id       | int      |
-- | team_name     | varchar  |
-- +---------------+----------+
-- team_id is the column with unique values of this table.
-- Each row of this table represents a single football team.
 
-- Table: Matches
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | match_id      | int     |
-- | host_team     | int     |
-- | guest_team    | int     | 
-- | host_goals    | int     |
-- | guest_goals   | int     |
-- +---------------+---------+
-- match_id is the column of unique values of this table.
-- Each row is a record of a finished match between two different teams. 
-- Teams host_team and guest_team are represented by their IDs in the 
-- Teams table (team_id), and they scored host_goals and guest_goals goals, respectively.
 
-- You would like to compute the scores of all teams after all matches. Points are awarded as follows:
-- A team receives three points if they win a match (i.e., Scored more goals than the opponent team).
-- A team receives one point if they draw a match (i.e., Scored the same number of goals as the
-- opponent team).
-- A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).

-- Write a solution that selects the team_id, team_name and num_points of each team in 
-- the tournament after all described matches.

-- Return the result table ordered by num_points in decreasing order. In case of a tie, 
-- order the records by team_id in increasing order.

-- Input: 
-- Teams table:
-- +-----------+--------------+
-- | team_id   | team_name    |
-- +-----------+--------------+
-- | 10        | Leetcode FC  |
-- | 20        | NewYork FC   |
-- | 30        | Atlanta FC   |
-- | 40        | Chicago FC   |
-- | 50        | Toronto FC   |
-- +-----------+--------------+
-- Matches table:
-- +------------+--------------+---------------+-------------+--------------+
-- | match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
-- +------------+--------------+---------------+-------------+--------------+
-- | 1          | 10           | 20            | 3           | 0            |
-- | 2          | 30           | 10            | 2           | 2            |
-- | 3          | 10           | 50            | 5           | 1            |
-- | 4          | 20           | 30            | 1           | 0            |
-- | 5          | 50           | 30            | 1           | 0            |
-- +------------+--------------+---------------+-------------+--------------+
-- Output: 
-- +------------+--------------+---------------+
-- | team_id    | team_name    | num_points    |
-- +------------+--------------+---------------+
-- | 10         | Leetcode FC  | 7             |
-- | 20         | NewYork FC   | 3             |
-- | 50         | Toronto FC   | 3             |
-- | 30         | Atlanta FC   | 1             |
-- | 40         | Chicago FC   | 0             |
-- +------------+--------------+---------------+


-- Drop tables
DROP TABLE IF EXISTS Matches;
DROP TABLE passes;
DROP TABLE IF EXISTS Teams;

-- Create Teams table
CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100)
);

-- Insert into Teams
INSERT INTO Teams (team_id, team_name) VALUES
(10, 'Leetcode FC'),
(20, 'NewYork FC'),
(30, 'Atlanta FC'),
(40, 'Chicago FC'),
(50, 'Toronto FC');

-- Create Matches table
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    host_team INT,
    guest_team INT,
    host_goals INT,
    guest_goals INT
);

-- Insert into Matches
INSERT INTO Matches (match_id, host_team, guest_team, host_goals, guest_goals) VALUES
(1, 10, 20, 3, 0),
(2, 30, 10, 2, 2),
(3, 10, 50, 5, 1),
(4, 20, 30, 1, 0),
(5, 50, 30, 1, 0);

-- m1
WITH match_info AS (
    SELECT
        host_team,
        CASE 
            WHEN host_goals > guest_goals THEN 3
            WHEN host_goals = guest_goals THEN 1
            ELSE 0
        END AS host_points,
        guest_team,
        CASE 
            WHEN host_goals < guest_goals THEN 3
            WHEN host_goals = guest_goals THEN 1
            ELSE 0
        END AS guest_points
    FROM Matches
),
full_team_info AS (
    SELECT 
        host_team AS team_id,
        host_points AS points
    FROM match_info
    UNION ALL
    SELECT 
        guest_team,
        guest_points
    FROM match_info
),
agg_info AS (
    SELECT 
        team_id,
        SUM(points) AS num_points
    FROM full_team_info
    GROUP BY team_id
)
SELECT 
    t.team_id,
    t.team_name,
    IFNULL(ai.num_points, 0) AS num_points
FROM teams t
LEFT JOIN agg_info ai 
ON t.team_id = ai.team_id
ORDER BY 
        num_points DESC,
        t.team_id;

----------------------------------------------------------------------------------------------
-- m2
WITH all_matches AS (
    SELECT 
        host_team AS team_id,
        CASE
            WHEN host_goals > guest_goals THEN 3
            WHEN host_goals = guest_goals THEN 1
            ELSE 0
        END AS points
    FROM Matches

    UNION ALL

    SELECT 
        guest_team,
        CASE
            WHEN guest_goals > host_goals THEN 3
            WHEN guest_goals = host_goals THEN 1
            ELSE 0
        END
    FROM Matches
)
SELECT
    t.team_id,
    t.team_name,
    COALESCE(SUM(am.points),0) AS num_points
FROM Teams t
LEFT JOIN all_matches am
ON t.team_id = am.team_id
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC,
         t.team_id;