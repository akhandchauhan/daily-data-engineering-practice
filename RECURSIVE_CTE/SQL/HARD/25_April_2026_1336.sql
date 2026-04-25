-- 1336. Number of Transactions per Visit

-- Table: Visits
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | visit_date    | date    |
-- +---------------+---------+
-- (user_id, visit_date) is the primary key for this table.
-- Each row of this table indicates that user_id has visited the bank in visit_date.

-- Table: Transactions
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | user_id          | int     |
-- | transaction_date | date    |
-- | amount           | int     |
-- +------------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- Each row of this table indicates that user_id has done a transaction of amount in
-- transaction_date.
-- It is guaranteed that the user has visited the bank in the transaction_date.
-- (i.e The Visits table contains (user_id, transaction_date) in one row)
 
-- A bank wants to draw a chart of the number of transactions bank visitors 
-- did in one visit to the bank and the corresponding number of visitors who 
-- have done this number of transaction in one visit.

-- Write an SQL query to find how many users visited the bank and 
-- didn't do any transactions, how many visited the bank and did one 
-- transaction and so on.

-- The result table will contain two columns:

-- transactions_count which is the number of transactions done in one visit.
-- visits_count which is the corresponding number of users who did transactions_count 
-- in one visit to the bank.
-- transactions_count should take all values from 0 to max(transactions_count)
--  done by one or more users.

-- Order the result table by transactions_count.

-- Visits table:
-- +---------+------------+
-- | user_id | visit_date |
-- +---------+------------+
-- | 1       | 2020-01-01 |
-- | 2       | 2020-01-02 |
-- | 12      | 2020-01-01 |
-- | 19      | 2020-01-03 |
-- | 1       | 2020-01-02 |
-- | 2       | 2020-01-03 |
-- | 1       | 2020-01-04 |
-- | 7       | 2020-01-11 |
-- | 9       | 2020-01-25 |
-- | 8       | 2020-01-28 |
-- +---------+------------+
-- Transactions table:
-- +---------+------------------+--------+
-- | user_id | transaction_date | amount |
-- +---------+------------------+--------+
-- | 1       | 2020-01-02       | 120    |
-- | 2       | 2020-01-03       | 22     |
-- | 7       | 2020-01-11       | 232    |
-- | 1       | 2020-01-04       | 7      |
-- | 9       | 2020-01-25       | 33     |
-- | 9       | 2020-01-25       | 66     |
-- | 8       | 2020-01-28       | 1      |
-- | 9       | 2020-01-25       | 99     |
-- +---------+------------------+--------+
-- Result table:
-- +--------------------+--------------+
-- | transactions_count | visits_count |
-- +--------------------+--------------+
-- | 0                  | 4            |
-- | 1                  | 5            |
-- | 2                  | 0            |
-- | 3                  | 1            |
-- +--------------------+--------------+
-- * For transactions_count = 0, The visits (1, "2020-01-01"), (2, "2020-01-02"), 
-- (12, "2020-01-01") and (19, "2020-01-03") did no transactions so visits_count = 4.
-- * For transactions_count = 1, The visits (2, "2020-01-03"), (7, "2020-01-11"), 
-- (8, "2020-01-28"), (1, "2020-01-02") and (1, "2020-01-04") did one transaction
--  so visits_count = 5.
-- * For transactions_count = 2, No customers visited the bank and did two 
-- transactions so visits_count = 0.
-- * For transactions_count = 3, The visit (9, "2020-01-25") did three transactions
--  so visits_count = 1.
-- * For transactions_count >= 4, No customers visited the bank and did more 
-- than three transactions so we will stop at transactions_count = 3


-- Drop tables if they exist
DROP TABLE IF EXISTS Visits;
DROP TABLE IF EXISTS Transactions;

-- Create Visits table with PRIMARY KEY
CREATE TABLE Visits (
    user_id INT,
    visit_date DATE,
    PRIMARY KEY (user_id, visit_date)
);

-- Insert data into Visits
INSERT INTO Visits (user_id, visit_date) VALUES
(1, '2020-01-01'),
(2, '2020-01-02'),
(12, '2020-01-01'),
(19, '2020-01-03'),
(1, '2020-01-02'),
(2, '2020-01-03'),
(1, '2020-01-04'),
(7, '2020-01-11'),
(9, '2020-01-25'),
(8, '2020-01-28');

-- Create Transactions table (no PK, duplicates allowed)
CREATE TABLE Transactions (
    user_id INT,
    transaction_date DATE,
    amount INT
);

-- Insert data into Transactions
INSERT INTO Transactions (user_id, transaction_date, amount) VALUES
(1, '2020-01-02', 120),
(2, '2020-01-03', 22),
(7, '2020-01-11', 232),
(1, '2020-01-04', 7),
(9, '2020-01-25', 33),
(9, '2020-01-25', 66),
(8, '2020-01-28', 1),
(9, '2020-01-25', 99);

WITH RECURSIVE user_info AS (
    SELECT 
            v.user_id,
            v.visit_date,
            COUNT(t.user_id) AS user_count
    FROM Visits v 
    LEFT JOIN Transactions t
    ON v.user_id = t.user_id
    AND v.visit_date = t.transaction_date
    GROUP BY v.user_id,
            v.visit_date
),
transaction_info AS (
    SELECT 
            user_count AS transactions_count,
            COUNT(user_id) AS visit_count
    FROM user_info
    GROUP BY user_count
),
 count_generation_cte AS (
    SELECT 0 AS transactions_count,
           MAX(transactions_count) AS max_transaction_count
    FROM transaction_info
    UNION ALL 
    SELECT transactions_count+1,max_transaction_count
    FROM count_generation_cte
    WHERE transactions_count < max_transaction_count

)
SELECT 
    cgc.transactions_count,
    COALESCE(ti.visit_count,0 ) AS visit_count
FROM count_generation_cte cgc 
LEFT JOIN transaction_info ti
ON cgc.transactions_count = ti.transactions_count;