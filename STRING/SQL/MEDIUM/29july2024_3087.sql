-- 3087. Find Trending Hashtags
-- Description
-- Table: Tweets
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | tweet_id    | int     |
-- | tweet_date  | date    |
-- | tweet       | varchar |
-- +-------------+---------+
-- tweet_id is the primary key (column with unique values) for this table.
-- Each row of this table contains user_id, tweet_id, tweet_date and tweet.
-- Write a solution to find the top 3 trending hashtags in February 2024.
-- Each tweet only contains one hashtag.
-- Return the result table ordered by count of hashtag, hashtag in descending order.
-- The result format is in the following example.
-- Example 1:
-- Input:
-- Tweets table:
-- +---------+----------+----------------------------------------------+------------+
-- | user_id | tweet_id | tweet                                        | tweet_date |
-- +---------+----------+----------------------------------------------+------------+
-- | 135     | 13       | Enjoying a great start to the day! #HappyDay | 2024-02-01 |
-- | 136     | 14       | Another #HappyDay with good vibes!           | 2024-02-03 |
-- | 137     | 15       | Productivity peaks! #WorkLife                | 2024-02-04 |
-- | 138     | 16       | Exploring new tech frontiers. #TechLife      | 2024-02-04 |
-- | 139     | 17       | Gratitude for today's moments. #HappyDay     | 2024-02-05 |
-- | 140     | 18       | Innovation drives us. #TechLife              | 2024-02-07 |
-- | 141     | 19       | Connecting with nature's serenity. #Nature   | 2024-02-09 |
-- +---------+----------+----------------------------------------------+------------+
-- Output:
-- +-----------+--------------+
-- | hashtag   | hashtag_count|
-- +-----------+--------------+
-- | #HappyDay | 3            |
-- | #TechLife | 2            |
-- | #WorkLife | 1            |
-- +-----------+--------------+

drop table Tweets;
Create table If Not Exists Tweets (user_id int, tweet_id int, tweet_date date, tweet varchar(100));
Truncate table Tweets;
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values ('135', '13', 'Enjoying a great start to the day. #HappyDay', '2024-02-01');
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values ('136', '14', 'Another #HappyDay with good ', '2024-02-03');
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values ('137', '15', 'Productivity peaks! #WorkLife', '2024-02-04');
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values ('138', '16', 'Exploring new tech frontiers. #TechLife', '2024-02-04');
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values ('139', '17', "Gratitude for today's moments. #HappyDay", '2024-02-05');
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values ('140', '18', 'Innovation drives us. #TechLife', '2024-02-07');
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values ('141', '19', "Connecting with nature's serenity. #Nature", '2024-02-09');

SELECT REGEXP_SUBSTR(tweet,'#[a-zA-Z0-9]+') as hashtag, COUNT(*) AS hashtag_count
FROM Tweets
WHERE DATE_FORMAT(tweet_date,'%Y-%m') ='2024-02'
GROUP BY 1
ORDER BY 2 DESC, 1 DESC
LIMIT 3;
