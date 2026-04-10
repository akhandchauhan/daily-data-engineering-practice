-- 1097. Game Play Analysis V 
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
-- Each row is a record of a player who logged in and played a number of 
-- games (possibly 0) before logging out on someday using some device.

-- The install date of a player is the first login day of that player.

-- We define day one retention of some date x to be the number of players whose 
-- install date is x and they logged back in on the day right after x, 
-- divided by the number of players whose install date is x, rounded to 2 decimal places.
-- Write a solution to report for each install date, the number of players that 
-- installed the game on that day, and the day one retention.
-- Return the result table in any order.
-- The resul1511t format is in the following example.
-- Input: 
-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-01 | 0            |
-- | 3         | 4         | 2016-07-03 | 5            |
-- +-----------+-----------+------------+--------------+

-- Output: 
-- +------------+----------+----------------+
-- | install_dt | installs | Day1_retention |
-- +------------+----------+----------------+
-- | 2016-03-01 | 2        | 0.50           |
-- | 2017-06-25 | 1        | 0.00           |
-- +------------+----------+----------------+
-- Explanation: 
-- Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back 
-- in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
-- Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 
-- so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00

DROP TABLE IF EXISTS Activity;
Create table If Not Exists Activity (
    player_id int, device_id int, event_date date, games_played int
);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values 
    ('1', '2', '2016-03-01', '5'), ('1', '2', '2016-03-02', '6'),
    ('2', '3', '2017-06-25', '1'),('3', '1', '2016-03-01', '0'),
    ('3', '4', '2018-07-03', '5');

-- Most elegant solution

WITH cte AS (
    SELECT 
        player_id,
        event_date,
        ROW_NUMBER() OVER (
            PARTITION BY player_id 
            ORDER BY event_date
        ) AS rnk,
        LEAD(event_date) OVER (
            PARTITION BY player_id 
            ORDER BY event_date
        ) AS next_date
    FROM Activity
)
SELECT 
    event_date AS install_dt,
    COUNT(*) AS installs,
    ROUND(
        SUM(next_date = DATE_ADD(event_date, INTERVAL 1 DAY)) / 
        COUNT(*),
        2
    ) AS Day1_retention
FROM cte
WHERE rnk = 1
GROUP BY event_date;

----------------------------------------------------------------------------------------
-- m1
WITH T AS (
        SELECT player_id, event_date, 
        MIN(event_date) OVER (PARTITION BY player_id) AS install_dt
        FROM Activity
    )
SELECT install_dt, 
       COUNT(DISTINCT player_id) AS installs,
       ROUND(
        COUNT(DISTINCT CASE 
            WHEN DATEDIFF(event_date, install_dt) = 1 
            THEN player_id 
        END) 
        / COUNT(DISTINCT player_id),
        2
    ) AS day1_retention 
FROM T
GROUP BY 1;

----------------------------------------------------------------------------------------
-- m2
WITH cte as (
    SELECT *, 
    LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) as nxt_day,
    MIN(event_date) OVER(PARTITION BY player_id) as install_dt
FROM Activity
)
SELECT install_dt,
COUNT(*) AS installs,
IFNULL(ROUND(
        SUM(nxt_day = DATE_ADD(install_dt, INTERVAL 1 DAY)) / COUNT(*),
        2
    ),0.00) AS Day1_retention
FROM cte
WHERE event_date = install_dt
GROUP BY install_dt;

----------------------------------------------------------------------------------------
--m3

WITH cte AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY player_id ORDER BY event_date) AS rnk,
           LEAD(event_date, 1) OVER (PARTITION BY player_id ORDER BY event_date) AS nxt_login
    FROM Activity
)
SELECT event_date AS install_dt,
       COUNT(*) AS installs,
       ROUND(SUM(CASE WHEN DATEDIFF(nxt_login, event_date) = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Day1_retention
FROM cte
WHERE rnk = 1
GROUP BY event_date;

----------------------------------------------------------------------------------------
-- m4
WITH cte as(
    SELECT *, 
        MIN(event_date) OVER(PARTITION BY player_id) as install_dt,
        DATE_ADD(event_date, interval 1 day) as nxt_dt,
        LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) as lead_day
    FROM Activity
),cte2 as(
    SELECT *
    FROM cte 
    WHERE event_date = install_dt and lead_day = nxt_dt
)
SELECT c.install_dt,COUNT(DISTINCT c.player_id) as installs,
SUM(IF(c.player_id = c2.player_id and c.event_date = c2.event_date,1,0))/COUNT(DISTINCT c.player_id) as Day1_retention
FROM cte c 
LEFT JOIN cte2 c2
ON c.player_id= c2.player_id
GROUP BY c.install_dt;

----------------------------------------------------------------------------------------
-- m5
WITH player_activity_ranked AS (
    SELECT
        player_id,
        event_date,
        ROW_NUMBER() OVER(
            PARTITION BY player_id
            ORDER BY event_date 
        ) AS activity_ranked
    FROM Activity
)
SELECT
        par.event_date AS install_dt,
        COUNT(par.player_id) AS installs,
        ROUND(COALESCE(
            COUNT(par.event_date)/
            NULLIF(COUNT(a.event_date),0)
        ,0),2) AS Day1_retention
FROM player_activity_ranked par
LEFT JOIN activity a 
ON par.player_id = a.player_id
AND DATE_ADD(par.event_date,interval 1 day) = a.event_date
WHERE par.activity_ranked = 1
GROUP BY par.event_date;