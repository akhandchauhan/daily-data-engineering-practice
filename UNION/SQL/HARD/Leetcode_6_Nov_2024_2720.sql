-- 2720. Popularity Percentage
-- Description
-- Table: Friends
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | user1       | int  |
-- | user2       | int  |
-- +-------------+------+
-- (user1, user2) is the primary key (combination of unique values) of this table.
-- Each row contains information about friendship where user1 and user2 are friends.
-- Write a solution to find the popularity percentage for each user on Meta/Facebook.
-- The popularity percentage is defined as the total number of friends the user has
-- divided by the total number of users on the platform, then converted into a percentage
-- by multiplying by 100, rounded to 2 decimal places.
-- Return the result table ordered by user1 in ascending order.
-- Example 1:
-- Input:
-- Friends table:
-- +-------+-------+
-- | user1 | user2 |
-- +-------+-------+
-- | 2     | 1     |
-- | 1     | 3     |
-- | 4     | 1     |
-- | 1     | 5     |
-- | 1     | 6     |
-- | 2     | 6     |
-- | 7     | 2     |
-- | 8     | 3     |
-- | 3     | 9     |
-- +-------+-------+
-- Output:
-- +-------+-----------------------+
-- | user1 | percentage_popularity |
-- +-------+-----------------------+
-- | 1     | 55.56                 |
-- | 2     | 33.33                 |
-- | 3     | 33.33                 |
-- | 4     | 11.11                 |
-- | 5     | 11.11                 |
-- | 6     | 22.22                 |
-- | 7     | 11.11                 |
-- | 8     | 11.11                 |
-- | 9     | 11.11                 |
-- +-------+-----------------------+

DROP TABLE IF EXISTS Friends;
Create table if not exists Friends (user1 int, user2 int);
Truncate table Friends;
insert into Friends (user1, user2) values ('2', '1');
insert into Friends (user1, user2) values ('1', '3');
insert into Friends (user1, user2) values ('4', '1');
insert into Friends (user1, user2) values ('1', '5');
insert into Friends (user1, user2) values ('1', '6');
insert into Friends (user1, user2) values ('2', '6');
insert into Friends (user1, user2) values ('7', '2');
insert into Friends (user1, user2) values ('8', '3');
insert into Friends (user1, user2) values ('3', '9');

WITH cte AS (
    SELECT *
    FROM Friends
    UNION
    SELECT user2, user1
    FROM Friends
)
SELECT user1, ROUND(COUNT(user2) * 100 / (SELECT COUNT(DISTINCT user1) FROM cte), 2) AS percentage_popularity
FROM cte
GROUP BY user1
ORDER BY 1;
