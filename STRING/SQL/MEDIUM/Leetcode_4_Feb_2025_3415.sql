-- 3415. Find Products with Three Consecutive Digits
-- Description
-- Table: Products
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_id  | int     |
-- | name        | varchar |
-- +-------------+---------+
-- product_id is the unique key for this table.
-- Each row of this table contains the ID and name of a product.
-- Write a solution to find all products whose names contain a sequence of exactly three digits in a row.
-- Return the result table ordered by product_id in ascending order.
-- The result format is in the following example.
-- Example:
-- Input:
-- products table:
-- +-------------+--------------------+
-- | product_id  | name               |
-- +-------------+--------------------+
-- | 1           | ABC123XYZ          |
-- | 2           | A12B34C            |
-- | 3           | Product56789       |
-- | 4           | NoDigitsHere       |
-- | 5           | 789Product         |
-- | 6           | Item003Description |
-- | 7           | Product12X34       |
-- +-------------+--------------------+
-- Output:
-- +-------------+--------------------+
-- | product_id  | name               |
-- +-------------+--------------------+
-- | 1           | ABC123XYZ          |
-- | 5           | 789Product         |
-- | 6           | Item003Description |
-- +-------------+--------------------+
-- Explanation:
-- Product 1: ABC123XYZ contains the digits 123.
-- Product 5: 789Product contains the digits 789.
-- Product 6: Item003Description contains 003, which is exactly three digits.
-- Note:
-- Results are ordered by product_id in ascending order.
-- Only products with exactly three consecutive digits in their names are included in the result.

DROP TABLE products;
CREATE TABLE if not exists products  (
    product_id INT,
    name VARCHAR(255)
);

Truncate table Products;
insert into Products (product_id, name) values ('1', 'ABC123XYZ');
insert into Products (product_id, name) values ('2', 'A12B34C');
insert into Products (product_id, name) values ('3', 'Product56789');
insert into Products (product_id, name) values ('4', 'NoDigitsHere');
insert into Products (product_id, name) values ('5', '789Product');
insert into Products (product_id, name) values ('6', 'Item003Description');
insert into Products (product_id, name) values ('7', 'Product12X34');

SELECT product_id, name
FROM Products
WHERE name REGEXP '(^|[^0-9])[0-9]{3}([^0-9]|$)'
ORDER BY 1;
