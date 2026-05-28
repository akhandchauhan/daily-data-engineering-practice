-- 1511. Customer Order Frequency
-- Description
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | name          | varchar |
-- | country       | varchar |
-- +---------------+---------+
-- customer_id is the primary key for this table.
-- This table contains information about the customers in the company.
-- Table: Product
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | description   | varchar |
-- | price         | int     |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- This table contains information on the products in the company.
-- price is the product cost.
-- Table: Order
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | product_id    | int     |
-- | order_date    | date    |
-- | quantity      | int     |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- This table contains information on customer orders.
-- customer_id is the id of the customer who bought "quantity" products with id "product_id".
-- Order_date is the date in format ('YYYY-MM-DD') when the order was shipped.
-- Write an  SQL query to report the customer_id and customer_name of customers
-- who have spent at least 100 in each month of June and July 2020.
-- Return the result table in any order.
-- Input: 
-- Customers table:
-- +--------------+-----------+-------------+
-- | customer_id  | name      | country     |
-- +--------------+-----------+-------------+
-- | 1            | Winston   | USA         |
-- | 2            | Jonathan  | Peru        |
-- | 3            | Moustafa  | Egypt       |
-- +--------------+-----------+-------------+
-- Product table:
-- +--------------+-------------+-------------+
-- | product_id   | description | price       |
-- +--------------+-------------+-------------+
-- | 10           | LC Phone    | 300         |
-- | 20           | LC T-Shirt  | 10          |
-- | 30           | LC Book     | 45          |
-- | 40           | LC Keychain | 2           |
-- +--------------+-------------+-------------+
-- Orders table:
-- +--------------+-------------+-------------+-------------+-----------+
-- | order_id     | customer_id | product_id  | order_date  | quantity  |
-- +--------------+-------------+-------------+-------------+-----------+
-- | 1            | 1           | 10          | 2020-06-10  | 1         |
-- | 2            | 1           | 20          | 2020-07-01  | 1         |
-- | 3            | 1           | 30          | 2020-07-08  | 2         |
-- | 4            | 2           | 10          | 2020-06-15  | 2         |
-- | 5            | 2           | 40          | 2020-07-01  | 10        |
-- | 6            | 3           | 20          | 2020-06-24  | 2         |
-- | 7            | 3           | 30          | 2020-06-25  | 2         |
-- | 9            | 3           | 30          | 2020-05-08  | 3         |
-- +--------------+-------------+-------------+-------------+-----------+

-- Output: 
-- +--------------+------------+
-- | customer_id  | name       |  
-- +--------------+------------+
-- | 1            | Winston    |
-- +--------------+------------+
-- Explanation: 
-- Winston spent 300 (300 * 1) in June and 100 ( 10 * 1 + 45 * 2) in July 2020.
-- Jonathan spent 600 (300 * 2) in June and 20 ( 2 * 10) in July 2020.


-- Drop tables if they already exist
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customers;
-- drop table Sales;
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(50)
);

-- Insert values into Customers table
INSERT INTO Customers (customer_id, name, country)
VALUES (1, 'Winston', 'USA'),
       (2, 'Jonathan', 'Peru'),
       (3, 'Moustafa', 'Egypt');

-- Create Product table
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    description VARCHAR(100),
    price INT
);

-- Insert values into Product table
INSERT INTO Product (product_id, description, price)
VALUES (10, 'LC Phone', 300),
       (20, 'LC T-Shirt', 10),
       (30, 'LC Book', 45),
       (40, 'LC Keychain', 2);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Insert values into Orders table
INSERT INTO Orders (order_id, customer_id, product_id, order_date, quantity)
VALUES (1, 1, 10, '2020-06-10', 1),
       (2, 1, 20, '2020-07-01', 1),
       (3, 1, 30, '2020-07-08', 2),
       (4, 2, 10, '2020-06-15', 2),
       (5, 2, 40, '2020-07-01', 10),
       (6, 3, 20, '2020-06-24', 2),
       (7, 3, 30, '2020-06-25', 2),
       (9, 3, 30, '2020-05-08', 3);

-- m1 not working 
SELECT c.customer_id,c.NAME
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
LEFT JOIN Product p
ON p.product_id = o.product_id
WHERE YEAR(o.order_date) = 2020 AND MONTH(o.order_date) IN (6,7) 
GROUP BY 1,2
HAVING SUM(quantity*price) >= 100 AND COUNT(DISTINCT MONTH(o.order_date)) =2;

---------------------------------------------------------------------------------------
--method 2
SELECT customer_id, name
FROM Orders
JOIN Product 
USING (product_id)
JOIN Customers 
USING (customer_id)
WHERE YEAR(order_date) = 2020
GROUP BY 1
HAVING SUM(IF(MONTH(order_date) = 6, quantity * price, 0)) >= 100
AND SUM(IF(MONTH(order_date) = 7, quantity * price, 0)) >= 100;

-----------------------------------------------------------------------------------------
-- method3
WITH cte AS (
    SELECT 
        o.customer_id, 
        YEAR(o.order_date) AS year, 
        MONTH(o.order_date) AS month, 
        SUM(o.quantity * p.price) AS spend
    FROM Orders o
    LEFT JOIN Product p ON o.product_id = p.product_id
    WHERE YEAR(o.order_date) = 2020
    AND MONTH(o.order_date) IN (6, 7)
    GROUP BY o.customer_id, YEAR(o.order_date), MONTH(o.order_date)
),
cte2 AS (
    SELECT customer_id
    FROM cte
    WHERE spend >= 100
    GROUP BY customer_id
    HAVING COUNT(Month) = 2
)
SELECT c.customer_id, Cu.name
FROM cte2 c 
LEFT JOIN Customers Cu ON c.customer_id = Cu.customer_id;

    
----------------------------------------------------------------------------------------
-- m4 
WITH order_month_info AS (
    SELECT 
            o.customer_id,
            MONTH(o.order_date) AS order_month,
            SUM(o.quantity * p.price) AS total_price
    FROM Orders o 
    JOIN Product p 
    ON o.product_id = p.product_id
    AND o.order_date >= '2020-06-01'
    AND o.order_date < '2020-08-01'
    GROUP BY o.customer_id,
            MONTH(o.order_date)
    HAVING SUM(o.quantity * p.price) >=100
)
SELECT 
    c.customer_id,
    c.name
FROM order_month_info omi 
JOIN Customers c 
ON omi.customer_id = c.customer_id
GROUP BY 
    c.customer_id,
    c.name
HAVING COUNT(order_month) = 2;