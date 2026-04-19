-- 1083. Sales Analysis II  
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
-- This table might have repeated rows.
-- product_id is a foreign key (reference column) to the Product table.
-- buyer_id is never NULL. 
-- sale_date is never NULL. 
-- Each row of this table contains some information about one sale.

-- Write a solution to report the buyers who have bought S8 but not iPhone.
-- Note that S8 and iPhone are products presented in the Product table.
-- Return the result table in any order.

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
-- | 2         | 1          | 3        | 2019-06-02 | 1        | 800   |
-- | 3         | 3          | 3        | 2019-05-13 | 2        | 2800  |
-- +-----------+------------+----------+------------+----------+-------+
-- Output: 
-- +-------------+
-- | buyer_id    |
-- +-------------+
-- | 1           |
-- +-------------+
-- Explanation: The buyer with id 1 bought an S8 but did not buy an iPhone. 
-- The buyer with id 3 bought both.
drop table Product;
drop table Sales;

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    unit_price INT
);
CREATE TABLE Sales (
    seller_id INT,
    product_id INT,
    buyer_id INT,
    sale_date DATE,
    quantity INT,
    price INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
INSERT INTO Product (product_id, product_name, unit_price) VALUES
(1, 'S8', 1000),
(2, 'G4', 800),
(3, 'iPhone', 1400);
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) VALUES
(1, 1, 1, '2019-01-21', 2, 2000),
(1, 2, 2, '2019-02-17', 1, 800),
(2, 1, 3, '2019-06-02', 1, 800),
(3, 3, 3, '2019-05-13', 2, 2800);

SELECT buyer_id
FROM Sales
JOIN Product USING (product_id)
GROUP BY 1
HAVING SUM(product_name = 'S8') > 0 AND SUM(product_name = 'iPhone') = 0;

--------------------------------------------------------------------------------------
--m2
WITH cte AS
(
    SELECT s.*, p.product_name
    FROM Sales s
    JOIN Product p
    ON s.product_id = p.product_id
)
SELECT DISTINCT buyer_id
FROM cte
WHERE product_name = 'S8'
AND buyer_id NOT IN (SELECT DISTINCT buyer_id
FROM cte WHERE product_name = 'iPhone');

--------------------------------------------------------------------------------------
--m3
WITH buyer_info AS (
SELECT  
        s.buyer_id,
        COUNT(
            CASE 
                WHEN p.product_name = 'S8' 
                THEN 1 
            END) AS s8_count,
        COUNT(
                CASE 
                    WHEN p.product_name = 'iPhone' 
                    THEN 1 
            END) AS iphone_count
FROM Sales s 
JOIN Product p
ON s.product_id = p.product_id
GROUP BY s.buyer_id
) 
SELECT buyer_id
FROM buyer_info
WHERE  s8_count > 0  AND
       iphone_count = 0 ;