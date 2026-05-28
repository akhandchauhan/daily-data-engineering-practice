-- 1809. Ad-Free Sessions
-- SQL Schema
-- Table: Playback
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | session_id  | int  |
-- | customer_id | int  |
-- | start_time  | int  |
-- | end_time    | int  |
-- +-------------+------+
-- session_id is the primary key for this table.
-- customer_id is the ID of the customer watching this session.
-- The session runs during the inclusive interval between start_time and end_time.
-- It is guaranteed that start_time <= end_time and that two sessions for the same customer do not intersect.
-- Table: Ads
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | ad_id       | int  |
-- | customer_id | int  |
-- | timestamp   | int  |
-- +-------------+------+
-- ad_id is the primary key for this table.
-- customer_id is the ID of the customer viewing this ad.
-- timestamp is the moment of time at which the ad was shown.
-- Write an  SQL query to report all the sessions that did not get shown any ads.
-- Return the result table in any order.
-- The query result format is in the following example:
-- Playback table:
-- +------------+-------------+------------+----------+
-- | session_id | customer_id | start_time | end_time |
-- +------------+-------------+------------+----------+
-- | 1          | 1           | 1          | 5        |
-- | 2          | 1           | 15         | 23       |
-- | 3          | 2           | 10         | 12       |
-- | 4          | 2           | 17         | 28       |
-- | 5          | 2           | 2          | 8        |
-- +------------+-------------+------------+----------+
-- Ads table:
-- +-------+-------------+-----------+
-- | ad_id | customer_id | timestamp |
-- +-------+-------------+-----------+
-- | 1     | 1           | 5         |
-- | 2     | 2           | 15        |
-- | 3     | 2           | 20        |
-- +-------+-------------+-----------+

-- Result table:
-- +------------+
-- | session_id |
-- +------------+
-- | 2          |
-- | 3          |
-- | 5          |
-- +------------+
-- The ad with ID 1 was shown to user 1 at time 5 while they were in session 1.
-- The ad with ID 2 was shown to user 2 at time 15 while they were in session 4.
-- The ad with ID 3 was shown to user 2 at time 20 while they were in session 4.
-- We can see that sessions 1 and 4 had at least one ad. Sessions 2, 3, 
--and 5 did not have any ads, so we return them.

DROP TABLE Playback;
CREATE TABLE Playback (
    session_id INT PRIMARY KEY,
    customer_id INT,
    start_time INT,
    end_time INT
);
drop table Ads;
CREATE TABLE Ads (
    ad_id INT PRIMARY KEY,
    customer_id INT,
    timestamp INT
);
INSERT INTO Playback (session_id, customer_id, start_time, end_time) VALUES
(1, 1, 1, 5),
(2, 1, 15, 23),
(3, 2, 10, 12),
(4, 2, 17, 28),
(5, 2, 2, 8);
INSERT INTO Ads (ad_id, customer_id, timestamp) VALUES
(1, 1, 5),
(2, 2, 15),
(3, 2, 20);

-- m1
WITH cte as(
    SELECT DISTINCT session_id
FROM Playback p 
LEFT JOIN Ads a 
ON p.customer_id = a.customer_id
WHERE a.timestamp IS NULL OR  a.timestamp  BETWEEN start_time and end_time
)
SELECT session_id
FROM Playback
WHERE session_id NOT IN (select session_id FROM cte);

-----------------------------------------------------------------------------------------------------------
--method 2
SELECT session_id
FROM Playback p
LEFT JOIN Ads a
ON p.customer_id = a.customer_id
AND a.timestamp BETWEEN p.start_time AND p.end_time
WHERE a.customer_id IS NULL;


-----------------------------------------------------------------------------------------------------------
--m3

WITH user_ads AS (
    SELECT  p.session_id
    FROM Playback p   
    JOIN ads a   
    ON p.customer_id = a.customer_id
    AND a.timestamp between p.start_time and p.end_time
)
SELECT p.session_id
FROM Playback p
LEFT JOIN user_ads ua 
ON p.session_id = ua.session_id 
WHERE ua.session_id IS NULL;