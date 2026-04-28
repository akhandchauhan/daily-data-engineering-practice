-- 2474. Customers With Strictly Increasing Purchases
-- Description
-- Table: Orders
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | order_id     | int  |
-- | customer_id  | int  |
-- | order_date   | date |
-- | price        | int  |
-- +--------------+------+
-- order_id is the primary key for this table.
-- Each row contains the id of an order, the id of customer that ordered it, 
-- the date of the order, and its price.

-- Write an SQL query to report the IDs of the customers with the total purchases 
-- strictly increasing yearly.
-- The total purchases of a customer in one year is the sum of the prices of 
-- their orders in that year.
-- If for some year the customer did not make any order, we consider the total 
-- purchases 0.
-- The first year to consider for each customer is the year of their first order.
-- The last year to consider for each customer is the year of their last order.
-- Return the result table in any order.
-- The query result format is in the following example.
-- Example 1:
-- Input: 
-- Orders table:
-- +----------+-------------+------------+-------+
-- | order_id | customer_id | order_date | price |
-- +----------+-------------+------------+-------+
-- | 1        | 1           | 2019-07-01 | 1100  |
-- | 2        | 1           | 2019-11-01 | 1200  |
-- | 3        | 1           | 2020-05-26 | 3000  |
-- | 4        | 1           | 2021-08-31 | 3100  |
-- | 5        | 1           | 2022-12-07 | 4700  |
-- | 6        | 2           | 2015-01-01 | 700   |
-- | 7        | 2           | 2017-11-07 | 1000  |
-- | 8        | 3           | 2017-01-01 | 900   |
-- | 9        | 3           | 2018-11-07 | 900   |
-- +----------+-------------+------------+-------+
-- Output: 
-- +-------------+
-- | customer_id |
-- +-------------+
-- | 1           |
-- +-------------+
-- Explanation: 
-- Customer 1: The first year is 2019 and the last year is 2022
--   - 2019: 1100 + 1200 = 2300
--   - 2020: 3000
--   - 2021: 3100
--   - 2022: 4700
--   We can see that the total purchases are strictly increasing yearly, 
-- so we include customer 1 in the answer.

-- Customer 2: The first year is 2015 and the last year is 2017
--   - 2015: 700
--   - 2016: 0
--   - 2017: 1000
--   We do not include customer 2 in the answer because the total 
-- purchases are not strictly increasing. Note that customer 2 did not 
-- make any purchases in 2016.

-- Customer 3: The first year is 2017, and the last year is 2018
--   - 2017: 900
--   - 2018: 900
--   We can see that the total purchases are strictly increasing yearly, so 
-- we include customer 1 in
DROP TABLE ORDERS;
Create table If Not Exists Orders (order_id int, customer_id int, order_date date, 
price int);
Truncate table Orders;

INSERT INTO Orders (order_id, customer_id, order_date, price) VALUES
('1', '1', '2019-07-01', '1100'),
('2', '1', '2019-11-01', '1200'),
('3', '1', '2020-05-26', '3000'),
('4', '1', '2021-08-31', '3100'),
('5', '1', '2022-12-07', '4700'),
('6', '2', '2015-01-01', '700'),
('7', '2', '2017-11-07', '1000'),
('8', '3', '2017-01-01', '900'),
('9', '3', '2018-11-07', '900');

WITH yearly AS (
    SELECT 
        customer_id,
        YEAR(order_date) AS yr,
        SUM(price) AS total
    FROM Orders
    GROUP BY customer_id, YEAR(order_date)
),
cte AS (
    SELECT 
        customer_id,
        yr,
        total,
        MAX(yr) OVER (PARTITION BY customer_id) 
        - MIN(yr) OVER (PARTITION BY customer_id) + 1 AS num_yrs,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY yr) AS rnk_yr,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY total) AS rnk_total
    FROM yearly
)
SELECT customer_id
FROM cte
GROUP BY customer_id
HAVING SUM(rnk_yr = rnk_total) = MAX(num_yrs);

----------------------------------------------------------------------------------------
-- m2
WITH RECURSIVE year_info AS(
    SELECT 
        customer_id,
        MIN(YEAR(order_date)) AS year,
        MAX(YEAR(order_date)) AS max_year
    FROM Orders
    GROUP BY 1
    UNION ALL 
    SELECT 
        customer_id,
        year +1,
        max_year
    FROM year_info
    WHERE year < max_year

), agg_order_info AS (
    SELECT 
        yi.customer_id,
        yi.year AS order_year,
        SUM(price) AS total_price,
        LEAD(SUM(price) ,1,0) OVER(
            PARTITION BY yi.customer_id
            ORDER BY yi.year
        ) AS next_purchase
    FROM year_info yi 
    LEFT JOIN Orders o 
    ON yi.customer_id = o.customer_id
    AND yi.year = YEAR(o.order_date)
    GROUP BY yi.customer_id,
            yi.year
),
final AS (
    SELECT 
            customer_id,
            MIN(CASE 
                WHEN next_purchase = 0 OR next_purchase > total_price THEN 1
                ELSE -1 
            END 
            ) AS increasing_trend 
    FROM agg_order_info
    GROUP BY customer_id
 )
 SELECT customer_id
 FROM final 
 WHERE increasing_trend = 1 ;