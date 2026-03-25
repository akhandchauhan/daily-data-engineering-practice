-- 2324. Product Sales Analysis IV 
-- Description
-- Table: Sales
-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | sale_id     | int   |
-- | product_id  | int   |
-- | user_id     | int   |
-- | quantity    | int   |
-- +-------------+-------+
-- sale_id contains unique values.
-- product_id is a foreign key (reference column) to Product table.
-- Each row of this table shows the ID of the product and the quantity
-- purchased by a user.
-- Table: Product
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | product_id  | int  |
-- | price       | int  |
-- +-------------+------+
-- product_id contains unique values.
-- Each row of this table indicates the price of each product.
-- Write a solution that reports for each user the product id on which the
-- user spent the most money. In case the same user spent the most money on 
--two or more products, report all of them.
-- Return the resulting table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Sales table:
-- +---------+------------+---------+----------+
-- | sale_id | product_id | user_id | quantity |
-- +---------+------------+---------+----------+
-- | 1       | 1          | 101     | 10       |
-- | 2       | 3          | 101     | 7        |
-- | 3       | 1          | 102     | 9        |
-- | 4       | 2          | 102     | 6        |
-- | 5       | 3          | 102     | 10       |
-- | 6       | 1          | 102     | 6        |
-- +---------+------------+---------+----------+
-- Product table:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 1          | 10    |
-- | 2          | 25    |
-- | 3          | 15    |
-- +------------+-------+
-- Output: 
-- +---------+------------+
-- | user_id | product_id |
-- +---------+------------+
-- | 101     | 3          |
-- | 102     | 1          |
-- | 102     | 2          |
-- | 102     | 3          |
-- +---------+------------+ 
-- Explanation: 
-- User 101:
--     - Spent 10 * 10 = 100 on product 1.
--     - Spent 7 * 15 = 105 on product 3.
-- User 101 spent the most money on product 3.
-- User 102:
--     - Spent (9 + 6) * 10 = 150 on product 1.
--     - Spent 6 * 25 = 150 on product 2.
--     - Spent 10 * 15 = 150 on product 3.
-- User 102 spent the most money on products 1, 2, and 3.

DROP TABLE Product;
DROP TABLE Sales;
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    price INT
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    user_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
-- Inserting data into Product table
INSERT INTO Product (product_id, price) VALUES
(1, 10),
(2, 25),
(3, 15);

-- Inserting data into Sales table
INSERT INTO Sales (sale_id, product_id, user_id, quantity) VALUES
(1, 1, 101, 10),
(2, 3, 101, 7),
(3, 1, 102, 9),
(4, 2, 102, 6),
(5, 3, 102, 10),
(6, 1, 102, 6);

-- m1
WITH T AS (
        SELECT user_id, product_id,
            RANK() OVER (PARTITION BY user_id
                ORDER BY SUM(quantity * price) DESC
            ) AS rk
        FROM
            Sales
            JOIN Product USING (product_id)
        GROUP BY 1, 2
    )
SELECT user_id, product_id
FROM T
WHERE rk = 1;

-- m2
--------------------------------------------------------------------------------------------------------------
WITH user_spending_info AS (
SELECT 
        s.user_id,
        s.product_id,
        DENSE_RANK() OVER(PARTITION BY s.user_id ORDER BY SUM(s.quantity * p.price) DESC) AS spend_rank
FROM Sales s 
JOIN Product p 
ON s.product_id = p.product_id
GROUP BY s.user_id,
         s.product_id
)
SELECT 
        user_id,
        product_id
FROM user_spending_info
WHERE spend_rank = 1;


--------------------------------------------------------------------------------------------------------------
-- m3
WITH user_spending_info AS (
    SELECT 
            s.user_id,
            s.product_id,
            SUM(s.quantity * p.price) AS amount_spend
    FROM Sales s 
    JOIN Product p 
    ON s.product_id = p.product_id
    GROUP BY s.user_id,
            s.product_id
),
user_spending_ranked AS (
    SELECT 
            user_id,
            product_id,
            DENSE_RANK() OVER(PARTITION BY user_id ORDER BY amount_spend DESC) AS spend_rank
    FROM user_spending_info
)
SELECT 
        user_id,
        product_id
FROM user_spending_ranked
WHERE spend_rank = 1;


--------------------------------------------------------------------------------------------------------------
-- m4 Using Max
WITH user_spending_info AS (
    SELECT 
            s.user_id,
            s.product_id,
            SUM(s.quantity * p.price) AS amount_spend
    FROM Sales s 
    JOIN Product p 
    ON s.product_id = p.product_id
    GROUP BY s.user_id,
            s.product_id
),
user_spending_ranked AS (
    SELECT 
            user_id,
            MAX(amount_spend) AS max_amount_spend
    FROM user_spending_info
    GROUP BY user_id
)
SELECT 
        usi.user_id,
        usi.product_id
FROM user_spending_info usi
JOIN user_spending_ranked usr 
ON usr.user_id = usi.user_id
AND usi.amount_spend = max_amount_spend;