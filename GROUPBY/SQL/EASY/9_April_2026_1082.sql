-- 1082. Sales Analysis I
-- Description
-- Table: Product
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | product_id   | int     |
-- | product_name | varchar |
-- | unit_price   | int     |
-- +--------------+---------+
-- product_id is the primary key (column with unique values) of this table.
-- Each row of this table indicates the name and the price of each product.

-- Table: Sales
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | seller_id   | int     |
-- | product_id  | int     |
-- | buyer_id    | int     |
-- | sale_date   | date    |
-- | quantity    | int     |
-- | price       | int     |
-- +-------------+---------+
-- This table can have repeated rows.
-- product_id is a foreign key (reference column) to the Product table.
-- Each row of this table contains some information about one sale.
 
-- Write a solution that reports the best seller by total sales price, 
-- If there is a tie, report them all.

-- Return the result table in any order.

-- The result format is in the following example.
-- Example 1:

-- Input: 
-- Product table:
-- +------------+--------------+------------+
-- | product_id | product_name | unit_price |
-- +------------+--------------+------------+
-- | 1          | S8           | 1000       |
-- | 2          | G4           | 800        |
-- | 3          | iPhone       | 1400       |
-- +------------+--------------+------------+
-- Sales table:
-- +-----------+------------+----------+------------+----------+-------+
-- | seller_id | product_id | buyer_id | sale_date  | quantity | price |
-- +-----------+------------+----------+------------+----------+-------+
-- | 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
-- | 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
-- | 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
-- | 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
-- +-----------+------------+----------+------------+----------+-------+
-- Output: 
-- +-------------+
-- | seller_id   |
-- +-------------+
-- | 1           |
-- | 3           |
-- +-------------+
-- Explanation: Both sellers with id 1 and 3 sold products with the most 
-- total price of 2800.

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Product;

-- Create Product table
CREATE TABLE Product (
    product_id INT,
    product_name VARCHAR(50),
    unit_price INT
);

-- Insert into Product
INSERT INTO Product (product_id, product_name, unit_price) VALUES
(1, 'S8', 1000),
(2, 'G4', 800),
(3, 'iPhone', 1400);

-- Create Sales table
CREATE TABLE Sales (
    seller_id INT,
    product_id INT,
    buyer_id INT,
    sale_date DATE,
    quantity INT,
    price INT
);

-- Insert into Sales
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) VALUES
(1, 1, 1, '2019-01-21', 2, 2000),
(1, 2, 2, '2019-02-17', 1, 800),
(2, 2, 3, '2019-06-02', 1, 800),
(3, 3, 4, '2019-05-13', 2, 2800);

-- m1 
WITH seller_sales_info AS (
    SELECT 
            seller_id,
            SUM(price) AS total_price
    FROM Sales
    GROUP BY seller_id
)
SELECT seller_id
FROM seller_sales_info
WHERE total_price = (
    SELECT MAX(total_price)
    FROM seller_sales_info
);

----------------------------------------------------------------------------------------
-- m2
WITH seller_ranked AS (
    SELECT 
            seller_id,
            DENSE_RANK() OVER(
                ORDER BY SUM(price) DESC
            ) AS total_price_ranked
    FROM Sales
    GROUP BY seller_id
)
SELECT 
        seller_id
FROM seller_ranked 
WHERE total_price_ranked = 1 ;

----------------------------------------------------------------------------------------
-- m3
WITH sales_info AS (
    SELECT 
            seller_id,
            SUM(price) AS total_price,
            MAX(SUM(price)) OVER() AS max_price
    FROM Sales
    GROUP BY seller_id
)
SELECT 
        seller_id
FROM sales_info
WHERE total_price =  max_price;


-- “Price column already represents total sale value (quantity * unit_price), 
-- so no need to recompute.”