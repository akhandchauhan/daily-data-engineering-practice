-- 1159. Market Analysis II
-- Description
-- Table: Users
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | user_id        | int     |
-- | join_date      | date    |
-- | favorite_brand | varchar |
-- +----------------+---------+
-- user_id is the primary key (column with unique values) of this table.
-- This table has the info of the users of an online shopping website where users can sell and buy items.

-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | item_id       | int     |
-- | buyer_id      | int     |
-- | seller_id     | int     |
-- +---------------+---------+
-- order_id is the primary key (column with unique values) of this table.
-- item_id is a foreign key (reference column) to the Items table.
-- buyer_id and seller_id are foreign keys to the Users table.

-- Table: Items
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | item_id       | int     |
-- | item_brand    | varchar |
-- +---------------+---------+
-- item_id is the primary key (column with unique values) of this table.

-- Write an  SQL query to find for each user, whether the brand of the second item (by date)
-- they sold is their favorite brand. If a user sold less than two items, report the answer for 
--that user as no.

-- It is guaranteed that no seller sold more than one item on a day.
-- The result format is in the following example.

-- Example 1:

-- Input: 
-- Users table:
-- +---------+------------+----------------+
-- | user_id | join_date  | favorite_brand |
-- +---------+------------+----------------+
-- | 1       | 2019-01-01 | Lenovo         |
-- | 2       | 2019-02-09 | Samsung        |
-- | 3       | 2019-01-19 | LG             |
-- | 4       | 2019-05-21 | HP             |
-- +---------+------------+----------------+
-- Orders table:
-- +----------+------------+---------+----------+-----------+
-- | order_id | order_date | item_id | buyer_id | seller_id |
-- +----------+------------+---------+----------+-----------+
-- | 1        | 2019-08-01 | 4       | 1        | 2         |
-- | 2        | 2019-08-02 | 2       | 1        | 3         |
-- | 3        | 2019-08-03 | 3       | 2        | 3         |
-- | 4        | 2019-08-04 | 1       | 4        | 2         |
-- | 5        | 2019-08-04 | 1       | 3        | 4         |
-- | 6        | 2019-08-05 | 2       | 2        | 4         |
-- +----------+------------+---------+----------+-----------+
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
-- +-----------+--------------------+
-- | seller_id | 2nd_item_fav_brand |
-- +-----------+--------------------+
-- | 1         | no                 |
-- | 2         | yes                |
-- | 3         | yes                |
-- | 4         | no                 |
-- +-----------+--------------------+
-- Explanation: 
-- The answer for the user with id 1 is no because they sold nothing.
-- The answer for the users with id 2 and 3 is yes because the brands of their second sold items 
-- are their favorite brands.
-- The answer for the user with id 4 is no because the brand of their second sold item is not the
drop table contest;
drop table Users;
drop table Orders;
drop table Items;
Create table If Not Exists Users (user_id int, join_date date, favorite_brand varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int);
Create table If Not Exists Items (item_id int, item_brand varchar(10));
Truncate table Users;
INSERT INTO Users (user_id, join_date, favorite_brand) 
VALUES 
    ('1', '2019-01-01', 'Lenovo'),
    ('2', '2019-02-09', 'Samsung'),
    ('3', '2019-01-19', 'LG'),
    ('4', '2019-05-21', 'HP');
Truncate table Orders;
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES
    ('1', '2019-08-01', '4', '1', '2'),
    ('2', '2019-08-02', '2', '1', '3'),
    ('3', '2019-08-03', '3', '2', '3'),
    ('4', '2019-08-04', '1', '4', '2'),
    ('5', '2019-08-04', '1', '3', '4'),
    ('6', '2019-08-05', '2', '2', '4');
Truncate table Items;
INSERT INTO Items (item_id, item_brand) VALUES
(1, 'Samsung'),
(2, 'Lenovo'),
(3, 'LG'),
(4, 'HP');

-- m1 is not that good because I am putting all the business logic in join condition which is difficult
-- to maintain.
WITH shopping_cte as (
    SELECT 
        u.user_id AS seller_id,
        i.item_brand,
        ROW_NUMBER() OVER(
                    PARTITION BY u.user_id 
                    ORDER BY o.order_date
                    ) AS shopping_rank
    FROM Users u 
    LEFT JOIN Orders o 
    ON u.user_id = o.seller_id 
    LEFT JOIN Items i 
    ON i.item_id = o.item_id
)
SELECT 
    u.user_id AS seller_id,
    CASE WHEN 
            sc.seller_id IS NULL THEN 'no'
        ELSE 'yes'
    END AS 2nd_item_fav_brand
FROM Users u 
LEFT JOIN shopping_cte sc 
ON u.user_id = sc.seller_id
AND sc.shopping_rank = 2 
AND sc.item_brand = u.favorite_brand ;


-- What it's ACTUALLY checking:
-- "Is NULL because: user sold nothing?
--              OR: user sold <2 items?
--              OR: 2nd item brand ≠ favorite brand?"

------------------------------------------------------------------------------------------------------------
-- m2 

WITH ranked_orders AS (
    SELECT 
        o.seller_id,
        i.item_brand,
        ROW_NUMBER() OVER (
            PARTITION BY o.seller_id 
            ORDER BY o.order_date
        ) AS rn
    FROM Orders o
    JOIN Items i ON o.item_id = i.item_id
),
second_item AS (
    SELECT seller_id, item_brand
    FROM ranked_orders
    WHERE rn = 2
)
SELECT 
    u.user_id AS seller_id,
    CASE 
        WHEN si.item_brand = u.favorite_brand THEN 'yes'
        ELSE 'no'
    END AS 2nd_item_fav_brand
FROM Users u
LEFT JOIN second_item si 
ON u.user_id = si.seller_id;

------------------------------------------------------------------------------------------------------------
-- m3

WITH DATA AS (
    SELECT U.USER_ID,
        U.FAVORITE_BRAND,
        O.ORDER_DATE,
        ITEM_BRAND,
        RANK() OVER (PARTITION BY U.USER_ID ORDER BY O.ORDER_DATE ) AS RN
    FROM USERS U
    LEFT JOIN ORDERS O ON U.USER_ID = O.SELLER_ID
    LEFT JOIN ITEMS I ON I.ITEM_ID = O.ITEM_ID
    ORDER BY U.USER_ID
)
SELECT USER_ID AS SELLER_ID,
CASE WHEN (RN = 2 AND ITEM_BRAND = FAVORITE_BRAND) THEN 'YES' ELSE 'NO' END AS "2ND_FAV_BRAND"
FROM DATA
WHERE RN = 2 OR ORDER_DATE IS NULL;