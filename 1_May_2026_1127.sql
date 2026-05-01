-- 1127. User Purchase Platform
-- Table: Spending

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | spend_date  | date    |
-- | platform    | enum    |
-- | amount      | int     |
-- +-------------+---------+
-- The table logs the spendings history of users that make purchases from an online shopping
--  website which has a desktop and a mobile application.
-- (user_id, spend_date, platform) is the primary key of this table.
-- The platform column is an ENUM type of ('desktop', 'mobile').

-- Write an SQL query to find the total number of users and the total amount spent using 
-- mobile only, desktop only and both mobile and desktop together for each date.


-- The query result format is in the following example:

-- Spending table:
-- +---------+------------+----------+--------+
-- | user_id | spend_date | platform | amount |
-- +---------+------------+----------+--------+
-- | 1       | 2019-07-01 | mobile   | 100    |
-- | 1       | 2019-07-01 | desktop  | 100    |
-- | 2       | 2019-07-01 | mobile   | 100    |
-- | 2       | 2019-07-02 | mobile   | 100    |
-- | 3       | 2019-07-01 | desktop  | 100    |
-- | 3       | 2019-07-02 | desktop  | 100    |
-- +---------+------------+----------+--------+

-- Result table:
-- +------------+----------+--------------+-------------+
-- | spend_date | platform | total_amount | total_users |
-- +------------+----------+--------------+-------------+
-- | 2019-07-01 | desktop  | 100          | 1           |
-- | 2019-07-01 | mobile   | 100          | 1           |
-- | 2019-07-01 | both     | 200          | 1           |
-- | 2019-07-02 | desktop  | 100          | 1           |
-- | 2019-07-02 | mobile   | 100          | 1           |
-- | 2019-07-02 | both     | 0            | 0           |
-- +------------+----------+--------------+-------------+
-- On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using 
-- mobile only and user 3 purchased using desktop only.
-- On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only
--  and no one purchased using both platforms.


-- DROP TABLE
DROP TABLE IF EXISTS Spending;

-- CREATE TABLE
CREATE TABLE Spending (
    user_id INT,
    spend_date DATE,
    platform ENUM('desktop', 'mobile'),
    amount INT,
    PRIMARY KEY (user_id, spend_date, platform)
);

-- INSERT DATA
INSERT INTO Spending (user_id, spend_date, platform, amount) VALUES
(1, '2019-07-01', 'mobile', 100),
(1, '2019-07-01', 'desktop', 100),
(2, '2019-07-01', 'mobile', 100),
(2, '2019-07-02', 'mobile', 100),
(3, '2019-07-01', 'desktop', 100),
(3, '2019-07-02', 'desktop', 100);

-- m1
WITH  date_create_cte AS (
    -- SELECT  - Wrong approach
    --     MIN(spend_date) AS start_date,
    --     MAX(spend_date) AS end_date
    -- FROM Spending
    -- UNION ALL
    -- SELECT 
    --     DATE_ADD(start_date,INTERVAL 1 DAY) AS start_date,
    --     end_date
    -- FROM date_create_cte
    -- WHERE start_date < end_date
    SELECT DISTINCT spend_date AS start_date
    FROM Spending
),
all_platform AS (
    SELECT 'both' AS platform
    UNION 
    SELECT 'mobile'
    UNION
    SELECT 'desktop'
),
user_platform_info AS (
    SELECT
            user_id,
            spend_date,
            SUM(CASE WHEN platform = 'mobile' THEN 1 ELSE 0 END) AS mobile_platform_count,
            SUM(CASE WHEN platform = 'desktop' THEN 1 ELSE 0 END) AS desktop_platform_count,
            SUM(CASE WHEN platform = 'mobile' THEN amount ELSE 0 END) AS mobile_amount,
            SUM(CASE WHEN platform = 'desktop' THEN amount ELSE 0 END) AS desktop_amount
    FROM Spending
    GROUP BY user_id,
            spend_date
),
agg_platform_info AS (
    SELECT 
        spend_date,
        CASE 
            WHEN mobile_platform_count = 1 AND desktop_platform_count = 1 THEN 'both'
            WHEN mobile_platform_count = 1 AND desktop_platform_count = 0 THEN 'mobile'
            WHEN mobile_platform_count = 0 AND desktop_platform_count = 1 THEN 'desktop'
        END AS platform,
        SUM(
            CASE 
            WHEN mobile_platform_count = 1 AND desktop_platform_count = 1 THEN mobile_amount + desktop_amount
            WHEN mobile_platform_count = 1 AND desktop_platform_count = 0 THEN mobile_amount
            WHEN mobile_platform_count = 0 AND desktop_platform_count = 1 THEN desktop_amount
        END
        ) AS total_amount,
        SUM(
            CASE 
            WHEN mobile_platform_count = 1 AND desktop_platform_count = 1 THEN 1 
            WHEN mobile_platform_count = 1 AND desktop_platform_count = 0 THEN 1
            WHEN mobile_platform_count = 0 AND desktop_platform_count = 1 THEN 1
            ELSE 0
        END
        ) AS total_users
    FROM user_platform_info
    GROUP BY spend_date,
            platform
)
SELECT 
        dcc.start_date AS spend_date,
        ap.platform,
        COALESCE(api.total_amount, 0) AS total_amount,
        COALESCE(api.total_users, 0 ) AS total_users
FROM date_create_cte  dcc
CROSS JOIN all_platform ap 
LEFT JOIN agg_platform_info api
ON dcc.start_date = api.spend_date
AND ap.platform = api.platform
ORDER BY dcc.start_date
;

------------------------------------------------------------------------------------------------
-- m2
WITH user_day AS (
    SELECT 
        user_id,
        spend_date,
        SUM(CASE WHEN platform = 'mobile' THEN amount ELSE 0 END) AS mobile_amt,
        SUM(CASE WHEN platform = 'desktop' THEN amount ELSE 0 END) AS desktop_amt
    FROM Spending
    GROUP BY user_id, spend_date
)
SELECT 
    spend_date,
    'mobile' AS platform,
    SUM(CASE WHEN mobile_amt > 0 AND desktop_amt = 0 THEN mobile_amt ELSE 0 END) AS total_amount,
    SUM(CASE WHEN mobile_amt > 0 AND desktop_amt = 0 THEN 1 ELSE 0 END) AS total_users
FROM user_day
GROUP BY spend_date

UNION ALL

SELECT 
    spend_date,
    'desktop',
    SUM(CASE WHEN desktop_amt > 0 AND mobile_amt = 0 THEN desktop_amt ELSE 0 END),
    SUM(CASE WHEN desktop_amt > 0 AND mobile_amt = 0 THEN 1 ELSE 0 END)
FROM user_day
GROUP BY spend_date

UNION ALL

SELECT 
    spend_date,
    'both',
    SUM(CASE WHEN mobile_amt > 0 AND desktop_amt > 0 THEN mobile_amt + desktop_amt ELSE 0 END),
    SUM(CASE WHEN mobile_amt > 0 AND desktop_amt > 0 THEN 1 ELSE 0 END)
FROM user_day
GROUP BY spend_date;