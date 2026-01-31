-- 2066. Account Balance
-- Description
-- Table: Transactions
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | account_id  | int  |
-- | day         | date |
-- | type        | ENUM |
-- | amount      | int  |
-- +-------------+------+
-- (account_id, day) is the primary key for this table.
-- Each row contains information about one transaction, including the transaction type, the day
-- it occurred on, and the amount.
-- type is an ENUM of the type ('Deposit','Withdraw') 
-- Write an  SQL query to report the balance of each user after each transaction. 
-- You may assume that the balance of each account before any transaction is 0 and that
-- the balance will never be below 0 at any moment.
-- Return the result table in ascending order by account_id, then by day in case of a tie.
-- The query result format is in the following example.
-- Example 1:
-- Input: 
-- Transactions table:
-- +------------+------------+----------+--------+
-- | account_id | day        | type     | amount |
-- +------------+------------+----------+--------+
-- | 1          | 2021-11-07 | Deposit  | 2000   |
-- | 1          | 2021-11-09 | Withdraw | 1000   |
-- | 1          | 2021-11-11 | Deposit  | 3000   |
-- | 2          | 2021-12-07 | Deposit  | 7000   |
-- | 2          | 2021-12-12 | Withdraw | 7000   |
-- +------------+------------+----------+--------+

-- Output: 
-- +------------+------------+---------+
-- | account_id | day        | balance |
-- +------------+------------+---------+
-- | 1          | 2021-11-07 | 2000    |
-- | 1          | 2021-11-09 | 1000    |
-- | 1          | 2021-11-11 | 4000    |
-- | 2          | 2021-12-07 | 7000    |
-- | 2          | 2021-12-12 | 0       |
-- +------------+------------+---------+
-- Explanation: 
-- Account 1:
-- - Initial balance is 0.
-- - 2021-11-07 --> deposit 2000. Balance is 0 + 2000 = 2000.
-- - 2021-11-09 --> withdraw 1000. Balance is 2000 - 1000 = 1000.
-- - 2021-11-11 --> deposit 3000. Balance is 1000 + 3000 = 4000.
-- Account 2:
-- - Initial balance is 0.
-- - 2021-12-07 --> deposit 7000. Balance is 0 + 7000 = 7000.
-- - 2021-12-12 --> withdraw 7000. Balance is 7000 - 7000 = 0.

DROP TABLE transactions;
CREATE TABLE Transactions (
    account_id INT,
    day DATE,
    type ENUM('Deposit', 'Withdraw'),
    amount INT,
    PRIMARY KEY (account_id, day)
);
INSERT INTO Transactions (account_id, day, type, amount) VALUES
(1, '2021-11-07', 'Deposit', 2000),
(1, '2021-11-09', 'Withdraw', 1000),
(1, '2021-11-11', 'Deposit', 3000),
(2, '2021-12-07', 'Deposit', 7000),
(2, '2021-12-12', 'Withdraw', 7000);

-- m1 
WITH cte as(
    SELECT account_id,day,IF(type='Withdraw',-amount,amount) as amount
    FROM Transactions
)
SELECT account_id,day,
          SUM(amount) OVER (PARTITION BY account_id ORDER BY day) as balance
FROM cte
ORDER BY 1,2;

--------------------------------------------------------------------------------------------------------------------------------
-- m2
SELECT t1.account_id, t1.day, 
       SUM(IF(t2.type='Deposit', t2.amount, -t2.amount)) AS balance
FROM Transactions t1
JOIN Transactions t2 
ON t1.account_id = t2.account_id 
AND t2.day <= t1.day
GROUP BY t1.account_id, t1.day
ORDER BY t1.account_id, t1.day;

--------------------------------------------------------------------------------------------------------------------------------
-- m3
SELECT account_id,
       day,
       SUM(CASE WHEN type = 'Deposit' THEN amount ELSE -amount END)
       OVER(PARTITION BY account_id ORDER BY day) AS balance
FROM Transactions 
GROUP BY account_id,day
ORDER BY 1,2;

--------------------------------------------------------------------------------------------------------------------------------
--m4
SELECT account_id,
       day,
       SUM(CASE WHEN type = 'Deposit' THEN amount ELSE -amount END) OVER(
           PARTITION BY account_id 
           ORDER BY day
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance
FROM Transactions 
ORDER BY account_id,
         day;

--------------------------------------------------------------------------------------------------------------------------------
--m5
SELECT t1.account_id,
        t1.day,
        SUM(CASE WHEN t2.type = 'Deposit' THEN t2.amount ELSE -t2.amount END) AS balance
FROM Transactions t1 
JOIN Transactions t2 
ON t1.account_id = t2.account_id
AND t1.day >= t2.day
GROUP BY 1,2
ORDER BY 1,2;
