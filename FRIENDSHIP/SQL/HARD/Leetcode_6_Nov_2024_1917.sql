-- 1917. Leetcodify Friends Recommendations
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
-- Write an SQL query to recommend friends to Leetcodify users. We recommend user x to user y if:
-- Users x and y are not friends, and
-- Users x and y listened to the same three or more different songs on the same day.
-- Friend recommendations are unidirectional. The result should not contain duplicates.
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
-- +---------+---------+------------+
-- Friendship table:
-- +----------+----------+
-- | user1_id | user2_id |
-- +----------+----------+
-- | 1        | 2        |
-- +----------+----------+
-- Result table:
-- +---------+----------------+
-- | user_id | recommended_id |
-- +---------+----------------+
-- | 1       | 3              |
-- | 2       | 3              |
-- | 3       | 1              |
-- | 3       | 2              |
-- +---------+----------------+

WITH cte AS (
    SELECT l1.user_id AS user1_id, l2.user_id AS user2_id
    FROM Listens AS l1
    LEFT JOIN Listens AS l2
    ON l1.song_id = l2.song_id
    AND l1.day = l2.day
    AND l1.user_id <> l2.user_id
    GROUP BY l1.user_id, l2.user_id, l1.day
    HAVING COUNT(DISTINCT l2.song_id) >= 3
)
SELECT DISTINCT cte.user1_id AS user_id, cte.user2_id AS recommended_id
FROM cte
LEFT JOIN Friendship f
ON ((cte.user1_id = f.user1_id AND cte.user2_id = f.user2_id)
    OR (cte.user1_id = f.user2_id AND cte.user2_id = f.user1_id))
WHERE f.user1_id IS NULL;
