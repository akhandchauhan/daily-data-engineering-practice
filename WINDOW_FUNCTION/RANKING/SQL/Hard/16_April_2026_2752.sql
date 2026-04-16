-- 2752. Customers with Maximum Number of Transactions on Consecutive Days
-- Description
-- Table: Transactions
-- +------------------+------+
-- | Column Name      | Type |
-- +------------------+------+
-- | transaction_id   | int  |
-- | customer_id      | int  |
-- | transaction_date | date |
-- | amount           | int  |
-- +------------------+------+
-- transaction_id is the column with unique values of this table.
-- Each row contains information about transactions that includes unique 
-- (customer_id, transaction_date) along with the corresponding customer_id and amount.   
-- Write a solution to find all customer_id who made the maximum number of 
-- transactions on consecutive days.

-- Return all customer_id with the maximum number of consecutive transactions.
-- Order the result table by customer_id in ascending order.

-- Input: 
-- Transactions table:
-- +----------------+-------------+------------------+--------+
-- | transaction_id | customer_id | transaction_date | amount |
-- +----------------+-------------+------------------+--------+
-- | 1              | 101         | 2023-05-01       | 100    |
-- | 2              | 101         | 2023-05-02       | 150    |
-- | 3              | 101         | 2023-05-03       | 200    |
-- | 4              | 102         | 2023-05-01       | 50     |
-- | 5              | 102         | 2023-05-03       | 100    |
-- | 6              | 102         | 2023-05-04       | 200    |
-- | 7              | 105         | 2023-05-01       | 100    |
-- | 8              | 105         | 2023-05-02       | 150    |
-- | 9              | 105         | 2023-05-03       | 200    |
-- +----------------+-------------+------------------+--------+
-- Output: 
-- +-------------+
-- | customer_id | 
-- +-------------+
-- | 101         | 
-- | 105         | 
-- +-------------+
-- Explanation: 
-- - customer_id 101 has a total of 3 transactions, and all of them are consecutive.
-- - customer_id 102 has a total of 3 transactions, but only 2 of them are consecutive. 
-- - customer_id 105 has a total of 3 transactions, and all of them are consecutive.
-- In total, the highest number of consecutive transactions is 3, achieved by 
-- customer_id 101 and 105. The customer_id are sorted in ascending order.

-- Drop table if exists
DROP TABLE IF EXISTS Transactions;

-- Create table
CREATE TABLE Transactions (
    transaction_id INT,
    customer_id INT,
    transaction_date DATE,
    amount INT
);

-- Insert data
INSERT INTO Transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1, 101, '2023-05-01', 100),
(2, 101, '2023-05-02', 150),
(3, 101, '2023-05-03', 200),
(4, 102, '2023-05-01', 50),
(5, 102, '2023-05-03', 100),
(6, 102, '2023-05-04', 200),
(7, 105, '2023-05-01', 100),
(8, 105, '2023-05-02', 150),
(9, 105, '2023-05-03', 200);

-- m1 
WITH transactions_ranked AS (
    SELECT 
        customer_id,
        transaction_date,
        DATE_ADD(transaction_date, INTERVAL - ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) DAY) AS transactions_ranked_date
    FROM Transactions
),
transactions_grouped AS (
    SELECT 
            customer_id,
            COUNT(transactions_ranked_date) AS grouped_count
    FROM transactions_ranked 
    GROUP BY customer_id,
            transactions_ranked_date
)
SELECT 
      DISTINCT customer_id
FROM transactions_grouped tg 
WHERE grouped_count = (
    SELECT MAX(grouped_count)
    FROM transactions_grouped
)
ORDER BY customer_id;

----------------------------------------------------------------------------------------

-- m2 
WITH transactions_ranked AS (
    SELECT 
        customer_id,
        transaction_date,
        DATE_ADD(transaction_date, INTERVAL - ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) DAY) AS transactions_ranked_date
    FROM Transactions
),
transactions_grouped AS (
    SELECT 
            customer_id,
            COUNT(transactions_ranked_date) AS grouped_count
    FROM transactions_ranked 
    GROUP BY customer_id,
            transactions_ranked_date
)
SELECT 
      DISTINCT customer_id
FROM transactions_grouped tg 
JOIN (
    SELECT MAX(grouped_count) AS grouped_count
    FROM transactions_grouped
) tg2
ON tg.grouped_count = tg2.grouped_count
ORDER BY customer_id;

----------------------------------------------------------------------------------------

-- m3

WITH t AS (
    SELECT *,
           CASE 
               WHEN DATEDIFF(transaction_date,
                             LAG(transaction_date) OVER (
                                 PARTITION BY customer_id 
                                 ORDER BY transaction_date
                             )) = 1
               THEN 0 ELSE 1
           END AS new_group
    FROM Transactions
),
grp AS (
    SELECT *,
           SUM(new_group) OVER (
               PARTITION BY customer_id 
               ORDER BY transaction_date
           ) AS grp_id
    FROM t
),
agg AS (
    SELECT customer_id, COUNT(*) AS cnt
    FROM grp
    GROUP BY customer_id, grp_id
),
mx AS (
    SELECT MAX(cnt) AS max_cnt FROM agg
)
SELECT DISTINCT customer_id
FROM agg
WHERE cnt = (SELECT max_cnt FROM mx)
ORDER BY customer_id;