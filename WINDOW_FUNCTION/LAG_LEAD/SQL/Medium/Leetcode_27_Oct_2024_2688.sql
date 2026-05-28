-- 2688. Find Active Users
-- Description
-- Table: Users
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | user_id     | int      |
-- | item        | varchar  |
-- | created_at  | datetime |
-- | amount      | int      |
-- +-------------+----------+
-- This table may contain duplicate records.
-- Each row includes the user ID, the purchased item, the date of purchase, and the purchase amount.
-- Write a solution to identify active users. An active user is a user that has
-- made a second purchase within 7 days of any other of their purchases.
-- Return a list of user_id which denotes the list of active users in any order.
-- Input:
-- Users table:
-- +---------+-------------------+------------+--------+
-- | user_id | item              | created_at | amount |
-- +---------+-------------------+------------+--------+
-- | 5       | Smart Crock Pot   | 2021-09-18 | 698882 |
-- | 6       | Smart Lock        | 2021-09-14 | 11487  |
-- | 6       | Smart Thermostat  | 2021-09-10 | 674762 |
-- | 8       | Smart Light Strip | 2021-09-29 | 630773 |
-- | 4       | Smart Cat Feeder  | 2021-09-02 | 693545 |
-- | 4       | Smart Bed         | 2021-09-13 | 170249 |
-- +---------+-------------------+------------+--------+
-- Output:
-- +---------+
-- | user_id |
-- +---------+
-- | 6       |
-- +---------+
-- Explanation:
-- - User with user_id 5 has only one transaction, so he is not an active user.
-- - User with user_id 6 has two transactions; first on 2021-09-10, second on 2021-09-14.
--   The distance between them is <= 7 days, so he is an active user.
-- - User with user_id 8 has only one transaction, so he is not an active user.
-- - User with user_id 4 has two transactions; first on 2021-09-02, second on 2021-09-13.
--   The distance is > 7 days, so he is not an active user.

DROP TABLE Users;
Create table If Not Exists Users (user_id int, item varchar(100), created_at date, amount int);
Truncate table Users;
insert into Users (user_id, item, created_at, amount) values ('5', 'Smart Crock Pot', '2021-09-18', '698882');
insert into Users (user_id, item, created_at, amount) values ('6', 'Smart Lock', '2021-09-14', '11487');
insert into Users (user_id, item, created_at, amount) values ('6', 'Smart Thermostat', '2021-09-10', '674762');
insert into Users (user_id, item, created_at, amount) values ('8', 'Smart Light Strip', '2021-09-29', '630773');
insert into Users (user_id, item, created_at, amount) values ('4', 'Smart Cat Feeder', '2021-09-02', '693545');
insert into Users (user_id, item, created_at, amount) values ('4', 'Smart Bed', '2021-09-13', '170249');

WITH cte AS (
    SELECT *, LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at) AS nxt
    FROM Users
)
SELECT DISTINCT user_id
FROM cte
WHERE DATEDIFF(nxt, created_at) <= 7;
