-- 2372. Calculate the Influence of Each Salesperson 
-- Description
-- Table: Salesperson
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | salesperson_id | int     |
-- | name           | varchar |
-- +----------------+---------+
-- salesperson_id contains unique values.
-- Each row in this table shows the ID of a salesperson.
 
-- Table: Customer
-- +----------------+------+
-- | Column Name    | Type |
-- +----------------+------+
-- | customer_id    | int  |
-- | salesperson_id | int  |
-- +----------------+------+
-- customer_id contains unique values.
-- salesperson_id is a foreign key (reference column) from the Salesperson table.
-- Each row in this table shows the ID of a customer and the ID of the salesperson. 

-- Table: Sales
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | sale_id     | int  |
-- | customer_id | int  |
-- | price       | int  |
-- +-------------+------+
-- sale_id contains unique values.
-- customer_id is a foreign key (reference column) from the Customer table.
-- Each row in this table shows ID of a customer and the price they paid for the sale with sale_id.

-- Write a solution to report the sum of prices paid by the customers of each salesperson.
-- If a salesperson does not have any customers, the total value should be 0.

-- Return the result table in any order.
-- Example 1:

-- Input: 
-- Salesperson table:
-- +----------------+-------+
-- | salesperson_id | name  |
-- +----------------+-------+
-- | 1              | Alice |
-- | 2              | Bob   |
-- | 3              | Jerry |
-- +----------------+-------+
-- Customer table:
-- +-------------+----------------+
-- | customer_id | salesperson_id |
-- +-------------+----------------+
-- | 1           | 1              |
-- | 2           | 1              |
-- | 3           | 2              |
-- +-------------+----------------+
-- Sales table:
-- +---------+-------------+-------+
-- | sale_id | customer_id | price |
-- +---------+-------------+-------+
-- | 1       | 2           | 892   |
-- | 2       | 1           | 354   |
-- | 3       | 3           | 988   |
-- | 4       | 3           | 856   |
-- +---------+-------------+-------+
-- Output: 
-- +----------------+-------+-------+
-- | salesperson_id | name  | total |
-- +----------------+-------+-------+
-- | 1              | Alice | 1246  |
-- | 2              | Bob   | 1844  |
-- | 3              | Jerry | 0     |
-- +----------------+-------+-------+

-- Explanation: 
-- Alice is the salesperson for customers 1 and 2.
--   - Customer 1 made one purchase with 354.
--   - Customer 2 made one purchase with 892.
-- The total for Alice is 354 + 892 = 1246.
-- Bob is the salesperson for customers 3.
--   - Customer 1 made one purchase with 988 and 856.
-- The total for Bob is 988 + 856 = 1844.
-- Jerry is not the salesperson of any customer.
-- The total for Jerry is 0.=create table and insert values
-- Drop tables if they already exist
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Salesperson;

-- Create the Salesperson table
CREATE TABLE Salesperson (
    salesperson_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Insert data into Salesperson table
INSERT INTO Salesperson (salesperson_id, name)
VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Jerry');

-- Create the Customer table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    salesperson_id INT,
    FOREIGN KEY (salesperson_id) REFERENCES Salesperson(salesperson_id)
);

-- Insert data into Customer table
INSERT INTO Customer (customer_id, salesperson_id)
VALUES
(1, 1),
(2, 1),
(3, 2);

-- Create the Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    price INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Insert data into Sales table
INSERT INTO Sales (sale_id, customer_id, price)
VALUES
(1, 2, 892),
(2, 1, 354),
(3, 3, 988),
(4, 3, 856);

SELECT s.salesperson_id, s.name, COALESCE(SUM(sales.price), 0) AS total
FROM Salesperson s 
LEFT JOIN Customer c 
ON s.salesperson_id = c.salesperson_id 
LEFT JOIN Sales sales 
ON c.customer_id = sales.customer_id
GROUP BY s.salesperson_id, s.name;

------------------------------------------------------------------------------------------------------

-- m2
SELECT sp.salesperson_id,
       sp.name,
       IFNULL(SUM(price),0) AS total
FROM Salesperson sp 
LEFT JOIN customer c 
ON sp.salesperson_id = c.salesperson_id
LEFT JOIN Sales s 
ON s.customer_id = c.customer_id
GROUP BY sp.salesperson_id,
         sp.name;

------------------------------------------------------------------------------------------------------
-- m3 
WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM(price) AS total_spent
    FROM Sales
    GROUP BY customer_id
)
SELECT 
    sp.salesperson_id,
    sp.name,
    COALESCE(SUM(cs.total_spent), 0) AS total
FROM Salesperson sp
LEFT JOIN Customer c
    ON sp.salesperson_id = c.salesperson_id
LEFT JOIN customer_sales cs
    ON c.customer_id = cs.customer_id
GROUP BY sp.salesperson_id, sp.name;
