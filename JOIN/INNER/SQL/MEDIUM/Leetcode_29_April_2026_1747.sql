-- 1747. Leetflex Banned Accounts
-- SQL Schema
-- Table: LogInfo
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | account_id  | int      |
-- | ip_address  | int      |
-- | login       | datetime |
-- | logout      | datetime |
-- +-------------+----------+
-- There is no primary key for this table, and it may contain duplicates.
-- The table contains information about the login and logout dates of Leetflex accounts. 
-- It also contains the IP address from which the account logged in and out.
-- It is guaranteed that the logout time is after the login time.

-- Write an SQL query to find the account_id of the accounts that should be banned from 
-- Leetflex. An account should be banned if it was logged in at some moment from two different 
-- IP addresses.

-- Return the result table in any order.

-- LogInfo table:
-- +------------+------------+---------------------+---------------------+
-- | account_id | ip_address | login               | logout              |
-- +------------+------------+---------------------+---------------------+
-- | 1          | 1          | 2021-02-01 09:00:00 | 2021-02-01 09:30:00 |
-- | 1          | 2          | 2021-02-01 08:00:00 | 2021-02-01 11:30:00 |
-- | 2          | 6          | 2021-02-01 20:30:00 | 2021-02-01 22:00:00 |
-- | 2          | 7          | 2021-02-02 20:30:00 | 2021-02-02 22:00:00 |
-- | 3          | 9          | 2021-02-01 16:00:00 | 2021-02-01 16:59:59 |
-- | 3          | 13         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
-- | 4          | 10         | 2021-02-01 16:00:00 | 2021-02-01 17:00:00 |
-- | 4          | 11         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
-- +------------+------------+---------------------+---------------------+

-- Result table:
-- +------------+
-- | account_id |
-- +------------+
-- | 1          |
-- | 4          |
-- +------------+
-- Account ID 1 --> The account was active from "2021-02-01 09:00:00" to "2021-02-01 09:30:00" with 
-- two different IP addresses (1 and 2). It should be banned.
-- Account ID 2 --> The account was active from two different addresses (6, 7) but in two different times.
-- Account ID 3 --> The account was active from two different addresses (9, 13) on the same day but they 
-- do not intersect at any moment.
-- Account ID 4 --> The account was active from "2021-02-01 17:00:00" to "2021-02-01 17:00:00" with two 
-- different IP addresses (10 and 11). It should be banned.

DROP TABLE IF EXISTS LogInfo;

CREATE TABLE LogInfo (
    account_id INT,
    ip_address INT,
    login DATETIME,
    logout DATETIME
);

INSERT INTO LogInfo (account_id, ip_address, login, logout) VALUES
(1, 1, '2021-02-01 09:00:00', '2021-02-01 09:30:00'),
(1, 2, '2021-02-01 08:00:00', '2021-02-01 11:30:00'),
(2, 6, '2021-02-01 20:30:00', '2021-02-01 22:00:00'),
(2, 7, '2021-02-02 20:30:00', '2021-02-02 22:00:00'),
(3, 9, '2021-02-01 16:00:00', '2021-02-01 16:59:59'),
(3, 13, '2021-02-01 17:00:00', '2021-02-01 17:59:59'),
(4, 10, '2021-02-01 16:00:00', '2021-02-01 17:00:00'),
(4, 11, '2021-02-01 17:00:00', '2021-02-01 17:59:59');

-- m1 fully correct
SELECT li.account_id
FROM LogInfo li 
JOIN LogInfo li2
ON li.account_id = li2.account_id
WHERE li.ip_address <> li2.ip_address
AND li.login BETWEEN li2.login AND li2.logout
GROUP BY li.account_id ;

------------------------------------------------------------------------------------------------------------------------
-- m2
WITH login_info AS (
    SELECT 
            account_id,
            ip_address,
            LEAD(ip_address) OVER(
                PARTITION BY account_id
                ORDER BY login 
            ) AS next_ip_address,
            login,
            logout,
            LEAD(login) OVER(
                PARTITION BY account_id
                ORDER BY login
            ) AS next_login
    FROM LogInfo 
)
SELECT 
        account_id
FROM login_info
WHERE ip_address <> next_ip_address
AND next_login BETWEEN login AND logout 
GROUP BY account_id ;