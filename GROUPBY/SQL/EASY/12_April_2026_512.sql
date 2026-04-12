-- 512. Game Play Analysis II
-- Description
-- Table: Activity
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key (combination of columns with unique 
-- values) of this table.
-- This table shows the activity of players of some games.
-- Each row is a record of a player who logged in and played a number of games
-- (possibly 0) before logging out on someday using some device.
 
-- Write a solution to report the device that is first logged in for each player.
-- Return the result table in any order.

-- Input: 
-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-05-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-02 | 0            |
-- | 3         | 4         | 2018-07-03 | 5            |
-- +-----------+-----------+------------+--------------+
-- Output: 
-- +-----------+-----------+
-- | player_id | device_id |
-- +-----------+-----------+
-- | 1         | 2         |
-- | 2         | 3         |
-- | 3         | 1         |
-- +-----------+-----------+

-- Drop table if exists
DROP TABLE IF EXISTS Activity;

-- Create table
CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT
);

-- Insert data
INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);


-- m1 
WITH first_event_info AS (
    SELECT 
            player_id,
            device_id,
            event_date,
            MIN(event_date) OVER(PARTITION BY player_id) AS min_event_date
    FROM Activity
)
SELECT 
    player_id,
    device_id
FROM first_event_info
WHERE event_date = min_event_date;

---------------------------------------------------------------------------------------
-- m2

WITH first_event_info AS (
    SELECT 
            player_id,
            MIN(event_date) AS min_event_date
    FROM Activity
    GROUP BY player_id
)
SELECT 
    a.player_id,
    a.device_id
FROM Activity a 
JOIN first_event_info fei 
ON a.player_id = fei.player_id
AND a.event_date = fei.min_event_date;

---------------------------------------------------------------------------------------
-- m3

WITH first_event_info AS (
    SELECT 
            player_id,
            device_id,
            ROW_NUMBER() OVER(
                PARTITION BY player_id
                ORDER BY event_date) AS player_ranked
    FROM Activity
)
SELECT 
    player_id,
    device_id
FROM first_event_info
WHERE player_ranked = 1;
