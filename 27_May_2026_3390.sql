-- 3390. Longest Team Pass Streak
-- Description
-- Table: Teams
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | player_id   | int     |
-- | team_name   | varchar |
-- +-------------+---------+
-- player_id is the unique key for this table.
-- Each row contains the unique identifier for player -- and the name of one of the teams participating in -- that match.

-- Table: Passes
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | pass_from   | int     |
-- | time_stamp  | varchar |
-- | pass_to     | int     |
-- +-------------+---------+
-- (pass_from, time_stamp) is the unique key for this table.
-- pass_from is a foreign key to player_id from Teams table.
-- Each row represents a pass made during a match, time_stamp represents the time in minutes (00:00-90:00) when the pass was made,
-- pass_to is the player_id of the player receiving the pass.
-- Write a solution to find the longest successful pass streak for each team during the match. The rules are as follows:

-- A successful pass streak is defined as consecutive passes where:
-- Both the pass_from and pass_to players belong to the same team
-- A streak breaks when either:
-- The pass is intercepted (received by a player from the opposing team)
-- Return the result table ordered by team_name in ascending order.

-- Input:

-- Teams table:
-- +-----------+-----------+
-- | player_id | team_name |
-- +-----------+-----------+
-- | 1         | Arsenal   |
-- | 2         | Arsenal   |
-- | 3         | Arsenal   |
-- | 4         | Arsenal   |
-- | 5         | Chelsea   |
-- | 6         | Chelsea   |
-- | 7         | Chelsea   |
-- | 8         | Chelsea   |
-- +-----------+-----------+

-- Passes table:
-- +-----------+------------+---------+
-- | pass_from | time_stamp | pass_to |
-- +-----------+------------+---------+
-- | 1         | 00:05      | 2       |
-- | 2         | 00:07      | 3       |
-- | 3         | 00:08      | 4       |
-- | 4         | 00:10      | 5       |
-- | 6         | 00:15      | 7       |
-- | 7         | 00:17      | 8       |
-- | 8         | 00:20      | 6       |
-- | 6         | 00:22      | 5       |
-- | 1         | 00:25      | 2       |
-- | 2         | 00:27      | 3       |
-- +-----------+------------+---------+
-- Output:

-- +-----------+----------------+
-- | team_name | longest_streak |
-- +-----------+----------------+
-- | Arsenal   | 3              |
-- | Chelsea   | 4              |
-- +-----------+----------------+
-- Explanation:

-- Arsenal's streaks:
--   First streak: 3 passes (1 -> 2 -> 3 -> 4) ended when player 4 passed to Chelsea's player 5
--   Second streak: 2 passes (1 -> 2 -> 3)
--   Longest streak = 3
-- Chelsea's streaks:
--   First streak: 4 passes (6 -> 7 -> 8 -> 6 -> 5)
--   Longest streak = 4

USE practice;

DROP TABLE IF EXISTS Teams;

DROP TABLE IF EXISTS Passes;

CREATE TABLE Teams ( player_id INT, team_name VARCHAR(50) );

CREATE TABLE Passes (
    pass_from INT,
    time_stamp VARCHAR(5),
    pass_to INT
);

INSERT INTO
    Teams (player_id, team_name)
VALUES (1, 'Arsenal'),
    (2, 'Arsenal'),
    (3, 'Arsenal'),
    (4, 'Arsenal'),
    (5, 'Chelsea'),
    (6, 'Chelsea'),
    (7, 'Chelsea'),
    (8, 'Chelsea');

INSERT INTO
    Passes (
        pass_from,
        time_stamp,
        pass_to
    )
VALUES (1, '00:05', 2),
    (2, '00:07', 3),
    (3, '00:08', 4),
    (4, '00:10', 5),
    (6, '00:15', 7),
    (7, '00:17', 8),
    (8, '00:20', 6),
    (6, '00:22', 5),
    (1, '00:25', 2),
    (2, '00:27', 3);

WITH
    passes_with_team AS (
        SELECT
            p.time_stamp,
            CASE
                WHEN t_from.team_name = t_to.team_name THEN t_from.team_name
                ELSE NULL
            END AS success_team,
            ROW_NUMBER() OVER (
                ORDER BY p.time_stamp
            ) AS rn
        FROM
            Passes p
            JOIN Teams t_from ON p.pass_from = t_from.player_id
            JOIN Teams t_to ON p.pass_to = t_to.player_id
    ),
    streak_groups AS (
        SELECT success_team, rn, ROW_NUMBER() OVER (
                PARTITION BY
                    success_team
                ORDER BY time_stamp
            ) AS grp_rn
        FROM passes_with_team
        WHERE
            success_team IS NOT NULL
    ),
    islands AS (
        SELECT
            success_team,
            rn - grp_rn AS island_id,
            COUNT(*) AS streak_length
        FROM streak_groups
        GROUP BY
            success_team,
            rn - grp_rn
    )
SELECT
    success_team AS team_name,
    MAX(streak_length) AS longest_streak
FROM islands
GROUP BY
    success_team
ORDER BY team_name;