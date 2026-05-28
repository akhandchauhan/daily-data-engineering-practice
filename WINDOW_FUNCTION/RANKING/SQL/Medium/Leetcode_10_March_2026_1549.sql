-- 1549. The Most Recent Orders for Each Product
-- Description
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | name          | varchar |
-- +---------------+---------+
-- customer_id is the column with unique values for this table.
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
-- order_id is the column with unique values for this table.
-- This table contains information about the orders made by customer_id.
-- There will be no product ordered by the same user more than once in one day.
-- Table: Products
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- | price         | int     |
-- +---------------+---------+
-- product_id is the column with unique values for this table.
-- This table contains information about the Products.
-- Write a solution to find the most recent order(s) of each product.

-- Return the result table ordered by product_name in ascending order and 
-- in case of a tie by the product_id in ascending order. If there still a tie, order them by
-- order_id in ascending order.
-- The result format is in the following example.

-- Example 1:
-- Input: 
-- Customers table:
-- +-------------+-----------+
-- | customer_id | name      |
-- +-------------+-----------+
-- | 1           | Winston   |
-- | 2           | Jonathan  |
-- | 3           | Annabelle |
-- | 4           | Marwan    |
-- | 5           | Khaled    |
-- +-------------+-----------+
-- Orders table:
-- +----------+------------+-------------+------------+
-- | order_id | order_date | customer_id | product_id |
-- +----------+------------+-------------+------------+
-- | 1        | 2020-07-31 | 1           | 1          |
-- | 2        | 2020-07-30 | 2           | 2          |
-- | 3        | 2020-08-29 | 3           | 3          |
-- | 4        | 2020-07-29 | 4           | 1          |
-- | 5        | 2020-06-10 | 1           | 2          |
-- | 6        | 2020-08-01 | 2           | 1          |
-- | 7        | 2020-08-01 | 3           | 1          |
-- | 8        | 2020-08-03 | 1           | 2          |
-- | 9        | 2020-08-07 | 2           | 3          |
-- | 10       | 2020-07-15 | 1           | 2          |
-- +----------+------------+-------------+------------+
-- Products table:
-- +------------+--------------+-------+
-- | product_id | product_name | price |
-- +------------+--------------+-------+
-- | 1          | keyboard     | 120   |
-- | 2          | mouse        | 80    |
-- | 3          | screen       | 600   |
-- | 4          | hard disk    | 450   |
-- +------------+--------------+-------+
-- Output: 
-- +--------------+------------+----------+------------+
-- | product_name | product_id | order_id | order_date |
-- +--------------+------------+----------+------------+
-- | keyboard     | 1          | 6        | 2020-08-01 |
-- | keyboard     | 1          | 7        | 2020-08-01 |
-- | mouse        | 2          | 8        | 2020-08-03 |
-- | screen       | 3          | 3        | 2020-08-29 |
-- +--------------+------------+----------+------------+
-- Explanation: 
-- keyboard's most recent order is in 2020-08-01, it was ordered two times this day.
-- mouse's most recent order is in 2020-08-03, it was ordered only once this day.
-- screen's most recent order is in 2020-08-29, it was ordered only once this day.
-- The hard disk was never ordered and we do not include it in the result table.



-- Drop tables if they already exist
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO Customers (customer_id, name) VALUES
(1, 'Winston'),
(2, 'Jonathan'),
(3, 'Annabelle'),
(4, 'Marwan'),
(5, 'Khaled');

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price INT
);

INSERT INTO Products (product_id, product_name, price) VALUES
(1, 'keyboard', 120),
(2, 'mouse', 80),
(3, 'screen', 600),
(4, 'hard disk', 450);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Orders (order_id, order_date, customer_id, product_id) VALUES
(1, '2020-07-31', 1, 1),
(2, '2020-07-30', 2, 2),
(3, '2020-08-29', 3, 3),
(4, '2020-07-29', 4, 1),
(5, '2020-06-10', 1, 2),
(6, '2020-08-01', 2, 1),
(7, '2020-08-01', 3, 1),
(8, '2020-08-03', 1, 2),
(9, '2020-08-07', 2, 3),
(10, '2020-07-15', 1, 2);



WITH product_order_info AS
(
    SELECT 
            p.product_name,
            p.product_id,
            o.order_id,
            o.order_date,
            DENSE_RANK() OVER(PARTITION BY p.product_id 
                              ORDER BY o.order_date DESC
            ) AS product_order_rank
    FROM products p 
    JOIN Orders o 
    ON p.product_id = o.product_id
)
SELECT 
        product_name,
        product_id,
        order_id,
        order_date
FROM product_order_info
WHERE product_order_rank = 1
ORDER BY 
         product_name,
         product_id,
         order_id;


-----------------------------------------------------------------------------------------------------------
--m2

WITH latest_orders AS (
    SELECT
        product_id,
        MAX(order_date) AS max_date
    FROM Orders
    GROUP BY product_id
)
SELECT
    p.product_name,
    p.product_id,
    o.order_id,
    o.order_date
FROM Orders o
JOIN latest_orders l
    ON o.product_id = l.product_id
   AND o.order_date = l.max_date
JOIN Products p
    ON p.product_id = o.product_id
ORDER BY p.product_name, p.product_id, o.order_id;