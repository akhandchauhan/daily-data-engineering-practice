-- 2362. Generate the Invoice
-- Description
-- Table: Products
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | product_id  | int  |
-- | price       | int  |
-- +-------------+------+
-- product_id is the primary key for this table.
-- Each row in this table shows the ID of a product and the price of one unit.
-- Table: Purchases
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | invoice_id  | int  |
-- | product_id  | int  |
-- | quantity    | int  |
-- +-------------+------+
-- (invoice_id, product_id) is the primary key for this table.
-- Each row in this table shows the quantity ordered from one product in an invoice. 
-- Write an  SQL query to show the details of the invoice with the highest price. 
-- If two or more invoices have the same price, return the details of the one 
-- with the smallest invoice_id.
-- Return the result table in any order.
-- The query result format is shown in the following example.
-- Example 1:
-- Input: 
-- Products table:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 1          | 100   |
-- | 2          | 200   |
-- +------------+-------+
-- Purchases table:
-- +------------+------------+----------+
-- | invoice_id | product_id | quantity |
-- +------------+------------+----------+
-- | 1          | 1          | 2        |
-- | 3          | 2          | 1        |
-- | 2          | 2          | 3        |
-- | 2          | 1          | 4        |
-- | 4          | 1          | 10       |
-- +------------+------------+----------+
-- Output: 
-- +------------+----------+-------+
-- | product_id | quantity | price |
-- +------------+----------+-------+
-- | 2          | 3        | 600   |
-- | 1          | 4        | 400   |
-- +------------+----------+-------+
-- Explanation: 
-- Invoice 1: price = (2 * 100) = $200
-- Invoice 2: price = (4 * 100) + (3 * 200) = $1000
-- Invoice 3: price = (1 * 200) = $200
-- Invoice 4: price = (10 * 100) = $1000

-- The highest price is $1000, and the invoices with the highest prices are 2 and 4.
-- We return the details of the one with the smallest ID, which is invoice 2.

DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Purchases;
Create table If Not Exists Products (product_id int, price int);
Create table If Not Exists Purchases (invoice_id int, product_id int, quantity int);
Truncate table Products;
insert into Products (product_id, price) values ('1', '100'),('2', '200');
Truncate table Purchases;

INSERT INTO Purchases (invoice_id, product_id, quantity) VALUES
('1', '1', '2'),
('3', '2', '1'),
('2', '2', '3'),
('2', '1', '4'),
('4', '1', '10');

-- method 1
WITH cte as(
SELECT invoice_id, SUM(quantity * price) as total,
RANK() OVER(ORDER BY SUM(quantity * price) DESC, invoice_id ) as rnk
FROM Purchases p
JOIN Products pr
ON p.product_id = pr.product_id
GROUP BY invoice_id
ORDER BY total DESC, invoice_id
)
SELECT P.product_id, quantity, price * quantity as price
FROM Purchases p
JOIN Products pr
ON p.product_id = pr.product_id
WHERE invoice_id IN (SELECT invoice_id FROM cte where rnk = 1);

----------------------------------------------------------------------------------------
-- m2
WITH cte as(SELECT invoice_id,SUM(price*quantity) as sum_p_q
FROM Products p 
LEFT JOIN Purchases pu
ON p.product_id = pu.product_id
GROUP BY invoice_id
ORDER BY 2 desc,1
LIMIT 1
)
SELECT p.product_id, quantity, price
FROM Products p 
LEFT JOIN Purchases pu
ON p.product_id = pu.product_id
WHERE invoice_id in (SELECT invoice_id FROM cte);

----------------------------------------------------------------------------------------
-- m3
WITH invoice_info AS (
    SELECT 
            pu.invoice_id,
            SUM(pu.quantity * pr.price) AS price
    FROM Purchases pu 
    JOIN Products pr 
    ON pu.product_id = pr.product_id
    GROUP BY pu.invoice_id
    ORDER BY price DESC, pu.invoice_id
    LIMIT 1
)
SELECT 
        pu.product_id,
        pu.quantity,
        pu.quantity * pr.price AS price
FROM Purchases pu 
JOIN invoice_info io
ON pu.invoice_id = io.invoice_id
JOIN Products pr 
ON pr.product_id = pu.product_id;

----------------------------------------------------------------------------------------
-- m4
WITH invoice_info AS (
    SELECT 
        pu.invoice_id,
        pu.product_id,
        pu.quantity,
        pu.quantity * pr.price AS price,
        SUM(pu.quantity * pr.price) OVER(PARTITION BY pu.invoice_id) AS invoice_price
    FROM Purchases pu 
    JOIN Products pr 
    ON pu.product_id = pr.product_id
    ORDER BY price DESC, pu.invoice_id
),
invoices_ranked AS(
    SELECT *,
        DENSE_RANK() OVER(
            ORDER BY invoice_price DESC, invoice_id
        ) AS invoice_rank
    FROM invoice_info 
)
SELECT
    product_id,
    quantity,
    price
FROM invoices_ranked
WHERE invoice_rank = 1
;