-- 1821. Find Customers With Positive Revenue this Year
-- SQL Schema
-- Table: Customers
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | customer_id  | int  |
-- | year         | int  |
-- | revenue      | int  |
-- +--------------+------+
-- (customer_id, year) is the primary key for this table.
-- This table contains the customer ID and the revenue of customers in different years.
-- Note that this revenue can be negative.
-- Write an  SQL query to report the customers with postive revenue in the year 2021.
-- Return the result table in any order.
-- The query result format is in the following example
-- Customers
-- +-------------+------+---------+
-- | customer_id | year | revenue |
-- +-------------+------+---------+
-- | 1           | 2018 | 50      |
-- | 1           | 2021 | 30      |
-- | 1           | 2020 | 70      |
-- | 2           | 2021 | -50     |
-- | 3           | 2018 | 10      |
-- | 3           | 2016 | 50      |
-- | 4           | 2021 | 20      |
-- +-------------+------+---------+
-- Result table:
-- +-------------+
-- | customer_id |
-- +-------------+
-- | 1           |
-- | 4           |
-- +-------------+
-- Customer 1 has revenue equal to 50 in year 2021.
-- Customer 2 has revenue equal to -50 in year 2021.
-- Customer 3 has no revenue in year 2021.
-- Customer 4 has revenue equal to 20 in year 2021.
-- Thus only customers 1 and 4 have postive revenue in year 2021.


drop table Customers;
drop table Orders;
CREATE TABLE Customers (
    customer_id INT,
    year INT,
    revenue INT,
    PRIMARY KEY (customer_id, year)
);
INSERT INTO Customers (customer_id, year, revenue) VALUES
(1, 2018, 50),
(1, 2021, 30),
(1, 2020, 70),
(2, 2021, -50),
(3, 2018, 10),
(3, 2016, 50),
(4, 2021, 20);

-- m1 
SELECT customer_id
FROM Customers
WHERE Revenue>0 and year=2021;