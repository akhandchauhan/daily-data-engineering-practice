-- 1951. All the Pairs With the Maximum Number of Common Followers
-- Level: Medium
-- Description
-- Table: Relations
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | user_id     | int  |
-- | follower_id | int  |
-- +-------------+------+
-- (user_id, follower_id) is the primary key for this table.
-- Each row of this table indicates that the user with ID follower_id is following the user with ID user_id.
-- Write an SQL query to find all the pairs of users with the maximum number of common followers.
-- In other words, if the maximum number of common followers between any two users is maxCommon,
-- then you have to return all pairs of users that have maxCommon common followers.
-- The result table should contain the pairs user1_id and user2_id where user1_id < user2_id.
-- Return the result table in any order.
-- The query result format is in the following example:
-- Relations table:
-- +---------+-------------+
-- | user_id | follower_id |
-- +---------+-------------+
-- | 1       | 3           |
-- | 2       | 3           |
-- | 7       | 3           |
-- | 1       | 4           |
-- | 2       | 4           |
-- | 7       | 4           |
-- | 1       | 5           |
-- | 2       | 6           |
-- | 7       | 5           |
-- +---------+-------------+
-- Result table:
-- +----------+----------+
-- | user1_id | user2_id |
-- +----------+----------+
-- | 1        | 7        |
-- +----------+----------+
-- Users 1 and 2 have 2 common followers (3 and 4).
-- Users 1 and 7 have 3 common followers (3, 4, and 5).
-- Users 2 and 7 have 2 common followers (3 and 4).
-- Since the maximum number of common followers between any two users is 3, we return all pairs
-- of users with 3 common followers, which is only the pair (1, 7).

Create table If Not Exists Relations (user_id int, follower_id int);
Truncate table Relations;
insert into Relations (user_id, follower_id) values ('1', '3');
insert into Relations (user_id, follower_id) values ('2', '3');
insert into Relations (user_id, follower_id) values ('7', '3');
insert into Relations (user_id, follower_id) values ('1', '4');
insert into Relations (user_id, follower_id) values ('2', '4');
insert into Relations (user_id, follower_id) values ('7', '4');
insert into Relations (user_id, follower_id) values ('1', '5');
insert into Relations (user_id, follower_id) values ('2', '6');
insert into Relations (user_id, follower_id) values ('7', '5');

WITH r AS (
    SELECT r1.user_id AS user1_id, r2.user_id AS user2_id, COUNT(*) AS cnt
    FROM Relations r1
    JOIN Relations r2
    USING (follower_id)
    WHERE r1.user_id < r2.user_id
    GROUP BY r1.user_id, r2.user_id
)
SELECT user1_id, user2_id
FROM r
WHERE cnt = (SELECT MAX(cnt) FROM r);
