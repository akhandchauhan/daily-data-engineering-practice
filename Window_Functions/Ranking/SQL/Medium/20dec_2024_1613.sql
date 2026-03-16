-- 1613. Find the Missing IDs 
-- Description
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | customer_name | varchar |
-- +---------------+---------+
-- customer_id is the column with unique values for this table.
-- Each row of this table contains the name and the id customer.
-- Write a solution to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but 
--are in the range between 1 and the maximum customer_id present in the table.
-- Notice that the maximum customer_id will not exceed 100.
-- Return the result table ordered by ids in ascending order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Alice         |
-- | 4           | Bob           |
-- | 5           | Charlie       |
-- +-------------+---------------+
-- Output: 
-- +-----+
-- | ids |
-- +-----+
-- | 2   |
-- | 3   |
-- +-----+
-- Explanation: 
-- The maximum customer_id present
--  in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.
DROP TABLE Orders;
DROP TABLE Customers;
-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);
-- Insert data into the Customers table
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(4, 'Bob'),
(5, 'Charlie');


WITH RECURSIVE NumberSeries AS (
    SELECT 1 AS ids
    UNION ALL
    SELECT ids + 1
    FROM NumberSeries
    WHERE ids < (SELECT MAX(customer_id) FROM Customers)
)
SELECT ids
FROM NumberSeries
WHERE ids NOT IN (SELECT customer_id FROM Customers)
ORDER BY ids;


----------------------------------------------------------------------------------------------------------
-- m2
WITH recursive customer_info AS (
    SELECT 
        1 as id
    UNION ALL
    SELECT id+1 AS id
    FROM customer_info
    WHERE id < (SELECT MAX(customer_id) FROM Customers)
)
SELECT ci.id 
FROM customer_info ci 
LEFT JOIN customers c 
ON c.customer_id = ci.id
WHERE c.customer_id IS NULL
ORDER BY ci.id;