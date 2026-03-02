-- 3230. Customer Purchasing Behavior Analysis 
-- Description
-- Table: Transactions
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | transaction_id   | int     |
-- | customer_id      | int     |
-- | product_id       | int     |
-- | transaction_date | date    |
-- | amount           | decimal |
-- +------------------+---------+
-- transaction_id is the unique identifier for this table.
-- Each row of this table contains information about a transaction, including the 
--customer ID, product ID, date, and amount spent.
-- Table: Products
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_id  | int     |
-- | category    | varchar |
-- | price       | decimal |
-- +-------------+---------+
-- product_id is the unique identifier for this table.
-- Each row of this table contains information about a product, including its category and price.
-- Write a solution to analyze customer purchasing behavior. For each customer, calculate:
-- The total amount spent.
-- The number of transactions.
-- The number of unique product categories purchased.
-- The average amount spent. 
-- The most frequently purchased product category (if there is a tie, choose the one with the most 
--recent transaction).
-- A loyalty score defined as: (Number of transactions * 10) + (Total amount spent / 100).
-- Round total_amount, avg_transaction_amount, and loyalty_score to 2 decimal places.
-- Return the result table ordered by loyalty_score in descending order, then by customer_id 
--in ascending order.
-- The query result format is in the following example.
-- Example:
-- Input:
-- Transactions table:
-- +----------------+-------------+------------+------------------+--------+
-- | transaction_id | customer_id | product_id | transaction_date | amount |
-- +----------------+-------------+------------+------------------+--------+
-- | 1              | 101         | 1          | 2023-01-01       | 100.00 |
-- | 2              | 101         | 2          | 2023-01-15       | 150.00 |
-- | 3              | 102         | 1          | 2023-01-01       | 100.00 |
-- | 4              | 102         | 3          | 2023-01-22       | 200.00 |
-- | 5              | 101         | 3          | 2023-02-10       | 200.00 |
-- +----------------+-------------+------------+------------------+--------+
-- Products table
-- +------------+----------+--------+
-- | product_id | category | price  |
-- +------------+----------+--------+
-- | 1          | A        | 100.00 |
-- | 2          | B        | 150.00 |
-- | 3          | C        | 200.00 |
-- +------------+----------+--------+
-- Output:
-- +-------------+--------------+-------------------+-------------------+------------------------+--------------+---------------+
-- | customer_id | total_amount | transaction_count | unique_categories | avg_transaction_amount | top_category | loyalty_score |
-- +-------------+--------------+-------------------+-------------------+------------------------+--------------+---------------+
-- | 101         | 450.00       | 3                 | 3                 | 150.00                 | C            | 34.50         |
-- | 102         | 300.00       | 2                 | 2                 | 150.00                 | C            | 23.00         |
-- +-------------+--------------+-------------------+-------------------+------------------------+--------------+---------------+
-- Explanation:
-- For customer 101:
-- Total amount spent: 100.00 + 150.00 + 200.00 = 450.00
-- Number of transactions: 3
-- Unique categories: A, B, C (3 categories)
-- Average transaction amount: 450.00 / 3 = 150.00
-- Top category: C (Customer 101 made 1 purchase each in categories A, B, and C. 
--Since the count is the same for all categories, we choose the most recent transaction,
-- which is category C on 2023-02-10)
-- Loyalty score: (3 * 10) + (450.00 / 100) = 34.50
-- For customer 102:
-- Total amount spent: 100.00 + 200.00 = 300.00
-- Number of transactions: 2
-- Unique categories: A, C (2 categories)
-- Average transaction amount: 300.00 / 2 = 150.00
-- Top category: C (Customer 102 made 1 purchase each in categories A and C. Since the 
--count is the same for both categories, we choose the most recent transaction, which is 
--category C on 2023-01-22)
-- Loyalty score: (2 * 10) + (300.00 / 100) = 23.00
-- Note: The output is ordered by loyalty_score in descending order, then by customer_id in
-- ascending order.


DROP TABLE Transactions;
DROP TABLE Products;
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT, customer_id INT, product_id INT, transaction_date DATE, amount DECIMAL(10, 2)
);
CREATE TABLE IF NOT EXISTS Products (
    product_id INT, category VARCHAR(255), price DECIMAL(10, 2)
);
INSERT INTO Transactions VALUES 
(1, 101, 1, '2023-01-01', 100.0), (2, 101, 2, '2023-01-15', 150.0), 
(3, 102, 1, '2023-01-01', 100.0), (4, 102, 3, '2023-01-22', 200.0), 
(5, 101, 3, '2023-02-10', 200.0);

INSERT INTO Products VALUES 
(1, 'A', 100.0), (2, 'B', 150.0), (3, 'C', 200.0);



-- my method m1
WITH rnk_cte as(
    SELECT customer_id,
           category, 
           ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY transaction_date DESC) AS rnk
    FROM transactions t 
    JOIN Products p 
    ON t.product_id = p.product_id
),
agg_cte as(
    SELECT customer_id ,
        SUM(price) as total_amount ,
        COUNT(transaction_id),
        COUNT(DISTINCT t.product_id) as unique_categories ,
        ROUND(SUM(price)/COUNT(transaction_id), 2) AS avg_transaction_amount ,
        ROUND((COUNT(transaction_id) * 10) + (SUM(price) / 100), 2) as loyality_score
    FROM transactions t 
    JOIN Products p 
    ON t.product_id = p.product_id
    GROUP BY customer_id
)
SELECT *
FROM agg_cte 
JOIN rnk_cte
USING (customer_id)
WHERE rnk =1 ;

------------------------------------------------------------------------------------------------------------
-- m2
WITH cte AS (
    SELECT t.*, p.category, COUNT(*) OVER(PARTITION BY customer_id, category) AS cnt
    FROM Transactions AS t
    LEFT JOIN Products AS p
    ON t.product_id = p.product_id
),
cte2 AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY cnt DESC, transaction_date DESC) 
    AS rnk
    FROM cte
)
SELECT customer_id, ROUND(SUM(amount),2) AS total_amount, COUNT(transaction_id) AS transaction_count,
COUNT(DISTINCT category) AS unique_categories, ROUND(SUM(amount)/COUNT(transaction_id),2) AS 
avg_transaction_amount, MAX(CASE WHEN rnk = 1 THEN category ELSE NULL END) AS top_category,
ROUND((COUNT(transaction_id) * 10) + (SUM(amount)/100),2) AS loyalty_score
FROM cte2
GROUP BY customer_id
ORDER BY loyalty_score DESC, customer_id;

------------------------------------------------------------------------------------------------------------
--m3
WITH joined_data AS (
    SELECT t.customer_id,t.transaction_id,t.transaction_date,t.amount, p.category
    FROM Transactions t
    JOIN Products p 
    ON t.product_id = p.product_id
),
customer_summary AS (
    SELECT 
        customer_id, ROUND(SUM(amount), 2) AS total_amount,
        COUNT(*) AS transaction_count, COUNT(DISTINCT category) AS unique_categories,
        ROUND(AVG(amount), 2) AS avg_transaction_amount,
        ROUND((COUNT(*) * 10) + (SUM(amount) / 100), 2) AS loyalty_score
    FROM joined_data
    GROUP BY customer_id
),
category_rank AS (
    SELECT customer_id, category,COUNT(*) AS category_count,
        MAX(transaction_date) AS last_transaction_date,
        RANK() OVER (
            PARTITION BY customer_id 
            ORDER BY COUNT(*) DESC, MAX(transaction_date) DESC
        ) AS rnk
    FROM joined_data
    GROUP BY customer_id, category
),
top_categories AS (
    SELECT customer_id, category AS top_category
    FROM category_rank
    WHERE rnk = 1
)
SELECT 
    cs.customer_id,cs.total_amount,cs.transaction_count,cs.unique_categories,
    cs.avg_transaction_amount,tc.top_category,cs.loyalty_score
FROM customer_summary cs
JOIN top_categories tc 
ON cs.customer_id = tc.customer_id
ORDER BY cs.loyalty_score DESC, cs.customer_id ASC;

------------------------------------------------------------------------------------------------------------
--m4 latest try
WITH top_category_info AS (
SELECT 
        t.customer_id,
        p.category,
        ROW_NUMBER() OVER(
            PARTITION BY t.customer_id 
            ORDER BY COUNT(p.category) DESC, 
            MAX(t.transaction_date) DESC
        ) AS top_category
FROM transactions t    
JOIN Products p   
ON t.product_id = p.product_id
GROUP BY t.customer_id,
         p.category
),
customer_info AS (
SELECT 
      t.customer_id,
      SUM(t.amount) AS total_amount,
      COUNT(t.transaction_id) AS transaction_count,
      COUNT(DISTINCT p.category) AS unique_categories,
      AVG(t.amount) AS avg_transaction_amount
FROM transactions t    
JOIN Products p   
ON t.product_id = p.product_id
GROUP BY t.customer_id
)
SELECT 
      ci.customer_id,
      ROUND(ci.total_amount, 2) AS total_amount,
      ci.transaction_count,
      ci.unique_categories,
      ROUND(ci.avg_transaction_amount, 2) AS avg_transaction_amount,
      tci.category AS top_category,
      ROUND(ci.transaction_count*10 + (ci.total_amount/100.0), 2) AS loyalty_score
FROM customer_info ci 
JOIN top_category_info tci 
ON ci.customer_id = tci.customer_id
AND tci.top_category = 1
ORDER BY loyalty_score DESC,
         customer_id;