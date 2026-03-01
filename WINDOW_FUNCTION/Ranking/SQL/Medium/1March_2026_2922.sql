-- 2922. Market Analysis III
-- Description
-- Table: Users
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | seller_id      | int     |
-- | join_date      | date    |
-- | favorite_brand | varchar |
-- +----------------+---------+
-- seller_id is the primary key for this table.
-- This table contains seller id, join date, and favorite brand of sellers.
-- Table: Items
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | item_id       | int     |
-- | item_brand    | varchar |
-- +---------------+---------+
-- item_id is the primary key for this table.
-- This table contains item id and item brand.
-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | item_id       | int     |
-- | seller_id     | int     |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- item_id is a foreign key to the Items table.
-- seller_id is a foreign key to the Users table.
-- This table contains order id, order date, item id and seller id.

-- Write a solution to find the top seller who has sold the highest number of unique
-- items with a different brand than their favorite brand. If there are multiple sellers 
-- with the same highest count, return all of them.

-- Return the result table ordered by seller_id in ascending order.

-- Input: 
-- Users table:
-- +-----------+------------+----------------+
-- | seller_id | join_date  | favorite_brand |
-- +-----------+------------+----------------+
-- | 1         | 2019-01-01 | Lenovo         |
-- | 2         | 2019-02-09 | Samsung        |
-- | 3         | 2019-01-19 | LG             |
-- +-----------+------------+----------------+
-- Orders table:
-- +----------+------------+---------+-----------+
-- | order_id | order_date | item_id | seller_id |
-- +----------+------------+---------+-----------+
-- | 1        | 2019-08-01 | 4       | 2         |
-- | 2        | 2019-08-02 | 2       | 3         |
-- | 3        | 2019-08-03 | 3       | 3         |
-- | 4        | 2019-08-04 | 1       | 2         |
-- | 5        | 2019-08-04 | 4       | 2         |
-- +----------+------------+---------+-----------+
-- Items table:
-- +---------+------------+
-- | item_id | item_brand |
-- +---------+------------+
-- | 1       | Samsung    |
-- | 2       | Lenovo     |
-- | 3       | LG         |
-- | 4       | HP         |
-- +---------+------------+
-- Output: 
-- +-----------+-----------+
-- | seller_id | num_items |
-- +-----------+-----------+
-- | 2         | 1         |
-- | 3         | 1         |
-- +-----------+-----------+
-- Explanation: 
-- - The user with seller_id 2 has sold three items, but only two of them are not
--  marked as a favorite. We will include a unique count of 1 because both of these 
--  items are identical.
-- - The user with seller_id 3 has sold two items, but only one of them is not marked 
-- as a favorite. We will include just that non-favorite item in our count.
-- Since seller_ids 2 and 3 have the same count of one item each, they both will be
-- displayed in the output
-- Drop tables if they already exist
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Items;

-- Create Users table
CREATE TABLE Users (
    seller_id INT PRIMARY KEY,
    join_date DATE,
    favorite_brand VARCHAR(50)
);

INSERT INTO Users (seller_id, join_date, favorite_brand) VALUES
(1, '2019-01-01', 'Lenovo'),
(2, '2019-02-09', 'Samsung'),
(3, '2019-01-19', 'LG');


-- Create Items table
CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    item_brand VARCHAR(50)
);

INSERT INTO Items (item_id, item_brand) VALUES
(1, 'Samsung'),
(2, 'Lenovo'),
(3, 'LG'),
(4, 'HP');


-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    item_id INT,
    seller_id INT,
    FOREIGN KEY (item_id) REFERENCES Items(item_id),
    FOREIGN KEY (seller_id) REFERENCES Users(seller_id)
);

INSERT INTO Orders (order_id, order_date, item_id, seller_id) VALUES
(1, '2019-08-01', 4, 2),
(2, '2019-08-02', 2, 3),
(3, '2019-08-03', 3, 3),
(4, '2019-08-04', 1, 2),
(5, '2019-08-04', 4, 2);

-- m1 
WITH item_sell_info AS (
    SELECT    
            o.seller_id,
            COUNT(DISTINCT o.item_id) AS num_items,
            DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT o.item_id) DESC) AS num_items_rank
    FROM Orders o 
    JOIN Users u 
    ON o.seller_id = u.seller_id
    JOIN Items i 
    ON i.item_id = o.item_id 
    WHERE i.item_brand <> u.favorite_brand
    GROUP BY 1
)
SELECT 
        seller_id,
        num_items
FROM item_sell_info 
WHERE num_items_rank = 1
ORDER BY seller_id;

-----------------------------------------------------------------------------------------------------------
-- m2 = Pre- aggregate then rank

WITH seller_counts AS (
    SELECT 
        o.seller_id,
        COUNT(DISTINCT o.item_id) AS num_items
    FROM Orders o
    JOIN Items i 
        ON i.item_id = o.item_id
    JOIN Users u 
        ON u.seller_id = o.seller_id
        AND i.item_brand <> u.favorite_brand
    GROUP BY o.seller_id
)
SELECT seller_id, num_items
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY num_items DESC) AS rnk
    FROM seller_counts
) t
WHERE rnk = 1
ORDER BY seller_id;

-----------------------------------------------------------------------------------------------------------
-- m3 max function
WITH seller_counts AS (
    SELECT 
        o.seller_id,
        COUNT(DISTINCT o.item_id) AS num_items
    FROM Orders o
    JOIN Items i ON i.item_id = o.item_id
    JOIN Users u ON u.seller_id = o.seller_id
    AND i.item_brand <> u.favorite_brand
    GROUP BY o.seller_id
)
SELECT seller_id, num_items
FROM seller_counts
WHERE num_items = (
    SELECT MAX(num_items) FROM seller_counts
)
ORDER BY seller_id;