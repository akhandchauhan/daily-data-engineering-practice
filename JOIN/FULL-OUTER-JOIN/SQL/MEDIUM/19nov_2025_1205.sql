-- 1205. Monthly Transactions II
-- Table: Transactions
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | id             | int     |
-- | country        | varchar |
-- | state          | enum    |
-- | amount         | int     |
-- | trans_date     | date    |
-- +----------------+---------+
-- id is the primary key of this table.
-- The table has information about incoming transactions.
-- The state column is an enum of type ["approved", "declined"].
-- Table: Chargebacks
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | trans_id       | int     |
-- | charge_date    | date    |
-- +----------------+---------+
-- Chargebacks contains basic information regarding incoming chargebacks from some transactions
-- placed in Transactions table.
-- trans_id is a foreign key to the id column of Transactions table.
-- Each chargeback corresponds to a transaction made previously even if they were not approved.
-- Write an  SQL query to find for each month and country, the number of approved transactions 
-- and their total amount, the number of chargebacks and their total amount.
-- Note: In your query, given the month and country, ignore rows with all zeros.
-- The query result format is in the following example:
-- Transactions table:
-- +------+---------+----------+--------+------------+
-- | id   | country | state    | amount | trans_date |
-- +------+---------+----------+--------+------------+
-- | 101  | US      | approved | 1000   | 2019-05-18 |
-- | 102  | US      | declined | 2000   | 2019-05-19 |
-- | 103  | US      | approved | 3000   | 2019-06-10 |
-- | 104  | US      | approved | 4000   | 2019-06-13 |
-- | 105  | US      | approved | 5000   | 2019-06-15 |
-- +------+---------+----------+--------+------------+
-- Chargebacks table:
-- +------------+------------+
-- | trans_id   | trans_date |
-- +------------+------------+
-- | 102        | 2019-05-29 |
-- | 101        | 2019-06-30 |
-- | 105        | 2019-09-18 |
-- +------------+------------+
-- Result table:
-- +----------+---------+----------------+-----------------+-------------------+--------------------+
-- | month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
-- +----------+---------+----------------+-----------------+-------------------+--------------------+
-- | 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
-- | 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
-- | 2019-09  | US      | 0              | 0               | 1                 | 5000               |
-- +----------+---------+----------------+-----------------+-------------------+--------------------+

DROP TABLE transactions;
Create table If Not Exists Transactions (id int, country varchar(4), state enum('approved', 'declined'), amount int, trans_date date);

Create table If Not Exists Chargebacks (trans_id int, trans_date date);

Truncate table Transactions;
INSERT INTO Transactions (id, country, state, amount, trans_date) 
VALUES
('101', 'US', 'approved', '1000', '2019-05-18'),
('102', 'US', 'declined', '2000', '2019-05-19'),
('103', 'US', 'approved', '3000', '2019-06-10'),
('104', 'US', 'declined', '4000', '2019-06-13'),
('105', 'US', 'approved', '5000', '2019-06-15');

Truncate table Chargebacks;

INSERT INTO Chargebacks (trans_id, trans_date) 
VALUES
('102', '2019-05-29'),
('101', '2019-06-30'),
('105', '2019-09-18');


-- m1 not working
WITH cte as(
SELECT id,country
FROM transactions t 
LEFT JOIN chargebacks c 
ON c.trans_id = t.id
UNION ALL
SELECT *
FROM transactions t 
RIGHT JOIN chargebacks c 
ON c.trans_id = t.id
)
SELECT DATE_FORMAT(c.trans_date,'%Y-%m'),country,sum(state='approved') as apporved_count,
SUM(if(state='approved',amount,0)) as approved_amount
FROM cte
GROUP BY 1,2;;

-- m2 not working
SELECT 
    DATE_FORMAT(COALESCE(t.trans_date,c.trans_date),'%Y-%m') AS month,
    t.country,
    COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
    SUM(CASE WHEN state = 'approved' THEN amount END) AS approved_amount,
    COUNT(CASE WHEN c.trans_id IS NOT NULL THEN 1 END) AS chargeback_count,
    SUM(CASE WHEN c.trans_id IS NOT NULL THEN amount END) AS chargeback_amount
FROM Chargebacks c 
CROSS JOIN Transactions t 
    ON t.id = c.trans_id
GROUP BY 
    DATE_FORMAT(COALESCE(t.trans_date,c.trans_date),'%Y-%m'),
    t.country;

-- m3
WITH
    T AS (
        SELECT * FROM Transactions
        UNION
        SELECT id, country, 'chargeback', amount, c.trans_date
        FROM
            Transactions AS t
            JOIN Chargebacks AS c ON t.id = c.trans_id
    )
SELECT
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    SUM(state = 'approved') AS approved_count,
    SUM(IF(state = 'approved', amount, 0)) AS approved_amount,
    SUM(state = 'chargeback') AS chargeback_count,
    SUM(IF(state = 'chargeback', amount, 0)) AS chargeback_amount
FROM T
GROUP BY 1, 2
HAVING approved_amount OR chargeback_amount;


-- m4
SELECT 
    month,
    country,
    SUM(approved_count) AS approved_count,
    SUM(approved_amount) AS approved_amount,
    SUM(chargeback_count) AS chargeback_count,
    SUM(chargeback_amount) AS chargeback_amount
FROM (
    -- Approved transactions
    SELECT 
        DATE_FORMAT(trans_date, '%Y-%m') AS month,
        country,
        COUNT(*) AS approved_count,
        SUM(amount) AS approved_amount,
        0 AS chargeback_count,
        0 AS chargeback_amount
    FROM Transactions
    WHERE state = 'approved'
    GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country
    
    UNION ALL
    -- Chargebacks
    SELECT 
        DATE_FORMAT(c.trans_date, '%Y-%m') AS month,
        t.country,
        0 AS approved_count,
        0 AS approved_amount,
        COUNT(*) AS chargeback_count,
        SUM(t.amount) AS chargeback_amount
    FROM Chargebacks c
    INNER JOIN Transactions t ON c.trans_id = t.id
    GROUP BY DATE_FORMAT(c.trans_date, '%Y-%m'), t.country
) AS combined
GROUP BY month, country
HAVING approved_count > 0 OR chargeback_count > 0
ORDER BY month, country;