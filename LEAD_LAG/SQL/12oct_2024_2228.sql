-- 2228. Users With Two Purchases Within Seven Days
-- Description
-- Table: Purchases
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | purchase_id   | int  |
-- | user_id       | int  |
-- | purchase_date | date |
-- +---------------+------+
-- purchase_id is the primary key for this table.
-- This table contains logs of the dates that users purchased from a certain retailer
-- Write an  SQL query to report the IDs of the users that made any two purchases at most 7 days apart.
-- Return the result table ordered by user_id. 
-- Purchases table:
-- +-------------+---------+---------------+
-- | purchase_id | user_id | purchase_date |
-- +-------------+---------+---------------+
-- | 4           | 2       | 2022-03-13    |
-- | 1           | 5       | 2022-02-11    |
-- | 3           | 7       | 2022-06-19    |
-- | 6           | 2       | 2022-03-20    |
-- | 5           | 7       | 2022-06-19    |
-- | 2           | 2       | 2022-06-08    |
-- +-------------+---------+---------------+
-- Output: 
-- +---------+
-- | user_id |
-- +---------+
-- | 2       |
-- | 7       |
-- +---------+
-- Explanation: 
-- User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the 
--second purchase is within 7 days of the first purchase, we add their ID.
-- User 5 had only 1 purchase.
-- User 7 had two purchases on the same day so we add their ID.

drop table Purchases;
CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    purchase_date DATE
);
INSERT INTO Purchases (purchase_id, user_id, purchase_date) VALUES
(4, 2, '2022-03-13'),
(1, 5, '2022-02-11'),
(3, 7, '2022-06-19'),
(6, 2, '2022-03-20'),
(5, 7, '2022-06-19'),
(2, 2, '2022-06-08');


-- m1 using lead
WITH purchase_info AS (
    SELECT user_id,
        purchase_date,
        LEAD(purchase_date) OVER(PARTITION BY user_id ORDER BY purchase_date) AS next_purchase_date
    FROM Purchases
)
SELECT DISTINCT user_id
FROM Purchase_info
WHERE DATEDIFF(next_purchase_date, purchase_date) <= 7
ORDER BY user_id ;

---------------------------------------------------------------------------------------------------------------------------------
-- m2 using non equi join

SELECT DISTINCT p1.user_id
FROM Purchases p1
JOIN Purchases p2 
ON p1.user_id = p2.user_id
AND p1.purchase_date <= p2.purchase_date
WHERE DATEDIFF(p2.purchase_date, p1.purchase_date) <= 7
GROUP BY p1.user_id
HAVING COUNT(p1.user_id) > 1;


---------------------------------------------------------------------------------------------------------------------------------
--m3
SELECT DISTINCT p1.user_id
FROM Purchases p1
JOIN Purchases p2
  ON p1.user_id = p2.user_id
 AND p1.purchase_id < p2.purchase_id
WHERE ABS(DATEDIFF(p2.purchase_date, p1.purchase_date)) <= 7
ORDER BY p1.user_id;

