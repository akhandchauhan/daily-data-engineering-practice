
-- 1173. Immediate Food Delivery I
-- Description
-- Table: Delivery
-- +-----------------------------+---------+
-- | Column Name                 | Type    |
-- +-----------------------------+---------+
-- | delivery_id                 | int     |
-- | customer_id                 | int     |
-- | order_date                  | date    |
-- | customer_pref_delivery_date | date    |
-- +-----------------------------+---------+
-- delivery_id is the primary key (column with unique values) of this table.
-- The table holds information about food delivery to customers that make orders at some date 
--and specify a preferred delivery date (on the same order date or after it).
-- If the customer's preferred delivery date is the same as the order date, then the order 
--is called immediate; otherwise, it is called scheduled.
-- Write a solution to find the percentage of immediate orders in the table, rounded to 2 decimal places.
-- The result format is in the following example.
-- Input: 
-- Delivery table:
-- +-------------+-------------+------------+-----------------------------+
-- | delivery_id | customer_id | order_date | customer_pref_delivery_date |
-- +-------------+-------------+------------+-----------------------------+
-- | 1           | 1           | 2019-08-01 | 2019-08-02                  |
-- | 2           | 5           | 2019-08-02 | 2019-08-02                  |
-- | 3           | 1           | 2019-08-11 | 2019-08-11                  |
-- | 4           | 3           | 2019-08-24 | 2019-08-26                  |
-- | 5           | 4           | 2019-08-21 | 2019-08-22                  |
-- | 6           | 2           | 2019-08-11 | 2019-08-13                  |
-- +-------------+-------------+------------+-----------------------------+
-- Output: 
-- +----------------------+
-- | immediate_percentage |
-- +----------------------+
-- | 33.33                |
-- +----------------------+
-- Explanation: The orders with delivery id 2 and 3 are immediate while the others are scheduled.

DROP TABLE IF EXISTS Delivery;
CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    customer_pref_delivery_date DATE
);

-- Insert values
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES 
(1, 1, '2019-08-01', '2019-08-02'),
(2, 5, '2019-08-02', '2019-08-02'),
(3, 1, '2019-08-11', '2019-08-11'),
(4, 3, '2019-08-24', '2019-08-26'),
(5, 4, '2019-08-21', '2019-08-22'),
(6, 2, '2019-08-11', '2019-08-13');

-- m1 
WITH cte as(
	SELECT SUM(IF(order_date=customer_pref_delivery_date,1,0)) as imm
    FROM Delivery  
)
SELECT ROUND(imm * 100/(SELECT COUNT(*) FROM Delivery),2) as immediate_percentage
FROM cte;

-- m2
SELECT 
    ROUND(SUM(order_date = customer_pref_delivery_date) / COUNT(1) * 100, 2) AS immediate_percentage
FROM Delivery;

-- m3
SELECT ROUND(COUNT(CASE WHEN order_date = customer_pref_delivery_date THEN 1 END) * 100.0/
       COUNT(order_date),2) as immediate_percentage
FROM Delivery;

-- 2686. Immediate Food Delivery III
-- Description
-- Table: Delivery
-- +-----------------------------+---------+
-- | Column Name                 | Type    |
-- +-----------------------------+---------+
-- | delivery_id                 | int     |
-- | customer_id                 | int     |
-- | order_date                  | date    |
-- | customer_pref_delivery_date | date    |
-- +-----------------------------+---------+
-- delivery_id is the primary key of this table.
-- Each row contains information about food delivery to a customer that makes an order at 
--some date and specifies a preferred delivery date (on the order date or after it).
-- If the customer's preferred delivery date is the same as the order date, then the order 
--is called immediate, otherwise, it is scheduled.
-- Write an SQL query to find the percentage of immediate orders on each unique 
--order_date, rounded to 2 decimal places. 
-- Return the result table ordered by order_date in ascending order.
-- Input: 
-- Delivery table:
-- +-------------+-------------+------------+-----------------------------+
-- | delivery_id | customer_id | order_date | customer_pref_delivery_date |
-- +-------------+-------------+------------+-----------------------------+
-- | 1           | 1           | 2019-08-01 | 2019-08-02                  |
-- | 2           | 2           | 2019-08-01 | 2019-08-01                  |
-- | 3           | 1           | 2019-08-01 | 2019-08-01                  |
-- | 4           | 3           | 2019-08-02 | 2019-08-13                  |
-- | 5           | 3           | 2019-08-02 | 2019-08-02                  |
-- | 6           | 2           | 2019-08-02 | 2019-08-02                  |
-- | 7           | 4           | 2019-08-03 | 2019-08-03                  |
-- | 8           | 1           | 2019-08-03 | 2019-08-03                  |
-- | 9           | 5           | 2019-08-04 | 2019-08-08                  |
-- | 10          | 2           | 2019-08-04 | 2019-08-18                  |
-- +-------------+-------------+------------+-----------------------------+
-- Output: 
-- +------------+----------------------+
-- | order_date | immediate_percentage |
-- +------------+----------------------+
-- | 2019-08-01 | 66.67                |
-- | 2019-08-02 | 66.67                |
-- | 2019-08-03 | 100.00               |
-- | 2019-08-04 | 0.00                 |
-- +------------+----------------------+


-- Explanation: 
-- - On 2019-08-01 there were three orders, out of those, two were immediate and one was scheduled. 
--So, immediate percentage for that date was 66.67.
-- - On 2019-08-02 there were three orders, out of those, two were immediate and one was scheduled.
-- So, immediate percentage for that date was 66.67.
-- - On 2019-08-03 there were two orders, both were immediate. So, the immediate percentage for that
-- date was 100.00.
-- - On 2019-08-04 there were two orders, both were scheduled. So, the immediate percentage for that
-- date was 0.00.
-- order_date is sorted in ascending order.
DROP TABLE IF EXISTS Delivery;
CREATE TABLE IF NOT EXISTS Delivery (
    delivery_id INT, 
    customer_id INT, 
    order_date DATE, 
    customer_pref_delivery_date DATE
);

INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) VALUES
('1', '1', '2019-08-01', '2019-08-02'),
('2', '2', '2019-08-01', '2019-08-01'),
('3', '1', '2019-08-01', '2019-08-01'),
('4', '3', '2019-08-02', '2019-08-13'),
('5', '3', '2019-08-02', '2019-08-02'),
('6', '2', '2019-08-02', '2019-08-02'),
('7', '4', '2019-08-03', '2019-08-03'),
('8', '1', '2019-08-03', '2019-08-03'),
('9', '5', '2019-08-04', '2019-08-18'),
('10', '2', '2019-08-04', '2019-08-18');

-- m1 
SELECT  order_date
       ,round(100*SUM(IF(customer_pref_delivery_date = order_date,1,0))/COUNT(*),2) AS immediate_percentage
FROM Delivery
GROUP BY  order_date
ORDER BY order_date;

-- m2 while practice
WITH cte as(
SELECT *,IF(DATE(order_date) = DATE(customer_pref_delivery_date),1,0) as pref
FROM Delivery
)
SELECT order_date,ROUND(SUM(pref=1) *100 /COUNT(pref), 2) as immediate_percentage
FROM cte
GROUP BY 1
ORDER BY 1;

-- m3 

SELECT order_date,
       ROUND(COUNT(CASE WHEN order_date = customer_pref_delivery_date THEN 1 END) * 100.0/COUNT(order_date),2) as immediate_percentage
FROM Delivery 
GROUP BY order_date
ORDER BY order_date;






