-- 1322. Ads Performance
-- Description
-- Table: Ads
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | ad_id         | int     |
-- | user_id       | int     |
-- | action        | enum    |
-- +---------------+---------+
-- (ad_id, user_id) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table contains the ID of an Ad, the ID of a user, and the action taken by this user 
-- regarding this Ad.
-- The action column is an ENUM (category) type of ('Clicked', 'Viewed', 'Ignored').
-- A company is running Ads and wants to calculate the performance of each Ad.
-- Performance of the Ad is measured using Click-Through Rate (CTR) where:
-- Write a solution to find the ctr of each Ad. Round ctr to two decimal points.
-- Return the result table ordered by ctr in descending order and by ad_id in ascending order
-- in case of a tie.

-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Ads table:
-- +-------+---------+---------+
-- | ad_id | user_id | action  |
-- +-------+---------+---------+
-- | 1     | 1       | Clicked |
-- | 2     | 2       | Clicked |
-- | 3     | 3       | Viewed  |
-- | 5     | 5       | Ignored |
-- | 1     | 7       | Ignored |
-- | 2     | 7       | Viewed  |
-- | 3     | 5       | Clicked |
-- | 1     | 4       | Viewed  |
-- | 2     | 11      | Viewed  |
-- | 1     | 2       | Clicked |
-- +-------+---------+---------+
-- Output: 
-- +-------+-------+
-- | ad_id | ctr   |
-- +-------+-------+
-- | 1     | 66.67 |
-- | 3     | 50.00 |
-- | 2     | 33.33 |
-- | 5     | 0.00  |
-- +-------+-------+
-- Explanation: 
-- for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
-- for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
-- for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
-- for ad_id = 5, ctr = 0.00, Note that ad_id = 5 has no clicks or views.
-- Note that we do not care about Ignored Ads.
DROP TABLE IF EXISTS ads;

CREATE TABLE Ads (
    ad_id INT,
    user_id INT,
    action ENUM('Clicked', 'Viewed', 'Ignored'),
    PRIMARY KEY (ad_id, user_id)
);

INSERT INTO Ads (ad_id, user_id, action) VALUES
(1, 1, 'Clicked'),
(2, 2, 'Clicked'),
(3, 3, 'Viewed'),
(5, 5, 'Ignored'),
(1, 7, 'Ignored'),
(2, 7, 'Viewed'),
(3, 5, 'Clicked'),
(1, 4, 'Viewed'),
(2, 11, 'Viewed'),
(1, 2, 'Clicked');

--method 1
SELECT ad_id,
    CASE WHEN SUM(IF(action = 'Clicked', 1, 0)) + SUM(IF(action = 'Viewed', 1, 0)) = 0 THEN ROUND(0, 2)
        ELSE ROUND(
            (SUM(IF(action = 'Clicked', 1, 0)) * 100.0) / 
            (SUM(IF(action = 'Clicked', 1, 0)) + SUM(IF(action = 'Viewed', 1, 0))), 2
        )END AS ctr
FROM Ads
GROUP BY ad_id
ORDER BY ctr DESC, ad_id ASC;

-----------------------------------------------------------------------------------------------------------
--method2
SELECT
    ad_id,
    ROUND(IFNULL(SUM(action = 'Clicked') / SUM(action IN ('Clicked', 'Viewed')) * 100, 0), 2) AS ctr
FROM Ads
GROUP BY 1
ORDER BY 2 DESC, 1;

-----------------------------------------------------------------------------------------------------------
--method 3

WITH cte AS (
    SELECT ad_id, 
        SUM(CASE WHEN action = 'Clicked' THEN 1 ELSE 0 END) AS Clicked, 
        SUM(CASE WHEN action = 'Viewed' THEN 1 ELSE 0 END) AS Viewed 
    FROM Ads
    GROUP BY ad_id
)
SELECT 
    ad_id, CASE 
        WHEN Clicked + Viewed = 0 THEN 0.00 
        ELSE ROUND((Clicked * 100.0) / (Clicked + Viewed), 2) END AS ctr
FROM cte
ORDER BY ctr DESC, ad_id;

-----------------------------------------------------------------------------------------------------------
-- m4:
SELECT ad_id,CASE WHEN SUM(action ='Clicked')+ SUM(action ='Viewed') =0 THEN 0.00
ELSE ROUND(SUM(action ='Clicked')*100/(SUM(action ='Clicked')+ SUM(action ='Viewed')),2) end as ctr
FROM Ads
GROUP BY ad_id
ORDER BY 2 DESC;

-----------------------------------------------------------------------------------------------------------
-- m5
SELECT ad_id,
       IFNULL(ROUND(COUNT(CASE WHEN action = 'Clicked' THEN 1 END) * 100.0/ 
       COUNT(CASE WHEN action IN ('Clicked','Viewed') THEN 1 END), 2), 0.0) as ctr 
FROM Ads 
GROUP BY ad_id
ORDER BY ctr DESC, ad_id;


-----------------------------------------------------------------------------------------------------------
-- m6 
WITH agg AS (
    SELECT
        ad_id,
        SUM(CASE WHEN action = 'Clicked' THEN 1 ELSE 0 END) AS clicks,
        SUM(CASE WHEN action = 'Viewed' THEN 1 ELSE 0 END) AS views
    FROM Ads
    GROUP BY ad_id
)
SELECT
    ad_id,
    ROUND(
        CASE WHEN clicks + views = 0
             THEN 0
             ELSE clicks * 100.0 / (clicks + views)
        END, 2
    ) AS ctr
FROM agg
ORDER BY ctr DESC, ad_id ASC;
