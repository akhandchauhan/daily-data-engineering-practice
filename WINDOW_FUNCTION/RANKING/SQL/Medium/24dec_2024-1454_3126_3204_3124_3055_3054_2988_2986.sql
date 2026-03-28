
-- 1454. Active Users
-- SQL Schema 
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
-- This table contains the account id of the user who logged in and
-- the login date. A user may log in multiple times in the day.
-- Write an  SQL query to find the id and the name of active users.
-- Active users are those who logged in to their accounts for 5 or more consecutive days.
-- Return the result table ordered by the id.
-- The query result format is in the following example:
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
-- User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
-- User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so,
--  Jonathan is an active user.
-- Follow up question: Can you write a general solution if the active users are those who logged in to their
--  accounts for n or more consecutive days?

DROP TABLE Accounts;
DROP TABLE Logins;
Create table If Not Exists Accounts (id int, name varchar(10));
Create table If Not Exists Logins (id int, login_date date);
Truncate table Accounts;
insert into Accounts (id, name) values ('1', 'Winston');
insert into Accounts (id, name) values ('7', 'Jonathan');
Truncate table Logins;
insert into Logins (id, login_date) values ('7', '2020-05-30');
insert into Logins (id, login_date) values ('1', '2020-05-30');
insert into Logins (id, login_date) values ('7', '2020-05-31');
insert into Logins (id, login_date) values ('7', '2020-06-01');
insert into Logins (id, login_date) values ('7', '2020-06-02');
insert into Logins (id, login_date) values ('7', '2020-06-02');
insert into Logins (id, login_date) values ('7', '2020-06-03');
insert into Logins (id, login_date) values ('1', '2020-06-07');
insert into Logins (id, login_date) values ('7', '2020-06-10');





WITH cte as(
    SELECT DISTINCT l.id, name, login_date
    from Logins  l
    LEFT JOIN accounts a 
    ON l.id = a.id
),
cte2 AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY login_date) AS rnk
    FROM cte
)
SELECT DISTINCT id, name
FROM cte2
GROUP BY id, name, DATE_SUB(login_date, INTERVAL rnk DAY)
HAVING COUNT(*) >= 5;


-- 3126. Server Utilization Time 
-- Description
-- Table: Servers
-- +----------------+----------+
-- | Column Name    | Type     |
-- +----------------+----------+
-- | server_id      | int      |
-- | status_time    | datetime |
-- | session_status | enum     |
-- +----------------+----------+
-- (server_id, status_time, session_status) is the primary key (combination of columns with unique values) 
-- for this table.
-- session_status is an ENUM (category) type of ('start', 'stop').
-- Each row of this table contains server_id, status_time, and session_status.
-- Write a solution to find the total time when servers were running. The output should be rounded down 
-- to the nearest number of full days.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example:
-- Input:
-- Servers table:
-- +-----------+---------------------+----------------+
-- | server_id | status_time         | session_status |
-- +-----------+---------------------+----------------+
-- | 3         | 2023-11-04 16:29:47 | start          |
-- | 3         | 2023-11-05 01:49:47 | stop           |
-- | 3         | 2023-11-25 01:37:08 | start          |
-- | 3         | 2023-11-25 03:50:08 | stop           |
-- | 1         | 2023-11-13 03:05:31 | start          |
-- | 1         | 2023-11-13 11:10:31 | stop           |
-- | 4         | 2023-11-29 15:11:17 | start          |
-- | 4         | 2023-11-29 15:42:17 | stop           |
-- | 4         | 2023-11-20 00:31:44 | start          |
-- | 4         | 2023-11-20 07:03:44 | stop           |
-- | 1         | 2023-11-20 00:27:11 | start          |
-- | 1         | 2023-11-20 01:41:11 | stop           |
-- | 3         | 2023-11-04 23:16:48 | start          |
-- | 3         | 2023-11-05 01:15:48 | stop           |
-- | 4         | 2023-11-30 15:09:18 | start          |
-- | 4         | 2023-11-30 20:48:18 | stop           |
-- | 4         | 2023-11-25 21:09:06 | start          |
-- | 4         | 2023-11-26 04:58:06 | stop           |
-- | 5         | 2023-11-16 19:42:22 | start          |
-- | 5         | 2023-11-16 21:08:22 | stop           |
-- +-----------+---------------------+----------------+
-- Output:
-- +-------------------+
-- | total_uptime_days |
-- +-------------------+
-- | 1                 |
-- +-------------------+
-- Explanation:
-- For server ID 3:
-- From 2023-11-04 16:29:47 to 2023-11-05 01:49:47: ~9.3 hours
-- From 2023-11-25 01:37:08 to 2023-11-25 03:50:08: ~2.2 hours
-- From 2023-11-04 23:16:48 to 2023-11-05 01:15:48: ~1.98 hours
-- Total for server 3: ~13.48 hours
-- For server ID 1:
-- From 2023-11-13 03:05:31 to 2023-11-13 11:10:31: ~8 hours
-- From 2023-11-20 00:27:11 to 2023-11-20 01:41:11: ~1.23 hours
-- Total for server 1: ~9.23 hours
-- For server ID 4:
-- From 2023-11-29 15:11:17 to 2023-11-29 15:42:17: ~0.52 hours
-- From 2023-11-20 00:31:44 to 2023-11-20 07:03:44: ~6.53 hours
-- From 2023-11-30 15:09:18 to 2023-11-30 20:48:18: ~5.65 hours
-- From 2023-11-25 21:09:06 to 2023-11-26 04:58:06: ~7.82 hours
-- Total for server 4: ~20.52 hours
-- For server ID 5:
-- From 2023-11-16 19:42:22 to 2023-11-16 21:08:22: ~1.43 hours
-- Total for server 5: ~1.43 hours
-- The accumulated runtime for all servers totals approximately 44.46 hours,
--  equivalent to one full day plus some additional hours. However, since we consider only full
--   days, the final output is rounded to 1 full day.

DROP TABLE Servers;
CREATE TABLE IF NOT EXISTS Servers (
    server_id INT,
    status_time TIMESTAMP,
    session_status ENUM ('start', 'stop')
);

TRUNCATE TABLE Servers;

INSERT INTO Servers (server_id, status_time, session_status) VALUES
('3', '2023-11-04 16:29:47', 'start'),
('3', '2023-11-05 01:49:47', 'stop'),
('3', '2023-11-25 01:37:08', 'start'),
('3', '2023-11-25 03:50:08', 'stop'),
('1', '2023-11-13 03:05:31', 'start'),
('1', '2023-11-13 11:10:31', 'stop'),
('4', '2023-11-29 15:11:17', 'start'),
('4', '2023-11-29 15:42:17', 'stop'),
('4', '2023-11-20 00:31:44', 'start'),
('4', '2023-11-20 07:03:44', 'stop'),
('1', '2023-11-20 00:27:11', 'start'),
('1', '2023-11-20 01:41:11', 'stop'),
('3', '2023-11-04 23:16:48', 'start'),
('3', '2023-11-05 01:15:48', 'stop'),
('4', '2023-11-30 15:09:18', 'start'),
('4', '2023-11-30 20:48:18', 'stop'),
('4', '2023-11-25 21:09:06', 'start'),
('4', '2023-11-26 04:58:06', 'stop'),
('5', '2023-11-16 19:42:22', 'start'),
('5', '2023-11-16 21:08:22', 'stop');


WITH T AS (
        SELECT session_status, status_time,
            LEAD(status_time) OVER (PARTITION BY server_id ORDER BY status_time) AS next_status_time
        FROM Servers
    )
SELECT FLOOR(SUM(TIMESTAMPDIFF(SECOND, status_time, next_status_time)) / 86400) AS total_uptime_days
FROM T
WHERE session_status = 'start';

-- 3204. Bitwise User Permissions Analysis 
-- Description
-- Table: user_permissions
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | permissions | int     |
-- +-------------+---------+
-- user_id is the primary key.
-- Each row of this table contains the user ID and their permissions encoded as an integer.
-- Consider that each bit in the permissions integer represents a different access level or 
-- feature that a user has.
-- Write a solution to calculate the following:
-- common_perms: The access level granted to all users. This is computed using a bitwise 
-- AND operation on the permissions column.
-- any_perms: The access level granted to any user. This is computed using a bitwise OR 
-- operation on the permissions column.
-- Return the result table in any order.
-- The result format is shown in the following example.
-- Example:
-- Input:
-- user_permissions table:
-- +---------+-------------+
-- | user_id | permissions |
-- +---------+-------------+
-- | 1       | 5           |
-- | 2       | 12          |
-- | 3       | 7           |
-- | 4       | 3           |
-- +---------+-------------+
-- Output:
-- +-------------+--------------+
-- | common_perms | any_perms   |
-- +--------------+-------------+
-- | 0            | 15          |
-- +--------------+-------------+
-- Explanation:
-- common_perms: Represents the bitwise AND result of all permissions:
-- <ul>
-- 	<li>For user 1 (5): 5 (binary 0101)</li>
-- 	<li>For user 2 (12): 12 (binary 1100)</li>
-- 	<li>For user 3 (7): 7 (binary 0111)</li>
-- 	<li>For user 4 (3): 3 (binary 0011)</li>
-- 	<li>Bitwise AND: 5 &amp; 12 &amp; 7 &amp; 3 = 0 (binary 0000)</li>
-- </ul>
-- </li>
-- <li><strong>any_perms:</strong> Represents the bitwise OR result of all permissions:
-- <ul>
-- 	<li>Bitwise OR: 5 | 12 | 7 | 3 = 15 (binary 1111)</li>
-- </ul>
-- </li>

Create table if not exists user_permissions(user_id int, permissions int);
Truncate table user_permissions;
insert into user_permissions (user_id, permissions) values ('1', '5');
insert into user_permissions (user_id, permissions) values ('2', '12');
insert into user_permissions (user_id, permissions) values ('3', '7');
insert into user_permissions (user_id, permissions) values ('4', '3');

SELECT BIT_AND(permissions) as common_perm,
BIT_OR(permissions) as any_perm
FROM user_permissions;

-- 3054. Binary Tree Nodes
-- Description
-- Table: Tree
-- +-------------+------+ 
-- \| Column Name \| Type \| 
-- +-------------+------+ 
-- \| N           \| int  \| 
-- \| P           \| int  \|
-- +-------------+------+
-- N is the column of unique values for this table.
-- Each row includes N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
-- Write a solution to find the node type of the Binary Tree. Output one of the following for each node:
-- Root: if the node is the root node.
-- Leaf: if the node is the leaf node.
-- Inner: if the node is neither root nor leaf node.
-- Return the result table ordered by node value in ascending order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Tree table:
-- +---+------+
-- \| N \| P    \| 
-- +---+------+
-- \| 1 \| 2    \|
-- \| 3 \| 2    \| 
-- \| 6 \| 8    \| 
-- \| 9 \| 8    \| 
-- \| 2 \| 5    \| 
-- \| 8 \| 5    \| 
-- \| 5 \| null \| 
-- +---+------+
-- Output: 
-- +---+-------+
-- \| N \| Type  \| 
-- +---+-------+
-- \| 1 \| Leaf  \| 
-- \| 2 \| Inner \|
-- \| 3 \| Leaf  \|
-- \| 5 \| Root  \|
-- \| 6 \| Leaf  \|
-- \| 8 \| Inner \|
-- \| 9 \| Leaf  \|    
-- +---+-------+
-- Explanation: 
-- - Node 5 is the root node since it has no parent node.
-- - Nodes 1, 3, 6, and 8 are leaf nodes because they don't have any child nodes.
-- - Nodes 2, 4, and 7 are inner nodes as they serve as parents to some of the nodes in the structure.


DROP TABLE IF EXISTS Tree;
Create table If Not Exists Tree (N int,P int);
INSERT INTO Tree (N, P) VALUES 
  ('1', '2'),
  ('3', '2'),
  ('6', '8'),
  ('9', '8'),
  ('2', '5'),
  ('8', '5'),
  ('5', NULL);

-- m1 
SELECT N,CASE WHEN P IS NULL THEN 'Root'
WHEN P IS NOT NULL AND N IN (SELECT P FROM Tree) then 'Inner'
ELSE 'Leaf' end as type
FROM Tree
ORDER BY 1;






