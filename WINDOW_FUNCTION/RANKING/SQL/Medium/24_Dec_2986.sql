
-- 2986. Find Third Transaction
-- Description
-- Table: Transactions
-- +------------------+----------+
-- | Column Name      | Type     |
-- +------------------+----------+
-- | user_id          | int      |
-- | spend            | decimal  |
-- | transaction_date | datetime |
-- +------------------+----------+
-- (user_id, transaction_date) is column of unique values for this table.
-- This table contains user_id, spend, and transaction_date.
-- Write a solution to find the third transaction (if they have at least three transactions) 
-- of every user, where the spending on the preceding two transactions is lower than the spending
--  on the third transaction.
-- Return the result table by user_id in ascending order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Transactions table:
-- +---------+--------+---------------------+
-- | user_id | spend  | transaction_date    | 
-- +---------+--------+---------------------+
-- | 1       | 65.56  | 2023-11-18 13:49:42 | 
-- | 1       | 96.0   | 2023-11-30 02:47:26 |     
-- | 1       | 7.44   | 2023-11-02 12:15:23 | 
-- | 1       | 49.78  | 2023-11-12 00:13:46 | 
-- | 2       | 40.89  | 2023-11-21 04:39:15 |  
-- | 2       | 100.44 | 2023-11-20 07:39:34 | 
-- | 3       | 37.33  | 2023-11-03 06:22:02 | 
-- | 3       | 13.89  | 2023-11-11 16:00:14 | 
-- | 3       | 7.0    | 2023-11-29 22:32:36 | 
-- +---------+--------+---------------------+
-- Output
-- +---------+-------------------------+------------------------+
-- | user_id | third_transaction_spend | third_transaction_date | 
-- +---------+-------------------------+------------------------+
-- | 1       | 65.56                   | 2023-11-18 13:49:42    |  
-- +---------+-------------------------+------------------------+
-- Explanation
-- - For user_id 1, their third transaction occurred on 2023-11-18 at 13:49:42 with an amount of $65.56, 
-- surpassing the expenditures of the previous two transactions which were $7.44 on 2023-11-02 at 12:15:23 
-- and $49.78 on 2023-11-12 at 00:13:46. Thus, this third transaction will be included in the output table.
-- - user_id 2 only has a total of 2 transactions, so there isn't a third transaction to consider.
-- - For user_id 3, the amount of $7.0 for their third transaction is less than that of the preceding two 
-- transactions, so it won't be included.
-- Output table is ordered by user_id in ascending order.

DROP TABLE transactions;
Create Table if Not Exists Transactions (user_id int, spend decimal(5,2), transaction_date datetime) ;

INSERT INTO Transactions (user_id, spend, transaction_date) VALUES
('1', '65.56', '2023-11-18 13:49:42'),
('1', '96.0', '2023-11-30 02:47:26'),
('1', '7.44', '2023-11-02 12:15:23'),
('1', '49.78', '2023-11-12 00:13:46'),
('2', '40.89', '2023-11-21 04:39:15'),
('2', '100.44', '2023-11-20 07:39:34'),
('3', '37.33', '2023-11-03 06:22:02'),
('3', '13.89', '2023-11-11 16:00:14'),
('3', '7.0', '2023-11-29 22:32:36');


WITH cte1 AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rw,
           LAG(spend, 1) OVER(PARTITION BY user_id ORDER BY transaction_date) AS lag1,
           LAG(spend, 2) OVER(PARTITION BY user_id ORDER BY transaction_date) AS lag2
    FROM Transactions
)
SELECT user_id,transaction_date, spend,lag1, lag2
FROM cte1
WHERE rw = 3 AND spend > lag1 AND spend > lag2;

------------------------------------------------------------------------------------------------------------
-- m2
WITH cte as(
    SELECT *, LEAD(spend,1) OVER(PARTITION BY user_id ORDER BY transaction_date) as nxt_spend,
            LEAD(spend,2) OVER(PARTITION BY user_id ORDER BY transaction_date) as nxt_nxt_spend,
            LEAD(transaction_date,2) OVER(PARTITION BY user_id ORDER BY transaction_date) as nxt_nxt_dt,
            ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) as rnk
    FROM transactions
)
SELECT user_id, nxt_nxt_spend as third_transaction_spend,nxt_nxt_dt as third_transaction_date
FROM cte
WHERE rnk = 1 and nxt_nxt_spend > spend and nxt_nxt_spend > nxt_spend;

------------------------------------------------------------------------------------------------------------
--m3
WITH cte as(
    SELECT *, DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) as order_rnk
    FROM transactions
),
cte2 as(
    SELECT *,DENSE_RANK() OVER(PARTITION BY user_id ORDER BY spend) as spend_rnk
    FROM cte
    WHERE order_rnk <= 3
)
SELECT user_id, spend as third_transaction_spend, transaction_date as third_transaction_date
FROM cte2
WHERE order_rnk = 3 and spend_rnk = 3;