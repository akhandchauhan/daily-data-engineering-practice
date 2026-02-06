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
-- and specify a preferred delivery date (on the same order date or after it).
-- If the customer's preferred delivery date is the same as the order date, then the order 
-- is called immediate; otherwise, it is called scheduled.
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

-----------------------------------------------------------------------------------------------------------
-- m2
SELECT 
    ROUND(SUM(order_date = customer_pref_delivery_date) / COUNT(1) * 100, 2) AS immediate_percentage
FROM Delivery;

-----------------------------------------------------------------------------------------------------------
-- m3
SELECT ROUND(COUNT(CASE WHEN order_date = customer_pref_delivery_date THEN 1 END) * 100.0/
       COUNT(order_date),2) as immediate_percentage
FROM Delivery;

-----------------------------------------------------------------------------------------------------------
-- m4 
SELECT ROUND(
        SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0/
       COUNT(order_date)
       , 2)  AS  immediate_percentage
FROM Delivery ;


