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

