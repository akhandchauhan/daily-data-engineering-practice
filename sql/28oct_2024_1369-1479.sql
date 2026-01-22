-- 1369. Get the Second Most Recent Activity
-- SQL Schema 
-- Table: UserActivity
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | username      | varchar |
-- | activity      | varchar |
-- | startDate     | Date    |
-- | endDate       | Date    |
-- +---------------+---------+
-- This table does not contain primary key.
-- This table contain information about the activity performed of each user in a period of time.
-- A person with username performed a activity from startDate to endDate.
-- Write an  SQL query to show the second most recent activity of each user.
-- If the user only has one activity, return that one. 
-- A user can't perform more than one activity at the same time. Return the result table in any order.
-- The query result format is in the following example:
-- UserActivity table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Travel       | 2020-02-12  | 2020-02-20  |
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Alice      | Travel       | 2020-02-24  | 2020-02-28  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+
-- Result table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
-- Bob only has one record, we just take that one.
DROP TABLE UserActivity;
CREATE TABLE UserActivity (
    username VARCHAR(50),
    activity VARCHAR(50),
    startDate DATE,
    endDate DATE
);

INSERT INTO UserActivity (username, activity, startDate, endDate) VALUES
('Alice', 'Travel', '2020-02-12', '2020-02-20'),
('Alice', 'Dancing', '2020-02-21', '2020-02-23'),
('Alice', 'Travel', '2020-02-24', '2020-02-28'),
('Bob', 'Travel', '2020-02-11', '2020-02-18');

 -- #method 1
WITH cte as(
    SELECT *,
    dense_rank() over(partition by username ORDER BY startDate DESC) as rnk,
    count(username) OVER(PARTITION BY username) as cnt
    FROM UserActivity
)
SELECT username, activity, startDate, endDate
FROM cte
WHERE IF(cnt>1,rnk=2,rnk=1);


--method 2

WITH cte as(
SELECT *, dense_rank() over(partition by username ORDER BY startDate DESC) as rnk,
count(username) OVER(PARTITION BY username) as cnt
FROM UserActivity
)
SELECT username, activity, startDate, endDate
FROM cte
WHERE rnk=2 or cnt = 1;


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
-- ou are the business owner and would like to obtain a sales report for category items and day of the week.
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
SELECT item_category,
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


-- method 2

WITH cte as ( SELECT DAYNAME(order_date) as nameday, item_id,quantity
FROM Orders 
)
SELECT item_category, SUM(IF(nameday= 'Monday',quantity,0)) as monday,SUM(IF(nameday= 'Tuesday',quantity,0)) as Tuesday,
SUM(IF(nameday= 'Wednesday',quantity,0)) as Wednesday,SUM(IF(nameday= 'Thursday',quantity,0)) as Thursday,
SUM(IF(nameday= 'Friday',quantity,0)) as Friday,SUM(IF(nameday= 'Saturday',quantity,0)) as Saturday,
SUM(IF(nameday= 'Sunday',quantity,0)) as Sunday
FROM  Items i 
LEFT JOIN cte c 
ON c.item_id = i.item_id
GROUP BY item_category
ORDER BY 1;


-- m3

SELECT i.item_category AS category,
       SUM(CASE WHEN DAYNAME(order_date) = 'Monday' THEN quantity ELSE 0 END) AS Monday
       
FROM Items i 
LEFT JOIN Orders o 
ON i.item_id = o.item_id
GROUP BY category;