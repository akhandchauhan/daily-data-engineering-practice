-- 1919. Leetcodify Similar Friends
-- Hard
-- Description
-- Table: Listens
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | song_id     | int     |
-- | day         | date    |
-- +-------------+---------+
-- There is no primary key for this table. It may contain duplicates.
-- Each row indicates that the user user_id listened to the song song_id on the day day.
-- Table: Friendship
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user1_id      | int     |
-- | user2_id      | int     |
-- +---------------+---------+
-- (user1_id, user2_id) is the primary key for this table.
-- Each row indicates that the users user1_id and user2_id are friends.
-- Note that user1_id < user2_id.
-- Write an SQL query to report the similar friends of Leetcodify users. A user x and user y are similar friends if:
-- Users x and y are friends, and
-- Users x and y listened to the same three or more different songs on the same day.
-- Return the result table in any order. Return the similar pairs with user1_id < user2_id.
-- Listens table:
-- +---------+---------+------------+
-- | user_id | song_id | day        |
-- +---------+---------+------------+
-- | 1       | 10      | 2021-03-15 |
-- | 1       | 11      | 2021-03-15 |
-- | 1       | 12      | 2021-03-15 |
-- | 2       | 10      | 2021-03-15 |
-- | 2       | 11      | 2021-03-15 |
-- | 2       | 12      | 2021-03-15 |
-- | 3       | 10      | 2021-03-15 |
-- | 3       | 11      | 2021-03-15 |
-- | 3       | 12      | 2021-03-15 |
-- | 4       | 10      | 2021-03-15 |
-- | 4       | 11      | 2021-03-15 |
-- | 4       | 13      | 2021-03-15 |
-- | 5       | 10      | 2021-03-16 |
-- | 5       | 11      | 2021-03-16 |
-- | 5       | 12      | 2021-03-16 |
-- +---------+---------+------------+
-- Friendship table:
-- +----------+----------+
-- | user1_id | user2_id |
-- +----------+----------+
-- | 1        | 2        |
-- | 2        | 4        |
-- | 2        | 5        |
-- +----------+----------+
-- Result table:
-- +----------+----------+
-- | user1_id | user2_id |
-- +----------+----------+
-- | 1        | 2        |
-- +----------+----------+
-- Users 1 and 2 are friends, and they listened to songs 10, 11, and 12 on the same day.
-- Users 2 and 4 are friends, but they did not listen to the same three different songs.
-- Users 2 and 5 are friends but did not listen to them on the same day.

DROP TABLE IF EXISTS Listens;
DROP TABLE IF EXISTS Friendship;
Create table If Not Exists Listens (user_id int, song_id int, day date);
Create table If Not Exists Friendship (user1_id int, user2_id int);
Truncate table Listens;
insert into Listens (user_id, song_id, day) values ('1', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('1', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('1', '12', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('2', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('2', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('2', '12', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('3', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('3', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('3', '12', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('4', '10', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('4', '11', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('4', '13', '2021-03-15');
insert into Listens (user_id, song_id, day) values ('5', '10', '2021-03-16');
insert into Listens (user_id, song_id, day) values ('5', '11', '2021-03-16');
insert into Listens (user_id, song_id, day) values ('5', '12', '2021-03-16');
Truncate table Friendship;
insert into Friendship (user1_id, user2_id) values ('1', '2');
insert into Friendship (user1_id, user2_id) values ('2', '4');
insert into Friendship (user1_id, user2_id) values ('2', '5');

WITH cte AS (
    SELECT l1.user_id AS user1_id, l2.user_id AS user2_id
    FROM Listens AS l1
    LEFT JOIN Listens AS l2
    ON l1.song_id = l2.song_id
    AND l1.day = l2.day
    AND l1.user_id <> l2.user_id
    GROUP BY l1.user_id, l2.user_id, l1.day
    HAVING COUNT(DISTINCT l1.song_id) >= 3
)
SELECT DISTINCT user1_id, user2_id
FROM cte
WHERE (user1_id, user2_id) IN (SELECT * FROM Friendship)
AND user1_id < user2_id;
