-- 1398. Customers Who Bought Products A and B but Not C
-- Description
-- Table: Customers
-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | customer_id         | int     |
-- | customer_name       | varchar |
-- +---------------------+---------+
-- customer_id is the column with unique values for this table.
-- customer_name is the name of the customer.
-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- order_id is the column with unique values for this table.
-- customer_id is the id of the customer who bought the product "product_name".

-- Write a solution to report the customer_id and customer_name of customers who
-- bought products "A","B" but did not buy the product "C"
-- since we want to recommend them to purchase this product.
-- Return the result table ordered by customer_id.

-- Example 1:
-- Input: 
-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Diana         |
-- | 3           | Elizabeth     |
-- | 4           | Jhon          |
-- +-------------+---------------+
-- Orders table:
-- +------------+--------------+---------------+
-- | order_id   | customer_id  | product_name  |
-- +------------+--------------+---------------+
-- | 10         |     1        |     A         |
-- | 20         |     1        |     B         |
-- | 30         |     1        |     D         |
-- | 40         |     1        |     C         |
-- | 50         |     2        |     A         |
-- | 60         |     3        |     A         |
-- | 70         |     3        |     B         |
-- | 80         |     3        |     D         |
-- | 90         |     4        |     C         |
-- +------------+--------------+---------------+
-- Output: 
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 3           | Elizabeth     |
-- +-------------+---------------+
-- Explanation: Only the customer_id with id 3 bought the product A and B 
-- but not the product C.

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100)
);

INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Daniel'),
(2, 'Diana'),
(3, 'Elizabeth'),
(4, 'Jhon');

INSERT INTO Orders (order_id, customer_id, product_name) VALUES
(10, 1, 'A'),
(20, 1, 'B'),
(30, 1, 'D'),
(40, 1, 'C'),
(50, 2, 'A'),
(60, 3, 'A'),
(70, 3, 'B'),
(80, 3, 'D'),
(90, 4, 'C');

SELECT 
      o.customer_id,
      c.customer_name
FROM Orders o 
JOIN Customers c 
ON o.customer_id = c.customer_id
GROUP BY o.customer_id,
         c.customer_name
HAVING 
        SUM(CASE WHEN o.product_name = 'A' THEN 1 ELSE 0 END) > 0 AND 
        SUM(CASE WHEN o.product_name = 'B' THEN 1 ELSE 0 END) > 0 AND 
        SUM(CASE WHEN o.product_name = 'C' THEN 1 ELSE 0 END) = 0
ORDER BY c.customer_id ;