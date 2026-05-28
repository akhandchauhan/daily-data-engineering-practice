-- 3214. Year on Year Growth Rate 
-- Description
-- Table: user_transactions

-- +------------------+----------+
-- | Column Name      | Type     | 
-- +------------------+----------+
-- | transaction_id   | integer  |
-- | product_id       | integer  |
-- | spend            | decimal  |
-- | transaction_date | datetime |
-- +------------------+----------+
-- The transaction_id column uniquely identifies each row in this table.
-- Each row of this table contains the transaction ID, product ID, the spend amount,
--  and the transaction date.
-- Write a solution to calculate the year-on-year growth rate for the total spend
--  for each product.

-- The result table should include the following columns:

-- year: The year of the transaction.
-- product_id: The ID of the product.
-- curr_year_spend: The total spend for the current year.
-- prev_year_spend: The total spend for the previous year.
-- yoy_rate: The year-on-year growth rate percentage, rounded to 2 decimal places.
-- Return the result table ordered by product_id,year in ascending order.

-- user_transactions table:
-- +----------------+------------+---------+---------------------+
-- | transaction_id | product_id | spend   | transaction_date    |
-- +----------------+------------+---------+---------------------+
-- | 1341           | 123424     | 1500.60 | 2019-12-31 12:00:00 |
-- | 1423           | 123424     | 1000.20 | 2020-12-31 12:00:00 |
-- | 1623           | 123424     | 1246.44 | 2021-12-31 12:00:00 |
-- | 1322           | 123424     | 2145.32 | 2022-12-31 12:00:00 |
-- +----------------+------------+---------+---------------------+\
-- Output:
-- +------+------------+----------------+----------------+----------+
-- | year | product_id | curr_year_spend| prev_year_spend| yoy_rate |
-- +------+------------+----------------+----------------+----------+
-- | 2019 | 123424     | 1500.60        | NULL           | NULL     |
-- | 2020 | 123424     | 1000.20        | 1500.60        | -33.35   |
-- | 2021 | 123424     | 1246.44        | 1000.20        | 24.62    |
-- | 2022 | 123424     | 2145.32        | 1246.44        | 72.12    |
-- +------+------------+----------------+----------------+----------+
-- Explanation:
-- For product ID 123424:
-- In 2019:
-- Current year's spend is 1500.60
-- No previous year's spend recorded
-- YoY growth rate: NULL
-- In 2020:
-- Current year's spend is 1000.20
-- Previous year's spend is 1500.60
-- YoY growth rate: ((1000.20 - 1500.60) / 1500.60) * 100 = -33.35%
-- In 2021:
-- Current year's spend is 1246.44
-- Previous year's spend is 1000.20
-- YoY growth rate: ((1246.44 - 1000.20) / 1000.20) * 100 = 24.62%
-- In 2022:
-- Current year's spend is 2145.32
-- Previous year's spend is 1246.44
-- YoY growth rate: ((2145.32 - 1246.44) / 1246.44) * 100 = 72.12%
-- Note: Output table is ordered by product_id and year in ascending order.


DROP TABLE IF EXISTS user_transactions;

CREATE TABLE user_transactions (
    transaction_id INT,
    product_id INT,
    spend DECIMAL(10,2),
    transaction_date TIMESTAMP
);

INSERT INTO user_transactions (transaction_id, product_id, spend, transaction_date) VALUES
(1341, 123424, 1500.60, '2019-12-31 12:00:00'),
(1423, 123424, 1000.20, '2020-12-31 12:00:00'),
(1623, 123424, 1246.44, '2021-12-31 12:00:00'),
(1322, 123424, 2145.32, '2022-12-31 12:00:00');

-- m1 
WITH product_spend_info AS (
    SELECT 
        YEAR(transaction_date) AS year,
        product_id,
        SUM(spend) AS curr_year_spend
    FROM user_transactions
    GROUP BY YEAR(transaction_date),
            product_id
),
prev_transaction_info AS (
    SELECT
        year,
        product_id,
        curr_year_spend,
        LAG(curr_year_spend) OVER(
            PARTITION BY product_id
            ORDER BY year
        ) AS prev_year_spend
    FROM product_spend_info
)
SELECT 
        year,
        product_id,
        curr_year_spend,
        prev_year_spend,
        ROUND(
            (curr_year_spend - prev_year_spend) * 100.0 
            / NULLIF(prev_year_spend, 0)
        , 2) AS yoy_rate

FROM prev_transaction_info
ORDER BY 
        product_id,
        year
;

----------------------------------------------------------------------------------------
-- m2 

WITH product_spend_info AS (
    SELECT 
        YEAR(transaction_date) AS year,
        product_id,
        SUM(spend) AS curr_year_spend
    FROM user_transactions
    GROUP BY YEAR(transaction_date), product_id
),
prev_transaction_info AS (
    SELECT
        psi_curr.year,
        psi_curr.product_id,
        psi_curr.curr_year_spend,
        psi_prev.curr_year_spend AS prev_year_spend
    FROM product_spend_info psi_curr
    LEFT JOIN product_spend_info psi_prev
        ON psi_curr.product_id = psi_prev.product_id
        AND psi_curr.year = psi_prev.year + 1
)
SELECT 
    year,
    product_id,
    curr_year_spend,
    prev_year_spend,
    ROUND(
        (curr_year_spend - prev_year_spend) * 100.0 
        / NULLIF(prev_year_spend, 0)
    , 2) AS yoy_rate
FROM prev_transaction_info
ORDER BY product_id, year;