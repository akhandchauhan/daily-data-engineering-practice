-- 1194. Tournament Winners
-- Table: Players
-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | player_id   | int   |
-- | group_id    | int   |
-- +-------------+-------+
-- player_id is the primary key of this table.
-- Each row of this table indicates the group of each player.
-- Table: Matches
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | match_id      | int     |
-- | first_player  | int     |
-- | second_player | int     |
-- | first_score   | int     |
-- | second_score  | int     |
-- +---------------+---------+
-- match_id is the primary key of this table.
-- Each row is a record of a match, first_player and second_player contain the 
-- player_id of each match.
-- first_score and second_score contain the number of points of the first_player 
-- and second_player respectively.
-- You may assume that, in each match, players belongs to the same group.

-- The winner in each group is the player who scored the maximum total points 
-- within the group.
-- In the case of a tie, the lowest player_id wins.
-- Write an  SQL query to find the winner in each group.
-- Players table:
-- +-----------+------------+
-- | player_id | group_id   |
-- +-----------+------------+
-- | 15        | 1          |
-- | 25        | 1          |
-- | 30        | 1          |
-- | 45        | 1          |
-- | 10        | 2          |
-- | 35        | 2          |
-- | 50        | 2          |
-- | 20        | 3          |
-- | 40        | 3          |
-- +-----------+------------+
-- Matches table:
-- +------------+--------------+---------------+-------------+--------------+
-- | match_id   | first_player | second_player | first_score | second_score |
-- +------------+--------------+---------------+-------------+--------------+
-- | 1          | 15           | 45            | 3           | 0            |
-- | 2          | 30           | 25            | 1           | 2            |
-- | 3          | 30           | 15            | 2           | 0            |
-- | 4          | 40           | 20            | 5           | 2            |
-- | 5          | 35           | 50            | 1           | 1            |
-- +------------+--------------+---------------+-------------+--------------+
-- Result table:
-- +-----------+------------+
-- | group_id  | player_id  |
-- +-----------+------------+
-- | 1         | 15         |
-- | 2         | 35         |
-- | 3         | 40         |
-- +-----------+------------+
DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Matches;
Create table If Not Exists Players (player_id int, group_id int);
Create table If Not Exists Matches (match_id int, first_player int, second_player int, first_score int, second_score int);
Truncate table Players;
INSERT INTO Players (player_id, group_id) VALUES
('10', '2'),
('15', '1'),
('20', '3'),
('25', '1'),
('30', '1'),
('35', '2'),
('40', '3'),
('45', '1'),
('50', '2');

Truncate table Matches;
INSERT INTO Matches (match_id, first_player, second_player, first_score, second_score) VALUES
('1', '15', '45', '3', '0'),
('2', '30', '25', '1', '2'),
('3', '30', '15', '2', '0'),
('4', '40', '20', '5', '2'),
('5', '35', '50', '1', '1');

-- m1
WITH cte as(
    SELECT p.group_id, p.player_id, 
    SUM(IF(p.player_id = m.first_player,m.first_score, IF(p.player_id = m.second_player,m.second_score,NULL))) AS total_score
    FROM  Matches m
    LEFT JOIN Players p
    ON p.player_id = m.first_player 
    or p.player_id = m.second_player
    GROUP BY 1, 2
), ranked_cte AS (
    SELECT *, ROW_NUMBER() OVER(
            PARTITION BY group_id 
            ORDER BY total_score DESC,
            player_id 
        ) as rnk
    FROM cte
)
SELECT group_id,
       player_id
FROM ranked_cte
WHERE rnk = 1;

------------------------------------------------------------------------------------------
-- m2
WITH cte as(
    SELECT first_player as player_id, first_score as score
FROM matches 
UNION ALL
SELECT second_player, second_score 
FROM matches
),cte2 as(
SELECT p.player_id,group_id,SUM(score) OVER(PARTITION BY player_id )as sum_score
FROM players p 
LEFT JOIN cte c 
ON p.player_id = c.player_id
),cte3 as(
SELECT group_id,player_id,row_number() over(PARTITION BY group_id ORDER BY sum_score desc, player_id) as rnk
FROM cte2
)
SELECT group_id, player_id
FROM cte3
WHERE rnk = 1;


------------------------------------------------------------------------------------------
--m3

-- Every player in the Players table must be considered; if they didn’t play any match,
--  their total score is 0, not “excluded.”

-- Group 1:
-- Player 1 → 0 matches → score = 0
-- Player 2 → 1 match → score = 0

-- 👉 Tie → smallest player_id wins
-- 👉 Winner = Player 1 (who played ZERO matches)
WITH match_info AS (
    SELECT match_id,
        first_player AS player_id,
        first_score AS score
    FROM Matches 
    UNION ALL
    SELECT match_id,
        second_player AS player_id,
        second_score AS score
    FROM Matches
),
player_ranked AS (
SELECT 
        p.group_id,
        p.player_id,
        ROW_NUMBER() OVER(
            PARTITION BY p.group_id 
            ORDER BY COALESCE(SUM(mi.score),0) DESC,
                    p.player_id) AS player_rank
FROM Players p 
LEFT JOIN match_info mi 
ON p.player_id = mi.player_id 
GROUP BY 
    p.group_id,
    p.player_id
)
SELECT 
    group_id,
    player_id
FROM player_ranked
WHERE player_rank = 1;