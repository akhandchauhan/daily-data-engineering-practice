-- 2701. Consecutive Transactions with Increasing Amounts

-- Table: Transactions
-- +------------------+------+
-- | Column Name      | Type |
-- +------------------+------+
-- | transaction_id   | int  |
-- | customer_id      | int  |
-- | transaction_date | date |
-- | amount           | int  |
-- +------------------+------+
-- transaction_id is the primary key of this table. 
-- Each row contains information about transactions that includes unique 
-- (customer_id, transaction_date) along with the corresponding customer_id 
-- and amount.  

-- Write an SQL query to find the customers who have made consecutive 
-- transactions with increasing amount for at least three consecutive 
-- days. Include the customer_id, start date of the consecutive 
-- transactions period and the end date of the consecutive transactions
-- period. There can be multiple consecutive transactions by a customer.

-- Return the result table ordered by customer_id in ascending order.

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
-- | 10             | 105         | 2023-05-04       | 300    |
-- | 11             | 105         | 2023-05-12       | 250    |
-- | 12             | 105         | 2023-05-13       | 260    |
-- | 13             | 105         | 2023-05-14       | 270    |
-- +----------------+-------------+------------------+--------+
-- Output: 
-- +-------------+-------------------+-----------------+
-- | customer_id | consecutive_start | consecutive_end | 
-- +-------------+-------------------+-----------------+
-- | 101         |  2023-05-01       | 2023-05-03      | 
-- | 105         |  2023-05-01       | 2023-05-04      |
-- | 105         |  2023-05-12       | 2023-05-14      | 
-- +-------------+-------------------+-----------------+
-- Explanation: 
-- - customer_id 101 has made consecutive transactions with increasing 
-- amounts from May 1st, 2023, to May 3rd, 2023
-- - customer_id 102 does not have any consecutive transactions for at 
-- least 3 days. 
-- - customer_id 105 has two sets of consecutive transactions: from May 
-- 1st, 2023, to May 4th, 2023, and from May 12th, 2023, to May 14th, 2023. 
-- customer_id is sorted in ascending order.

DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    transaction_id   INT PRIMARY KEY,
    customer_id      INT,
    transaction_date DATE,
    amount           INT
);

INSERT INTO Transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1,  101, '2023-05-01', 100),
(2,  101, '2023-05-02', 150),
(3,  101, '2023-05-03', 200),
(4,  102, '2023-05-01', 50),
(5,  102, '2023-05-03', 100),
(6,  102, '2023-05-04', 200),
(7,  105, '2023-05-01', 100),
(8,  105, '2023-05-02', 150),
(9,  105, '2023-05-03', 200),
(10, 105, '2023-05-04', 300),
(11, 105, '2023-05-12', 250),
(12, 105, '2023-05-13', 260),
(13, 105, '2023-05-14', 270);

-- m1 error here = we dont know if amount is increasing or not.
WITH customer_ranking_info AS (
    SELECT 
        customer_id,
        transaction_date,
        amount,
        LEAD(amount) OVER(
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS next_amount,
        ROW_NUMBER() OVER(
                    PARTITION BY customer_id
                    ORDER BY transaction_date 
        ) AS customer_rank,
        DATE_SUB(transaction_date, INTERVAL ROW_NUMBER() OVER(
                    PARTITION BY customer_id
                    ORDER BY transaction_date 
                ) DAY
        ) AS streak
    FROM Transactions
)
SELECT 
    customer_id,
    MIN(transaction_date) AS consecutive_start,
    MAX(transaction_date) AS consecutive_end
FROM customer_ranking_info
GROUP BY 
        customer_id,
        streak
HAVING COUNT(*) >= 3
AND 
    SUM(
        CASE 
            WHEN next_amount > amount THEN 1 ELSE 0 END 
    ) >= 2
ORDER BY 
        customer_id ;


-------------------------------------------------------------------------------
-- m2

WITH
    T AS (
        SELECT
            t1.*,
            SUM(
                CASE
                    WHEN t2.customer_id IS NULL THEN 1
                    ELSE 0
                END
            ) OVER (ORDER BY customer_id, transaction_date) AS s
        FROM
            Transactions AS t1
            LEFT JOIN Transactions AS t2
                ON t1.customer_id = t2.customer_id
                AND t1.amount > t2.amount
                AND DATEDIFF(t1.transaction_date, t2.transaction_date) = 1
    )
SELECT
    customer_id,
    MIN(transaction_date) AS consecutive_start,
    MAX(transaction_date) AS consecutive_end
FROM T
GROUP BY customer_id, s
HAVING COUNT(1) >= 3
ORDER BY customer_id;

--------------------------------------------------------------------------------
-- m3

WITH lead_info AS (
    SELECT
        customer_id,
        transaction_date,
        LEAD(transaction_date) OVER(PARTITION BY customer_id ORDER BY transaction_date) AS next_date,
        LEAD(amount)           OVER(PARTITION BY customer_id ORDER BY transaction_date) AS next_amount,
        amount
    FROM Transactions
),
increasing_rows AS (
    SELECT customer_id, transaction_date
    FROM lead_info
    WHERE next_date   = transaction_date + INTERVAL 1 DAY
      AND next_amount > amount
),
grouped AS (
    SELECT
        customer_id,
        transaction_date,
        DATE_SUB(transaction_date, INTERVAL ROW_NUMBER() OVER(
            PARTITION BY customer_id ORDER BY transaction_date
        ) DAY) AS grp
    FROM increasing_rows
)
SELECT
    customer_id,
    MIN(transaction_date)                   AS consecutive_start,
    MAX(transaction_date) + INTERVAL 1 DAY AS consecutive_end
FROM grouped
GROUP BY customer_id, grp
HAVING COUNT(*) >= 2
ORDER BY customer_id;
