-- 1841. League Statistics
-- Description
-- Table: Teams
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | team_id        | int     |
-- | team_name      | varchar |
-- +----------------+---------+
-- team_id is the column with unique values for this table.
-- Each row contains information about one team in the league.
-- Table: Matches
-- +-----------------+---------+
-- | Column Name     | Type    |
-- +-----------------+---------+
-- | home_team_id    | int     |
-- | away_team_id    | int     |
-- | home_team_goals | int     |
-- | away_team_goals | int     |
-- +-----------------+---------+
-- (home_team_id, away_team_id) is the primary key (combination of columns with unique values) for this table.
-- Each row contains information about one match.
-- home_team_goals is the number of goals scored by the home team.
-- away_team_goals is the number of goals scored by the away team.
-- The winner of the match is the team with the higher number of goals.

-- Write a solution to report the  statistics of the league. The statistics
-- should be built using the played matches where the winning team gets three points and 
-- the losing team gets no points.
--  If a match ends with a draw, both teams get one point.
-- Each row of the result table should contain:

-- team_name - The name of the team in the Teams table.
-- matches_played - The number of matches played as either a home or away team.
-- points - The total points the team has so far.
-- goal_for - The total number of goals scored by the team across all matches.
-- goal_against - The total number of goals scored by opponent teams against this team
-- - across all matches.
-- goal_diff - The result of goal_for - goal_against.

-- Return the result table ordered by points in descending order. If two or more teams 
-- have the same points, order them by goal_diff in descending order. 
-- If there is still a tie, order them by team_name in lexicographical order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Teams table:
-- +---------+-----------+
-- | team_id | team_name |
-- +---------+-----------+
-- | 1       | Ajax      |
-- | 4       | Dortmund  |
-- | 6       | Arsenal   |
-- +---------+-----------+
-- Matches table:
-- +--------------+--------------+-----------------+-----------------+
-- | home_team_id | away_team_id | home_team_goals | away_team_goals |
-- +--------------+--------------+-----------------+-----------------+
-- | 1            | 4            | 0               | 1               |
-- | 1            | 6            | 3               | 3               |
-- | 4            | 1            | 5               | 2               |
-- | 6            | 1            | 0               | 0               |
-- +--------------+--------------+-----------------+-----------------+
-- Output: 
-- +-----------+----------------+--------+----------+--------------+-----------+
-- | team_name | matches_played | points | goal_for | goal_against | goal_diff |
-- +-----------+----------------+--------+----------+--------------+-----------+
-- | Dortmund  | 2              | 6      | 6        | 2            | 4         |
-- | Arsenal   | 2              | 2      | 3        | 3            | 0         |
-- | Ajax      | 4              | 2      | 5        | 9            | -4        |
-- +-----------+----------------+--------+----------+--------------+-----------+
-- Explanation: 
-- Ajax (team_id=1) played 4 matches: 2 losses and 2 draws. Total points = 0 + 0 + 1 + 1 = 2.
-- Dortmund (team_id=4) played 2 matches: 2 wins. Total points = 3 + 3 = 6.
-- Arsenal (team_id=6) played 2 matches: 2 draws. Total points = 1 + 1 = 2.
-- Dortmund is the first team in the table. Ajax and Arsenal have the same points, but since Arsenal has a 

DROP TABLE Teams;
DROP TABLE Matches;
-- Create Teams Table
CREATE TABLE IF NOT EXISTS Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50)
);

-- Create Matches Table
CREATE TABLE IF NOT EXISTS Matches (
    home_team_id INT,
    away_team_id INT,
    home_team_goals INT,
    away_team_goals INT,
    PRIMARY KEY (home_team_id, away_team_id)
);

-- Insert Data into Teams Table
INSERT INTO Teams (team_id, team_name) VALUES
(1, 'Ajax'),
(4, 'Dortmund'),
(6, 'Arsenal');

-- Insert Data into Matches Table
INSERT INTO Matches (home_team_id, away_team_id, home_team_goals, away_team_goals) VALUES
(1, 4, 0, 1),
(1, 6, 3, 3),
(4, 1, 5, 2),
(6, 1, 0, 0);

-- m1
WITH goals_info AS (
    SELECT 
        home_team_id AS team_id,
        CASE 
            WHEN home_team_goals > away_team_goals THEN 3
            WHEN home_team_goals = away_team_goals THEN 1
            ELSE 0 
        END AS points,
        home_team_goals AS goals_for,
        away_team_goals AS goals_against
    FROM Matches 
    UNION ALL
    SELECT 
        away_team_id AS team_id,
        CASE 
            WHEN home_team_goals < away_team_goals THEN 3
            WHEN home_team_goals = away_team_goals THEN 1
            ELSE 0 
        END AS points,
        away_team_goals AS goals_for,
        home_team_goals AS goals_against
    FROM Matches
 ),
 teams_agg_info AS (
    SELECT 
            team_id,
            COUNT(*) AS matches_played,
            SUM(points) AS points,
            SUM(goals_for) AS goals_for,
            SUM(goals_against) AS goals_against

    FROM goals_info
    GROUP BY 
            team_id
 )
 SELECT
        t.team_name,
        IFNULL(tai.matches_played, 0) AS matches_played,
        IFNULL(tai.points, 0) AS points,
        IFNULL(tai.goals_for, 0) AS goals_for,
        IFNULL(tai.goals_against, 0) AS goals_against,
        IFNULL(tai.goals_for,0) - IFNULL(tai.goals_against,0) AS goal_diff
 FROM teams t 
 LEFT JOIN teams_agg_info tai 
 ON t.team_id = tai.team_id
 ORDER BY 
        points DESC,
        goal_diff DESC,
        t.team_name
 ;