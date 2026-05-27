-- 1454. Active Users

-- Table Accounts:
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- the id is the primary key for this table.
-- This table contains the account id and the user name of each account.

-- Table Logins:
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | login_date    | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- This table contains the account id of the user who logged in and the login date.
-- A user may log in multiple times in the day.

-- Write an SQL query to find the id and the name of active users.
-- Active users are those who logged in to their accounts for 5 or more consecutive days.
-- Return the result table ordered by the id.

-- Accounts table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 1  | Winston  |
-- | 7  | Jonathan |
-- +----+----------+
-- Logins table:
-- +----+------------+
-- | id | login_date |
-- +----+------------+
-- | 7  | 2020-05-30 |
-- | 1  | 2020-05-30 |
-- | 7  | 2020-05-31 |
-- | 7  | 2020-06-01 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-03 |
-- | 1  | 2020-06-07 |
-- | 7  | 2020-06-10 |
-- +----+------------+
-- Result table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 7  | Jonathan |
-- +----+----------+
-- User Winston with id = 1 logged in 2 times only in 2 different days, 
-- so, Winston is not an active user.
-- User Jonathan with id = 7 logged in 7 times in 6 different days, 
-- five of them were consecutive days, so, Jonathan is an active user.
drop table if exists Accounts;
drop table if exists Logins;
Create table If Not Exists Accounts (id int, name varchar(10));
Create table If Not Exists Logins (id int, login_date date);
Truncate table Accounts;
insert into Accounts (id, name) values ('1', 'Winston'),('7', 'Jonathan');
Truncate table Logins;
INSERT INTO Logins (id, login_date) VALUES
('7', '2020-05-30'),
('1', '2020-05-30'),
('7', '2020-05-31'),
('7', '2020-06-01'),
('7', '2020-06-02'),
('7', '2020-06-02'),
('7', '2020-06-03'),
('1', '2020-06-07'),
('7', '2020-06-10');

-- m1
WITH cte as (
    SELECT DISTINCT l.*, a.name
    FROM Logins as l
    LEFT JOIN Accounts as a
    USING (id)
),
cte2 as (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY login_date) AS rnk
    FROM cte
)
SELECT DISTINCT id, name
FROM cte2
GROUP BY id, name, DATE_SUB(login_date, INTERVAL rnk DAY)
HAVING COUNT(*) >= 5;


--------------------------------------------------------------------------------
-- m2
WITH login_info AS (
    SELECT
        DISTINCT id, login_date
    FROM Logins
),
consecutive_rank_info AS (
    SELECT 
        id,
        login_date,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER(
                PARTITION BY id
                ORDER BY login_date
        ) DAY) AS id_group
    FROM login_info
),
consecutive_id AS (
    SELECT
        id
    FROM consecutive_rank_info
    GROUP BY id,id_group
    HAVING COUNT(*) >= 5
)
SELECT 
    a.id,
    a.name
FROM consecutive_id ci 
JOIN Accounts a
ON ci.id = a.id
ORDER BY a.id;