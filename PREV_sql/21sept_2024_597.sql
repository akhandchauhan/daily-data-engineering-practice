-- 597. Friend Requests I Overall Acceptance Rate
-- Description
-- Table: FriendRequest
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | sender_id      | int     |
-- | send_to_id     | int     |
-- | request_date   | date    |
-- +----------------+---------+
-- This table may contain duplicates (In other words, there is no primary key for this table in SQL).
-- This table contains the ID of the user who sent the request, the ID of the user who received the request,
-- and the date of the request.
-- Table: RequestAccepted
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | requester_id   | int     |
-- | accepter_id    | int     |
-- | accept_date    | date    |
-- +----------------+---------+
-- This table may contain duplicates (In other words, there is no primary key for this table in SQL).
-- This table contains the ID of the user who sent the request, the ID of the user who received the request,
-- and the date when the request was accepted.
-- Find the overall acceptance rate of requests, which is the number of acceptance divided by the number of
-- requests. Return the answer rounded to 2 decimals places.
-- Note that:
-- The accepted requests are not necessarily from the table friend_request. In this case, Count the total
-- accepted requests (no matter whether they are in the original requests), and divide it by the number of]
-- requests to get the acceptance rate.
-- It is possible that a sender sends multiple requests to the same receiver, and a request could be 
--accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once.
-- If there are no requests at all, you should return 0.00 as the accept_rate.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- FriendRequest table:
-- +-----------+------------+--------------+
-- | sender_id | send_to_id | request_date |
-- +-----------+------------+--------------+
-- | 1         | 2          | 2016/06/01   |
-- | 1         | 3          | 2016/06/01   |
-- | 1         | 4          | 2016/06/01   |
-- | 2         | 3          | 2016/06/02   |
-- | 3         | 4          | 2016/06/09   |
-- +-----------+------------+--------------+
-- RequestAccepted table:
-- +--------------+-------------+-------------+
-- | requester_id | accepter_id | accept_date |
-- +--------------+-------------+-------------+
-- | 1            | 2           | 2016/06/03  |
-- | 1            | 3           | 2016/06/08  |
-- | 2            | 3           | 2016/06/08  |
-- | 3            | 4           | 2016/06/09  |
-- | 3            | 4           | 2016/06/10  |
-- +--------------+-------------+-------------+
-- Output: 
-- +-------------+
-- | accept_rate |
-- +-------------+
-- | 0.8         |
-- +-------------+
-- Explanation: 
-- There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80.
-- Follow up:
-- Could you find the acceptance rate for every month?
-- Could you find the cumulative acceptance rate for every day?

DROP TABLE requestaccepted;
DROP TABLE FriendRequest;
-- Create FriendRequest table
CREATE TABLE IF NOT EXISTS FriendRequest (
    sender_id INT,
    send_to_id INT,
    request_date DATE
);

-- Insert data into FriendRequest table
INSERT INTO FriendRequest (sender_id, send_to_id, request_date) VALUES
(1, 2, '2016-06-01'),
(1, 3, '2016-06-01'),
(1, 4, '2016-06-01'),
(2, 3, '2016-06-02'),
(3, 4, '2016-06-09');

-- Create RequestAccepted table
CREATE TABLE IF NOT EXISTS RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);

-- Insert data into RequestAccepted table
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09'),
(3, 4, '2016-06-10');

SELECT
    ROUND(IFNULL((SELECT COUNT(DISTINCT requester_id, accepter_id) FROM RequestAccepted) / 
        (SELECT COUNT(DISTINCT sender_id, send_to_id) FROM FriendRequest),0),2) AS accept_rate;


-- m2
WITH cte as(
    SELECT requester_id,accepter_id,MONTH(accept_date) as mth
FROM requestaccepted
GROUP BY requester_id, accepter_id,MONTH(accept_date) 
)
SELECT COUNT(requester_id)/(SELECT COUNT(sender_id) FROM FriendRequest  ) as accept_rate
FROM cte;

-- m3
WITH cte as(
    SELECT requester_id,accepter_id,MONTH(accept_date) as mth
FROM requestaccepted
GROUP BY requester_id, accepter_id,MONTH(accept_date) 
),cte2 as(
SELECT mth,COUNT(requester_id) as cnt
FROM cte
GROUP BY mth
)
SELECT cnt/(SELECT COUNT(sender_id) FROM FriendRequest  ) as accept_rate
FROM cte2;
