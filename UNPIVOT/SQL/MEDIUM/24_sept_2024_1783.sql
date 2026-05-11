-- 1783. Grand Slam Titles

-- Table: Players
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | player_id      | int     |
-- | player_name    | varchar |
-- +----------------+---------+
-- player_id is the primary key for this table.
-- Each row in this table contains the name and the ID of a tennis player.

-- Table: Championships
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | year          | int     |
-- | Wimbledon     | int     |
-- | Fr_open       | int     |
-- | US_open       | int     |
-- | Au_open       | int     |
-- +---------------+---------+
-- year is the primary key for this table.
-- Each row of this table containts the IDs of the players who won one each tennis tournament 
--of the grand slam.

-- Write an  SQL query to report the number of grand slam tournaments won by each player. 
--Do not include the players who did not win any tournament.
-- Return the result table in any order.
-- The query result format is in the following example:
-- Players table:
-- +-----------+-------------+
-- | player_id | player_name |
-- +-----------+-------------+
-- | 1         | Nadal       |
-- | 2         | Federer     |
-- | 3         | Novak       |
-- +-----------+-------------+
-- Championships table:
-- +------+-----------+---------+---------+---------+
-- | year | Wimbledon | Fr_open | US_open | Au_open |
-- +------+-----------+---------+---------+---------+
-- | 2018 | 1         | 1       | 1       | 1       |
-- | 2019 | 1         | 1       | 2       | 2       |
-- | 2020 | 2         | 1       | 2       | 2       |
-- +------+-----------+---------+---------+---------+

-- Result table:
-- +-----------+-------------+-------------------+
-- | player_id | player_name | grand_slams_count |
-- +-----------+-------------+-------------------+
-- | 2         | Federer     | 5                 |
-- | 1         | Nadal       | 7                 |
-- +-----------+-------------+-------------------+
-- Player 1 (Nadal) won 7 titles: Wimbledon (2018, 2019), Fr_open (2018, 2019, 2020),
-- US_open (2018), and Au_open (2018).
-- Player 2 (Federer) won 5 titles: Wimbledon (2020), US_open (2019, 2020), and Au_open (2019, 2020).
-- Player 3 (Novak) did not win anything, we did not include them in the result table.

-- Drop the tables if they already exist
DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Championships;

-- Create the Players table
CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(50)
);

-- Insert data into the Players table
INSERT INTO Players (player_id, player_name)
VALUES 
(1, 'Nadal'),
(2, 'Federer'),
(3, 'Novak');

-- Create the Championships table
CREATE TABLE Championships (
    year INT PRIMARY KEY,
    Wimbledon INT,
    Fr_open INT,
    US_open INT,
    Au_open INT
);

-- Insert data into the Championships table
INSERT INTO Championships (year, Wimbledon, Fr_open, US_open, Au_open)
VALUES 
(2018, 1, 1, 1, 1),
(2019, 1, 1, 2, 2),
(2020, 2, 1, 2, 2);

WITH cte as(
SELECT year,'Wimbledon' AS Championship,Wimbledon as player_id
FROM Championships
UNION 
SELECT year,'Fr_open' AS Championship,Fr_open as player_id
FROM Championships
UNION 
SELECT year,'US_open' AS Championship,US_open as player_id
FROM Championships
UNION 
SELECT year,'Au_open' AS Championship,Au_open as player_id
FROM Championships
),
cte2 as(
SELECT player_id,COUNT(player_id)  as grand_slams_count
FROM cte
GROUP BY 1)
SELECT c.player_id,p.player_name,grand_slams_count
FROM cte2 c
JOIN Players p
USING (player_id)

-------------------------------------------------------------------------------------------------------
-- m2 during practice
WITH mathces_won as(
SELECT year,'Wimbledon',CASE WHEN `Wimbledon` IS NOT NULL THEN Wimbledon  end as won
FROM championships
UNION ALL
SELECT year,'Fr_open', CASE WHEN `Fr_open` IS NOT NULL THEN Fr_open end
FROM championships
UNION ALL
SELECT year,'US_open',CASE WHEN `US_open` IS NOT NULL THEN US_open end
FROM championships
UNION ALL
SELECT year,'Au_open', CASE WHEN `Au_open` IS NOT NULL THEN Au_open end
FROM championships
)
SELECT player_id, player_name, COUNT(won) as grand_slams_count
FROM mathces_won c 
JOIN players p 
ON c.won = p.player_id
GROUP BY 1,2;

-------------------------------------------------------------------------------------------------------
-- m3
WITH win_info AS (  
    SELECT Wimbledon AS player_id
    FROM championships
    UNION ALL
    SELECT Fr_open
    FROM championships
    UNION ALL
    SELECT US_open
    FROM championships
    UNION ALL
    SELECT Au_open
    FROM championships
),
player_win_info AS (
SELECT
     player_id,
     COUNT(*) AS  grand_slams_count
FROM win_info
GROUP BY player_id
)
SELECT 
    pwi.player_id,
    p.player_name,
    pwi.grand_slams_count
FROM player_win_info pwi 
JOIN Players p 
ON p.player_id = pwi.player_id;