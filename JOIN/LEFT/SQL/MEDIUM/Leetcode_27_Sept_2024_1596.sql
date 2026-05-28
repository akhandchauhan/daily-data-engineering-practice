-- 1596. The Most Frequently Ordered Products for Each Customer
-- SQL Schema 
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | name          | varchar |
-- +---------------+---------+
-- customer_id is the primary key for this table.
-- This table contains information about the customers.
-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | customer_id   | int     |
-- | product_id    | int     |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- This table contains information about the orders made by customer_id.
-- No customer will order the same product more than once in a single day.
-- Table: Products
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- | price         | int     |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- This table contains information about the products.
-- Write an  SQL query to find the most frequently ordered product(s) for each customer.
-- The result table should have the product_id and product_name for each customer_id who 
--ordered at least one order. Return the result table in any order.
-- The query result format is in the following example:
-- Customers
-- +-------------+-------+
-- | customer_id | name  |
-- +-------------+-------+
-- | 1           | Alice |
-- | 2           | Bob   |
-- | 3           | Tom   |
-- | 4           | Jerry |
-- | 5           | John  |
-- +-------------+-------+
-- Orders
-- +----------+------------+-------------+------------+
-- | order_id | order_date | customer_id | product_id |
-- +----------+------------+-------------+------------+
-- | 1        | 2020-07-31 | 1           | 1          |
-- | 2        | 2020-07-30 | 2           | 2          |
-- | 3        | 2020-08-29 | 3           | 3          |
-- | 4        | 2020-07-29 | 4           | 1          |
-- | 5        | 2020-06-10 | 1           | 2          |
-- | 6        | 2020-08-01 | 2           | 1          |
-- | 7        | 2020-08-01 | 3           | 3          |
-- | 8        | 2020-08-03 | 1           | 2          |
-- | 9        | 2020-08-07 | 2           | 3          |
-- | 10       | 2020-07-15 | 1           | 2          |
-- +----------+------------+-------------+------------+

-- Products
-- +------------+--------------+-------+
-- | product_id | product_name | price |
-- +------------+--------------+-------+
-- | 1          | keyboard     | 120   |
-- | 2          | mouse        | 80    |
-- | 3          | screen       | 600   |
-- | 4          | hard disk    | 450   |
-- +------------+--------------+-------+
-- Result table:
-- +-------------+------------+--------------+
-- | customer_id | product_id | product_name |
-- +-------------+------------+--------------+
-- | 1           | 2          | mouse        |
-- | 2           | 1          | keyboard     |
-- | 2           | 2          | mouse        |
-- | 2           | 3          | screen       |
-- | 3           | 3          | screen       |
-- | 4           | 1          | keyboard     |
-- +-------------+------------+--------------+

-- Alice (customer 1) ordered the mouse three times and the keyboard one time, so the mouse is 
--the most frquently ordered product for them.
-- Bob (customer 2) ordered the keyboard, the mouse, and the screen one time, so those are the 
--most frquently ordered products for them.
-- Tom (customer 3) only ordered the screen (two times), so that is the most frquently ordered 
--product for them.
-- Jerry (customer 4) only ordered the keyboard (one time), so that is the most frquently ordered
-- product for them.
-- John (customer 5) did not order anything, so we do not include them in the result table.

drop table if exists Customers;
drop table if exists Orders;
drop table if exists Products;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price INT
);
INSERT INTO Customers (customer_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Tom'),
(4, 'Jerry'),
(5, 'John');

INSERT INTO Products (product_id, product_name, price) VALUES
(1, 'keyboard', 120),
(2, 'mouse', 80),
(3, 'screen', 600),
(4, 'hard disk', 450);

INSERT INTO Orders (order_id, order_date, customer_id, product_id) VALUES
(1, '2020-07-31', 1, 1),
(2, '2020-07-30', 2, 2),
(3, '2020-08-29', 3, 3),
(4, '2020-07-29', 4, 1),
(5, '2020-06-10', 1, 2),
(6, '2020-08-01', 2, 1),
(7, '2020-08-01', 3, 3),
(8, '2020-08-03', 1, 2),
(9, '2020-08-07', 2, 3),
(10, '2020-07-15', 1, 2);



--method 1

WITH cte AS
(
    SELECT customer_id, product_id, COUNT(*) AS num_ordered 
    FROM Orders
    GROUP BY customer_id, product_id
),
cte2 AS (
SELECT *, 
    FIRST_VALUE(num_ordered) OVER(PARTITION BY customer_id ORDER BY num_ordered DESC) AS most_frequent 
    FROM cte
)
SELECT c.customer_id, c.product_id, p.product_name 
FROM cte2 c
LEFT JOIN Products p
ON c.product_id = p.product_id
WHERE c.num_ordered = c.most_frequent

-- m2:
WITH cte as(
SELECT *,COUNT(product_id) OVER(PARTITION BY customer_id, product_id) as cnt
FROM  Orders o
LEFT JOIN products p
USING (product_id)
),cte2 as(
SELECT customer_id,product_id, product_name,cnt,MAX(cnt) OVER(PARTITION BY customer_id) as maxi
FROM cte
)
SELECT DISTINCT customer_id,product_id,product_name
FROM cte2
WHERE maxi = cnt;

-- m3:
SELECT customer_id, T.product_id, product_name
FROM(
    SELECT customer_id, product_id,
    RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(*) DESC ) AS RK
    FROM Orders o
    GROUP BY customer_id, product_id
) T
LEFT JOIN Products p 
on p.product_id = T.product_id
WHERE RK=1;


-- m4
WITH order_info as (
    SELECT customer_id,product_id,COUNT(product_id) as product_cnt
    FROM orders o 
    GROUP BY 1,2
)
SELECT oi.customer_id,oi.product_id,p.product_name
FROM order_info oi 
JOIN Products p 
ON oi.product_id = p.product_id
WHERE (customer_id,product_cnt) IN (SELECT customer_id,max(product_cnt) FROM order_info group by 1)
ORDER BY 1