-- 2292. Products With Three or More Orders in Two Consecutive Years
-- Description
-- Table: Orders
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | order_id      | int  |
-- | product_id    | int  |
-- | quantity      | int  |
-- | purchase_date | date |
-- +---------------+------+
-- order_id is the primary key for this table.
-- Each row in this table contains the ID of an order, the id of the product purchased,
-- the quantity, and the purchase date.
-- Write an SQL query to report the IDs of all the products that were ordered three 
--or more times in two consecutive years.

-- Input: 
-- Orders table:
-- +----------+------------+----------+---------------+
-- | order_id | product_id | quantity | purchase_date |
-- +----------+------------+----------+---------------+
-- | 1        | 1          | 7        | 2020-03-16    |
-- | 2        | 1          | 4        | 2020-12-02    |
-- | 3        | 1          | 7        | 2020-05-10    |
-- | 4        | 1          | 6        | 2021-12-23    |
-- | 5        | 1          | 5        | 2021-05-21    |
-- | 6        | 1          | 6        | 2021-10-11    |
-- | 7        | 2          | 6        | 2022-10-11    |
-- +----------+------------+----------+---------------+
-- Output: 
-- +------------+
-- | product_id |
-- +------------+
-- | 1          |
-- +------------+
-- Explanation: 
-- Product 1 was ordered in 2020 three times and in 2021 three times. Since it was ordered 
--three times in two consecutive years, we include it in the answer.
-- Product 2 was ordered one time in 2022. We do not include it in the answer.

DROP TABLE Orders;
Create table If Not Exists Orders (order_id int, product_id int, quantity int, purchase_date date);
INSERT INTO Orders (order_id, product_id, quantity, purchase_date)
VALUES 
    (1, 1, 7, '2020-03-16'),
    (2, 1, 4, '2020-12-02'),
    (3, 1, 7, '2020-05-10'),
    (4, 1, 6, '2021-12-23'),
    (5, 1, 5, '2021-05-21'),
    (6, 1, 6, '2021-10-11'),
    (7, 2, 6, '2022-10-11');

-- m1
WITH cte as(
    SELECT product_id,YEAR(purchase_date) as purchase_yr, COUNT(*)
    FROM Orders
    GROUP BY 1,2
    HAVING COUNT(*) >= 3
),
cte2 as(
    SELECT product_id,purchase_yr,
    LEAD(purchase_yr) OVER(PARTITION BY product_id ORDER BY purchase_yr) as nxt_yr
    FROM cte
)
SELECT DISTINCT product_id
FROM cte2
WHERE nxt_yr - purchase_yr = 1;

-----------------------------------------------------------------------------------------------------------------------------------

--m2

WITH product_order_info AS (
    SELECT YEAR(purchase_date) as year_purchase_date,
        product_id,
        COUNT(order_id) AS order_count
    FROM Orders
    GROUP BY 1,2
    HAVING order_count >= 3
),
order_year_info AS (
    SELECT product_id,
        year_purchase_date,
        LEAD(year_purchase_date) OVER(PARTITION BY product_id ORDER BY year_purchase_date) AS next_purchase_date
    FROM product_order_info
)
SELECT DISTINCT product_id AS product_id
FROM order_year_info 
WHERE next_purchase_date - year_purchase_date = 1;

-----------------------------------------------------------------------------------------------------------------------------------
--m3

WITH yearly_orders AS (
    SELECT
        product_id,
        YEAR(purchase_date) AS yr,
        COUNT(*) AS order_cnt
    FROM Orders
    GROUP BY product_id, YEAR(purchase_date)
    HAVING COUNT(*) >= 3
)
SELECT DISTINCT a.product_id
FROM yearly_orders a
JOIN yearly_orders b
  ON a.product_id = b.product_id
 AND b.yr = a.yr + 1;


