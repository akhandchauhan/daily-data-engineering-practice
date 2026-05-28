-- 1479. Sales by Day of the Week
-- SQL Schema 
-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | order_date    | date    |
-- | item_id       | varchar |
-- | quantity      | int     |
-- +---------------+---------+
-- (order_id, item_id) is the primary key for this table.
-- This table contains information of the orders placed.
-- order_date is the date when item_id was ordered by the customer with id customer_id.
-- Table: Items
-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | item_id             | varchar |
-- | item_name           | varchar |
-- | item_category       | varchar |
-- +---------------------+---------+
-- item_id is the primary key for this table.
-- item_name is the name of the item.
-- item_category is the category of the item.
-- You are the business owner and would like to obtain a sales report for category items and day of the week.
-- Write an  SQL query to report how many units in each category have been ordered on each day of the week.
-- Return the result table ordered by category.
-- The query result format is in the following example:
-- Orders table:
-- +------------+--------------+-------------+--------------+-------------+
-- | order_id   | customer_id  | order_date  | item_id      | quantity    |
-- +------------+--------------+-------------+--------------+-------------+
-- | 1          | 1            | 2020-06-01  | 1            | 10          |
-- | 2          | 1            | 2020-06-08  | 2            | 10          |
-- | 3          | 2            | 2020-06-02  | 1            | 5           |
-- | 4          | 3            | 2020-06-03  | 3            | 5           |
-- | 5          | 4            | 2020-06-04  | 4            | 1           |
-- | 6          | 4            | 2020-06-05  | 5            | 5           |
-- | 7          | 5            | 2020-06-05  | 1            | 10          |
-- | 8          | 5            | 2020-06-14  | 4            | 5           |
-- | 9          | 5            | 2020-06-21  | 3            | 5           |
-- +------------+--------------+-------------+--------------+-------------+
-- Items table:
-- +------------+----------------+---------------+
-- | item_id    | item_name      | item_category |
-- +------------+----------------+---------------+
-- | 1          | LC Alg. Book   | Book          |
-- | 2          | LC DB. Book    | Book          |
-- | 3          | LC SmarthPhone | Phone         |
-- | 4          | LC Phone 2020  | Phone         |
-- | 5          | LC SmartGlass  | Glasses       |
-- | 6          | LC T-Shirt XL  | T-Shirt       |
-- +------------+----------------+---------------+
-- Result table:
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- | Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- | Book       | 20        | 5         | 0         | 0         | 10        | 0         | 0         |
-- | Glasses    | 0         | 0         | 0         | 0         | 5         | 0         | 0         |
-- | Phone      | 0         | 0         | 5         | 1         | 0         | 0         | 10        |
-- | T-Shirt    | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- On Monday (2020-06-01, 2020-06-08) were sold a total of 20 units (10 + 10) in the category Book (ids: 1, 2).
-- On Tuesday (2020-06-02) were sold a total of 5 units  in the category Book (ids: 1, 2).
-- On Wednesday (2020-06-03) were sold a total of 5 units in the category Phone (ids: 3, 4).
-- On Thursday (2020-06-04) were sold a total of 1 unit in the category Phone (ids: 3, 4).
-- On Friday (2020-06-05) were sold 10 units in the category Book (ids: 1, 2) and 5 units in Glasses (ids: 5).
-- On Saturday there are no items sold.
-- On Sunday (2020-06-14, 2020-06-21) were sold a total of 10 units (5 +5) in the category Phone (ids: 3, 4).
-- There are no sales of T-Shirt.
drop table Orders;
drop table Items;
-- Create the Orders table
CREATE TABLE Orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    item_id VARCHAR(10),
    quantity INT,
    PRIMARY KEY (order_id, item_id)
);

-- Create the Items table
CREATE TABLE Items (
    item_id VARCHAR(10),
    item_name VARCHAR(50),
    item_category VARCHAR(50),
    PRIMARY KEY (item_id)
);

-- Insert values into the Orders table
INSERT INTO Orders (order_id, customer_id, order_date, item_id, quantity) VALUES
(1, 1, '2020-06-01', '1', 10),
(2, 1, '2020-06-08', '2', 10),
(3, 2, '2020-06-02', '1', 5),
(4, 3, '2020-06-03', '3', 5),
(5, 4, '2020-06-04', '4', 1),
(6, 4, '2020-06-05', '5', 5),
(7, 5, '2020-06-05', '1', 10),
(8, 5, '2020-06-14', '4', 5),
(9, 5, '2020-06-21', '3', 5);

-- Insert values into the Items table
INSERT INTO Items (item_id, item_name, item_category) VALUES
('1', 'LC Alg. Book', 'Book'),
('2', 'LC DB. Book', 'Book'),
('3', 'LC SmarthPhone', 'Phone'),
('4', 'LC Phone 2020', 'Phone'),
('5', 'LC SmartGlass', 'Glasses'),
('6', 'LC T-Shirt XL', 'T-Shirt');

WITH cte as(
    SELECT item_category, DAYNAME(o.order_date) as dayn, SUM(quantity) as total
    FROM Items i
    LEFT JOIN Orders o
    ON i.item_id = o.item_id
    GROUP BY 1 , 2
)
SELECT item_category AS category,
SUM(CASE WHEN dayn = 'Monday' THEN total ELSE 0 END) AS Monday,
    SUM(CASE WHEN dayn = 'Tuesday' THEN total ELSE 0 END) AS Tuesday,
    SUM(CASE WHEN dayn = 'Wednesday' THEN total ELSE 0 END) AS Wednesday,
    SUM(CASE WHEN dayn = 'Thursday' THEN total ELSE 0 END) AS Thursday,
    SUM(CASE WHEN dayn = 'Friday' THEN total ELSE 0 END) AS Friday,
    SUM(CASE WHEN dayn = 'Saturday' THEN total ELSE 0 END) AS Saturday,
    SUM(CASE WHEN dayn = 'Sunday' THEN total ELSE 0 END) AS Sunday
FROM cte 
GROUP BY 1
order by 1;


-----------------------------------------------------------------------------------------------------------
-- m2

SELECT 
    i.item_category AS category,
    SUM(CASE WHEN DAYNAME(o.order_date) = 'Monday' THEN quantity ELSE 0 END) AS Monday,
    SUM(CASE WHEN DAYNAME(o.order_date) = 'Tuesday' THEN quantity ELSE 0 END) AS Tuesday,
    SUM(CASE WHEN DAYNAME(o.order_date) = 'Wednesday' THEN quantity ELSE 0 END) AS Wednesday,
    SUM(CASE WHEN DAYNAME(o.order_date) = 'Thursday' THEN quantity ELSE 0 END) AS Thursday,
    SUM(CASE WHEN DAYNAME(o.order_date) = 'Friday' THEN quantity ELSE 0 END) AS Friday,
    SUM(CASE WHEN DAYNAME(o.order_date) = 'Saturday' THEN quantity ELSE 0 END) AS Saturday,
    SUM(CASE WHEN DAYNAME(o.order_date) = 'Sunday' THEN quantity ELSE 0 END) AS Sunday
FROM Items i 
LEFT JOIN Orders o   
    ON i.item_id = o.item_id
GROUP BY i.item_category
ORDER BY i.item_category;