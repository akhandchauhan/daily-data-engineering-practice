-- 2324. Product Sales Analysis IV 🔒
-- 中文文档
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

-- 1555. Bank Account Summary
-- SQL Schema 
-- Table: Users

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | user_id      | int     |
-- | user_name    | varchar |
-- | credit       | int     |
-- +--------------+---------+
-- user_id is the primary key for this table.
-- Each row of this table contains the current credit information for each user.
 

-- Table: Transaction

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | trans_id      | int     |
-- | paid_by       | int     |
-- | paid_to       | int     |
-- | amount        | int     |
-- | transacted_on | date    |
-- +---------------+---------+
-- trans_id is the primary key for this table.
-- Each row of this table contains the information about the transaction in the bank.
-- User with id (paid_by) transfer money to user with id (paid_to).
 

-- Leetcode Bank (LCB) helps its coders in making virtual payments. Our bank records all transactions in the table Transaction, we want to find out the current balance of all users and check wheter they have breached their credit limit (If their current credit is less than 0).

-- Write an  SQL query to report.SQL database courses

-- user_id
-- user_name
-- credit, current balance after performing transactions.  
-- credit_limit_breached, check credit_limit ("Yes" or "No")
-- Return the result table in any order.

-- The query result format is in the following example.

 

-- Users table:
-- +------------+--------------+-------------+
-- | user_id    | user_name    | credit      |
-- +------------+--------------+-------------+
-- | 1          | Moustafa     | 100         |
-- | 2          | Jonathan     | 200         |
-- | 3          | Winston      | 10000       |
-- | 4          | Luis         | 800         |
-- +------------+--------------+-------------+

-- Transaction table:
-- +------------+------------+------------+----------+---------------+
-- | trans_id   | paid_by    | paid_to    | amount   | transacted_on |
-- +------------+------------+------------+----------+---------------+
-- | 1          | 1          | 3          | 400      | 2020-08-01    |
-- | 2          | 3          | 2          | 500      | 2020-08-02    |
-- | 3          | 2          | 1          | 200      | 2020-08-03    |
-- +------------+------------+------------+----------+---------------+

-- Result table:
-- +------------+------------+------------+-----------------------+
-- | user_id    | user_name  | credit     | credit_limit_breached |
-- +------------+------------+------------+-----------------------+
-- | 1          | Moustafa   | -100       | Yes                   |
-- | 2          | Jonathan   | 500        | No                    |
-- | 3          | Winston    | 9990       | No                    |
-- | 4          | Luis       | 800        | No                    |
-- +------------+------------+------------+-----------------------+
-- Moustafa paid $400 on "2020-08-01" and received $200 on "2020-08-03", credit (100 -400 +200) = -$100
-- Jonathan received $500 on "2020-08-02" and paid $200 on "2020-08-08", credit (200 +500 -200) = $500
-- Winston received $400 on "2020-08-01" and paid $500 on "2020-08-03", credit (10000 +400 -500) = $9990
-- Luis didn't received any transfer, credit = $800

DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Transaction;

-- Create the Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(255),
    credit INT
);

-- Create the Transaction table
CREATE TABLE Transaction (
    trans_id INT PRIMARY KEY,
    paid_by INT,
    paid_to INT,
    amount INT,
    transacted_on DATE,
    FOREIGN KEY (paid_by) REFERENCES Users(user_id),
    FOREIGN KEY (paid_to) REFERENCES Users(user_id)
);

-- Insert sample data into Users table
INSERT INTO Users (user_id, user_name, credit) VALUES
(1, 'Moustafa', 100),
(2, 'Jonathan', 200),
(3, 'Winston', 10000),
(4, 'Luis', 800);

-- Insert sample data into Transaction table
INSERT INTO Transaction (trans_id, paid_by, paid_to, amount, transacted_on) VALUES
(1, 1, 3, 400, '2020-08-01'),
(2, 3, 2, 500, '2020-08-02'),
(3, 2, 1, 200, '2020-08-03');

SELECT  u.user_id, u.user_name,
    u.credit + COALESCE(SUM(IF(t.paid_by = u.user_id, -t.amount, IF(t.paid_to = u.user_id, t.amount, 0))), 0) AS credit,
    IF(u.credit + COALESCE(SUM(IF(t.paid_by = u.user_id, -t.amount, IF(t.paid_to = u.user_id, t.amount, 0))), 0) < 0, 'Yes', 'No') AS credit_limit_breached
FROM Users u
LEFT JOIN Transaction t 
ON u.user_id = t.paid_by OR u.user_id = t.paid_to
GROUP BY u.user_id, u.user_name, u.credit;

-- 1811. Find Interview Candidates
-- SQL Schema
-- Table: Contests

-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | contest_id   | int  |
-- | gold_medal   | int  |
-- | silver_medal | int  |
-- | bronze_medal | int  |
-- +--------------+------+
-- contest_id is the primary key for this table.
-- This table contains the LeetCode contest ID and the user IDs of the gold,
-- silver, and bronze medalists.
-- It is guaranteed that any consecutive contests have consecutive IDs and 
--that no ID is skipped.
 

-- Table: Users

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | mail        | varchar |
-- | name        | varchar |
-- +-------------+---------+
-- user_id is the primary key for this table.
-- This table contains information about the users.
 

-- Write an SQL query to report the name and the mail of all interview 
--candidates. A user is an interview candidate if at least one of these two 
--conditions is true:

-- The user won any medal in three or more consecutive contests.
-- The user won the gold medal in three or more different contests 
--(not necessarily consecutive).
-- Return the result table in any order.

-- The query result format is in the following example:

 

-- Contests table:
-- +------------+------------+--------------+--------------+
-- | contest_id | gold_medal | silver_medal | bronze_medal |
-- +------------+------------+--------------+--------------+
-- | 190        | 1          | 5            | 2            |
-- | 191        | 2          | 3            | 5            |
-- | 192        | 5          | 2            | 3            |
-- | 193        | 1          | 3            | 5            |
-- | 194        | 4          | 5            | 2            |
-- | 195        | 4          | 2            | 1            |
-- | 196        | 1          | 5            | 2            |
-- +------------+------------+--------------+--------------+
-- Users table:
-- +---------+--------------------+-------+
-- | user_id | mail               | name  |
-- +---------+--------------------+-------+
-- | 1       | sarah@leetcode.com | Sarah |
-- | 2       | bob@leetcode.com   | Bob   |
-- | 3       | alice@leetcode.com | Alice |
-- | 4       | hercy@leetcode.com | Hercy |
-- | 5       | quarz@leetcode.com | Quarz |
-- +---------+--------------------+-------+
-- Result table:
-- +-------+--------------------+
-- | name  | mail               |
-- +-------+--------------------+
-- | Sarah | sarah@leetcode.com |
-- | Bob   | bob@leetcode.com   |
-- | Alice | alice@leetcode.com |
-- | Quarz | quarz@leetcode.com |
-- +-------+--------------------+
-- Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
-- Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
--     - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
-- Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
-- Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.

DROP TABLE Users;
DROP TABLE Contests;
-- Create the Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    mail VARCHAR(255),
    name VARCHAR(255)
);

-- Create the Contests table
CREATE TABLE Contests (
    contest_id INT PRIMARY KEY,
    gold_medal INT,
    silver_medal INT,
    bronze_medal INT,
    FOREIGN KEY (gold_medal) REFERENCES Users(user_id),
    FOREIGN KEY (silver_medal) REFERENCES Users(user_id),
    FOREIGN KEY (bronze_medal) REFERENCES Users(user_id)
);

WITH cte AS (
    -- Combine all users who won a medal (gold, silver, or bronze) along with contest_id
    SELECT gold_medal AS user, contest_id FROM contests
    UNION
    SELECT silver_medal AS user, contest_id FROM contests
    UNION
    SELECT bronze_medal AS user, contest_id FROM contests
),
cte2 AS (
    -- Assign a row number based on contest_id for each user
    SELECT user, contest_id, 
           ROW_NUMBER() OVER (PARTITION BY user ORDER BY contest_id) AS rnk
    FROM cte
),
cte3 AS (
    -- Find users who have won medals in three or more consecutive contests
    SELECT user
    FROM cte2
    GROUP BY user, contest_id - rnk
    HAVING COUNT(*) >= 3

    UNION

    -- Find users who won the gold medal in three or more different contests
    SELECT gold_medal AS user
    FROM contests
    GROUP BY gold_medal
    HAVING COUNT(DISTINCT contest_id) >= 3
)

-- Select the name and mail of the users from Users table
SELECT u.name, u.mail
FROM cte3
LEFT JOIN Users u 
ON cte3.user = u.user_id;

-- 1613. Find the Missing IDs 🔒
-- Description
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | customer_name | varchar |
-- +---------------+---------+
-- customer_id is the column with unique values for this table.
-- Each row of this table contains the name and the id customer.
-- Write a solution to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but 
--are in the range between 1 and the maximum customer_id present in the table.
-- Notice that the maximum customer_id will not exceed 100.
-- Return the result table ordered by ids in ascending order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Alice         |
-- | 4           | Bob           |
-- | 5           | Charlie       |
-- +-------------+---------------+
-- Output: 
-- +-----+
-- | ids |
-- +-----+
-- | 2   |
-- | 3   |
-- +-----+
-- Explanation: 
-- The maximum customer_id present
--  in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.

DROP TABLE Customers;
-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);
-- Insert data into the Customers table
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(4, 'Bob'),
(5, 'Charlie');


WITH RECURSIVE NumberSeries AS (
    SELECT 1 AS ids
    UNION ALL
    SELECT ids + 1
    FROM NumberSeries
    WHERE ids < (SELECT MAX(customer_id) FROM Customers)
)
SELECT ids
FROM NumberSeries
WHERE ids NOT IN (SELECT customer_id FROM Customers)
ORDER BY ids;

