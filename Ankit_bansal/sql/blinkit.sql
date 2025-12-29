
-- Question:
-- You are given an Orders table with the following columns:

-- Customer_id : ID of the customer
-- Order_date  : Date when the order was placed
-- coupon_code : Coupon code used in the order
--               (can be NULL if no coupon was applied)

-- Write an SQL query to return the number of new customers
-- who satisfy all of the following conditions:

-- 1. They place orders in each of their first 3 consecutive months
--    since their very first order.

-- 2. The number of orders in the second month is exactly double
--    the number of orders in the first month.

-- 3. The number of orders in the third month is exactly triple
--    the number of orders in the first month.

-- 4. Their last order (latest by date) was placed with a coupon code
--    (i.e., coupon_code IS NOT NULL).

DROP TABLE Orders;

CREATE TABLE orders (
    customer_id INT,
    order_date DATE,
    coupon_code VARCHAR(50)
);


INSERT INTO Orders (customer_id, order_date, coupon_code)
VALUES
-- Customer 1
(1, '2025-01-10', NULL),
(1, '2025-02-05', NULL),
(1, '2025-02-20', NULL),
(1, '2025-03-01', NULL),
(1, '2025-03-10', NULL),
(1, '2025-03-15', 'DISC10'),
-- Customer 2
(2, '2025-02-02', NULL),
(2, '2025-02-05', NULL),
(2, '2025-03-05', NULL),
(2, '2025-03-18', NULL),
(2, '2025-03-20', NULL),
(2, '2025-03-22', NULL),
(2, '2025-04-02', NULL),
(2, '2025-04-10', NULL),
(2, '2025-04-15', 'DISC20'),
(2, '2025-04-16', NULL),
(2, '2025-04-18', NULL),
(2, '2025-04-20', 'DISC20'),
-- Customer 3
(3, '2025-03-05', NULL),
(3, '2025-04-10', NULL),
(3, '2025-05-15', 'DISC30'),
-- Customer 4
(4, '2025-02-01', NULL),
(4, '2025-04-05', 'DISC40'),
-- Customer 5
(5, '2025-01-03', NULL),
(5, '2025-02-05', NULL),
(5, '2025-02-15', NULL),
(5, '2025-03-01', NULL),
(5, '2025-03-08', 'DISC50'),
(5, '2025-03-20', NULL),
-- Customer 6
(6, '2025-01-05', NULL),
(6, '2025-03-02', NULL),
(6, '2025-03-15', NULL),
(6, '2025-05-05', NULL),
(6, '2025-05-10', NULL),
(6, '2025-05-25', 'DISC60');


-- m1 

WITH cust_order_info as (
    SELECT *,
        DATE_FORMAT(order_date,'%Y-%m') as format_order_dt,
        DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY DATE_FORMAT(order_date,'%Y-%m')) as rnk,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS rnk2
    FROM Orders
),
month_check AS (
    SELECT customer_id,
           MIN(format_order_dt) as month1,
           MAX(CASE WHEN rnk = 2 THEN format_order_dt END) as month2,
           MAX(CASE WHEN rnk = 3 THEN format_order_dt END) as month3,
           SUM(CASE WHEN rnk = 1 THEN 1 ELSE 0 END) AS first_mth_order_cnt,
           SUM(CASE WHEN rnk = 2 THEN 1 ELSE 0 END) AS second_mth_order_cnt,
           SUM(CASE WHEN rnk = 3 THEN 1 ELSE 0 END) AS third_mth_order_cnt,
           MAX(CASE WHEN rnk2 = 1 THEN coupon_code END) AS coupon_used
    FROM cust_order_info
    GROUP BY customer_id
)
SELECT COUNT(*) AS new_customer_count
FROM month_check
WHERE DATE_FORMAT(DATE_ADD(STR_TO_DATE(CONCAT(month1, '-01'), '%Y-%m-%d'), INTERVAL 1 MONTH), '%Y-%m') = month2
  AND DATE_FORMAT(DATE_ADD(STR_TO_DATE(CONCAT(month2, '-01'), '%Y-%m-%d'), INTERVAL 1 MONTH), '%Y-%m') = month3
  AND first_mth_order_cnt * 2 = second_mth_order_cnt
  AND first_mth_order_cnt * 3 = third_mth_order_cnt
  AND coupon_used IS NOT NULL;

------------------------------------------------------------------------------------------------------------------------------

-- m2 
WITH cte AS (
    SELECT customer_id, coupon_code, order_date,
        DATE_FORMAT(order_date, '%Y-%m-01') AS order_month_first_day,  -- Add '-01' to make it a valid date
        MIN(order_date) OVER(PARTITION BY customer_id) AS first_order_date,  -- Use actual date
        LAST_VALUE(coupon_code) OVER(PARTITION BY customer_id ORDER BY order_date 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_coupon
    FROM orders
),
cte2 AS (
    SELECT *,
        TIMESTAMPDIFF(MONTH, 
            DATE_FORMAT(first_order_date, '%Y-%m-01'), 
            order_month_first_day) + 1 AS month_number
    FROM cte
    WHERE last_coupon IS NOT NULL
),
cte3 AS (
    SELECT customer_id,
        SUM(CASE WHEN month_number = 1 THEN 1 ELSE 0 END) AS count_first_month,
        SUM(CASE WHEN month_number = 2 THEN 1 ELSE 0 END) AS count_second_month,
        SUM(CASE WHEN month_number = 3 THEN 1 ELSE 0 END) AS count_third_month
    FROM cte2
    WHERE month_number IN (1, 2, 3)
    GROUP BY customer_id
)
SELECT COUNT(*) AS no_of_customers
FROM cte3
WHERE count_second_month = 2 * count_first_month 
  AND count_third_month = 3 * count_first_month;



