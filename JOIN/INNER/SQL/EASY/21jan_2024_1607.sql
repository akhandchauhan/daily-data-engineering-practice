-- 1607. Sellers With No Sales
-- SQL Schema 
-- Table: Customer
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | customer_name | varchar |
-- +---------------+---------+
-- customer_id is the primary key for this table.
-- Each row of this table contains the information of each customer in the WebStore.
-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | sale_date     | date    |
-- | order_cost    | int     |
-- | customer_id   | int     |
-- | seller_id     | int     |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- Each row of this table contains all orders made in the webstore.
-- sale_date is the date when the transaction was made between the 
--customer (customer_id) and the seller (seller_id).
-- Table: Seller
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | seller_id     | int     |
-- | seller_name   | varchar |
-- +---------------+---------+
-- seller_id is the primary key for this table.
-- Each row of this table contains the information of each seller.
-- Write an  SQL query to report the names of all sellers who did not
-- make any sales in 2020.
-- Return the result table ordered by seller_name in ascending order.

-- Customer table:
-- +--------------+---------------+
-- | customer_id  | customer_name |
-- +--------------+---------------+
-- | 101          | Alice         |
-- | 102          | Bob           |
-- | 103          | Charlie       |
-- +--------------+---------------+
-- Orders table:
-- +-------------+------------+--------------+-------------+-------------+
-- | order_id    | sale_date  | order_cost   | customer_id | seller_id   |
-- +-------------+------------+--------------+-------------+-------------+
-- | 1           | 2020-03-01 | 1500         | 101         | 1           |
-- | 2           | 2020-05-25 | 2400         | 102         | 2           |
-- | 3           | 2019-05-25 | 800          | 101         | 3           |
-- | 4           | 2020-09-13 | 1000         | 103         | 2           |
-- | 5           | 2019-02-11 | 700          | 101         | 2           |
-- +-------------+------------+--------------+-------------+-------------+
-- Seller table:
-- +-------------+-------------+
-- | seller_id   | seller_name |
-- +-------------+-------------+
-- | 1           | Daniel      |
-- | 2           | Elizabeth   |
-- | 3           | Frank       |
-- +-------------+-------------+
-- Result table:
-- +-------------+
-- | seller_name |
-- +-------------+
-- | Frank       |
-- +-------------+
-- Daniel made 1 sale in March 2020.
-- Elizabeth made 2 sales in 2020 and 1 sale in 2019.
-- Frank made 1 sale in 2019 but no sales in 2020.

-- Drop tables if they exist
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Seller;

-- Create the Customer table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);

-- Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    sale_date DATE,
    order_cost INT,
    customer_id INT,
    seller_id INT
);

-- Create the Seller table
CREATE TABLE Seller (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(255)
);

-- Insert data into the Customer table
INSERT INTO Customer (customer_id, customer_name)
VALUES
(101, 'Alice'),
(102, 'Bob'),
(103, 'Charlie');

-- Insert data into the Orders table
INSERT INTO Orders (order_id, sale_date, order_cost, customer_id, seller_id)
VALUES
(1, '2020-03-01', 1500, 101, 1),
(2, '2020-05-25', 2400, 102, 2),
(3, '2019-05-25', 800, 101, 3),
(4, '2020-09-13', 1000, 103, 2),
(5, '2019-02-11', 700, 101, 2);

-- Insert data into the Seller table
INSERT INTO Seller (seller_id, seller_name)
VALUES
(1, 'Daniel'),
(2, 'Elizabeth'),
(3, 'Frank');

-- m1 
WITH cte as(
    SELECT s.seller_id
    FROM Seller s
    LEFT JOIN Orders o
    ON s.seller_id = o.seller_id
    WHERE YEAR(sale_date) = 2020
)
SELECT seller_name
FROM Seller
WHERE seller_id NOT IN (SELECT seller_id FROM cte);

--------------------------------------------------------------------------------------------
-- m2
SELECT s.seller_name
FROM Seller s
LEFT JOIN Orders o
ON s.seller_id = o.seller_id
GROUP BY s.seller_name
HAVING SUM(YEAR(sale_date)=2020) = 0;

--------------------------------------------------------------------------------------------
-- m3 
SELECT s.seller_name
FROM Seller s
LEFT JOIN Orders o
ON s.seller_id = o.seller_id AND YEAR(o.sale_date) = 2020
WHERE o.seller_id IS NULL
ORDER BY s.seller_name;

--------------------------------------------------------------------------------------------
-- m4
WITH seller_info AS (
SELECT 
        s.seller_id,
        s.seller_name
FROM Seller s 
LEFT JOIN Orders o 
ON s.seller_id = o.seller_id
AND YEAR(sale_date) = 2020
GROUP BY s.seller_id,
        s.seller_name
HAVING COUNT(
            CASE WHEN o.seller_id IS NULL 
            THEN 1 
            END
        ) = COUNT(s.seller_id)
)
SELECT 
        seller_name
FROM seller_info
ORDER BY seller_name;

--------------------------------------------------------------------------------------------
-- m5

WITH sales_2020_info AS (
    SELECT seller_id
    FROM Orders
    WHERE YEAR(sale_date) = 2020
    GROUP BY seller_id
)
SELECT
        s.seller_name
FROM seller s
LEFT JOIN sales_2020_info si 
ON s.seller_id = si.seller_id 
WHERE si.seller_id IS NULL
ORDER BY s.seller_name;

--------------------------------------------------------------------------------------------
-- m6
WITH cte AS (
    SELECT DISTINCT seller_id
    FROM Orders
    WHERE YEAR(sale_date) = 2020
)
SELECT seller_name
FROM Seller
WHERE seller_id NOT IN (SELECT seller_id FROM cte)
ORDER BY seller_name;